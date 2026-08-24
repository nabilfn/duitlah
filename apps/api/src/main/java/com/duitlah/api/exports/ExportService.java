package com.duitlah.api.exports;

import com.duitlah.api.bills.PersonalBillRepository;
import com.duitlah.api.bills.PersonalBillResponse;
import com.duitlah.api.budgets.BudgetResponse;
import com.duitlah.api.budgets.BudgetService;
import com.duitlah.api.liabilities.LiabilityResponse;
import com.duitlah.api.liabilities.LiabilityService;
import com.duitlah.api.networth.BreakdownLine;
import com.duitlah.api.networth.NetWorthResponse;
import com.duitlah.api.networth.NetWorthService;
import com.duitlah.api.transactions.Transaction;
import com.duitlah.api.transactions.TransactionRepository;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;
import org.springframework.stereotype.Service;

@Service
public class ExportService {

  private final CsvExportWriter csv;
  private final XlsxExportWriter xlsx;
  private final PdfExportWriter pdf;
  private final TransactionRepository transactions;
  private final PersonalBillRepository bills;
  private final LiabilityService liabilityService;
  private final NetWorthService netWorthService;
  private final BudgetService budgetService;

  public ExportService(
      CsvExportWriter csv,
      XlsxExportWriter xlsx,
      PdfExportWriter pdf,
      TransactionRepository transactions,
      PersonalBillRepository bills,
      LiabilityService liabilityService,
      NetWorthService netWorthService,
      BudgetService budgetService) {
    this.csv = csv;
    this.xlsx = xlsx;
    this.pdf = pdf;
    this.transactions = transactions;
    this.bills = bills;
    this.liabilityService = liabilityService;
    this.netWorthService = netWorthService;
    this.budgetService = budgetService;
  }

  public byte[] exportTransactions(UUID userId, LocalDate from, LocalDate to, ExportFormat format) {
    List<Transaction> rows = transactions.findByUserIdAndOccurredOnBetween(userId, from, to);
    TabularData table =
        new TabularData(
            "Transactions",
            List.of("Date", "Type", "Direction", "Merchant", "Description", "Amount"),
            rows.stream()
                .map(
                    t ->
                        List.of(
                            t.getOccurredOn().toString(),
                            t.getType().name(),
                            t.getDirection().name(),
                            nullToEmpty(t.getMerchant()),
                            nullToEmpty(t.getDescription()),
                            t.getAmount().toPlainString()))
                .toList());
    return render(table, format);
  }

  public byte[] exportBills(UUID userId, ExportFormat format) {
    List<PersonalBillResponse> rows =
        bills.findByUserIdOrderByDueDateAsc(userId).stream()
            .map(PersonalBillResponse::from)
            .toList();
    TabularData table =
        new TabularData(
            "Bills",
            List.of("Name", "Provider", "Due date", "Expected amount", "Status"),
            rows.stream()
                .map(
                    b ->
                        List.of(
                            b.name(),
                            nullToEmpty(b.provider()),
                            b.dueDate().toString(),
                            b.expectedAmount().toPlainString(),
                            b.status().name()))
                .toList());
    return render(table, format);
  }

  public byte[] exportLoans(UUID userId, ExportFormat format) {
    List<LiabilityResponse> rows = liabilityService.list(userId);
    TabularData table =
        new TabularData(
            "Loans",
            List.of("Name", "Type", "Lender", "Original amount", "Outstanding principal", "Status"),
            rows.stream()
                .map(
                    l ->
                        List.of(
                            l.name(),
                            l.type().name(),
                            nullToEmpty(l.lender()),
                            l.originalAmount().toPlainString(),
                            l.outstandingPrincipal().toPlainString(),
                            l.status().name()))
                .toList());
    return render(table, format);
  }

  public byte[] exportNetWorth(UUID userId, ExportFormat format) {
    NetWorthResponse netWorth = netWorthService.compute(userId);
    List<List<String>> rows = new ArrayList<>();
    for (BreakdownLine line : netWorth.assetsBreakdown()) {
      rows.add(List.of("Asset", line.label(), line.amount().toPlainString()));
    }
    for (BreakdownLine line : netWorth.liabilitiesBreakdown()) {
      rows.add(List.of("Liability", line.label(), line.amount().toPlainString()));
    }
    rows.add(List.of("Total assets", "", netWorth.totalAssets().toPlainString()));
    rows.add(List.of("Total liabilities", "", netWorth.totalLiabilities().toPlainString()));
    rows.add(List.of("Net worth", "", netWorth.netWorth().toPlainString()));
    TabularData table = new TabularData("Net Worth", List.of("Category", "Label", "Amount"), rows);
    return render(table, format);
  }

  public byte[] exportBudgets(UUID userId, int year, int month, ExportFormat format) {
    List<BudgetResponse> rows = budgetService.listForPeriod(userId, year, month);
    TabularData table =
        new TabularData(
            "Budgets",
            List.of("Category", "Limit", "Spent", "Remaining", "Status"),
            rows.stream()
                .map(
                    b ->
                        List.of(
                            b.categoryName(),
                            b.limit().toPlainString(),
                            b.spent().toPlainString(),
                            b.remaining().toPlainString(),
                            b.status().name()))
                .toList());
    return render(table, format);
  }

  /**
   * A single ZIP bundling every export above as CSV — the "full account archive" (spec section 23).
   */
  public byte[] exportFullArchive(UUID userId) {
    java.io.ByteArrayOutputStream out = new java.io.ByteArrayOutputStream();
    LocalDate today = LocalDate.now();
    try (ZipOutputStream zip = new ZipOutputStream(out)) {
      addEntry(
          zip,
          "transactions.csv",
          exportTransactions(userId, today.minusYears(5), today, ExportFormat.CSV));
      addEntry(zip, "bills.csv", exportBills(userId, ExportFormat.CSV));
      addEntry(zip, "loans.csv", exportLoans(userId, ExportFormat.CSV));
      addEntry(zip, "net-worth.csv", exportNetWorth(userId, ExportFormat.CSV));
      addEntry(
          zip,
          "budgets.csv",
          exportBudgets(userId, today.getYear(), today.getMonthValue(), ExportFormat.CSV));
    } catch (java.io.IOException e) {
      throw new IllegalStateException("Failed to build export archive", e);
    }
    return out.toByteArray();
  }

  private static void addEntry(ZipOutputStream zip, String name, byte[] content)
      throws java.io.IOException {
    zip.putNextEntry(new ZipEntry(name));
    zip.write(content);
    zip.closeEntry();
  }

  private byte[] render(TabularData table, ExportFormat format) {
    return switch (format) {
      case CSV -> csv.write(table);
      case XLSX -> xlsx.write(table);
      case PDF -> pdf.write(table);
    };
  }

  private static String nullToEmpty(String value) {
    return value == null ? "" : value;
  }
}
