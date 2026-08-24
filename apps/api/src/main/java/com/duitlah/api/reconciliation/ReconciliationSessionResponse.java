package com.duitlah.api.reconciliation;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

public record ReconciliationSessionResponse(
    UUID id,
    UUID businessAccountId,
    UUID businessStatementImportId,
    BigDecimal statementEndingBalance,
    ReconciliationSessionStatus status,
    Instant startedAt,
    Instant completedAt) {

  static ReconciliationSessionResponse of(ReconciliationSession s) {
    return new ReconciliationSessionResponse(
        s.getId(),
        s.getBusinessAccountId(),
        s.getBusinessStatementImportId(),
        s.getStatementEndingBalance(),
        s.getStatus(),
        s.getStartedAt(),
        s.getCompletedAt());
  }
}
