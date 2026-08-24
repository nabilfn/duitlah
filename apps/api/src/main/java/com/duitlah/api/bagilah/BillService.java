package com.duitlah.api.bagilah;

import com.duitlah.api.audit.AuditAction;
import com.duitlah.api.audit.AuditLogService;
import com.duitlah.api.common.error.ApiException;
import com.duitlah.api.common.error.ConflictException;
import com.duitlah.api.common.error.ForbiddenException;
import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.common.money.EqualSplitter;
import com.duitlah.api.common.security.SecureTokens;
import com.duitlah.api.groups.GroupMemberRepository;
import com.duitlah.api.settlements.DebtSimplifier;
import com.duitlah.api.settlements.SettlementService;
import com.duitlah.api.settlements.SourceType;
import com.duitlah.api.users.User;
import com.duitlah.api.users.UserRepository;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.UUID;
import java.util.function.Function;
import java.util.stream.Collectors;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

@Service
public class BillService {

  private static final int GUEST_SESSION_TTL_HOURS = 24;

  private final BillRepository bills;
  private final ReceiptItemRepository items;
  private final BillParticipantRepository participants;
  private final ItemClaimRepository claims;
  private final BillPaymentRepository payments;
  private final BillFinalAmountRepository finalAmounts;
  private final BillGuestSessionRepository guestSessions;
  private final UserRepository users;
  private final GroupMemberRepository groupMembers;
  private final BillEventBroadcaster events;
  private final SettlementService settlementService;
  private final AuditLogService auditLogService;

  public BillService(
      BillRepository bills,
      ReceiptItemRepository items,
      BillParticipantRepository participants,
      ItemClaimRepository claims,
      BillPaymentRepository payments,
      BillFinalAmountRepository finalAmounts,
      BillGuestSessionRepository guestSessions,
      UserRepository users,
      GroupMemberRepository groupMembers,
      BillEventBroadcaster events,
      SettlementService settlementService,
      AuditLogService auditLogService) {
    this.bills = bills;
    this.items = items;
    this.participants = participants;
    this.claims = claims;
    this.payments = payments;
    this.finalAmounts = finalAmounts;
    this.guestSessions = guestSessions;
    this.users = users;
    this.groupMembers = groupMembers;
    this.events = events;
    this.settlementService = settlementService;
    this.auditLogService = auditLogService;
  }

  public List<BillResponse> listForUser(UUID userId) {
    return bills.findAllVisibleToUser(userId).stream().map(BillResponse::of).toList();
  }

  public BillResponse getForUser(UUID userId, UUID billId) {
    return BillResponse.of(requireVisibleBill(userId, billId));
  }

  @Transactional
  public BillResponse create(UUID userId, CreateBillRequest request) {
    if (request.groupId() != null
        && !groupMembers.existsByGroupIdAndUserId(request.groupId(), userId)) {
      throw new ApiException(
          HttpStatus.BAD_REQUEST,
          "NOT_A_GROUP_MEMBER",
          "You must be a member of that group to attach a bill to it.");
    }
    Bill bill =
        new Bill(userId, request.groupId(), request.merchant(), request.receiptDate(), "MYR");
    bills.save(bill);
    participants.save(new BillParticipant(bill.getId(), userId, null));
    return BillResponse.of(bill);
  }

  @Transactional
  public InviteTokenResponse regenerateInviteToken(UUID userId, UUID billId) {
    Bill bill = requireOwnedBill(userId, billId);
    String rawToken = SecureTokens.generate();
    bill.setInviteTokenHash(SecureTokens.hash(rawToken));
    bills.save(bill);
    return new InviteTokenResponse(rawToken);
  }

