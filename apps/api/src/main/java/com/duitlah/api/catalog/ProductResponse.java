package com.duitlah.api.catalog;

import java.math.BigDecimal;
import java.util.UUID;

public record ProductResponse(
    UUID id,
    String name,
    String sku,
    ProductType type,
    String unit,
    BigDecimal unitPrice,
    boolean active,
    String description,
    BigDecimal cost,
    TaxClassification taxClassification,
    boolean trackInventory,
    BigDecimal reorderPoint) {

  static ProductResponse of(Product p) {
    return new ProductResponse(
        p.getId(),
        p.getName(),
        p.getSku(),
        p.getType(),
        p.getUnit(),
        p.getUnitPrice(),
        p.isActive(),
        p.getDescription(),
        p.getCost(),
        p.getTaxClassification(),
        p.isTrackInventory(),
        p.getReorderPoint());
  }
}
