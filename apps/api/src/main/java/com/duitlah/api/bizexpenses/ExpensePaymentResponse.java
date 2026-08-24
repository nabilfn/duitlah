package com.duitlah.api.bizexpenses;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

public record ExpensePaymentResponse(
    UUID id, UUID businessAccountId, BigDecimal amount, LocalDate paidOn, String notes) {

  static ExpensePaymentResponse of(ExpensePayment p) {
    return new ExpensePaymentResponse(
        p.getId(), p.getBusinessAccountId(), p.getAmount(), p.getPaidOn(), p.getNotes());
  }
}