  /**
   * Handles both halves of the join link (product spec section 12): an already-logged-in user joins
   * as themselves (idempotent, like Groups' join), an anonymous visitor must supply a {@code
   * guestName} and gets back a guest session token instead of a real user session.
   */
  @Transactional
  public JoinBillResponse joinViaInvite(String token, String guestName, UUID authenticatedUserId) {
    Bill bill =
        bills
            .findByInviteTokenHash(SecureTokens.hash(token))
            .orElseThrow(
                () -> new NotFoundException("INVALID_INVITE", "This invite link is invalid."));
    if (bill.getStatus() != BillStatus.DRAFT) {
      throw new ConflictException(
          "BILL_NOT_JOINABLE", "This bill is no longer accepting new participants.");
    }

    if (authenticatedUserId != null) {
      BillParticipant participant =
          participants
              .findByBillIdAndUserId(bill.getId(), authenticatedUserId)
              .orElseGet(
                  () ->
                      participants.save(
                          new BillParticipant(bill.getId(), authenticatedUserId, null)));
      User user = users.findById(authenticatedUserId).orElseThrow();
      events.publish(bill.getId(), "PARTICIPANT_JOINED");
      return new JoinBillResponse(
          bill.getId(), participant.getId(), user.getDisplayName(), false, null);
    }

    if (guestName == null || guestName.isBlank()) {
      throw new ApiException(
          HttpStatus.BAD_REQUEST, "GUEST_NAME_REQUIRED", "Enter a name to join as a guest.");
    }
    BillParticipant guest = new BillParticipant(bill.getId(), null, guestName.trim());
    participants.save(guest);
    String rawSessionToken = SecureTokens.generate();
    guestSessions.save(
        new BillGuestSession(
            bill.getId(),
            guest.getId(),
            SecureTokens.hash(rawSessionToken),
            Instant.now().plus(GUEST_SESSION_TTL_HOURS, ChronoUnit.HOURS)));
    events.publish(bill.getId(), "PARTICIPANT_JOINED");
    return new JoinBillResponse(
        bill.getId(), guest.getId(), guest.getGuestName(), true, rawSessionToken);
  }

  public SseEmitter subscribeToEvents(UUID userId, UUID billId) {
    requireVisibleBill(userId, billId);
    return events.subscribe(billId);
  }

  public SseEmitter subscribeToEventsAsGuest(String guestToken) {
    BillGuestSession session = requireGuestSession(guestToken);
    return events.subscribe(session.getBillId());
  }

  @Transactional
  public BillResponse update(UUID userId, UUID billId, UpdateBillRequest request) {
    Bill bill = requireOwnedDraftBill(userId, billId);
    bill.setMerchant(request.merchant());
    bill.setReceiptDate(request.receiptDate());
    bill.setTax(request.tax());
    bill.setTaxStrategy(request.taxStrategy());
    bill.setServiceCharge(request.serviceCharge());
    bill.setServiceStrategy(request.serviceStrategy());
    bill.setDiscount(request.discount());
    bill.setDiscountLabel(request.discountLabel());
    bill.setDeclaredTotal(request.declaredTotal());
    bills.save(bill);
    return BillResponse.of(bill);
  }

  @Transactional
  public void cancel(UUID userId, UUID billId) {
    Bill bill = requireOwnedBill(userId, billId);
    if (bill.getStatus() == BillStatus.FINALIZED) {
      throw new ConflictException("BILL_ALREADY_FINALIZED", "A finalized bill can't be cancelled.");
    }
    bill.setStatus(BillStatus.CANCELLED);
    bills.save(bill);
  }

  @Transactional
  public ReceiptItemResponse addItem(UUID userId, UUID billId, CreateReceiptItemRequest request) {
    requireOwnedDraftBill(userId, billId);
    ReceiptItem item = buildReceiptItem(billId, request);
    items.save(item);
    events.publish(billId, "ITEM_CHANGED");
    return ReceiptItemResponse.of(item);
  }

  @Transactional
  public ReceiptItemResponse updateItem(
      UUID userId, UUID billId, UUID itemId, CreateReceiptItemRequest request) {
    requireOwnedDraftBill(userId, billId);
    ReceiptItem item = requireItem(billId, itemId);
    ReceiptItem updated = buildReceiptItem(billId, request);
    item.setName(updated.getName());
    item.setQuantity(updated.getQuantity());
    item.setUnitPrice(updated.getUnitPrice());
    item.setItemDiscount(updated.getItemDiscount());
    item.setTotalPrice(updated.getTotalPrice());
    items.save(item);
    return ReceiptItemResponse.of(item);
  }

  @Transactional
  public void deleteItem(UUID userId, UUID billId, UUID itemId) {
    requireOwnedDraftBill(userId, billId);
    items.delete(requireItem(billId, itemId));
  }

  public List<ReceiptItemResponse> listItems(UUID userId, UUID billId) {
    requireVisibleBill(userId, billId);
    return items.findByBillIdOrderByCreatedAtAsc(billId).stream()
        .map(ReceiptItemResponse::of)
        .toList();
  }

