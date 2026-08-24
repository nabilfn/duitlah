package com.duitlah.api.bizbanking;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDate;

public record CreateEntryRequest(
    @NotNull EntryDirection direction,
    @NotNull @DecimalMin(value = "0", inclusive = false) BigDecimal amount,
    @NotNull LocalDate occurredOn,
    String description) {}
