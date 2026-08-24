package com.duitlah.api.inventory;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Append-only — see package-info. {@code quantity} is signed (positive = stock in, negative = stock
 * out); {@code unitCost} is snapshotted at creation time and never recalculated.
 */
@Entity
@Table(name = "inventory_movements")
@Getter
@Setter
@NoArgsConstructor
public class InventoryMovement {

  @Id @GeneratedValue private UUID id;

  @Column(name = "space_id", nullable = false)
  private UUID spaceId;

  @Column(name = "product_id", nullable = false)
  private UUID productId;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private MovementType type;

  @Column(nullable = false)
  private BigDecimal quantity;

  @Column(name = "unit_cost", nullable = false)
  private BigDecimal unitCost;

  @Column(name = "occurred_on", nullable = false)
  private LocalDate occurredOn;

  private String notes;

  @Column(name = "source_invoice_line_item_id")
  private UUID sourceInvoiceLineItemId;

  @Column(name = "created_by_user_id", nullable = false)
  private UUID createdByUserId;

  @Column(name = "created_at", nullable = false)
  private Instant createdAt;

  public InventoryMovement(
      UUID spaceId,
      UUID productId,
      MovementType type,
      BigDecimal quantity,
      BigDecimal unitCost,
      LocalDate occurredOn,
      String notes,
      UUID createdByUserId) {
    this.spaceId = spaceId;
    this.productId = productId;
    this.type = type;
    this.quantity = quantity;
    this.unitCost = unitCost;
    this.occurredOn = occurredOn;
    this.notes = notes;
    this.createdByUserId = createdByUserId;
    this.createdAt = Instant.now();
  }

  public BigDecimal value() {
    return quantity.multiply(unitCost);
  }
}