  @Transactional
  public ParticipantResponse addParticipant(
      UUID userId, UUID billId, AddParticipantRequest request) {
    requireOwnedDraftBill(userId, billId);
    boolean hasUser = request.userId() != null;
    boolean hasGuest = request.guestName() != null && !request.guestName().isBlank();
    if (hasUser == hasGuest) {
      throw new ApiException(
          HttpStatus.BAD_REQUEST,
          "INVALID_PARTICIPANT",
          "Provide exactly one of userId or guestName.");
    }
    String displayName;
    if (hasUser) {
      User user =
          users
              .findById(request.userId())
              .orElseThrow(() -> new NotFoundException("USER_NOT_FOUND", "User not found."));
      if (participants.existsByBillIdAndUserId(billId, request.userId())) {
        throw new ConflictException(
            "PARTICIPANT_ALREADY_ADDED", "This person is already on the bill.");
      }
      displayName = user.getDisplayName();
    } else {
      displayName = request.guestName();
    }
    BillParticipant participant =
        new BillParticipant(
            billId, hasUser ? request.userId() : null, hasUser ? null : request.guestName());
    participants.save(participant);
    events.publish(billId, "PARTICIPANT_JOINED");
    return new ParticipantResponse(
        participant.getId(), participant.getUserId(), displayName, participant.isGuest());
  }

  @Transactional
  public void removeParticipant(UUID userId, UUID billId, UUID participantId) {
    Bill bill = requireOwnedDraftBill(userId, billId);
    BillParticipant participant = requireParticipant(billId, participantId);
    if (userId.equals(participant.getUserId()) && userId.equals(bill.getOwnerUserId())) {
      throw new ForbiddenException("CANNOT_REMOVE_OWNER", "The bill owner can't be removed.");
    }
    participants.delete(participant);
  }

  public List<ParticipantResponse> listParticipants(UUID userId, UUID billId) {
    requireVisibleBill(userId, billId);
    Map<UUID, String> names = participantDisplayNames(billId);
    return participants.findByBillIdOrderByCreatedAtAsc(billId).stream()
        .map(
            p ->
                new ParticipantResponse(
                    p.getId(), p.getUserId(), names.get(p.getId()), p.isGuest()))
        .toList();
  }

  /**
   * Claiming is collaborative (product spec section 13/Phase 7): any participant of a draft bill --
   * not just the owner -- can add, adjust, or remove a claim, including on someone else's behalf
   * ("let me fix Ameer's claim, he mistyped"). This is a deliberate simplification: claims aren't
   * ownership-gated per participant, only gated by "you're actually in this bill." Item,
   * participant, and charge management stay owner-only (see {@link #requireOwnedDraftBill}).
   */
  @Transactional
  public ClaimResponse addClaim(UUID userId, UUID billId, UUID itemId, ClaimRequest request) {
    requireParticipantDraftBill(userId, billId);
    ClaimResponse response = doAddClaim(billId, itemId, request);
    events.publish(billId, "CLAIM_CHANGED");
    return response;
  }

  @Transactional
  public List<ClaimResponse> equalSplitItem(
      UUID userId, UUID billId, UUID itemId, EqualSplitClaimRequest request) {
    requireParticipantDraftBill(userId, billId);
    List<ClaimResponse> response = doEqualSplitItem(billId, itemId, request);
    events.publish(billId, "CLAIM_CHANGED");
    return response;
  }

  @Transactional
  public void removeClaim(UUID userId, UUID billId, UUID itemId, UUID claimId) {
    requireParticipantDraftBill(userId, billId);
    doRemoveClaim(billId, itemId, claimId);
    events.publish(billId, "CLAIM_CHANGED");
  }

  public List<ClaimResponse> listClaims(UUID userId, UUID billId, UUID itemId) {
    requireVisibleBill(userId, billId);
    requireItem(billId, itemId);
    return claims.findByReceiptItemId(itemId).stream().map(this::toClaimResponse).toList();
  }

  public BillResponse getForGuest(String guestToken) {
    return BillResponse.of(requireBill(requireGuestSession(guestToken).getBillId()));
  }

