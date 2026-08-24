package com.duitlah.api.personaltax;

import com.duitlah.api.exports.PdfExportWriter;
import com.duitlah.api.exports.TabularData;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;

/**
 * The spec's own "MyTax preparation summary" (section 30) — a reference document for the taxpayer's
 * own use, never a submission (spec: "do not simulate successful LHDN submission"). Reuses {@code
 * exports.PdfExportWriter} rather than a second PDF-writing code path.
 */
@Service
public class TaxPreparationSummaryService {

  private final PersonalTaxCalculationService calculationService;
  private final FilingReadinessService filingReadinessService;
  private final PdfExportWriter pdfWriter;

  public TaxPreparationSummaryService(
      PersonalTaxCalculationService calculationService,
      FilingReadinessService filingReadinessService,
      PdfExportWriter pdfWriter) {
    this.calculationService = calculationService;
    this.filingReadinessService = filingReadinessService;
    this.pdfWriter = pdfWriter;
  }

  public byte[] generate(UUID userId, int yearOfAssessment) {
    PersonalTaxCalculationResponse calculation =
        calculationService.calculate(userId, yearOfAssessment);
    FilingReadinessResponse readiness = filingReadinessService.compute(userId, yearOfAssessment);

    List<String> headers = List.of("Line", "Amount (RM)");
    List<List<String>> rows = new ArrayList<>();
    rows.add(List.of("Total income", calculation.totalIncome().toPlainString()));
    rows.add(List.of("Self relief", calculation.residentIndividualRelief().toPlainString()));
    for (var relief : calculation.reliefs()) {
      rows.add(List.of("Relief: " + relief.label(), relief.claimedAmount().toPlainString()));
    }
    rows.add(List.of("Chargeable income", calculation.chargeableIncome().toPlainString()));
    rows.add(List.of("Gross tax payable", calculation.grossTaxPayable().toPlainString()));
    rows.add(List.of("Rebate", calculation.rebate().toPlainString()));
    rows.add(List.of("Zakat rebate", calculation.zakatRebate().toPlainString()));
    rows.add(List.of("PCB already paid", calculation.pcbPaid().toPlainString()));
    rows.add(
        List.of(
            "Estimated payable / (refund)",
            calculation.estimatedPayableOrRefund().toPlainString()));
    rows.add(List.of("", ""));
    rows.add(List.of("Filing readiness", readiness.readyPercent().toPlainString() + "%"));
    for (var item : readiness.items()) {
      rows.add(List.of(item.label(), item.ready() ? "Ready" : "Not ready"));
    }
    rows.add(List.of("", ""));
    rows.add(List.of("Disclaimer", calculation.disclaimer()));

    TabularData table =
        new TabularData("Personal Tax Preparation Summary — YA " + yearOfAssessment, headers, rows);
    return pdfWriter.write(table);
  }
}
