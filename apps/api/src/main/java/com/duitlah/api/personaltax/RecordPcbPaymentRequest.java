package com.duitlah.api.personaltax;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;

public record RecordPcbPaymentRequest(
    @NotNull @Min(2000) @Max(3000) Integer yearOfAssessment,
    @NotNull @Min(1) @Max(12) Integer month,
    @NotNull @DecimalMin(value = "0") BigDecimal amount,
    String notes) {}
