package com.duitlah.api.liabilities;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

public record LiabilityPaymentResponse(
    UUID id,
    BigDecimal amount,
    BigDecimal principalPortion,
    BigDecimal interestPortion,
    LocalDate paidOn,
    UUID linkedTransactionId) {

  public static LiabilityPaymentResponse from(LiabilityPayment payment) {
    return new LiabilityPaymentResponse(
        payment.getId(),
        payment.getAmount(),
        payment.getPrincipalPortion(),
        payment.getInterestPortion(),
        payment.getPaidOn(),
        payment.getLinkedTransactionId());
  }
}
