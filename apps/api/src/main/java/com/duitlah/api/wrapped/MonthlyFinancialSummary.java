package com.duitlah.api.wrapped;

import com.duitlah.api.analytics.CategorySpendingResponse;
import com.duitlah.api.analytics.MerchantSpendingResponse;
import com.duitlah.api.budgets.BudgetResponse;
import com.duitlah.api.recurring.SubscriptionsSummaryResponse;
import com.duitlah.api.transactions.Transaction;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

/**
 * One completed month's real financial activity, computed once by {@link MonthlyAggregationService}
 * and shared by every downstream engine ({@link MoneyPersonaEngine}, {@link MonthlyInsightEngine},
 * {@link GoalRecommendationEngine}) — nothing recomputes a total or re-scans the transaction list a
 * second time. Every figure here is either reused directly from an existing service ({@code
 * analytics.AnalyticsService}, {@code budgets.BudgetService}, {@code
 * recurring.RecurringTransactionService}) or derived once from the same raw {@code
 * expenseTransactions} list this record already carries.
 */
public record MonthlyFinancialSummary(
    int year,
    int month,
    LocalDate monthStart,
    LocalDate monthEnd,
    BigDecimal totalIncome,
    BigDecimal totalExpense,
    BigDecimal netAmount,
    BigDecimal totalSavingsContribution,
    int transactionCount,
    /**
     * Top-level category breakdown, reused as-is from {@code AnalyticsService.spendingByCategory}.
     */
    List<CategorySpendingResponse> topLevelCategoryBreakdown,
    /**
     * Leaf-level breakdown — the granularity persona matching actually needs (e.g. "Cafe" alone,
     * not all of "Food"), which {@code AnalyticsService} deliberately doesn't compute since the
     * real Insights screen only ever needs the top-level roll-up.
     */
    List<LeafCategoryStats> leafCategoryBreakdown,
    List<MerchantSpendingResponse> merchantBreakdown,
    List<Transaction> expenseTransactions,
    BigDecimal discretionaryTotal,
    BigDecimal essentialTotal,
    SubscriptionsSummaryResponse subscriptions,
    List<BudgetResponse> budgets,
    Map<LocalDate, BigDecimal> dailyExpenseTotals,
    int distinctSpendingDays,
    int noSpendDays,
    Transaction largestExpenseTransaction,
    BigDecimal previousMonthExpense,
    BigDecimal previousMonthIncome,
    BigDecimal previousMonthSavingsContribution,
    List<LeafCategoryStats> previousMonthLeafCategoryBreakdown,
    /**
     * Average of the 3 completed months before this one, per leaf category — the "historical
     * average" {@link MoneyPersonaEngine}'s scoring formula compares this month against.
     */
    Map<String, BigDecimal> historicalAverageLeafCategoryAmount) {

  public BigDecimal spendingChangePercentage() {
    return percentageChange(previousMonthExpense, totalExpense);
  }

  public BigDecimal incomeChangePercentage() {
    return percentageChange(previousMonthIncome, totalIncome);
  }

  public BigDecimal savingsRate() {
    if (totalIncome.signum() <= 0) return BigDecimal.ZERO;
    return totalSavingsContribution
        .divide(totalIncome, 4, java.math.RoundingMode.HALF_UP)
        .multiply(BigDecimal.valueOf(100));
  }

  public BigDecimal previousSavingsRate() {
    if (previousMonthIncome.signum() <= 0) return BigDecimal.ZERO;
    return previousMonthSavingsContribution
        .divide(previousMonthIncome, 4, java.math.RoundingMode.HALF_UP)
        .multiply(BigDecimal.valueOf(100));
  }

  /** Section 15's minimum-data rule: enough real spending to say anything meaningful. */
  public boolean hasSufficientData() {
    return transactionCount >= 10 && distinctSpendingDays >= 14;
  }

  private static BigDecimal percentageChange(BigDecimal from, BigDecimal to) {
    if (from == null || from.signum() <= 0) return null;
    return to.subtract(from)
        .divide(from, 4, java.math.RoundingMode.HALF_UP)
        .multiply(BigDecimal.valueOf(100));
  }
}
