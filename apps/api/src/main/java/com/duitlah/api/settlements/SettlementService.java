package com.duitlah.api.settlements;

import com.duitlah.api.audit.AuditAction;
import com.duitlah.api.audit.AuditLogService;
import com.duitlah.api.common.error.ConflictException;
import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.users.User;
import com.duitlah.api.users.UserRepository;
import java.math.BigDecimal;
import java.time.Duration;
import java.time.Instant;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Owns settlement generation (via {@link DebtSimplifier}), payment history, and the "who owes me"
 * dashboard (product spec section 34). Bills and Groups both call into {@link #generateSettlements}
 * with their own net positions rather than this module reaching into either — {@code bagilah} and
 * {@code groups} depend on this module's public surface, not the other way around.
 */
@Service
public class SettlementService {

  private final SettlementRepository settlements;
  private final SettlementPaymentRepository payments;
  private final UserRepository users;
  private final PaymentHandoffService handoffService;
  private final AuditLogService auditLogService;

  public SettlementService(
      SettlementRepository settlements,
      SettlementPaymentRepository payments,
      UserRepository users,
      PaymentHandoffService handoffService,
      AuditLogService auditLogService) {
    this.settlements = settlements;
    this.payments = payments;
    this.users = users;
    this.handoffService = handoffService;
    this.auditLogService = auditLogService;
  }

  @Transactional
  public List<SettlementResponse> generateSettlements(
      SourceType sourceType, UUID sourceId, List<DebtSimplifier.NetPosition> positions) {
    List<DebtSimplifier.Transfer> transfers = DebtSimplifier.simplify(positions);
    List<Settlement> created = new ArrayList<>(transfers.size());
    for (DebtSimplifier.Transfer transfer : transfers) {
      Settlement settlement =
          new Settlement(
              transfer.fromUserId(), transfer.toUserId(), transfer.amount(), sourceType, sourceId);
      settlements.save(settlement);
      created.add(settlement);
    }
    Map<UUID, String> names = resolveDisplayNames(participantIds(created));
    return created.stream().map(s -> toResponse(s, names)).toList();
  }

  public BigDecimal netAlreadyGenerated(SourceType sourceType, UUID sourceId, UUID userId) {
    return settlements.netAlreadyGeneratedForUser(sourceType, sourceId, userId);
  }

  public List<SettlementResponse> listForUser(UUID userId) {
    List<Settlement> mine = settlements.findAllInvolvingUser(userId);
    Map<UUID, String> names = resolveDisplayNames(participantIds(mine));
    return mine.stream().map(s -> toResponse(s, names)).toList();
  }

  public SettlementResponse getForUser(UUID userId, UUID settlementId) {
    Settlement settlement = requireInvolvedSettlement(userId, settlementId);
    Map<UUID, String> names = resolveDisplayNames(participantIds(List.of(settlement)));
    return toResponse(settlement, names);
  }

  public List<SettlementPaymentResponse> listPayments(UUID userId, UUID settlementId) {
    requireInvolvedSettlement(userId, settlementId);
    List<SettlementPayment> history = payments.findBySettlementIdOrderByPaidAtAsc(settlementId);
    Map<UUID, String> names =
        resolveDisplayNames(
            history.stream()
                .map(SettlementPayment::getRecordedByUserId)
                .collect(Collectors.toSet()));
    return history.stream()
        .map(
            p ->
                new SettlementPaymentResponse(
                    p.getId(),
                    p.getAmount(),
                    p.getRecordedByUserId(),
                    names.get(p.getRecordedByUserId()),
                    p.getNote(),
                    p.getPaidAt()))
        .toList();
  }

  @Transactional
  public SettlementResponse recordPayment(
      UUID userId, UUID settlementId, RecordSettlementPaymentRequest request) {
    Settlement settlement =
        settlements
            .findByIdInvolvingUserForUpdate(settlementId, userId)
            .orElseThrow(
                () ->
                    new NotFoundException("SETTLEMENT_NOT_FOUND", "Settlement not found."));
    if (settlement.getCancelledAt() != null) {
      throw new ConflictException(
          "SETTLEMENT_CANCELLED", "This settlement was cancelled and can't take payments.");
    }
    BigDecimal remaining = settlement.getAmount().subtract(payments.sumBySettlementId(settlementId));
    if (request.amount().compareTo(remaining) > 0) {
      throw new ConflictException(
          "PAYMENT_EXCEEDS_REMAINING",
          "Payment cannot exceed the settlement's remaining amount.");
    }
    payments.save(new SettlementPayment(settlementId, request.amount(), userId, request.note()));
    auditLogService.record(
        userId,
        AuditAction.PAYMENT_MARKED,
        "Settlement",
        settlementId,
        Map.of("amount", request.amount()));
    Map<UUID, String> names = resolveDisplayNames(participantIds(List.of(settlement)));
    return toResponse(settlement, names);
  }

  @Transactional
  public SettlementResponse cancel(UUID userId, UUID settlementId) {
    Settlement settlement = requireInvolvedSettlement(userId, settlementId);
    settlement.setCancelledAt(Instant.now());
    settlements.save(settlement);
    Map<UUID, String> names = resolveDisplayNames(participantIds(List.of(settlement)));
    return toResponse(settlement, names);
  }

  @Transactional
  public SettlementResponse dispute(UUID userId, UUID settlementId) {
    Settlement settlement = requireInvolvedSettlement(userId, settlementId);
    settlement.setDisputedAt(Instant.now());
    settlements.save(settlement);
    Map<UUID, String> names = resolveDisplayNames(participantIds(List.of(settlement)));
    return toResponse(settlement, names);
  }

  public SettlementSummaryResponse getSummary(UUID userId) {
    List<Settlement> mine =
        settlements.findAllInvolvingUser(userId).stream()
            .filter(s -> s.getCancelledAt() == null)
            .toList();

    Map<UUID, BigDecimal> netByCounterparty = new LinkedHashMap<>();
    Map<UUID, Instant> oldestUnpaidByCounterparty = new LinkedHashMap<>();

    for (Settlement s : mine) {
      BigDecimal paid = payments.sumBySettlementId(s.getId());
      BigDecimal remaining = s.getAmount().subtract(paid);
      if (remaining.signum() <= 0) {
        continue;
      }
      UUID counterpartyId = s.getFromUserId().equals(userId) ? s.getToUserId() : s.getFromUserId();
      BigDecimal signedRemaining = s.getToUserId().equals(userId) ? remaining : remaining.negate();
      netByCounterparty.merge(counterpartyId, signedRemaining, BigDecimal::add);
      oldestUnpaidByCounterparty.merge(
          counterpartyId, s.getCreatedAt(), (a, b) -> a.isBefore(b) ? a : b);
    }

    Map<UUID, String> names = resolveDisplayNames(netByCounterparty.keySet());
    List<CounterpartySummary> owedToMe = new ArrayList<>();
    List<CounterpartySummary> iOwe = new ArrayList<>();
    BigDecimal totalOwedToMe = new BigDecimal("0.00");
    BigDecimal totalIOwe = new BigDecimal("0.00");

    for (Map.Entry<UUID, BigDecimal> entry : netByCounterparty.entrySet()) {
      BigDecimal net = entry.getValue();
      if (net.signum() == 0) {
        continue;
      }
      long days =
          Duration.between(oldestUnpaidByCounterparty.get(entry.getKey()), Instant.now()).toDays();
      String name = names.get(entry.getKey());
      if (net.signum() > 0) {
        owedToMe.add(new CounterpartySummary(entry.getKey(), name, net, days));
        totalOwedToMe = totalOwedToMe.add(net);
      } else {
        BigDecimal magnitude = net.negate();
        iOwe.add(new CounterpartySummary(entry.getKey(), name, magnitude, days));
        totalIOwe = totalIOwe.add(magnitude);
      }
    }
    owedToMe.sort((a, b) -> b.netAmount().compareTo(a.netAmount()));
    iOwe.sort((a, b) -> b.netAmount().compareTo(a.netAmount()));
    return new SettlementSummaryResponse(totalOwedToMe, totalIOwe, owedToMe, iOwe);
  }

  private SettlementResponse toResponse(Settlement s, Map<UUID, String> names) {
    BigDecimal amountPaid = payments.sumBySettlementId(s.getId());
    SettlementStatus status;
    if (s.getCancelledAt() != null) {
      status = SettlementStatus.CANCELLED;
    } else if (s.getDisputedAt() != null) {
      status = SettlementStatus.DISPUTED;
    } else if (amountPaid.signum() == 0) {
      status = SettlementStatus.UNPAID;
    } else if (amountPaid.compareTo(s.getAmount()) >= 0) {
      status = SettlementStatus.PAID;
    } else {
      status = SettlementStatus.PARTIALLY_PAID;
    }
    BigDecimal remaining = s.getAmount().subtract(amountPaid).max(BigDecimal.ZERO);
    PaymentHandoffLink handoff =
        handoffService.buildHandoffLink(
            remaining.signum() > 0 ? remaining : s.getAmount(), names.get(s.getToUserId()));
    return new SettlementResponse(
        s.getId(),
        s.getFromUserId(),
        names.get(s.getFromUserId()),
        s.getToUserId(),
        names.get(s.getToUserId()),
        s.getAmount(),
        amountPaid,
        remaining,
        status,
        s.getSourceType(),
        s.getSourceId(),
        s.getCreatedAt(),
        handoff);
  }

  private Set<UUID> participantIds(List<Settlement> list) {
    Set<UUID> ids = new HashSet<>();
    for (Settlement s : list) {
      ids.add(s.getFromUserId());
      ids.add(s.getToUserId());
    }
    return ids;
  }

  private Map<UUID, String> resolveDisplayNames(Set<UUID> userIds) {
    return users.findAllById(userIds).stream()
        .collect(Collectors.toMap(User::getId, User::getDisplayName));
  }

  private Settlement requireInvolvedSettlement(UUID userId, UUID settlementId) {
    return settlements
        .findByIdInvolvingUser(settlementId, userId)
        .orElseThrow(() -> new NotFoundException("SETTLEMENT_NOT_FOUND", "Settlement not found."));
  }
}
