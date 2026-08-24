package com.duitlah.api.catalog;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;

public record CreateProductRequest(
    @NotBlank String name,
    String sku,
    @NotNull ProductType type,
    String unit,
    @NotNull @DecimalMin(value = "0", inclusive = true) BigDecimal unitPrice,
    String description,
    @DecimalMin(value = "0", inclusive = true) BigDecimal cost,
    TaxClassification taxClassification,
    Boolean trackInventory,
    @DecimalMin(value = "0", inclusive = true) BigDecimal reorderPoint) {

  public TaxClassification taxClassificationOrDefault() {
    return taxClassification != null ? taxClassification : TaxClassification.NOT_APPLICABLE;
  }

  public boolean trackInventoryOrFalse() {
    return Boolean.TRUE.equals(trackInventory);
  }
}
