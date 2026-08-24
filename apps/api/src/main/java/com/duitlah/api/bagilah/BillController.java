package com.duitlah.api.bagilah;

import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

@RestController
public class BillController {

  private final BillService billService;

  public BillController(BillService billService) {
    this.billService = billService;
  }

  @GetMapping("/api/v1/bills")
  public List<BillResponse> list(@AuthenticationPrincipal UUID userId) {
    return billService.listForUser(userId);
  }

  @GetMapping("/api/v1/bills/{billId}")
  public BillResponse get(@AuthenticationPrincipal UUID userId, @PathVariable UUID billId) {
    return billService.getForUser(userId, billId);
  }

  @PostMapping("/api/v1/bills")
  @ResponseStatus(HttpStatus.CREATED)
  public BillResponse create(
      @AuthenticationPrincipal UUID userId, @Valid @RequestBody CreateBillRequest request) {
    return billService.create(userId, request);
  }

  @PatchMapping("/api/v1/bills/{billId}")
  public BillResponse update(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID billId,
      @Valid @RequestBody UpdateBillRequest request) {
    return billService.update(userId, billId, request);
  }

  @DeleteMapping("/api/v1/bills/{billId}")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  public void cancel(@AuthenticationPrincipal UUID userId, @PathVariable UUID billId) {
    billService.cancel(userId, billId);
  }

  @PostMapping("/api/v1/bills/{billId}/finalize")
  public BillResponse finalizeBill(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID billId) {
    return billService.finalizeBill(userId, billId);
  }

  @PostMapping("/api/v1/bills/{billId}/invite-token")
  public InviteTokenResponse regenerateInviteToken(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID billId) {
    return billService.regenerateInviteToken(userId, billId);
  }

  @GetMapping(path = "/api/v1/bills/{billId}/events", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
  public SseEmitter subscribeToEvents(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID billId) {
    return billService.subscribeToEvents(userId, billId);
  }

  @GetMapping("/api/v1/bills/{billId}/items")
  public List<ReceiptItemResponse> listItems(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID billId) {
    return billService.listItems(userId, billId);
  }

  @PostMapping("/api/v1/bills/{billId}/items")
  @ResponseStatus(HttpStatus.CREATED)
  public ReceiptItemResponse addItem(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID billId,
      @Valid @RequestBody CreateReceiptItemRequest request) {
    return billService.addItem(userId, billId, request);
  }

  @PatchMapping("/api/v1/bills/{billId}/items/{itemId}")
  public ReceiptItemResponse updateItem(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID billId,
      @PathVariable UUID itemId,
      @Valid @RequestBody CreateReceiptItemRequest request) {
    return billService.updateItem(userId, billId, itemId, request);
  }

  @DeleteMapping("/api/v1/bills/{billId}/items/{itemId}")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  public void deleteItem(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID billId, @PathVariable UUID itemId) {
    billService.deleteItem(userId, billId, itemId);
  }

  @GetMapping("/api/v1/bills/{billId}/participants")
  public List<ParticipantResponse> listParticipants(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID billId) {
    return billService.listParticipants(userId, billId);
  }

  @PostMapping("/api/v1/bills/{billId}/participants")
  @ResponseStatus(HttpStatus.CREATED)
  public ParticipantResponse addParticipant(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID billId,
      @Valid @RequestBody AddParticipantRequest request) {
    return billService.addParticipant(userId, billId, request);
  }

  @DeleteMapping("/api/v1/bills/{billId}/participants/{participantId}")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  public void removeParticipant(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID billId,
      @PathVariable UUID participantId) {
    billService.removeParticipant(userId, billId, participantId);
  }

  @GetMapping("/api/v1/bills/{billId}/items/{itemId}/claims")
  public List<ClaimResponse> listClaims(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID billId, @PathVariable UUID itemId) {
    return billService.listClaims(userId, billId, itemId);
  }

  @PostMapping("/api/v1/bills/{billId}/items/{itemId}/claims")
  @ResponseStatus(HttpStatus.CREATED)
  public ClaimResponse addClaim(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID billId,
      @PathVariable UUID itemId,
      @Valid @RequestBody ClaimRequest request) {
    return billService.addClaim(userId, billId, itemId, request);
  }

  @PostMapping("/api/v1/bills/{billId}/items/{itemId}/claims/equal-split")
  public List<ClaimResponse> equalSplitItem(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID billId,
      @PathVariable UUID itemId,
      @Valid @RequestBody EqualSplitClaimRequest request) {
    return billService.equalSplitItem(userId, billId, itemId, request);
  }

  @DeleteMapping("/api/v1/bills/{billId}/items/{itemId}/claims/{claimId}")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  public void removeClaim(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID billId,
      @PathVariable UUID itemId,
      @PathVariable UUID claimId) {
    billService.removeClaim(userId, billId, itemId, claimId);
  }

  @GetMapping("/api/v1/bills/{billId}/payments")
  public List<PaymentResponse> listPayments(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID billId) {
    return billService.listPayments(userId, billId);
  }

  @PutMapping("/api/v1/bills/{billId}/payments/{participantId}")
  public PaymentResponse recordPayment(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID billId,
      @PathVariable UUID participantId,
      @Valid @RequestBody RecordPaymentRequest request) {
    return billService.recordPayment(userId, billId, participantId, request);
  }

  @DeleteMapping("/api/v1/bills/{billId}/payments/{participantId}")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  public void removePayment(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID billId,
      @PathVariable UUID participantId) {
    billService.removePayment(userId, billId, participantId);
  }

  @GetMapping("/api/v1/bills/{billId}/breakdown")
  public BreakdownResponse getBreakdown(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID billId) {
    return billService.getBreakdown(userId, billId);
  }

  @GetMapping("/api/v1/bills/{billId}/balances")
  public List<BillBalanceResponse> getBalances(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID billId) {
    return billService.getBalances(userId, billId);
  }
}
