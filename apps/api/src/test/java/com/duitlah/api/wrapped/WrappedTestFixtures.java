package com.duitlah.api.wrapped;

import com.duitlah.api.analytics.CategorySpendingResponse;
import com.duitlah.api.analytics.MerchantSpendingResponse;
import com.duitlah.api.budgets.BudgetResponse;
import com.duitlah.api.budgets.BudgetStatus;
import com.duitlah.api.recurring.RecurringTransactionResponse;
import com.duitlah.api.recurring.SubscriptionsSummaryResponse;
import com.duitlah.api.transactions.Transaction;
import com.duitlah.api.transactions.TransactionDirection;
import com.duitlah.api.transactions.TransactionType;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

/**
 * A hand-buildable {@link MonthlyFinancialSummary} for engine unit tests — every field defaults to
 * "nothing happened this month" so a test only ever sets what it actually needs to exercise.
 */
final class WrappedTestFixtures {

  private WrappedTestFixtures() {}

  static Builder summary() {
    return new Builder();
  }

  static Transaction expense(
      String categoryName, UUID categoryId, String amount, String merchant, LocalDate date) {
    Transaction t =
        new Transaction(
            UUID.randomUUID(),
            UUID.randomUUID(),
            TransactionType.EXPENSE,
            TransactionDirection.OUT,
            categoryId,
            null,
            new BigDecimal(amount),
            merchant,
            null,
            null,
            date);
    return t;
  }

  static LeafCategoryStats leaf(String name, String amount, int count, String... merchants) {
    return new LeafCategoryStats(name, new BigDecimal(amount), count, Set.of(merchants));
  }

  static BudgetResponse budget(String limit, String spent, BudgetStatus status) {
    return new BudgetResponse(
        UUID.randomUUID(),
        null,
        "Overall",
        2026,
        8,
        com.duitlah.api.budgets.BudgetCycleType.CALENDAR_MONTH,
        null,
        null,
        new BigDecimal(limit),
        new BigDecimal(spent),
        new BigDecimal(limit).subtract(new BigDecimal(spent)),
        status);
  }

  static SubscriptionsSummaryResponse subscriptions(String monthlyTotal, int count) {
    List<RecurringTransactionResponse> subs = new ArrayList<>();
    for (int i = 0; i < count; i++) {
      subs.add(
          new RecurringTransactionResponse(
              UUID.randomUUID(),
              UUID.randomUUID(),
              TransactionType.EXPENSE,
              TransactionDirection.OUT,
              null,
              new BigDecimal("10.00"),
              "Sub " + i,
              null,
              null,
              com.duitlah.api.recurring.RecurrenceFrequency.MONTHLY,
              1,
              LocalDate.now(),
              null,
              LocalDate.now(),
              true,
              true));
    }
    return new SubscriptionsSummaryResponse(new BigDecimal(monthlyTotal), subs);
  }

  static final class Builder {
    private int year = 2026;
    private int month = 8;
    private BigDecimal totalIncome = BigDecimal.ZERO;
    private BigDecimal totalExpense = BigDecimal.ZERO;
    private BigDecimal totalSavingsContribution = BigDecimal.ZERO;
    private int transactionCount = 0;
    private List<CategorySpendingResponse> topLevelCategoryBreakdown = List.of();
    private List<LeafCategoryStats> leafCategoryBreakdown = List.of();
    private List<MerchantSpendingResponse> merchantBreakdown = List.of();
    private List<Transaction> expenseTransactions = List.of();
    private BigDecimal discretionaryTotal = BigDecimal.ZERO;
    private BigDecimal essentialTotal = BigDecimal.ZERO;
    private SubscriptionsSummaryResponse subscriptions =
        new SubscriptionsSummaryResponse(BigDecimal.ZERO, List.of());
    private List<BudgetResponse> budgets = List.of();
    private Map<LocalDate, BigDecimal> dailyExpenseTotals = new HashMap<>();
    private int distinctSpendingDays = 0;
    private int noSpendDays = 0;
    private Transaction largestExpenseTransaction = null;
    private BigDecimal previousMonthExpense = BigDecimal.ZERO;
    private BigDecimal previousMonthIncome = BigDecimal.ZERO;
    private BigDecimal previousMonthSavingsContribution = BigDecimal.ZERO;
    private List<LeafCategoryStats> previousMonthLeafCategoryBreakdown = List.of();
    private Map<String, BigDecimal> historicalAverageLeafCategoryAmount = new HashMap<>();

