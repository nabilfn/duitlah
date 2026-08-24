package com.duitlah.api.statements;

import com.duitlah.api.autotrack.CandidateSourceType;
import com.duitlah.api.autotrack.TransactionCandidateService;
import com.duitlah.api.common.error.ApiException;
import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.common.storage.ObjectStorage;
import com.duitlah.api.finance.AccountService;
import com.duitlah.api.spaces.SpaceService;
import com.duitlah.api.transactions.TransactionDirection;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Upload → parse → normalize → hand off to AutoTrack (spec section 13). Each parsed row becomes a
 * {@code transaction_candidate} in the same request — there's no separate "review the raw parsed
 * rows" screen, since AutoTrack's own PENDING-candidate list already is that review step; building
 * a second one here would duplicate it.
 */
@Service
public class StatementImportService {

  private static final long MAX_FILE_BYTES = 10L * 1024 * 1024;

  private final StatementImportRepository imports;
  private final ObjectStorage storage;
  private final AccountService accountService;
  private final SpaceService spaceService;
  private final TransactionCandidateService candidateService;
  private final Map<StatementProvider, StatementParser> parsersByProvider;

  public StatementImportService(
      StatementImportRepository imports,
      ObjectStorage storage,
      AccountService accountService,
      SpaceService spaceService,
      TransactionCandidateService candidateService,
      List<StatementParser> parsers) {
    this.imports = imports;
    this.storage = storage;
    this.accountService = accountService;
    this.spaceService = spaceService;
    this.candidateService = candidateService;
    this.parsersByProvider =
        parsers.stream()
            .collect(java.util.stream.Collectors.toMap(StatementParser::provider, p -> p));
  }

  @Transactional
  public StatementImportResponse upload(
      UUID userId, UUID accountId, String originalFilename, String contentType, byte[] fileBytes) {
    accountService.requireOwned(userId, accountId);
    if (fileBytes.length == 0) {
      throw new ApiException(HttpStatus.BAD_REQUEST, "EMPTY_FILE", "The uploaded file is empty.");
    }
    if (fileBytes.length > MAX_FILE_BYTES) {
      throw new ApiException(
          HttpStatus.BAD_REQUEST, "FILE_TOO_LARGE", "Statements must be under 10MB.");
    }
    StatementProvider provider = detectProvider(originalFilename, contentType);

    String storageKey = "statements/" + userId + "/" + UUID.randomUUID() + extensionFor(provider);
    storage.put(
        storageKey, fileBytes, contentType != null ? contentType : "application/octet-stream");

    UUID spaceId = spaceService.personalSpaceIdFor(userId);
    StatementImport statementImport =
        new StatementImport(userId, spaceId, accountId, provider, originalFilename, storageKey);

    List<ParsedStatementRow> rows = parsersByProvider.get(provider).parse(fileBytes);
    if (rows.isEmpty()) {
      statementImport.setStatus(StatementImportStatus.FAILED);
      statementImport.setErrorMessage(
          "Couldn't detect any transactions in this file — check it has a date and amount column.");
    } else {
      statementImport.setStatus(StatementImportStatus.PARSED);
      statementImport.setRowCount(rows.size());
    }
    imports.save(statementImport);

    for (ParsedStatementRow row : rows) {
      CandidateSourceType sourceType =
          switch (provider) {
            case GENERIC_CSV -> CandidateSourceType.STATEMENT_CSV;
            case GENERIC_EXCEL -> CandidateSourceType.STATEMENT_XLSX;
            case PDF -> CandidateSourceType.STATEMENT_PDF;
          };
      candidateService.create(
          userId,
          spaceId,
          sourceType,
          null,
          statementImport.getId(),
          row.amount().abs(),
          "MYR",
          row.description(),
          row.date(),
          row.amount().signum() >= 0 ? TransactionDirection.IN : TransactionDirection.OUT,
          accountId,
          BigDecimal.valueOf(row.confidence()));
    }

    return StatementImportResponse.from(statementImport);
  }

  public List<StatementImportResponse> list(UUID userId) {
    return imports.findByUserIdOrderByCreatedAtDesc(userId).stream()
        .map(StatementImportResponse::from)
        .toList();
  }

  public StatementImportResponse get(UUID userId, UUID importId) {
    return StatementImportResponse.from(requireOwned(userId, importId));
  }

  private StatementImport requireOwned(UUID userId, UUID importId) {
    return imports
        .findByIdAndUserId(importId, userId)
        .orElseThrow(
            () -> new NotFoundException("STATEMENT_IMPORT_NOT_FOUND", "Import not found."));
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
