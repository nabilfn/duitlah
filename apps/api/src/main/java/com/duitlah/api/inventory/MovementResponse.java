package com.duitlah.api.inventory;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.UUID;

public record MovementResponse(
    UUID id,
    UUID productId,
    MovementType type,
    BigDecimal quantity,
    BigDecimal unitCost,
    BigDecimal value,
    LocalDate occurredOn,
    String notes,
    UUID sourceInvoiceLineItemId,
    UUID createdByUserId,
    Instant createdAt) {

  public static MovementResponse of(InventoryMovement m) {
    return new MovementResponse(
        m.getId(),
        m.getProductId(),
        m.getType(),
        m.getQuantity(),
        m.getUnitCost(),
        m.value(),
        m.getOccurredOn(),
        m.getNotes(),
        m.getSourceInvoiceLineItemId(),
        m.getCreatedByUserId(),
        m.getCreatedAt());
  }
}
