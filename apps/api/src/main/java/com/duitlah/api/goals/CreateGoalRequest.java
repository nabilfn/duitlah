package com.duitlah.api.goals;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;
import java.time.LocalDate;

public record CreateGoalRequest(
    @NotBlank @Size(max = 120) String name,
    @NotNull GoalType type,
    @NotNull @DecimalMin(value = "0.01") BigDecimal targetAmount,
    LocalDate targetDate) {}
