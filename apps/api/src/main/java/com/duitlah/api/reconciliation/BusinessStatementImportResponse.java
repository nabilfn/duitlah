package com.duitlah.api.reconciliation;

import com.duitlah.api.statements.StatementProvider;
import java.util.UUID;

public record BusinessStatementImportResponse(
    UUID id,
    UUID businessAccountId,
    StatementProvider provider,
    String originalFilename,
    BusinessStatementImportStatus status,
    int rowCount,
    String errorMessage,
    UUID reconciliationSessionId) {

  static BusinessStatementImportResponse of(
      BusinessStatementImport i, UUID reconciliationSessionId) {
    return new BusinessStatementImportResponse(
        i.getId(),
        i.getBusinessAccountId(),
        i.getProvider(),
        i.getOriginalFilename(),
        i.getStatus(),
        i.getRowCount(),
        i.getErrorMessage(),
        reconciliationSessionId);
  }
}
