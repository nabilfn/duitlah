package com.duitlah.api.wrapped;

import java.math.BigDecimal;

/**
 * Screen 02's numbers (spec section 7) — a deliberately small subset of {@link
 * MonthlyFinancialSummary}, not the full Analytics page.
 */
public record WrappedOverview(
    int year,
    int month,
    BigDecimal totalIncome,
    BigDecimal totalExpense,
    BigDecimal netAmount,
    BigDecimal totalSavingsContribution,
    int transactionCount,
    /**
     * Null when there's no prior-month figure to compare against (percentage change is undefined,
     * never presented as 0%).
     */
    BigDecimal spendingChangePercentage,
    BigDecimal incomeChangePercentage) {

  static WrappedOverview from(MonthlyFinancialSummary summary) {
    return new WrappedOverview(
        summary.year(),
        summary.month(),
        summary.totalIncome(),
        summary.totalExpense(),
        summary.netAmount(),
        summary.totalSavingsContribution(),
        summary.transactionCount(),
        summary.spendingChangePercentage(),
        summary.incomeChangePercentage());
  }
}