  public List<ReceiptItemResponse> listItemsForGuest(String guestToken) {
    UUID billId = requireGuestSession(guestToken).getBillId();
    return items.findByBillIdOrderByCreatedAtAsc(billId).stream()
        .map(ReceiptItemResponse::of)
        .toList();
  }

  public List<ParticipantResponse> listParticipantsForGuest(String guestToken) {
    UUID billId = requireGuestSession(guestToken).getBillId();
    Map<UUID, String> names = participantDisplayNames(billId);
    return participants.findByBillIdOrderByCreatedAtAsc(billId).stream()
        .map(
            p ->
                new ParticipantResponse(
                    p.getId(), p.getUserId(), names.get(p.getId()), p.isGuest()))
        .toList();
  }

  public List<ClaimResponse> listClaimsForGuest(String guestToken, UUID itemId) {
    UUID billId = requireGuestSession(guestToken).getBillId();
    requireItem(billId, itemId);
    return claims.findByReceiptItemId(itemId).stream().map(this::toClaimResponse).toList();
  }

  @Transactional
  public ClaimResponse addClaimAsGuest(String guestToken, UUID itemId, ClaimRequest request) {
    UUID billId = requireGuestDraftBillId(guestToken);
    ClaimResponse response = doAddClaim(billId, itemId, request);
    events.publish(billId, "CLAIM_CHANGED");
    return response;
  }

  @Transactional
  public List<ClaimResponse> equalSplitItemAsGuest(
      String guestToken, UUID itemId, EqualSplitClaimRequest request) {
    UUID billId = requireGuestDraftBillId(guestToken);
    List<ClaimResponse> response = doEqualSplitItem(billId, itemId, request);
    events.publish(billId, "CLAIM_CHANGED");
    return response;
  }

  @Transactional
  public void removeClaimAsGuest(String guestToken, UUID itemId, UUID claimId) {
    UUID billId = requireGuestDraftBillId(guestToken);
    doRemoveClaim(billId, itemId, claimId);
    events.publish(billId, "CLAIM_CHANGED");
  }

  public BreakdownResponse getBreakdownForGuest(String guestToken) {
    UUID billId = requireGuestSession(guestToken).getBillId();
    return getBreakdownForBill(requireBill(billId));
  }

  private ClaimResponse doAddClaim(UUID billId, UUID itemId, ClaimRequest request) {
    requireItem(billId, itemId);
    requireParticipant(billId, request.participantId());

    if (request.claimType() != ClaimType.AMOUNT && request.value().signum() <= 0) {
      throw new ApiException(
          HttpStatus.BAD_REQUEST,
          "INVALID_CLAIM_VALUE",
          "Quantity and percentage claims must be greater than zero.");
    }

    boolean mixedTypeConflict =
        claims.findByReceiptItemId(itemId).stream()
            .anyMatch(
                c ->
                    !c.getParticipantId().equals(request.participantId())
                        && c.getClaimType() != request.claimType());
    if (mixedTypeConflict) {
      throw new ApiException(
          HttpStatus.BAD_REQUEST,
          "MIXED_CLAIM_TYPES",
          "All claims on one item must use the same claim type (quantity, percentage, or amount).");
    }

    ItemClaim claim =
        claims
            .findByReceiptItemIdAndParticipantId(itemId, request.participantId())
            .orElse(
                new ItemClaim(
                    itemId, request.participantId(), request.claimType(), request.value()));
    claim.setClaimType(request.claimType());
    claim.setQuantity(null);
    claim.setPercentage(null);
    claim.setAmount(null);
    switch (request.claimType()) {
      case QUANTITY -> claim.setQuantity(request.value());
      case PERCENTAGE -> claim.setPercentage(request.value());
      case AMOUNT -> claim.setAmount(request.value());
    }
    claims.save(claim);
    return toClaimResponse(claim);
  }

  private List<ClaimResponse> doEqualSplitItem(
      UUID billId, UUID itemId, EqualSplitClaimRequest request) {
    ReceiptItem item = requireItem(billId, itemId);
    List<UUID> participantIds = new ArrayList<>(new LinkedHashSet<>(request.participantIds()));
    for (UUID participantId : participantIds) {
      requireParticipant(billId, participantId);
    }

    claims.deleteAll(claims.findByReceiptItemId(itemId));
    List<BigDecimal> shares = EqualSplitter.split(item.getTotalPrice(), participantIds.size());
    List<ItemClaim> created = new ArrayList<>(participantIds.size());
    for (int i = 0; i < participantIds.size(); i++) {
      ItemClaim claim =
          new ItemClaim(itemId, participantIds.get(i), ClaimType.AMOUNT, shares.get(i));
      claims.save(claim);
      created.add(claim);
    }
    return created.stream().map(this::toClaimResponse).toList();
  }

