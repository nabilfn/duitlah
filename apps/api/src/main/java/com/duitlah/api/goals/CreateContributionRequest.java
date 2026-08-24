package com.duitlah.api.goals;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;
import java.time.LocalDate;

/** {@code amount} may be negative (a correction or withdrawal) but never zero. */
public record CreateContributionRequest(
    @NotNull BigDecimal amount, @NotNull LocalDate occurredOn, @Size(max = 255) String note) {}
