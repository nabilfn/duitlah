package com.duitlah.api.personaltax;

import java.math.BigDecimal;
import java.util.UUID;

public record PcbPaymentResponse(
    UUID id, int yearOfAssessment, int month, BigDecimal amount, String notes) {

  public static PcbPaymentResponse from(PcbPayment payment) {
    return new PcbPaymentResponse(
        payment.getId(),
        payment.getYearOfAssessment(),
        payment.getMonth(),
        payment.getAmount(),
        payment.getNotes());
  }
}
