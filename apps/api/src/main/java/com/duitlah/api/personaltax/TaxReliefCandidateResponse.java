package com.duitlah.api.personaltax;

import java.math.BigDecimal;
import java.util.UUID;

public record TaxReliefCandidateResponse(
    UUID id,
    int yearOfAssessment,
    PersonalTaxReliefCategory category,
    UUID sourceReceiptId,
    BigDecimal suggestedAmount,
    TaxReliefCandidateStatus status,
    String notes) {

  public static TaxReliefCandidateResponse from(TaxReliefCandidate candidate) {
    return new TaxReliefCandidateResponse(
        candidate.getId(),
        candidate.getYearOfAssessment(),
        candidate.getCategory(),
        candidate.getSourceReceiptId(),
        candidate.getSuggestedAmount(),
        candidate.getStatus(),
        candidate.getNotes());
  }
}
