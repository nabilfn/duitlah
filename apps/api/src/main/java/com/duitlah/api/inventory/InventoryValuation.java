package com.duitlah.api.inventory;

import java.math.BigDecimal;

public record InventoryValuation(
    BigDecimal quantityOnHand, BigDecimal weightedAverageCost, BigDecimal totalValue) {}
