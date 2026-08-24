package com.duitlah.api.liabilities;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;
import java.time.LocalDate;

public record CreateLiabilityRequest(
    @NotNull LiabilityType type,
    @NotBlank @Size(max = 120) String name,
    @Size(max = 120) String lender,
    @NotNull @DecimalMin(value = "0.01") BigDecimal originalAmount,
    BigDecimal interestRatePercent,
    BigDecimal instalmentAmount,
    LocalDate nextDueDate,
    LocalDate maturityDate) {}
