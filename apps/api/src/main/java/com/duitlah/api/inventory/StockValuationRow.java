package com.duitlah.api.inventory;

import java.math.BigDecimal;
import java.util.UUID;

public record StockValuationRow(
    UUID productId,
    String productName,
    String sku,
    BigDecimal quantityOnHand,
    BigDecimal weightedAverageCost,
    BigDecimal totalValue) {}