  private void doRemoveClaim(UUID billId, UUID itemId, UUID claimId) {
    requireItem(billId, itemId);
    ItemClaim claim =
        claims
            .findByIdAndReceiptItemId(claimId, itemId)
            .orElseThrow(() -> new NotFoundException("CLAIM_NOT_FOUND", "Claim not found."));
    claims.delete(claim);
  }

  @Transactional
  public PaymentResponse recordPayment(
      UUID userId, UUID billId, UUID participantId, RecordPaymentRequest request) {
    requireOwnedDraftBill(userId, billId);
    requireParticipant(billId, participantId);
    BillPayment payment =
        payments
            .findByBillIdAndParticipantId(billId, participantId)
            .orElse(new BillPayment(billId, participantId, request.amountPaid()));
    payment.setAmountPaid(request.amountPaid());
    payments.save(payment);
    return toPaymentResponse(payment);
  }

  @Transactional
  public void removePayment(UUID userId, UUID billId, UUID participantId) {
    requireOwnedDraftBill(userId, billId);
    BillPayment payment =
        payments
            .findByBillIdAndParticipantId(billId, participantId)
            .orElseThrow(
                () ->
                    new NotFoundException(
                        "PAYMENT_NOT_FOUND", "No payment recorded for this participant."));
    payments.delete(payment);
  }

  public List<PaymentResponse> listPayments(UUID userId, UUID billId) {
    requireVisibleBill(userId, billId);
    return payments.findByBillId(billId).stream().map(this::toPaymentResponse).toList();
  }

  public BreakdownResponse getBreakdown(UUID userId, UUID billId) {
    Bill bill = requireVisibleBill(userId, billId);
    return getBreakdownForBill(bill);
  }

  private BreakdownResponse getBreakdownForBill(Bill bill) {
    UUID billId = bill.getId();
    Map<UUID, String> names = participantDisplayNames(billId);

    if (bill.getStatus() == BillStatus.FINALIZED) {
      List<BillFinalAmount> snapshot = finalAmounts.findByBillId(billId);
      BigDecimal subtotal =
          snapshot.stream()
              .map(BillFinalAmount::getSubtotal)
              .reduce(BigDecimal.ZERO, BigDecimal::add);
      List<ParticipantBreakdownResponse> breakdowns =
          snapshot.stream()
              .map(
                  f ->
                      new ParticipantBreakdownResponse(
                          f.getParticipantId(),
                          names.get(f.getParticipantId()),
                          f.getSubtotal(),
                          f.getTaxShare(),
                          f.getServiceShare(),
                          f.getDiscountShare(),
                          f.getRoundingShare(),
                          f.getFinalAmount()))
              .toList();
      return new BreakdownResponse(
          true, List.of(), subtotal, bill.getTotal(), bill.getRoundingAdjustment(), breakdowns);
    }

    Map<UUID, String> itemNames =
        items.findByBillIdOrderByCreatedAtAsc(billId).stream()
            .collect(Collectors.toMap(ReceiptItem::getId, ReceiptItem::getName));
    BagilahCalculationEngine.CalculationResult result = computeResult(bill);
    List<ItemIssueResponse> issues =
        result.issues().stream()
            .map(i -> new ItemIssueResponse(i.itemId(), itemNames.get(i.itemId()), i.type()))
            .toList();
    List<ParticipantBreakdownResponse> breakdowns =
        result.breakdowns().stream()
            .map(
                b ->
                    new ParticipantBreakdownResponse(
                        b.participantId(),
                        names.get(b.participantId()),
                        b.subtotal(),
                        b.taxShare(),
                        b.serviceShare(),
                        b.discountShare(),
                        b.roundingShare(),
                        b.finalAmount()))
            .toList();
    return new BreakdownResponse(
        result.isValid(),
        issues,
        result.subtotal(),
        result.computedTotal(),
        result.roundingAdjustment(),
        breakdowns);
  }

