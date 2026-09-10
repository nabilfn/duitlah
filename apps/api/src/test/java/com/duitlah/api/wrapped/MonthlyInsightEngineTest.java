package com.duitlah.api.wrapped;

import static com.duitlah.api.wrapped.WrappedTestFixtures.leaf;
import static org.assertj.core.api.Assertions.assertThat;

import com.duitlah.api.analytics.CategorySpendingResponse;
import com.duitlah.api.analytics.MerchantSpendingResponse;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import org.junit.jupiter.api.Test;

class MonthlyInsightEngineTest {

  private final MonthlyInsightEngine engine = new MonthlyInsightEngine();

  @Test
  void recurringPaymentsAppearsWhenActiveSubscriptionsExist() {
    MonthlyFinancialSummary summary =
        WrappedTestFixtures.summary()
            .totalExpense("500.00")
            .subscriptions(WrappedTestFixtures.subscriptions("98.00", 3))
            .build();

    List<WrappedInsight> insights = engine.rank(summary);

    assertThat(insights).anySatisfy(i -> assertThat(i.type()).isEqualTo("RECURRING_PAYMENTS"));
    WrappedInsight recurring =
        insights.stream()
            .filter(i -> i.type().equals("RECURRING_PAYMENTS"))
            .findFirst()
            .orElseThrow();
    assertThat(recurring.primaryValue()).isEqualTo("3 active");
    assertThat(recurring.secondaryValue()).contains("98.00");
  }

  @Test
  void noRecurringPaymentsInsightWhenThereAreNoSubscriptions() {
    MonthlyFinancialSummary summary = WrappedTestFixtures.summary().totalExpense("500.00").build();
    List<WrappedInsight> insights = engine.rank(summary);
    assertThat(insights).noneSatisfy(i -> assertThat(i.type()).isEqualTo("RECURRING_PAYMENTS"));
  }

  @Test
  void topCategoryReportsAnAccuratePercentageOfTotalSpending() {
    MonthlyFinancialSummary summary =
        WrappedTestFixtures.summary()
            .totalExpense("1000.00")
            .topLevelCategoryBreakdown(
                List.of(
                    new CategorySpendingResponse(
                        UUID.randomUUID(), "Food", new BigDecimal("400.00"))))
            .build();

    List<WrappedInsight> insights = engine.rank(summary);
    WrappedInsight top =
        insights.stream().filter(i -> i.type().equals("TOP_CATEGORY")).findFirst().orElseThrow();

    assertThat(top.secondaryValue()).contains("400.00");
    assertThat(top.comparison()).isEqualTo("40% of spending");
  }

  @Test
  void spendingChangeDetectsANegativeSwingVsLastMonth() {
    MonthlyFinancialSummary summary =
        WrappedTestFixtures.summary()
            .totalExpense("500.00")
            .topLevelCategoryBreakdown(
                List.of(
                    new CategorySpendingResponse(
                        UUID.randomUUID(), "Shopping", new BigDecimal("100.00"))))
            .previousMonthLeafCategoryBreakdown(List.of(leaf("Shopping", "300.00", 5)))
            .build();

    List<WrappedInsight> insights = engine.rank(summary);
    WrappedInsight change =
        insights.stream().filter(i -> i.type().equals("SPENDING_CHANGE")).findFirst().orElseThrow();

    // A drop from 300 to 100 is -66.67%, i.e. a genuine decrease, not a fabricated increase.
    assertThat(change.secondaryValue()).startsWith("▼");
  }

  @Test
  void noSpendDaysIsOmittedWhenThereWereNone() {
    MonthlyFinancialSummary summary = WrappedTestFixtures.summary().noSpendDays(0).build();
    assertThat(engine.rank(summary))
        .noneSatisfy(i -> assertThat(i.type()).isEqualTo("NO_SPEND_DAYS"));
  }

  @Test
  void savingsImprovementNeverAppearsWhenSavingsRateGotWorse() {
    MonthlyFinancialSummary summary =
        WrappedTestFixtures.summary()
            .totalIncome("2000.00")
            .totalSavingsContribution("100.00") // 5%
            .previousMonthIncome("2000.00")
            .previousMonthSavingsContribution("400.00") // 20%
            .build();
    assertThat(engine.rank(summary))
        .noneSatisfy(i -> assertThat(i.type()).isEqualTo("SAVINGS_IMPROVEMENT"));
  }

  @Test
  void returnsAtMostFourInsightsEvenWhenManyCandidatesQualify() {
    MonthlyFinancialSummary summary =
        WrappedTestFixtures.summary()
            .totalExpense("1000.00")
            .totalIncome("3000.00")
            .totalSavingsContribution("500.00")
            .topLevelCategoryBreakdown(
                List.of(
                    new CategorySpendingResponse(
                        UUID.randomUUID(), "Food", new BigDecimal("400.00"))))
            .merchantBreakdown(
                List.of(
                    new MerchantSpendingResponse("ZUS Coffee", new BigDecimal("100.00"), 6),
                    new MerchantSpendingResponse(
                        "Big Purchase Store", new BigDecimal("300.00"), 1)))
            .subscriptions(WrappedTestFixtures.subscriptions("50.00", 2))
            .noSpendDays(5)
            .dailyExpenseTotals(Map.of(LocalDate.of(2026, 8, 5), new BigDecimal("200.00")))
            .largestExpenseTransaction(
                WrappedTestFixtures.expense(
                    "Shopping", null, "300.00", "Big Purchase Store", LocalDate.of(2026, 8, 5)))
            .build();

    assertThat(engine.rank(summary)).hasSizeLessThanOrEqualTo(4);
  }

  @Test
  void neverProducesNaNOrInfiniteValuesWhenEverythingIsZero() {
    MonthlyFinancialSummary summary = WrappedTestFixtures.summary().build();
    List<WrappedInsight> insights = engine.rank(summary);
    for (WrappedInsight insight : insights) {
      assertThat(insight.primaryValue()).doesNotContain("NaN", "Infinity", "null");
    }
  }
}
