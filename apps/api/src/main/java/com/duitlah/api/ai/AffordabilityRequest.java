package com.duitlah.api.ai;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;

public record AffordabilityRequest(
    @NotNull @DecimalMin(value = "0.01") BigDecimal amount, @Size(max = 255) String description) {}
