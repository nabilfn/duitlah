package com.duitlah.api.crossspace;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

/** Not Business Revenue (spec section 59). */
public record RecordOwnerContributionRequest(
    @NotNull UUID personalTransactionId,
    @NotNull UUID businessAccountId,
    @NotNull @Positive BigDecimal amount,
    @NotNull LocalDate occurredOn,
    String description) {}
