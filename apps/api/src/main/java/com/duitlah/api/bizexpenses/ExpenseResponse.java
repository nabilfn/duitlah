package com.duitlah.api.bizexpenses;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

public record ExpenseResponse(
    UUID id,
    UUID supplierId,
    String category,
    BigDecimal amount,
    BigDecimal amountPaid,
    BigDecimal amountRemaining,
    LocalDate occurredOn,
    ExpenseStatus status,
    UUID receiptId,
    UUID chartOfAccountsId,
    String notes) {

  static ExpenseResponse of(BusinessExpense e, BigDecimal amountPaid) {
    return new ExpenseResponse(
        e.getId(),
        e.getSupplierId(),
        e.getCategory(),
        e.getAmount(),
        amountPaid,
        e.getAmount().subtract(amountPaid),
        e.getOccurredOn(),
        e.getStatus(),
        e.getReceiptId(),
        e.getChartOfAccountsId(),
        e.getNotes());
  }
}
