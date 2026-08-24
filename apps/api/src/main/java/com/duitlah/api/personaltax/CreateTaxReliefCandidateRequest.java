package com.duitlah.api.personaltax;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;

/** Manual creation — e.g. "I know I paid for this but don't have proof yet." */
public record CreateTaxReliefCandidateRequest(
    @NotNull @Min(2000) @Max(3000) Integer yearOfAssessment,
    PersonalTaxReliefCategory category,
    @NotNull @DecimalMin(value = "0.01") BigDecimal suggestedAmount,
    TaxReliefCandidateStatus status,
    String notes) {

  public TaxReliefCandidateStatus statusOrDefault() {
    return status == null ? TaxReliefCandidateStatus.NEEDS_REVIEW : status;
  }
}
