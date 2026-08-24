package com.duitlah.api.crossspace;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

/** Not a normal business expense (spec section 60). */
public record RecordOwnerDrawingRequest(
    @NotNull UUID personalTransactionId,
    @NotNull UUID businessAccountId,
    @NotNull @Positive BigDecimal amount,
    @NotNull LocalDate occurredOn,
    String description) {}
