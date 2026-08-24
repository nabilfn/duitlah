package com.duitlah.api.sales;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

public record CreditNoteResponse(
    UUID id,
    UUID customerId,
    UUID invoiceId,
    String creditNoteNumber,
    LocalDate issueDate,
    BigDecimal amount,
    String reason,
    CreditNoteStatus status) {

  static CreditNoteResponse of(CreditNote c) {
    return new CreditNoteResponse(
        c.getId(),
        c.getCustomerId(),
        c.getInvoiceId(),
        c.getCreditNoteNumber(),
        c.getIssueDate(),
        c.getAmount(),
        c.getReason(),
        c.getStatus());
  }
}
