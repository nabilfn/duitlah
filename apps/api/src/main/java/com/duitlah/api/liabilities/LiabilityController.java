package com.duitlah.api.liabilities;

import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class LiabilityController {

  private final LiabilityService liabilities;

  public LiabilityController(LiabilityService liabilities) {
    this.liabilities = liabilities;
  }

  @PostMapping("/api/v1/liabilities")
  @ResponseStatus(HttpStatus.CREATED)
  public LiabilityResponse create(
      @AuthenticationPrincipal UUID userId, @Valid @RequestBody CreateLiabilityRequest request) {
    return liabilities.create(userId, request);
  }

  @GetMapping("/api/v1/liabilities")
  public List<LiabilityResponse> list(@AuthenticationPrincipal UUID userId) {
    return liabilities.list(userId);
  }

  @GetMapping("/api/v1/liabilities/{liabilityId}")
  public LiabilityResponse get(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID liabilityId) {
    return liabilities.get(userId, liabilityId);
  }

  @PostMapping("/api/v1/liabilities/{liabilityId}/payments")
  @ResponseStatus(HttpStatus.CREATED)
  public LiabilityPaymentResponse recordPayment(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID liabilityId,
      @Valid @RequestBody RecordLiabilityPaymentRequest request) {
    return liabilities.recordPayment(userId, liabilityId, request);
  }

  @GetMapping("/api/v1/liabilities/{liabilityId}/payments")
  public List<LiabilityPaymentResponse> listPayments(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID liabilityId) {
    return liabilities.listPayments(userId, liabilityId);
  }
}
