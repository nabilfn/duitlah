package com.duitlah.api.groups;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;

public record SetGroupBudgetRequest(@NotNull @DecimalMin(value = "0.01") BigDecimal amount) {}
