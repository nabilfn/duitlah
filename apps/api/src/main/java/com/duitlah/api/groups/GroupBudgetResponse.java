package com.duitlah.api.groups;

import java.math.BigDecimal;

public record GroupBudgetResponse(BigDecimal amount, BigDecimal spent, BigDecimal remaining) {}
