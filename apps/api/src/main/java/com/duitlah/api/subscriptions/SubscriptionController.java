package com.duitlah.api.subscriptions;

import jakarta.validation.Valid;
import java.util.UUID;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class SubscriptionController {

  private final SubscriptionService subscriptionService;

  public SubscriptionController(SubscriptionService subscriptionService) {
    this.subscriptionService = subscriptionService;
  }

  @GetMapping("/api/v1/subscriptions/me")
  public EntitlementResponse me(@AuthenticationPrincipal UUID userId) {
    return subscriptionService.getEntitlement(userId);
  }

  @PostMapping("/api/v1/subscriptions/verify")
  public EntitlementResponse verify(
      @AuthenticationPrincipal UUID userId, @Valid @RequestBody VerifyPurchaseRequest request) {
    return subscriptionService.verifyPurchase(userId, request);
  }
}