  @Transactional
  public BillResponse finalizeBill(UUID userId, UUID billId) {
    Bill bill = requireOwnedDraftBill(userId, billId);
    if (items.findByBillIdOrderByCreatedAtAsc(billId).isEmpty()) {
      throw new ApiException(
          HttpStatus.BAD_REQUEST, "BILL_HAS_NO_ITEMS", "Add at least one item before finalizing.");
    }

    BagilahCalculationEngine.CalculationResult result = computeResult(bill);
    if (!result.isValid()) {
      throw new ApiException(
          HttpStatus.BAD_REQUEST,
          "BILL_NOT_READY",
          "Some items still need to be fully and unambiguously claimed before this bill can be finalized.",
          Map.of("issueCount", result.issues().size()));
    }

    BigDecimal finalTotal =
        bill.getDeclaredTotal() != null ? bill.getDeclaredTotal() : result.computedTotal();
    List<BillPayment> billPayments = payments.findByBillId(billId);
    if (billPayments.isEmpty()) {
      throw new ApiException(
          HttpStatus.BAD_REQUEST, "NO_PAYMENTS_RECORDED", "Record who paid before finalizing.");
    }
    BigDecimal totalPaid =
        billPayments.stream()
            .map(BillPayment::getAmountPaid)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
    if (totalPaid.compareTo(finalTotal) != 0) {
      throw new ApiException(
          HttpStatus.BAD_REQUEST,
          "PAYMENTS_DONT_MATCH_TOTAL",
          "Recorded payments ("
              + totalPaid
              + ") must add up to the bill total ("
              + finalTotal
              + ").");
    }

    for (BagilahCalculationEngine.ParticipantBreakdown b : result.breakdowns()) {
      finalAmounts.save(
          new BillFinalAmount(
              billId,
              b.participantId(),
              b.subtotal(),
              b.taxShare(),
              b.serviceShare(),
              b.discountShare(),
              b.roundingShare(),
              b.finalAmount()));
    }

    bill.setTotal(finalTotal);
    bill.setRoundingAdjustment(result.roundingAdjustment());
    bill.setStatus(BillStatus.FINALIZED);
    bill.setFinalizedAt(Instant.now());
    bills.save(bill);

    generateSettlements(billId, result.breakdowns(), paidByParticipant(billPayments));
    auditLogService.record(
        userId, AuditAction.BILL_FINALIZED, "Bill", billId, Map.of("total", finalTotal));
    return BillResponse.of(bill);
  }

  /**
   * Turns each participant's net position (paid - owed) into fixed, independent settlement
   * obligations via {@link DebtSimplifier} — generated once, here, at the moment the bill's numbers
   * become permanent, and never recomputed afterward (see docs/bagilah-engine.md). Guests are
   * excluded: a settlement is meant to be visible from its own owner's "who owes me" dashboard,
   * which requires a real account to log into in the first place.
   */
  private void generateSettlements(
      UUID billId,
      List<BagilahCalculationEngine.ParticipantBreakdown> breakdowns,
      Map<UUID, BigDecimal> paidByParticipant) {
    Map<UUID, BillParticipant> participantsById =
        participants.findByBillIdOrderByCreatedAtAsc(billId).stream()
            .collect(Collectors.toMap(BillParticipant::getId, Function.identity()));
    BigDecimal zero = BigDecimal.ZERO.setScale(2);
    List<DebtSimplifier.NetPosition> positions = new ArrayList<>();
    for (BagilahCalculationEngine.ParticipantBreakdown b : breakdowns) {
      BillParticipant participant = participantsById.get(b.participantId());
      if (participant == null || participant.getUserId() == null) {
        continue;
      }
      BigDecimal paid = paidByParticipant.getOrDefault(b.participantId(), zero);
      positions.add(
          new DebtSimplifier.NetPosition(participant.getUserId(), paid.subtract(b.finalAmount())));
    }
    settlementService.generateSettlements(SourceType.BILL, billId, positions);
  }

  private Map<UUID, BigDecimal> paidByParticipant(List<BillPayment> billPayments) {
    return billPayments.stream()
        .collect(Collectors.toMap(BillPayment::getParticipantId, BillPayment::getAmountPaid));
  }

