package com.duitlah.api.analytics;

import java.math.BigDecimal;

public record MonthlyTrendResponse(
    int year, int month, BigDecimal income, BigDecimal expense, BigDecimal savings) {}
