package com.duitlah.api.wrapped;

import com.duitlah.api.analytics.AnalyticsService;
import com.duitlah.api.budgets.BudgetService;
import com.duitlah.api.finance.Category;
import com.duitlah.api.finance.CategoryRepository;
import com.duitlah.api.goals.GoalContributionRepository;
import com.duitlah.api.recurring.RecurringTransactionService;
import com.duitlah.api.transactions.Transaction;
import com.duitlah.api.transactions.TransactionRepository;
import com.duitlah.api.transactions.TransactionType;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import org.springframework.stereotype.Service;

/**
 * Turns three completed months of one user's already-real data (this month plus two of history)
 * into one {@link MonthlyFinancialSummary} — the single computation every Wrapped engine reads
 * from. Reuses {@code AnalyticsService}/{@code BudgetService}/{@code
 * RecurringTransactionService}/{@code GoalContributionRepository} wherever they already answer the
 * question; the only genuinely new aggregation here is the leaf-level category breakdown (the real
 * Insights screen only ever needs top-level) and the day-by-day/essential-vs-discretionary splits
 * Wrapped's persona and insight engines need that nothing else in the app computes.
 */
@Service
public class MonthlyAggregationService {

  private static final int HISTORY_MONTHS = 3;

  /**
   * Leaf category names classified as non-discretionary (spec section 14) — matched
   * case-insensitively so a user's own custom category with the same name still counts. Everything
   * not in this set, including any category a user created themselves, is discretionary by default;
   * essentials are the narrower, explicitly-known set, not the other way round.
   */
  private static final Set<String> ESSENTIAL_LEAF_NAMES =
      Set.of(
          "rent",
          "electricity",
          "water",
          "internet",
          "phone",
          "insurance",
          "groceries",
          "loan",
          "credit card",
          "tuition");

  private final AnalyticsService analyticsService;
  private final TransactionRepository transactions;
  private final CategoryRepository categories;
  private final BudgetService budgetService;
  private final GoalContributionRepository goalContributions;
  private final RecurringTransactionService recurringTransactionService;

  public MonthlyAggregationService(
      AnalyticsService analyticsService,
      TransactionRepository transactions,
      CategoryRepository categories,
      BudgetService budgetService,
      GoalContributionRepository goalContributions,
      RecurringTransactionService recurringTransactionService) {
    this.analyticsService = analyticsService;
    this.transactions = transactions;
    this.categories = categories;
    this.budgetService = budgetService;
    this.goalContributions = goalContributions;
    this.recurringTransactionService = recurringTransactionService;
  }

  public MonthlyFinancialSummary summarize(UUID userId, int year, int month) {
    LocalDate monthStart = LocalDate.of(year, month, 1);
    LocalDate monthEnd = monthStart.with(TemporalAdjusters.lastDayOfMonth());
    LocalDate previousMonthStart = monthStart.minusMonths(1);
    LocalDate previousMonthEnd = previousMonthStart.with(TemporalAdjusters.lastDayOfMonth());

    List<Transaction> monthTransactions =
        transactions.findByUserIdAndOccurredOnBetween(userId, monthStart, monthEnd);
    List<Transaction> expenseTransactions =
        monthTransactions.stream().filter(t -> t.getType() == TransactionType.EXPENSE).toList();

    BigDecimal totalIncome =
        transactions.sumAmountByUserIdAndTypeAndOccurredOnBetween(
            userId, TransactionType.INCOME, monthStart, monthEnd);
    BigDecimal totalExpense =
        transactions.sumAmountByUserIdAndTypeAndOccurredOnBetween(
            userId, TransactionType.EXPENSE, monthStart, monthEnd);
    BigDecimal totalSavingsContribution =
        goalContributions.sumAmountByUserIdAndOccurredOnBetween(userId, monthStart, monthEnd);

    Map<UUID, Category> categoryById = categoryById(userId);
    List<LeafCategoryStats> leafBreakdown =
        leafCategoryBreakdown(expenseTransactions, categoryById);
    BigDecimal essentialTotal = essentialTotal(leafBreakdown);
    BigDecimal discretionaryTotal = totalExpense.subtract(essentialTotal).max(BigDecimal.ZERO);

    Map<LocalDate, BigDecimal> dailyTotals = dailyExpenseTotals(expenseTransactions);
    Transaction largest =
        expenseTransactions.stream().max(Comparator.comparing(Transaction::getAmount)).orElse(null);

    BigDecimal previousMonthExpense =
        transactions.sumAmountByUserIdAndTypeAndOccurredOnBetween(
            userId, TransactionType.EXPENSE, previousMonthStart, previousMonthEnd);
    BigDecimal previousMonthIncome =
        transactions.sumAmountByUserIdAndTypeAndOccurredOnBetween(
            userId, TransactionType.INCOME, previousMonthStart, previousMonthEnd);
    BigDecimal previousMonthSavings =
        goalContributions.sumAmountByUserIdAndOccurredOnBetween(
            userId, previousMonthStart, previousMonthEnd);
    List<Transaction> previousMonthExpenseTransactions =
        transactions
            .findByUserIdAndOccurredOnBetween(userId, previousMonthStart, previousMonthEnd)
            .stream()
            .filter(t -> t.getType() == TransactionType.EXPENSE)
            .toList();
    List<LeafCategoryStats> previousLeafBreakdown =
        leafCategoryBreakdown(previousMonthExpenseTransactions, categoryById);

    Map<String, BigDecimal> historicalAverages =
        historicalAverageLeafAmounts(userId, monthStart, categoryById);

    return new MonthlyFinancialSummary(
        year,
        month,
        monthStart,
        monthEnd,
        totalIncome,
        totalExpense,
        totalIncome.subtract(totalExpense),
        totalSavingsContribution,
        monthTransactions.size(),
        analyticsService.spendingByCategory(userId, year, month),
        leafBreakdown,
        analyticsService.topMerchants(userId, year, month),
        expenseTransactions,
        discretionaryTotal,
        essentialTotal,
        recurringTransactionService.subscriptionsSummary(userId),
        budgetService.listForPeriod(userId, year, month),
        dailyTotals,
        dailyTotals.size(),
        (int)
            monthStart
                .datesUntil(monthEnd.plusDays(1))
                .filter(d -> !dailyTotals.containsKey(d))
                .count(),
        largest,
        previousMonthExpense,
        previousMonthIncome,
        previousMonthSavings,
        previousLeafBreakdown,
        historicalAverages);
  }

