package com.duitlah.api.exports;

import java.time.LocalDate;
import java.util.UUID;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ExportController {

  private final ExportService exports;

  public ExportController(ExportService exports) {
    this.exports = exports;
  }

  @GetMapping("/api/v1/exports/transactions")
  public ResponseEntity<byte[]> transactions(
      @AuthenticationPrincipal UUID userId,
      @RequestParam LocalDate from,
      @RequestParam LocalDate to,
      @RequestParam(defaultValue = "CSV") ExportFormat format) {
    return download("transactions", format, exports.exportTransactions(userId, from, to, format));
  }

  @GetMapping("/api/v1/exports/bills")
  public ResponseEntity<byte[]> bills(
      @AuthenticationPrincipal UUID userId,
      @RequestParam(defaultValue = "CSV") ExportFormat format) {
    return download("bills", format, exports.exportBills(userId, format));
  }

  @GetMapping("/api/v1/exports/loans")
  public ResponseEntity<byte[]> loans(
      @AuthenticationPrincipal UUID userId,
      @RequestParam(defaultValue = "CSV") ExportFormat format) {
    return download("loans", format, exports.exportLoans(userId, format));
  }

  @GetMapping("/api/v1/exports/net-worth")
  public ResponseEntity<byte[]> netWorth(
      @AuthenticationPrincipal UUID userId,
      @RequestParam(defaultValue = "CSV") ExportFormat format) {
    return download("net-worth", format, exports.exportNetWorth(userId, format));
  }

  @GetMapping("/api/v1/exports/budgets")
  public ResponseEntity<byte[]> budgets(
      @AuthenticationPrincipal UUID userId,
      @RequestParam int year,
      @RequestParam int month,
      @RequestParam(defaultValue = "CSV") ExportFormat format) {
    return download("budgets", format, exports.exportBudgets(userId, year, month, format));
  }

  @GetMapping("/api/v1/exports/archive")
  public ResponseEntity<byte[]> archive(@AuthenticationPrincipal UUID userId) {
    byte[] content = exports.exportFullArchive(userId);
    return ResponseEntity.ok()
        .contentType(MediaType.valueOf("application/zip"))
        .header(
            HttpHeaders.CONTENT_DISPOSITION,
            ContentDisposition.attachment().filename("duitlah-export.zip").build().toString())
        .body(content);
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
