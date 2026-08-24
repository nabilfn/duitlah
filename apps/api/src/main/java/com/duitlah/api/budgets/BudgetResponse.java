package com.duitlah.api.budgets;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

public record BudgetResponse(
    UUID id,
    UUID categoryId,
    String categoryName,
    int periodYear,
    int periodMonth,
    BudgetCycleType cycleType,
    LocalDate periodStartDate,
    LocalDate periodEndDate,
    BigDecimal limit,
    BigDecimal spent,
    BigDecimal remaining,
    BudgetStatus status) {

  public static BudgetResponse of(Budget budget, String categoryName, BigDecimal spent) {
    BigDecimal remaining = budget.getAmountLimit().subtract(spent);
    return new BudgetResponse(
        budget.getId(),
        budget.getCategoryId(),
        categoryName,
        budget.getPeriodYear(),
        budget.getPeriodMonth(),
        budget.getCycleType(),
        budget.getPeriodStartDate(),
        budget.getPeriodEndDate(),
        budget.getAmountLimit(),
        spent,
        remaining,
        BudgetStatus.of(spent, budget.getAmountLimit()));
  }
}
