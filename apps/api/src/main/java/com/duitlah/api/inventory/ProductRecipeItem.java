package com.duitlah.api.inventory;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * One ingredient line of a product's recipe (spec section 49) — one level deep only, see
 * package-info.
 */
@Entity
@Table(name = "product_recipe_items")
@Getter
@Setter
@NoArgsConstructor
public class ProductRecipeItem {

  @Id @GeneratedValue private UUID id;

  @Column(name = "product_id", nullable = false)
  private UUID productId;

  @Column(name = "ingredient_product_id", nullable = false)
  private UUID ingredientProductId;

  @Column(name = "quantity_per_unit", nullable = false)
  private BigDecimal quantityPerUnit;

  @Column(name = "created_at", nullable = false)
  private Instant createdAt;

  public ProductRecipeItem(UUID productId, UUID ingredientProductId, BigDecimal quantityPerUnit) {
    this.productId = productId;
    this.ingredientProductId = ingredientProductId;
    this.quantityPerUnit = quantityPerUnit;
    this.createdAt = Instant.now();
  }
}
