package com.duitlah.api.inventory;

import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

/**
 * {@code unitCost} is required for an inbound (positive-quantity) movement — the real cost paid —
 * and ignored for an outbound one, where the server always computes it from the current Weighted
 * Average Cost (see {@code InventoryMovementService}). {@code businessAccountId} is optional and
 * only meaningful for a {@code PURCHASE}: which account paid for it (omit for "bought on credit").
 */
public record CreateMovementRequest(
    @NotNull MovementType type,
    @NotNull BigDecimal quantity,
    BigDecimal unitCost,
    @NotNull LocalDate occurredOn,
    String notes,
    UUID businessAccountId) {}
