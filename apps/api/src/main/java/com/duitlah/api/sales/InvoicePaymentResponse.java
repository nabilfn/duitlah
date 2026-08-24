package com.duitlah.api.sales;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

public record InvoicePaymentResponse(
    UUID id, UUID businessAccountId, BigDecimal amount, LocalDate paidOn, String notes) {

  static InvoicePaymentResponse of(InvoicePayment p) {
    return new InvoicePaymentResponse(
        p.getId(), p.getBusinessAccountId(), p.getAmount(), p.getPaidOn(), p.getNotes());
  }
}
