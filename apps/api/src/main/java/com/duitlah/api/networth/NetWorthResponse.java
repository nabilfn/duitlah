package com.duitlah.api.networth;

import java.math.BigDecimal;
import java.util.List;

public record NetWorthResponse(
    BigDecimal totalAssets,
    BigDecimal totalLiabilities,
    BigDecimal netWorth,
    List<BreakdownLine> assetsBreakdown,
    List<BreakdownLine> liabilitiesBreakdown) {}
