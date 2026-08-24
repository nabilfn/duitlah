package com.duitlah.api.inventory;

import java.math.BigDecimal;
import java.util.UUID;

public record ValuationResponse(
    UUID productId,
    BigDecimal quantityOnHand,
    BigDecimal weightedAverageCost,
    BigDecimal totalValue) {

  public static ValuationResponse of(UUID productId, InventoryValuation valuation) {
    return new ValuationResponse(
        productId,
        valuation.quantityOnHand(),
        valuation.weightedAverageCost(),
        valuation.totalValue());
  }
}