  public List<BillBalanceResponse> getBalances(UUID userId, UUID billId) {
    Bill bill = requireVisibleBill(userId, billId);
    Map<UUID, String> names = participantDisplayNames(billId);
    Map<UUID, BigDecimal> paidByParticipant =
        payments.findByBillId(billId).stream()
            .collect(Collectors.toMap(BillPayment::getParticipantId, BillPayment::getAmountPaid));

    Map<UUID, BigDecimal> owedByParticipant;
    if (bill.getStatus() == BillStatus.FINALIZED) {
      owedByParticipant =
          finalAmounts.findByBillId(billId).stream()
              .collect(
                  Collectors.toMap(
                      BillFinalAmount::getParticipantId, BillFinalAmount::getFinalAmount));
    } else {
      owedByParticipant =
          computeResult(bill).breakdowns().stream()
              .collect(
                  Collectors.toMap(
                      BagilahCalculationEngine.ParticipantBreakdown::participantId,
                      BagilahCalculationEngine.ParticipantBreakdown::finalAmount));
    }

    BigDecimal zero = BigDecimal.ZERO.setScale(2);
    return participants.findByBillIdOrderByCreatedAtAsc(billId).stream()
        .map(
            p -> {
              BigDecimal paid = paidByParticipant.getOrDefault(p.getId(), zero);
              BigDecimal owed = owedByParticipant.getOrDefault(p.getId(), zero);
              return new BillBalanceResponse(
                  p.getId(), names.get(p.getId()), paid, owed, paid.subtract(owed));
            })
        .toList();
  }

  private BagilahCalculationEngine.CalculationResult computeResult(Bill bill) {
    List<ReceiptItem> billItems = items.findByBillIdOrderByCreatedAtAsc(bill.getId());
    List<BillParticipant> billParticipants =
        participants.findByBillIdOrderByCreatedAtAsc(bill.getId());
    List<ItemClaim> billClaims = claims.findAllByBillId(bill.getId());

    List<BagilahCalculationEngine.ItemInput> itemInputs =
        billItems.stream()
            .map(
                i ->
                    new BagilahCalculationEngine.ItemInput(
                        i.getId(), i.getQuantity(), i.getTotalPrice()))
            .toList();
    List<UUID> participantIds = billParticipants.stream().map(BillParticipant::getId).toList();
    List<BagilahCalculationEngine.ClaimInput> claimInputs =
        billClaims.stream()
            .map(
                c ->
                    new BagilahCalculationEngine.ClaimInput(
                        c.getReceiptItemId(), c.getParticipantId(), c.getClaimType(), c.getValue()))
            .toList();

    return BagilahCalculationEngine.calculate(
        itemInputs,
        participantIds,
        claimInputs,
        bill.getTax(),
        bill.getTaxStrategy(),
        bill.getServiceCharge(),
        bill.getServiceStrategy(),
        bill.getDiscount(),
        bill.getDeclaredTotal());
  }

  private ReceiptItem buildReceiptItem(UUID billId, CreateReceiptItemRequest request) {
    BigDecimal itemDiscount =
        request.itemDiscount() == null ? BigDecimal.ZERO.setScale(2) : request.itemDiscount();
    BigDecimal grossTotal =
        request.quantity().multiply(request.unitPrice()).setScale(2, RoundingMode.HALF_UP);
    if (itemDiscount.compareTo(grossTotal) > 0) {
      throw new ApiException(
          HttpStatus.BAD_REQUEST,
          "ITEM_DISCOUNT_EXCEEDS_TOTAL",
          "This item's discount can't be more than its price.");
    }
    BigDecimal totalPrice = grossTotal.subtract(itemDiscount);
    return new ReceiptItem(
        billId, request.name(), request.quantity(), request.unitPrice(), itemDiscount, totalPrice);
  }

  private ClaimResponse toClaimResponse(ItemClaim claim) {
    BillParticipant participant =
        participants
            .findById(claim.getParticipantId())
            .orElseThrow(
                () -> new NotFoundException("PARTICIPANT_NOT_FOUND", "Participant not found."));
    String displayName = resolveDisplayName(participant);
    return new ClaimResponse(
        claim.getId(),
        claim.getParticipantId(),
        displayName,
        claim.getClaimType(),
        claim.getValue());
  }

