package com.duitlah.api.accounting;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.util.UUID;

public record JournalLineRequest(
    @NotNull UUID accountId,
    @NotNull JournalDirection direction,
    @NotNull @DecimalMin(value = "0", inclusive = false) BigDecimal amount,
    String description) {}
