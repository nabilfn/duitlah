package com.duitlah.api.personaltax;

import java.math.BigDecimal;
import java.util.UUID;

public record ConfirmedTaxReliefResponse(
    UUID id, int yearOfAssessment, PersonalTaxReliefCategory category, BigDecimal confirmedAmount) {

  public static ConfirmedTaxReliefResponse from(ConfirmedTaxRelief relief) {
    return new ConfirmedTaxReliefResponse(
        relief.getId(),
        relief.getYearOfAssessment(),
        relief.getCategory(),
        relief.getConfirmedAmount());
  }
}
