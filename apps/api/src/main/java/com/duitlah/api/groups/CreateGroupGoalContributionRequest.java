package com.duitlah.api.groups;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;
import java.time.LocalDate;

/** {@code amount} may be negative (a correction or withdrawal) but never zero. */
public record CreateGroupGoalContributionRequest(
    @NotNull BigDecimal amount, @NotNull LocalDate occurredOn, @Size(max = 255) String note) {}