    Builder year(int v) {
      year = v;
      return this;
    }

    Builder month(int v) {
      month = v;
      return this;
    }

    Builder totalIncome(String v) {
      totalIncome = new BigDecimal(v);
      return this;
    }

    Builder totalExpense(String v) {
      totalExpense = new BigDecimal(v);
      return this;
    }

    Builder totalSavingsContribution(String v) {
      totalSavingsContribution = new BigDecimal(v);
      return this;
    }

    Builder transactionCount(int v) {
      transactionCount = v;
      return this;
    }

    Builder topLevelCategoryBreakdown(List<CategorySpendingResponse> v) {
      topLevelCategoryBreakdown = v;
      return this;
    }

    Builder leafCategoryBreakdown(List<LeafCategoryStats> v) {
      leafCategoryBreakdown = v;
      return this;
    }

    Builder merchantBreakdown(List<MerchantSpendingResponse> v) {
      merchantBreakdown = v;
      return this;
    }

    Builder expenseTransactions(List<Transaction> v) {
      expenseTransactions = v;
      return this;
    }

    Builder discretionaryTotal(String v) {
      discretionaryTotal = new BigDecimal(v);
      return this;
    }

    Builder essentialTotal(String v) {
      essentialTotal = new BigDecimal(v);
      return this;
    }

    Builder subscriptions(SubscriptionsSummaryResponse v) {
      subscriptions = v;
      return this;
    }

    Builder budgets(List<BudgetResponse> v) {
      budgets = v;
      return this;
    }

    Builder dailyExpenseTotals(Map<LocalDate, BigDecimal> v) {
      dailyExpenseTotals = v;
      return this;
    }

    Builder distinctSpendingDays(int v) {
      distinctSpendingDays = v;
      return this;
    }

    Builder noSpendDays(int v) {
      noSpendDays = v;
      return this;
    }

    Builder largestExpenseTransaction(Transaction v) {
      largestExpenseTransaction = v;
      return this;
    }

    Builder previousMonthExpense(String v) {
      previousMonthExpense = new BigDecimal(v);
      return this;
    }

    Builder previousMonthIncome(String v) {
      previousMonthIncome = new BigDecimal(v);
      return this;
    }

    Builder previousMonthSavingsContribution(String v) {
      previousMonthSavingsContribution = new BigDecimal(v);
      return this;
    }

    Builder previousMonthLeafCategoryBreakdown(List<LeafCategoryStats> v) {
      previousMonthLeafCategoryBreakdown = v;
      return this;
    }

    Builder historicalAverageLeafCategoryAmount(Map<String, BigDecimal> v) {
      historicalAverageLeafCategoryAmount = v;
      return this;
    }

    MonthlyFinancialSummary build() {
      LocalDate monthStart = LocalDate.of(year, month, 1);
      LocalDate monthEnd = monthStart.with(TemporalAdjusters.lastDayOfMonth());
      return new MonthlyFinancialSummary(
          year,
          month,
          monthStart,
          monthEnd,
          totalIncome,
          totalExpense,
          totalIncome.subtract(totalExpense),
          totalSavingsContribution,
          transactionCount,
          topLevelCategoryBreakdown,
          leafCategoryBreakdown,
          merchantBreakdown,
          expenseTransactions,
          discretionaryTotal,
          essentialTotal,
          subscriptions,
          budgets,
          dailyExpenseTotals,
          distinctSpendingDays,
          noSpendDays,
          largestExpenseTransaction,
          previousMonthExpense,
          previousMonthIncome,
          previousMonthSavingsContribution,
          previousMonthLeafCategoryBreakdown,
          historicalAverageLeafCategoryAmount);
    }
  }
}
