package com.duitlah.api.statements;

import java.util.UUID;

public record StatementImportResponse(
    UUID id,
    UUID accountId,
    StatementProvider provider,
    String originalFilename,
    StatementImportStatus status,
    int rowCount,
    String errorMessage) {

  public static StatementImportResponse from(StatementImport statementImport) {
    return new StatementImportResponse(
        statementImport.getId(),
        statementImport.getAccountId(),
        statementImport.getProvider(),
        statementImport.getOriginalFilename(),
        statementImport.getStatus(),
        statementImport.getRowCount(),
        statementImport.getErrorMessage());
  }
}