  /** Counts the same recorded expenses under their top-level category for story drill-downs. */
  public Map<UUID, Long> categoryCounts(UUID userId, MonthlyFinancialSummary summary) {
    Map<UUID, Category> byId = categoryById(userId);
    Map<UUID, Long> counts = new HashMap<>();
    for (Transaction transaction : summary.expenseTransactions()) {
      Category category = byId.get(transaction.getCategoryId());
      Set<UUID> visited = new HashSet<>();
      while (category != null && category.getParentId() != null && visited.add(category.getId())) {
        category = byId.get(category.getParentId());
      }
      if (category != null && category.getParentId() == null) counts.merge(category.getId(), 1L, Long::sum);
    }
    return counts;
  }

  private Map<UUID, Category> categoryById(UUID userId) {
    Map<UUID, Category> map = new HashMap<>();
    for (Category category : categories.findByUserIdIsNullOrUserId(userId)) {
      map.put(category.getId(), category);
    }
    return map;
  }

  /**
   * Every expense category a user actually spent in this month, at whatever level (leaf or
   * top-level with no children used) they recorded it against — grouped by name, not id, so a
   * global "Cafe" and a same-named custom category never double up under two different amounts.
   */
  private static List<LeafCategoryStats> leafCategoryBreakdown(
      List<Transaction> expenseTransactions, Map<UUID, Category> categoryById) {
    Map<String, BigDecimal> totals = new HashMap<>();
    Map<String, Integer> counts = new HashMap<>();
    Map<String, Set<String>> merchantsByName = new HashMap<>();
    for (Transaction t : expenseTransactions) {
      if (t.getCategoryId() == null) continue;
      Category category = categoryById.get(t.getCategoryId());
      if (category == null) continue;
      String name = category.getName();
      totals.merge(name, t.getAmount(), BigDecimal::add);
      counts.merge(name, 1, Integer::sum);
      merchantsByName
          .computeIfAbsent(name, k -> new HashSet<>())
          .add(t.getMerchant() == null ? "" : t.getMerchant().toLowerCase(Locale.ROOT));
    }
    List<LeafCategoryStats> result = new ArrayList<>();
    for (var entry : totals.entrySet()) {
      result.add(
          new LeafCategoryStats(
              entry.getKey(),
              entry.getValue(),
              counts.get(entry.getKey()),
              merchantsByName.get(entry.getKey())));
    }
    result.sort(Comparator.comparing(LeafCategoryStats::amount).reversed());
    return result;
  }

  private static BigDecimal essentialTotal(List<LeafCategoryStats> leafBreakdown) {
    BigDecimal total = BigDecimal.ZERO;
    for (LeafCategoryStats row : leafBreakdown) {
      if (ESSENTIAL_LEAF_NAMES.contains(row.categoryName().toLowerCase(Locale.ROOT))) {
        total = total.add(row.amount());
      }
    }
    return total;
  }

  private static Map<LocalDate, BigDecimal> dailyExpenseTotals(
      List<Transaction> expenseTransactions) {
    Map<LocalDate, BigDecimal> totals = new HashMap<>();
    for (Transaction t : expenseTransactions) {
      totals.merge(t.getOccurredOn(), t.getAmount(), BigDecimal::add);
    }
    return totals;
  }

  private Map<String, BigDecimal> historicalAverageLeafAmounts(
      UUID userId, LocalDate monthStart, Map<UUID, Category> categoryById) {
    Map<String, BigDecimal> runningTotal = new HashMap<>();
    for (int i = 1; i <= HISTORY_MONTHS; i++) {
      LocalDate priorStart = monthStart.minusMonths(i);
      LocalDate priorEnd = priorStart.with(TemporalAdjusters.lastDayOfMonth());
      List<Transaction> priorExpenses =
          transactions.findByUserIdAndOccurredOnBetween(userId, priorStart, priorEnd).stream()
              .filter(t -> t.getType() == TransactionType.EXPENSE)
              .toList();
      for (LeafCategoryStats row : leafCategoryBreakdown(priorExpenses, categoryById)) {
        runningTotal.merge(row.categoryName(), row.amount(), BigDecimal::add);
      }
    }
    Map<String, BigDecimal> averages = new HashMap<>();
    for (var entry : runningTotal.entrySet()) {
      averages.put(
          entry.getKey(),
          entry.getValue().divide(BigDecimal.valueOf(HISTORY_MONTHS), 4, RoundingMode.HALF_UP));
    }
    return averages;
  }
}
