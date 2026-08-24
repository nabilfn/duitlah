package com.duitlah.api.settlements;

import java.math.BigDecimal;
import java.util.List;

/** The "who owes me" dashboard (product spec section 34). */
public record SettlementSummaryResponse(
    BigDecimal totalOwedToMe,
    BigDecimal totalIOwe,
    List<CounterpartySummary> owedToMe,
    List<CounterpartySummary> iOwe) {}
