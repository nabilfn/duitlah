package com.duitlah.api.groups;

import java.math.BigDecimal;
import java.util.List;

public record TripSummaryResponse(
    BigDecimal budgetAmount,
    BigDecimal spent,
    BigDecimal remaining,
    List<CategoryAmount> spendingByCategory) {

  public record CategoryAmount(GroupExpenseCategory category, BigDecimal amount) {}
}
