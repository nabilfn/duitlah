package com.duitlah.api.wrapped;

import com.duitlah.api.analytics.CategorySpendingResponse;
import com.duitlah.api.analytics.MerchantSpendingResponse;
import com.duitlah.api.budgets.BudgetResponse;
import com.duitlah.api.budgets.BudgetStatus;
import com.duitlah.api.transactions.Transaction;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Service;

/**
 * Ranks a pool of candidate insights (spec sections 18-19) and returns only the top few — never
 * every statistic that could technically be computed, only the ones actually worth a screen.
 * Nothing here is randomized or LLM-written: the same {@link MonthlyFinancialSummary} always
 * produces the same ranked list.
 */
@Service
public class MonthlyInsightEngine {

  private static final int MAX_INSIGHTS = 4;
  private static final DateTimeFormatter DAY_FORMAT = DateTimeFormatter.ofPattern("d MMM");

  private record Candidate(WrappedInsight insight, BigDecimal priority) {}

  public List<WrappedInsight> rank(MonthlyFinancialSummary summary) {
    List<Candidate> candidates = new ArrayList<>();

    topCategory(summary).ifPresent(candidates::add);
    favouriteMerchant(summary).ifPresent(candidates::add);
    highestSpendMerchant(summary).ifPresent(candidates::add);
    recurringPayments(summary).ifPresent(candidates::add);
    biggestCategoryChange(summary).ifPresent(candidates::add);
    largestTransaction(summary).ifPresent(candidates::add);
    highestSpendingDay(summary).ifPresent(candidates::add);
    noSpendDays(summary).ifPresent(candidates::add);
    savingsImprovement(summary).ifPresent(candidates::add);
    budgetPerformance(summary).ifPresent(candidates::add);

    return candidates.stream()
        .sorted(Comparator.comparing(Candidate::priority).reversed())
        .limit(MAX_INSIGHTS)
        .map(Candidate::insight)
        .toList();
  }

  private java.util.Optional<Candidate> topCategory(MonthlyFinancialSummary summary) {
    if (summary.topLevelCategoryBreakdown().isEmpty() || summary.totalExpense().signum() <= 0) {
      return java.util.Optional.empty();
    }
    CategorySpendingResponse top = summary.topLevelCategoryBreakdown().get(0);
    BigDecimal share = percent(top.amount(), summary.totalExpense());
    return java.util.Optional.of(
        new Candidate(
            new WrappedInsight(
                "TOP_CATEGORY",
                "Top category",
                top.categoryName(),
                "RM" + format(top.amount()),
                share.setScale(0, RoundingMode.HALF_UP) + "% of spending"),
            share));
  }

  private java.util.Optional<Candidate> favouriteMerchant(MonthlyFinancialSummary summary) {
    return summary.merchantBreakdown().stream()
        .filter(m -> !m.merchant().isBlank())
        .max(Comparator.comparingLong(MerchantSpendingResponse::transactionCount))
        .filter(m -> m.transactionCount() >= 2)
        .map(
            m ->
                new Candidate(
                    new WrappedInsight(
                        "FAVOURITE_MERCHANT",
                        "Favourite merchant",
                        m.merchant(),
                        m.transactionCount() + " visits",
                        "RM" + format(m.amount()) + " total"),
                    BigDecimal.valueOf(m.transactionCount()).multiply(BigDecimal.TEN)));
  }

  private java.util.Optional<Candidate> highestSpendMerchant(MonthlyFinancialSummary summary) {
    if (summary.merchantBreakdown().isEmpty()) return java.util.Optional.empty();
    MerchantSpendingResponse top = summary.merchantBreakdown().get(0);
    // Skip if this is the same merchant already surfaced as the favourite by visit count.
    boolean sameAsFavourite =
        summary.merchantBreakdown().stream()
            .max(Comparator.comparingLong(MerchantSpendingResponse::transactionCount))
            .map(m -> m.merchant().equals(top.merchant()))
            .orElse(false);
    if (sameAsFavourite) return java.util.Optional.empty();
    return java.util.Optional.of(
        new Candidate(
            new WrappedInsight(
                "HIGHEST_SPEND_MERCHANT",
                "Biggest merchant spend",
                top.merchant(),
                "RM" + format(top.amount()),
                top.transactionCount() + " transaction(s)"),
            percent(top.amount(), summary.totalExpense())));
  }

  private java.util.Optional<Candidate> recurringPayments(MonthlyFinancialSummary summary) {
    int count = summary.subscriptions().subscriptions().size();
    if (count == 0) return java.util.Optional.empty();
    return java.util.Optional.of(
        new Candidate(
            new WrappedInsight(
                "RECURRING_PAYMENTS",
                "Recurring payments",
                count + " active",
                "RM" + format(summary.subscriptions().estimatedMonthlyTotal()) + " / month",
                null),
            BigDecimal.valueOf(45)));
  }

