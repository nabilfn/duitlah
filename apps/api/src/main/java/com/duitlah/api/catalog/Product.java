package com.duitlah.api.catalog;

import com.duitlah.api.common.jpa.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "products")
@Getter
@Setter
@NoArgsConstructor
public class Product extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "space_id", nullable = false)
  private UUID spaceId;

  @Column(nullable = false)
  private String name;

  private String sku;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private ProductType type;

  @Column(nullable = false)
  private String unit;

  @Column(name = "unit_price", nullable = false)
  private BigDecimal unitPrice;

  @Column(name = "is_active", nullable = false)
  private boolean active;

  private String description;

  /**
   * A reference/standard cost the user can set directly — distinct from the *actual* moving
   * Weighted Average Cost {@code inventory.InventoryValuationService} computes from {@code
   * inventory_movements} for a {@code trackInventory} product.
   */
  private BigDecimal cost;

  @Enumerated(EnumType.STRING)
  @Column(name = "tax_classification", nullable = false)
  private TaxClassification taxClassification;

  @Column(name = "track_inventory", nullable = false)
  private boolean trackInventory;

  @Column(name = "reorder_point")
  private BigDecimal reorderPoint;

  @Column(name = "low_stock_notified_at")
  private Instant lowStockNotifiedAt;

  public Product(UUID spaceId, String name, ProductType type, BigDecimal unitPrice) {
    this.spaceId = spaceId;
    this.name = name;
    this.type = type;
    this.unitPrice = unitPrice;
    this.unit = "unit";
    this.active = true;
    this.taxClassification = TaxClassification.NOT_APPLICABLE;
    this.trackInventory = false;
  }
}
