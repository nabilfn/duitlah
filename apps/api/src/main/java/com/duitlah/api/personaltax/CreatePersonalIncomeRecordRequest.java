package com.duitlah.api.personaltax;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;

public record CreatePersonalIncomeRecordRequest(
    @NotNull @Min(2000) @Max(3000) Integer yearOfAssessment,
    @NotNull IncomeType incomeType,
    @NotNull @DecimalMin(value = "0.01") BigDecimal amount,
    String description) {}
