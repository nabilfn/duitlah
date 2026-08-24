package com.duitlah.api.analytics;

import com.duitlah.api.finance.AccountService;
import com.duitlah.api.finance.Category;
import com.duitlah.api.finance.CategoryRepository;
import com.duitlah.api.finance.CategoryService;
import com.duitlah.api.recurring.RecurrenceCalculator;
import com.duitlah.api.recurring.RecurringTransaction;
import com.duitlah.api.recurring.RecurringTransactionRepository;
import com.duitlah.api.transactions.Transaction;
import com.duitlah.api.transactions.TransactionRepository;
import com.duitlah.api.transactions.TransactionResponse;
import com.duitlah.api.transactions.TransactionType;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;

/**
 * Advanced analytics beyond {@link DashboardService}'s single-month snapshot: category breakdowns,
 * month-over-month trends, top merchants, a financial calendar, and a cash-flow forecast. Every
 * figure here is derived from the same {@code transactions}/{@code accounts} tables the dashboard
 * reads — no separate analytics data store, so there's nothing to keep in sync.
 */
@Service
public class AnalyticsService {

  private static final int FORECAST_HISTORY_MONTHS = 3;

  private final AccountService accountService;
  private final CategoryService categoryService;
  private final CategoryRepository categories;
  private final TransactionRepository transactions;
  private final RecurringTransactionRepository recurringTransactions;

  public AnalyticsService(
      AccountService accountService,
      CategoryService categoryService,
      CategoryRepository categories,
      TransactionRepository transactions,
      RecurringTransactionRepository recurringTransactions) {
    this.accountService = accountService;
    this.categoryService = categoryService;
    this.categories = categories;
    this.transactions = transactions;
    this.recurringTransactions = recurringTransactions;
  }

  /** Expense total per top-level category for one month, highest first. */
  public List<CategorySpendingResponse> spendingByCategory(UUID userId, int year, int month) {
    LocalDate monthStart = LocalDate.of(year, month, 1);
    LocalDate monthEnd = monthStart.with(TemporalAdjusters.lastDayOfMonth());

    List<CategorySpendingResponse> results = new ArrayList<>();
    for (Category category : categories.findByUserIdIsNullOrUserId(userId)) {
      if (category.getParentId() != null) {
        continue; // only top-level categories are reported; children roll up into these.
      }
      if (category.getType() != com.duitlah.api.finance.CategoryType.EXPENSE) {
        continue;
      }
      List<UUID> ids = categoryService.expandToSelfAndChildren(category);
      BigDecimal amount =
          transactions.sumAmountByUserIdAndTypeAndCategoryIdInAndOccurredOnBetween(
              userId, TransactionType.EXPENSE, ids, monthStart, monthEnd);
      if (amount.signum() > 0) {
        results.add(new CategorySpendingResponse(category.getId(), category.getName(), amount));
      }
    }
    results.sort(Comparator.comparing(CategorySpendingResponse::amount).reversed());
    return results;
  }

  /** Income/expense/savings for each of the last {@code months} months, oldest first. */
  public List<MonthlyTrendResponse> monthlyTrend(UUID userId, int months) {
    List<MonthlyTrendResponse> trend = new ArrayList<>();
    LocalDate cursor =
        LocalDate.now().with(TemporalAdjusters.firstDayOfMonth()).minusMonths(months - 1L);
    for (int i = 0; i < months; i++) {
      LocalDate monthStart = cursor;
      LocalDate monthEnd = monthStart.with(TemporalAdjusters.lastDayOfMonth());
      BigDecimal income =
          transactions.sumAmountByUserIdAndTypeAndOccurredOnBetween(
              userId, TransactionType.INCOME, monthStart, monthEnd);
      BigDecimal expense =
          transactions.sumAmountByUserIdAndTypeAndOccurredOnBetween(
              userId, TransactionType.EXPENSE, monthStart, monthEnd);
      trend.add(
          new MonthlyTrendResponse(
              monthStart.getYear(),
              monthStart.getMonthValue(),
              income,
              expense,
              income.subtract(expense)));
      cursor = cursor.plusMonths(1);
    }
    return trend;
  }

  /** Top merchants by expense total for one month, highest first. */
  public List<MerchantSpendingResponse> topMerchants(UUID userId, int year, int month) {
    LocalDate monthStart = LocalDate.of(year, month, 1);
    LocalDate monthEnd = monthStart.with(TemporalAdjusters.lastDayOfMonth());
    return transactions.sumExpenseAmountGroupedByMerchant(userId, monthStart, monthEnd).stream()
        .map(
            row ->
                new MerchantSpendingResponse(
                    (String) row[0], (BigDecimal) row[1], ((Number) row[2]).longValue()))
        .toList();
  }

