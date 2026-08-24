package com.duitlah.api.reconciliation;

import com.duitlah.api.bizbanking.BusinessAccountService;
import com.duitlah.api.common.error.ApiException;
import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.common.storage.ObjectStorage;
import com.duitlah.api.spaces.BusinessPermission;
import com.duitlah.api.spaces.SpaceService;
import com.duitlah.api.statements.ParsedStatementRow;
import com.duitlah.api.statements.StatementParser;
import com.duitlah.api.statements.StatementProvider;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Upload → parse → normalize into {@link BusinessStatementLine} rows, and auto-open a {@link
 * ReconciliationSession} for the import (1:1 — see the migration's own comment for why). Reuses
 * {@code statements}' parser adapters directly rather than a second parsing code path; unlike
 * {@code statements.StatementImportService}, rows here become durable, individually-trackable lines
 * (UNMATCHED/MATCHED/CREATED/IGNORED/SPLIT), not one-shot transaction candidates.
 */
@Service
public class BusinessStatementImportService {

  private static final long MAX_FILE_BYTES = 10L * 1024 * 1024;

  private final BusinessStatementImportRepository imports;
  private final BusinessStatementLineRepository lines;
  private final ReconciliationSessionRepository sessions;
  private final ObjectStorage storage;
  private final BusinessAccountService businessAccountService;
  private final SpaceService spaceService;
  private final Map<StatementProvider, StatementParser> parsersByProvider;

  public BusinessStatementImportService(
      BusinessStatementImportRepository imports,
      BusinessStatementLineRepository lines,
      ReconciliationSessionRepository sessions,
      ObjectStorage storage,
      BusinessAccountService businessAccountService,
      SpaceService spaceService,
      List<StatementParser> parsers) {
    this.imports = imports;
    this.lines = lines;
    this.sessions = sessions;
    this.storage = storage;
    this.businessAccountService = businessAccountService;
    this.spaceService = spaceService;
    this.parsersByProvider =
        parsers.stream()
            .collect(java.util.stream.Collectors.toMap(StatementParser::provider, p -> p));
  }

  @Transactional
  public BusinessStatementImportResponse upload(
      UUID userId,
      UUID spaceId,
      UUID businessAccountId,
      String originalFilename,
      String contentType,
      byte[] fileBytes) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_BANKING);
    businessAccountService.requireOwned(spaceId, businessAccountId);
    if (fileBytes.length == 0) {
      throw new ApiException(HttpStatus.BAD_REQUEST, "EMPTY_FILE", "The uploaded file is empty.");
    }
    if (fileBytes.length > MAX_FILE_BYTES) {
      throw new ApiException(
          HttpStatus.BAD_REQUEST, "FILE_TOO_LARGE", "Statements must be under 10MB.");
    }
    StatementProvider provider = detectProvider(originalFilename, contentType);

    String storageKey =
        "business-statements/" + spaceId + "/" + UUID.randomUUID() + extensionFor(provider);
    storage.put(
        storageKey, fileBytes, contentType != null ? contentType : "application/octet-stream");

    BusinessStatementImport statementImport =
        new BusinessStatementImport(
            spaceId, businessAccountId, provider, originalFilename, storageKey, userId);

    List<ParsedStatementRow> rows = parsersByProvider.get(provider).parse(fileBytes);
    if (rows.isEmpty()) {
      statementImport.setStatus(BusinessStatementImportStatus.FAILED);
      statementImport.setErrorMessage(
          "Couldn't detect any transactions in this file — check it has a date and amount column.");
    } else {
      statementImport.setStatus(BusinessStatementImportStatus.PARSED);
      statementImport.setRowCount(rows.size());
    }
    imports.save(statementImport);

    for (ParsedStatementRow row : rows) {
      lines.save(
          new BusinessStatementLine(
              statementImport.getId(), row.date(), row.description(), row.amount()));
    }

    UUID sessionId = null;
    if (statementImport.getStatus() == BusinessStatementImportStatus.PARSED) {
      ReconciliationSession session =
          new ReconciliationSession(spaceId, businessAccountId, statementImport.getId(), userId);
      sessions.save(session);
      sessionId = session.getId();
    }

    return BusinessStatementImportResponse.of(statementImport, sessionId);
  }

  public List<BusinessStatementImportResponse> list(UUID userId, UUID spaceId) {
    spaceService.requireMembership(userId, spaceId);
    return imports.findBySpaceIdOrderByCreatedAtDesc(spaceId).stream()
        .map(
            i ->
                BusinessStatementImportResponse.of(
                    i,
                    sessions
                        .findByBusinessStatementImportId(i.getId())
                        .map(ReconciliationSession::getId)
                        .orElse(null)))
        .toList();
  }

  public List<StatementLineResponse> listLines(UUID userId, UUID spaceId, UUID importId) {
    spaceService.requireMembership(userId, spaceId);
    requireOwned(spaceId, importId);
    return lines.findByBusinessStatementImportIdOrderByOccurredOnAsc(importId).stream()
        .map(StatementLineResponse::of)
        .toList();
  }

  public BusinessStatementImport requireOwned(UUID spaceId, UUID importId) {
    return imports
        .findByIdAndSpaceId(importId, spaceId)
        .orElseThrow(
            () ->
                new NotFoundException("STATEMENT_IMPORT_NOT_FOUND", "Statement import not found."));
  }

  private static StatementProvider detectProvider(String filename, String contentType) {
    String lowerName = filename != null ? filename.toLowerCase() : "";
    String lowerType = contentType != null ? contentType.toLowerCase() : "";
    if (lowerName.endsWith(".csv") || lowerType.contains("csv")) {
      return StatementProvider.GENERIC_CSV;
    }
    if (lowerName.endsWith(".xlsx")
        || lowerName.endsWith(".xls")
        || lowerType.contains("spreadsheet")
        || lowerType.contains("excel")) {
      return StatementProvider.GENERIC_EXCEL;
    }
    if (lowerName.endsWith(".pdf") || lowerType.contains("pdf")) {
      return StatementProvider.PDF;
    }
    throw new ApiException(
        HttpStatus.BAD_REQUEST,
        "UNSUPPORTED_FILE_TYPE",
        "Upload a CSV, XLSX, or PDF bank statement export.");
  }

  private static String extensionFor(StatementProvider provider) {
    return switch (provider) {
      case GENERIC_CSV -> ".csv";
      case GENERIC_EXCEL -> ".xlsx";
      case PDF -> ".pdf";
    };
  }
}
