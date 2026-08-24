package com.duitlah.api.inventory;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

public record RecipeCostResponse(
    UUID productId,
    List<RecipeItemResponse> items,
    BigDecimal unitCost,
    BigDecimal sellingPrice,
    BigDecimal grossMargin,
    BigDecimal grossMarginPercent) {}
