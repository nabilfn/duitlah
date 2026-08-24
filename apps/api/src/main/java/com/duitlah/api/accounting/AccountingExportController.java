package com.duitlah.api.accounting;

import com.duitlah.api.exports.ExportFormat;
import java.time.LocalDate;
import java.util.UUID;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class AccountingExportController {

  private final AccountingExportService exports;

  public AccountingExportController(AccountingExportService exports) {
    this.exports = exports;
  }

  @GetMapping("/api/v1/spaces/{spaceId}/accounting/exports/trial-balance")
  public ResponseEntity<byte[]> trialBalance(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate asOf,
      @RequestParam(defaultValue = "CSV") ExportFormat format) {
    return download(
        "trial-balance", format, exports.exportTrialBalance(userId, spaceId, asOf, format));
  }

  @GetMapping("/api/v1/spaces/{spaceId}/accounting/exports/income-statement")
  public ResponseEntity<byte[]> incomeStatement(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
      @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to,
      @RequestParam(defaultValue = "CSV") ExportFormat format) {
    return download(
        "income-statement",
        format,
        exports.exportIncomeStatement(userId, spaceId, from, to, format));
  }

  @GetMapping("/api/v1/spaces/{spaceId}/accounting/exports/balance-sheet")
  public ResponseEntity<byte[]> balanceSheet(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate asOf,
      @RequestParam(defaultValue = "CSV") ExportFormat format) {
    return download(
        "balance-sheet", format, exports.exportBalanceSheet(userId, spaceId, asOf, format));
  }

  private static ResponseEntity<byte[]> download(
      String baseName, ExportFormat format, byte[] content) {
    String extension =
        switch (format) {
          case CSV -> "csv";
          case XLSX -> "xlsx";
          case PDF -> "pdf";
        };
    MediaType mediaType =
        switch (format) {
          case CSV -> MediaType.valueOf("text/csv");
          case XLSX ->
              MediaType.valueOf(
                  "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
          case PDF -> MediaType.APPLICATION_PDF;
        };
    return ResponseEntity.ok()
        .contentType(mediaType)
        .header(
            HttpHeaders.CONTENT_DISPOSITION,
            ContentDisposition.attachment().filename(baseName + "." + extension).build().toString())
        .body(content);
  }
}
