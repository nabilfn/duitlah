package com.duitlah.api.bagilah;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.util.UUID;

/**
 * {@code value} is read as a quantity, a percentage, or an RM amount depending on {@code
 * claimType}. A whole-item claim is just a QUANTITY claim whose value equals the item's quantity.
 */
public record ClaimRequest(
    @NotNull UUID participantId,
    @NotNull ClaimType claimType,
    @NotNull @DecimalMin(value = "0.00") BigDecimal value) {}
