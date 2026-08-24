package com.duitlah.api.settlements;

import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class SettlementController {

  private final SettlementService settlementService;

  public SettlementController(SettlementService settlementService) {
    this.settlementService = settlementService;
  }

  @GetMapping("/api/v1/settlements")
  public List<SettlementResponse> list(@AuthenticationPrincipal UUID userId) {
    return settlementService.listForUser(userId);
  }

  @GetMapping("/api/v1/settlements/summary")
  public SettlementSummaryResponse summary(@AuthenticationPrincipal UUID userId) {
    return settlementService.getSummary(userId);
  }

  @GetMapping("/api/v1/settlements/{settlementId}")
  public SettlementResponse get(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID settlementId) {
    return settlementService.getForUser(userId, settlementId);
  }

  @GetMapping("/api/v1/settlements/{settlementId}/payments")
  public List<SettlementPaymentResponse> listPayments(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID settlementId) {
    return settlementService.listPayments(userId, settlementId);
  }

  @PostMapping("/api/v1/settlements/{settlementId}/payments")
  public SettlementResponse recordPayment(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID settlementId,
      @Valid @RequestBody RecordSettlementPaymentRequest request) {
    return settlementService.recordPayment(userId, settlementId, request);
  }

  @PostMapping("/api/v1/settlements/{settlementId}/cancel")
  public SettlementResponse cancel(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID settlementId) {
    return settlementService.cancel(userId, settlementId);
  }

  @PostMapping("/api/v1/settlements/{settlementId}/dispute")
  public SettlementResponse dispute(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID settlementId) {
    return settlementService.dispute(userId, settlementId);
  }
}
