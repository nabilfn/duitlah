package com.duitlah.api.reconciliation;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

public record StatementLineResponse(
    UUID id,
    LocalDate occurredOn,
    String description,
    BigDecimal amount,
    StatementLineStatus status) {

  static StatementLineResponse of(BusinessStatementLine l) {
    return new StatementLineResponse(
        l.getId(), l.getOccurredOn(), l.getDescription(), l.getAmount(), l.getStatus());
  }
}
