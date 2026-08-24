package com.duitlah.api.assets;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

/**
 * {@code businessAccountId} is required whenever {@code proceeds} is greater than zero — the
 * disposal has to say where the money landed for the journal entry's cash leg to exist at all.
 */
public record DisposeAssetRequest(
    @NotNull LocalDate disposedOn,
    @NotNull @DecimalMin(value = "0", inclusive = true) BigDecimal proceeds,
    UUID businessAccountId) {}