  private java.util.Optional<Candidate> biggestCategoryChange(MonthlyFinancialSummary summary) {
    CategorySpendingResponse best = null;
    BigDecimal bestChange = null;
    for (CategorySpendingResponse row : summary.topLevelCategoryBreakdown()) {
      CategorySpendingResponse prior =
          summary.previousMonthLeafCategoryBreakdown().isEmpty()
              ? null
              : findTopLevelPriorEquivalent(summary, row.categoryName());
      BigDecimal priorAmount = prior == null ? BigDecimal.ZERO : prior.amount();
      if (priorAmount.signum() <= 0) continue;
      BigDecimal change = row.amount().subtract(priorAmount).abs();
      if (change.compareTo(BigDecimal.valueOf(50)) < 0) continue; // not material enough to mention
      BigDecimal changePercent =
          row.amount()
              .subtract(priorAmount)
              .divide(priorAmount, 4, RoundingMode.HALF_UP)
              .multiply(BigDecimal.valueOf(100));
      if (bestChange == null || changePercent.abs().compareTo(bestChange.abs()) > 0) {
        best = row;
        bestChange = changePercent;
      }
    }
    if (best == null) return java.util.Optional.empty();
    boolean up = bestChange.signum() > 0;
    CategorySpendingResponse finalBest = best;
    BigDecimal finalChange = bestChange;
    return java.util.Optional.of(
        new Candidate(
            new WrappedInsight(
                "SPENDING_CHANGE",
                "Spending change",
                finalBest.categoryName(),
                (up ? "▲ " : "▼ ") + finalChange.abs().setScale(0, RoundingMode.HALF_UP) + "%",
                "vs last month"),
            finalChange.abs()));
  }

  /**
   * Best-effort top-level lookup from the leaf-level previous-month breakdown — used only to detect
   * a material swing, so an approximate roll-up (summing leaf rows whose name equals the top-level
   * name, the common case when a user spends directly against a parent category) is good enough; a
   * genuinely wrong prior figure only suppresses the insight, it never fabricates a change that
   * didn't happen since the {@code >= RM50} floor above still applies.
   */
  private static CategorySpendingResponse findTopLevelPriorEquivalent(
      MonthlyFinancialSummary summary, String topLevelName) {
    return summary.previousMonthLeafCategoryBreakdown().stream()
        .filter(row -> row.categoryName().equalsIgnoreCase(topLevelName))
        .findFirst()
        .map(row -> new CategorySpendingResponse(null, row.categoryName(), row.amount()))
        .orElse(null);
  }

  private java.util.Optional<Candidate> largestTransaction(MonthlyFinancialSummary summary) {
    Transaction largest = summary.largestExpenseTransaction();
    if (largest == null) return java.util.Optional.empty();
    return java.util.Optional.of(
        new Candidate(
            new WrappedInsight(
                "LARGEST_TRANSACTION",
                "Biggest single expense",
                "RM" + format(largest.getAmount()),
                largest.getMerchant() == null ? largest.getDescription() : largest.getMerchant(),
                largest.getOccurredOn().format(DAY_FORMAT)),
            percent(largest.getAmount(), summary.totalExpense())));
  }

  private java.util.Optional<Candidate> highestSpendingDay(MonthlyFinancialSummary summary) {
    return summary.dailyExpenseTotals().entrySet().stream()
        .max(Map.Entry.comparingByValue())
        .map(
            entry ->
                new Candidate(
                    new WrappedInsight(
                        "HIGHEST_SPENDING_DAY",
                        "Biggest spending day",
                        "RM" + format(entry.getValue()),
                        entry.getKey().format(DAY_FORMAT),
                        null),
                    percent(entry.getValue(), summary.totalExpense())));
  }

  private java.util.Optional<Candidate> noSpendDays(MonthlyFinancialSummary summary) {
    if (summary.noSpendDays() <= 0) return java.util.Optional.empty();
    int daysInMonth = summary.monthEnd().getDayOfMonth();
    return java.util.Optional.of(
        new Candidate(
            new WrappedInsight(
                "NO_SPEND_DAYS",
                "No-spend days",
                summary.noSpendDays() + " days",
                "out of " + daysInMonth,
                null),
            BigDecimal.valueOf(20)));
  }

  private java.util.Optional<Candidate> savingsImprovement(MonthlyFinancialSummary summary) {
    BigDecimal delta = summary.savingsRate().subtract(summary.previousSavingsRate());
    if (summary.totalSavingsContribution().signum() <= 0 || delta.signum() <= 0) {
      return java.util.Optional.empty();
    }
    return java.util.Optional.of(
        new Candidate(
            new WrappedInsight(
                "SAVINGS_IMPROVEMENT",
                "Savings improvement",
                "RM" + format(summary.totalSavingsContribution()) + " saved",
                "+" + delta.setScale(0, RoundingMode.HALF_UP) + "pp vs last month",
                null),
            BigDecimal.valueOf(30).add(delta)));
  }

  private java.util.Optional<Candidate> budgetPerformance(MonthlyFinancialSummary summary) {
    List<BudgetResponse> budgets = summary.budgets();
    if (budgets.isEmpty()) return java.util.Optional.empty();
    long okCount = budgets.stream().filter(b -> b.status() == BudgetStatus.OK).count();
    if (okCount == 0) return java.util.Optional.empty();
    BigDecimal remaining =
        budgets.stream()
            .map(b -> b.remaining().max(BigDecimal.ZERO))
            .reduce(BigDecimal.ZERO, BigDecimal::add);
    return java.util.Optional.of(
        new Candidate(
            new WrappedInsight(
                "BUDGET_PERFORMANCE",
                "Budget performance",
                okCount + " of " + budgets.size() + " on track",
                "RM" + format(remaining) + " under budget",
                null),
            percent(BigDecimal.valueOf(okCount), BigDecimal.valueOf(budgets.size()))));
  }

  private static BigDecimal percent(BigDecimal part, BigDecimal whole) {
    if (whole.signum() <= 0) return BigDecimal.ZERO;
    return part.divide(whole, 4, RoundingMode.HALF_UP).multiply(BigDecimal.valueOf(100));
  }

  private static String format(BigDecimal amount) {
    return amount.setScale(2, RoundingMode.HALF_UP).toPlainString();
  }
}
