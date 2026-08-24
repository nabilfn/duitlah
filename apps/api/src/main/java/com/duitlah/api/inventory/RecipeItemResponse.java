package com.duitlah.api.inventory;

import java.math.BigDecimal;
import java.util.UUID;

public record RecipeItemResponse(
    UUID id,
    UUID ingredientProductId,
    String ingredientName,
    BigDecimal quantityPerUnit,
    BigDecimal ingredientUnitCost,
    BigDecimal lineCost) {}
