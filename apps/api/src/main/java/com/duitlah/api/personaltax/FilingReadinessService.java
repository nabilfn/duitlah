package com.duitlah.api.personaltax;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;

/**
 * An explainable readiness checklist (spec section 30). INCOME/EA/PCB are ready only when real data
 * exists; ZAKAT is marked ready by default since not every taxpayer owes it (this app has no way to
 * know a user's zakat obligation) -- a documented simplification, not a guess.
 * LIFESTYLE/MEDICAL/INSURANCE reflect a real, actionable signal: whether a candidate in that
 * category is still sitting unreviewed, not a guess about whether the user needs one at all.
 */
@Service
public class FilingReadinessService {

  private final PersonalIncomeRecordRepository incomeRecords;
  private final PersonalTaxDocumentService documentService;
  private final PcbService pcbService;
  private final TaxReliefCandidateService candidateService;

  public FilingReadinessService(
      PersonalIncomeRecordRepository incomeRecords,
      PersonalTaxDocumentService documentService,
      PcbService pcbService,
      TaxReliefCandidateService candidateService) {
    this.incomeRecords = incomeRecords;
    this.documentService = documentService;
    this.pcbService = pcbService;
    this.candidateService = candidateService;
  }

  public FilingReadinessResponse compute(UUID userId, int yearOfAssessment) {
    List<FilingReadinessItem> items = new ArrayList<>();

    boolean hasIncome =
        !incomeRecords.findByUserIdAndYearOfAssessment(userId, yearOfAssessment).isEmpty();
    items.add(
        new FilingReadinessItem(
            "INCOME",
            "Income",
            hasIncome,
            hasIncome ? "Income recorded." : "No income recorded yet."));

    boolean hasEa = documentService.hasDocumentOfType(userId, yearOfAssessment, TaxDocumentType.EA);
    items.add(
        new FilingReadinessItem(
            "EA", "EA form", hasEa, hasEa ? "EA uploaded." : "EA form not uploaded yet."));

    boolean hasPcb = !pcbService.list(userId, yearOfAssessment).isEmpty();
    items.add(
        new FilingReadinessItem(
            "PCB", "PCB", hasPcb, hasPcb ? "PCB recorded." : "No PCB payments recorded yet."));

    items.add(
        new FilingReadinessItem(
            "ZAKAT",
            "Zakat",
            true,
            "Optional -- marked ready since not every taxpayer owes zakat."));

    items.add(
        pendingCategoryItem(
            userId,
            yearOfAssessment,
            "LIFESTYLE",
            "Lifestyle",
            PersonalTaxReliefCategory.LIFESTYLE));
    items.add(
        pendingCategoryItem(
            userId,
            yearOfAssessment,
            "MEDICAL",
            "Medical",
            PersonalTaxReliefCategory.MEDICAL_SERIOUS_ILLNESS));
    items.add(
        pendingCategoryItem(
            userId,
            yearOfAssessment,
            "INSURANCE",
            "Insurance",
            PersonalTaxReliefCategory.EPF_LIFE_INSURANCE));

    long readyCount = items.stream().filter(FilingReadinessItem::ready).count();
    BigDecimal readyPercent =
        BigDecimal.valueOf(readyCount)
            .multiply(BigDecimal.valueOf(100))
            .divide(BigDecimal.valueOf(items.size()), 0, RoundingMode.HALF_UP);

    return new FilingReadinessResponse(yearOfAssessment, readyPercent, items);
  }

  private FilingReadinessItem pendingCategoryItem(
      UUID userId,
      int yearOfAssessment,
      String key,
      String label,
      PersonalTaxReliefCategory category) {
    boolean pending = candidateService.hasPendingCandidates(userId, yearOfAssessment, category);
    return new FilingReadinessItem(
        key,
        label,
        !pending,
        pending ? "Has receipts awaiting review." : "Nothing pending review.");
  }
}
