package com.duitlah.api.personaltax;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;

public record ConfirmTaxReliefCandidateRequest(
    @NotNull PersonalTaxReliefCategory category,
    @NotNull @DecimalMin(value = "0.01") BigDecimal amount) {}
