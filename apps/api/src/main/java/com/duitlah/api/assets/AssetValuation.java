package com.duitlah.api.assets;

import java.math.BigDecimal;

public record AssetValuation(BigDecimal accumulatedDepreciation, BigDecimal netBookValue) {}
