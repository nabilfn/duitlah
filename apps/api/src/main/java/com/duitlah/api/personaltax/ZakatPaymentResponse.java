package com.duitlah.api.personaltax;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

public record ZakatPaymentResponse(
    UUID id,
    int yearOfAssessment,
    BigDecimal amount,
    LocalDate paidOn,
    UUID receiptId,
    String notes) {

  public static ZakatPaymentResponse from(ZakatPayment payment) {
    return new ZakatPaymentResponse(
        payment.getId(),
        payment.getYearOfAssessment(),
        payment.getAmount(),
        payment.getPaidOn(),
        payment.getReceiptId(),
        payment.getNotes());
  }
}