  /**
   * Real transactions plus every recurring rule's projected (not-yet-materialized) occurrence
   * within the month, sorted by date. A rule's own {@code nextOccurrenceDate} is always the first
   * date NOT yet turned into a real transaction (see {@code RecurringTransactionService
   * #materializeAllDue}), so projecting from there can never double-count with an already-posted
   * transaction.
   */
  public List<CalendarEntryResponse> calendar(UUID userId, int year, int month) {
    LocalDate monthStart = LocalDate.of(year, month, 1);
    LocalDate monthEnd = monthStart.with(TemporalAdjusters.lastDayOfMonth());

    List<CalendarEntryResponse> entries = new ArrayList<>();
    for (Transaction t :
        transactions.findByUserIdAndOccurredOnBetween(userId, monthStart, monthEnd)) {
      TransactionResponse response = TransactionResponse.from(t);
      entries.add(
          new CalendarEntryResponse(
              response.occurredOn(),
              true,
              response.type(),
              response.direction(),
              response.amount(),
              response.merchant(),
              response.description()));
    }

    for (RecurringTransaction rule :
        recurringTransactions.findByUserIdAndActiveTrueOrderByNextOccurrenceDateAsc(userId)) {
      for (LocalDate date :
          RecurrenceCalculator.occurrencesBetween(
              rule.getNextOccurrenceDate(),
              rule.getFrequency(),
              rule.getIntervalCount(),
              rule.getEndDate(),
              monthStart,
              monthEnd)) {
        entries.add(
            new CalendarEntryResponse(
                date,
                false,
                rule.getType(),
                rule.getDirection(),
                rule.getAmount(),
                rule.getMerchant(),
                rule.getDescription()));
      }
    }

    entries.sort(Comparator.comparing(CalendarEntryResponse::date));
    return entries;
  }

  /**
   * Projects the balance to the end of the current month. See {@link ForecastResponse}'s Javadoc
   * for why confirmed/scheduled/predicted are kept as separate figures rather than one number.
   */
  public ForecastResponse forecast(UUID userId) {
    LocalDate today = LocalDate.now();
    LocalDate targetDate = today.with(TemporalAdjusters.lastDayOfMonth());
    BigDecimal currentBalance = accountService.totalAvailableBalance(userId);

    BigDecimal scheduledIncome = BigDecimal.ZERO;
    BigDecimal scheduledExpense = BigDecimal.ZERO;
    for (RecurringTransaction rule :
        recurringTransactions.findByUserIdAndActiveTrueOrderByNextOccurrenceDateAsc(userId)) {
      List<LocalDate> occurrences =
          RecurrenceCalculator.occurrencesBetween(
              rule.getNextOccurrenceDate(),
              rule.getFrequency(),
              rule.getIntervalCount(),
              rule.getEndDate(),
              today.plusDays(1),
              targetDate);
      if (occurrences.isEmpty()) {
        continue;
      }
      BigDecimal ruleTotal = rule.getAmount().multiply(BigDecimal.valueOf(occurrences.size()));
      if (rule.getType() == TransactionType.INCOME) {
        scheduledIncome = scheduledIncome.add(ruleTotal);
      } else {
        scheduledExpense = scheduledExpense.add(ruleTotal);
      }
    }

    BigDecimal predictedVariableExpense = predictedVariableExpense(userId, today, targetDate);

    BigDecimal projectedBalance =
        currentBalance
            .add(scheduledIncome)
            .subtract(scheduledExpense)
            .subtract(predictedVariableExpense);

    return new ForecastResponse(
        currentBalance,
        today,
        targetDate,
        scheduledIncome,
        scheduledExpense,
        predictedVariableExpense,
        projectedBalance,
        "This is an estimate based on your recurring transactions and average spending — not a guarantee.");
  }

  /**
   * Average of the last {@link #FORECAST_HISTORY_MONTHS} completed months' non-recurring
   * ("variable") expense, prorated for the days remaining in the current month. Recurring-linked
   * spending is excluded here since it's already counted as {@code scheduledExpense} — without the
   * exclusion, rent would be projected twice.
   */
  private BigDecimal predictedVariableExpense(UUID userId, LocalDate today, LocalDate targetDate) {
    BigDecimal historicalTotal = BigDecimal.ZERO;
    LocalDate monthCursor = today.with(TemporalAdjusters.firstDayOfMonth());
    for (int i = 1; i <= FORECAST_HISTORY_MONTHS; i++) {
      LocalDate priorMonthStart = monthCursor.minusMonths(i);
      LocalDate priorMonthEnd = priorMonthStart.with(TemporalAdjusters.lastDayOfMonth());
      historicalTotal =
          historicalTotal.add(
              transactions.sumNonRecurringAmountByUserIdAndTypeAndOccurredOnBetween(
                  userId, TransactionType.EXPENSE, priorMonthStart, priorMonthEnd));
    }
    BigDecimal monthlyAverage =
        historicalTotal.divide(
            BigDecimal.valueOf(FORECAST_HISTORY_MONTHS), 4, RoundingMode.HALF_UP);

    long daysRemaining = ChronoUnit.DAYS.between(today, targetDate) + 1;
    long daysInCurrentMonth = today.lengthOfMonth();
    return monthlyAverage
        .multiply(BigDecimal.valueOf(daysRemaining))
        .divide(BigDecimal.valueOf(daysInCurrentMonth), 2, RoundingMode.HALF_UP);
  }
}