  private PaymentResponse toPaymentResponse(BillPayment payment) {
    BillParticipant participant =
        participants
            .findById(payment.getParticipantId())
            .orElseThrow(
                () -> new NotFoundException("PARTICIPANT_NOT_FOUND", "Participant not found."));
    return new PaymentResponse(
        payment.getParticipantId(), resolveDisplayName(participant), payment.getAmountPaid());
  }

  private String resolveDisplayName(BillParticipant participant) {
    if (participant.isGuest()) {
      return participant.getGuestName();
    }
    return users.findById(participant.getUserId()).map(User::getDisplayName).orElse(null);
  }

  private Map<UUID, String> participantDisplayNames(UUID billId) {
    List<BillParticipant> billParticipants = participants.findByBillIdOrderByCreatedAtAsc(billId);
    Set<UUID> userIds =
        billParticipants.stream()
            .map(BillParticipant::getUserId)
            .filter(Objects::nonNull)
            .collect(Collectors.toSet());
    Map<UUID, User> usersById =
        users.findAllById(userIds).stream()
            .collect(Collectors.toMap(User::getId, Function.identity()));
    Map<UUID, String> result = new LinkedHashMap<>();
    for (BillParticipant p : billParticipants) {
      result.put(
          p.getId(),
          p.isGuest() ? p.getGuestName() : usersById.get(p.getUserId()).getDisplayName());
    }
    return result;
  }

  private ReceiptItem requireItem(UUID billId, UUID itemId) {
    return items
        .findByIdAndBillId(itemId, billId)
        .orElseThrow(() -> new NotFoundException("ITEM_NOT_FOUND", "Item not found."));
  }

  private BillParticipant requireParticipant(UUID billId, UUID participantId) {
    return participants
        .findByIdAndBillId(participantId, billId)
        .orElseThrow(
            () -> new NotFoundException("PARTICIPANT_NOT_FOUND", "Participant not found."));
  }

  private Bill requireBill(UUID billId) {
    return bills
        .findById(billId)
        .orElseThrow(() -> new NotFoundException("BILL_NOT_FOUND", "Bill not found."));
  }

  private Bill requireVisibleBill(UUID userId, UUID billId) {
    Bill bill = requireBill(billId);
    boolean isOwner = bill.getOwnerUserId().equals(userId);
    boolean isParticipant = participants.existsByBillIdAndUserId(billId, userId);
    if (!isOwner && !isParticipant) {
      throw new NotFoundException("BILL_NOT_FOUND", "Bill not found.");
    }
    return bill;
  }

  private Bill requireOwnedBill(UUID userId, UUID billId) {
    Bill bill = requireVisibleBill(userId, billId);
    if (!bill.getOwnerUserId().equals(userId)) {
      throw new ForbiddenException("NOT_BILL_OWNER", "Only the bill owner can do this.");
    }
    return bill;
  }

  private Bill requireOwnedDraftBill(UUID userId, UUID billId) {
    Bill bill = requireOwnedBill(userId, billId);
    if (bill.getStatus() != BillStatus.DRAFT) {
      throw new ConflictException(
          "BILL_NOT_DRAFT",
          "This bill has already been finalized or cancelled and can't be edited.");
    }
    return bill;
  }

  private Bill requireParticipantDraftBill(UUID userId, UUID billId) {
    Bill bill = requireVisibleBill(userId, billId);
    if (bill.getStatus() != BillStatus.DRAFT) {
      throw new ConflictException(
          "BILL_NOT_DRAFT",
          "This bill has already been finalized or cancelled and can't be claimed on.");
    }
    return bill;
  }

  private BillGuestSession requireGuestSession(String rawToken) {
    BillGuestSession session =
        guestSessions
            .findByTokenHash(SecureTokens.hash(rawToken))
            .orElseThrow(
                () ->
                    new NotFoundException(
                        "INVALID_GUEST_SESSION", "This guest session is invalid or has expired."));
    if (!session.isUsable()) {
      throw new NotFoundException(
          "INVALID_GUEST_SESSION", "This guest session is invalid or has expired.");
    }
    return session;
  }

  private UUID requireGuestDraftBillId(String rawToken) {
    UUID billId = requireGuestSession(rawToken).getBillId();
    if (requireBill(billId).getStatus() != BillStatus.DRAFT) {
      throw new ConflictException(
          "BILL_NOT_DRAFT",
          "This bill has already been finalized or cancelled and can't be claimed on.");
    }
    return billId;
  }
}
