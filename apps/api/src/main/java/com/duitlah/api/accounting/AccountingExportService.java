package com.duitlah.api.accounting;

import com.duitlah.api.exports.CsvExportWriter;
import com.duitlah.api.exports.ExportFormat;
import com.duitlah.api.exports.PdfExportWriter;
import com.duitlah.api.exports.TabularData;
import com.duitlah.api.exports.XlsxExportWriter;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;

/**
 * Reuses the existing {@code exports} writers (Phase 3) rather than a second CSV/PDF-writing code
 * path — every accounting report just needs to produce a {@link TabularData}.
 */
@Service
public class AccountingExportService {

  private final TrialBalanceService trialBalanceService;
  private final IncomeStatementService incomeStatementService;
  private final BalanceSheetService balanceSheetService;
  private final CsvExportWriter csvWriter;
  private final PdfExportWriter pdfWriter;
  private final XlsxExportWriter xlsxWriter;

  public AccountingExportService(
      TrialBalanceService trialBalanceService,
      IncomeStatementService incomeStatementService,
      BalanceSheetService balanceSheetService,
      CsvExportWriter csvWriter,
      PdfExportWriter pdfWriter,
      XlsxExportWriter xlsxWriter) {
    this.trialBalanceService = trialBalanceService;
    this.incomeStatementService = incomeStatementService;
    this.balanceSheetService = balanceSheetService;
    this.csvWriter = csvWriter;
    this.pdfWriter = pdfWriter;
    this.xlsxWriter = xlsxWriter;
  }

  public byte[] exportTrialBalance(UUID userId, UUID spaceId, LocalDate asOf, ExportFormat format) {
    TrialBalanceResponse report = trialBalanceService.generate(userId, spaceId, asOf);
    List<List<String>> rows =
        report.lines().stream()
            .map(
                l ->
                    List.of(
                        l.accountCode(),
                        l.accountName(),
                        l.type().name(),
                        l.debit().toPlainString(),
                        l.credit().toPlainString()))
            .collect(java.util.stream.Collectors.toCollection(java.util.ArrayList::new));
    rows.add(
        List.of(
            "",
            "",
            "Total",
            report.totalDebit().toPlainString(),
            report.totalCredit().toPlainString()));
    TabularData data =
        new TabularData(
            "Trial Balance as of " + asOf,
            List.of("Code", "Account", "Type", "Debit", "Credit"),
            rows);
    return write(data, format);
  }

  public byte[] exportIncomeStatement(
      UUID userId, UUID spaceId, LocalDate from, LocalDate to, ExportFormat format) {
    IncomeStatementResponse report = incomeStatementService.generate(userId, spaceId, from, to);
    List<List<String>> rows = new java.util.ArrayList<>();
    report
        .revenueLines()
        .forEach(l -> rows.add(List.of("Revenue", l.accountName(), l.amount().toPlainString())));
    rows.add(List.of("", "Total Revenue", report.totalRevenue().toPlainString()));
    report
        .expenseLines()
        .forEach(l -> rows.add(List.of("Expense", l.accountName(), l.amount().toPlainString())));
    rows.add(List.of("", "Total Expenses", report.totalExpenses().toPlainString()));
    rows.add(List.of("", "Net Income", report.netIncome().toPlainString()));
    TabularData data =
        new TabularData(
            "Profit & Loss: " + from + " to " + to, List.of("Section", "Account", "Amount"), rows);
    return write(data, format);
  }

  public byte[] exportBalanceSheet(UUID userId, UUID spaceId, LocalDate asOf, ExportFormat format) {
    BalanceSheetResponse report = balanceSheetService.generate(userId, spaceId, asOf);
    List<List<String>> rows = new java.util.ArrayList<>();
    report
        .assets()
        .forEach(l -> rows.add(List.of("Asset", l.accountName(), l.amount().toPlainString())));
    rows.add(List.of("", "Total Assets", report.totalAssets().toPlainString()));
    report
        .liabilities()
        .forEach(l -> rows.add(List.of("Liability", l.accountName(), l.amount().toPlainString())));
    rows.add(List.of("", "Total Liabilities", report.totalLiabilities().toPlainString()));
    report
        .equity()
        .forEach(l -> rows.add(List.of("Equity", l.accountName(), l.amount().toPlainString())));
    rows.add(List.of("Equity", "Current Earnings", report.currentEarnings().toPlainString()));
    rows.add(
        List.of(
            "", "Total Liabilities & Equity", report.totalLiabilitiesAndEquity().toPlainString()));
    TabularData data =
        new TabularData(
            "Balance Sheet as of " + asOf, List.of("Section", "Account", "Amount"), rows);
    return write(data, format);
  }

  private byte[] write(TabularData data, ExportFormat format) {
    return switch (format) {
      case CSV -> csvWriter.write(data);
      case XLSX -> xlsxWriter.write(data);
      case PDF -> pdfWriter.write(data);
    };
  }
}
