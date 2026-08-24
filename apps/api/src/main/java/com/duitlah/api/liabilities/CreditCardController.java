package com.duitlah.api.liabilities;

import jakarta.validation.Valid;
import java.util.UUID;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class CreditCardController {

  private final CreditCardService creditCards;

  public CreditCardController(CreditCardService creditCards) {
    this.creditCards = creditCards;
  }

  @PutMapping("/api/v1/accounts/{accountId}/credit-card-details")
  public CreditCardDetailsResponse setDetails(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID accountId,
      @Valid @RequestBody SetCreditCardDetailsRequest request) {
    return creditCards.setDetails(userId, accountId, request);
  }

  @GetMapping("/api/v1/accounts/{accountId}/credit-card-details")
  public CreditCardDetailsResponse get(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID accountId) {
    return creditCards.get(userId, accountId);
  }
}
