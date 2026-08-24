package com.duitlah.api.personaltax;

import java.math.BigDecimal;
import java.util.UUID;

public record PersonalIncomeRecordResponse(
    UUID id, int yearOfAssessment, IncomeType incomeType, BigDecimal amount, String description) {

  public static PersonalIncomeRecordResponse from(PersonalIncomeRecord record) {
    return new PersonalIncomeRecordResponse(
        record.getId(),
        record.getYearOfAssessment(),
        record.getIncomeType(),
        record.getAmount(),
        record.getDescription());
  }
}
