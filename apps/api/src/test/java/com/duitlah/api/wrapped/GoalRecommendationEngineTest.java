package com.duitlah.api.wrapped;

import static com.duitlah.api.wrapped.WrappedTestFixtures.leaf;
import static org.assertj.core.api.Assertions.assertThat;

import com.duitlah.api.budgets.BudgetStatus;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import org.junit.jupiter.api.Test;

class GoalRecommendationEngineTest {

  private final GoalRecommendationEngine engine = new GoalRecommendationEngine();

  @Test
  void suggestsARealisticPersonaCategoryLimitWhenSpendingJumpedMaterially() {
    MonthlyFinancialSummary summary =
        WrappedTestFixtures.summary()
            .historicalAverageLeafCategoryAmount(Map.of("Cafe", new BigDecimal("200.00")))
            .build();
    PersonaScore cafeHunter =
        new PersonaScore(
            MoneyPersonaId.CAFE_HUNTER,
            new BigDecimal("80"),
            new BigDecimal("500.00"),
            new BigDecimal("60"),
            "of discretionary spending",
            List.of());

    WrappedGoal goal = engine.recommend(summary, Optional.of(cafeHunter), "Cafe Hunter");

    assertThat(goal.message()).contains("cafe hunter").contains("RM450");
  }

  @Test
  void suggestsReviewingSubscriptionsAtThreeOrMoreActive() {
    MonthlyFinancialSummary summary =
        WrappedTestFixtures.summary()
            .subscriptions(WrappedTestFixtures.subscriptions("60.00", 3))
            .build();

    WrappedGoal goal = engine.recommend(summary, Optional.empty(), "");

    assertThat(goal.message()).contains("3 active subscriptions");
  }

  @Test
  void doesNotSuggestSubscriptionReviewBelowThreeActive() {
    MonthlyFinancialSummary summary =
        WrappedTestFixtures.summary()
            .subscriptions(WrappedTestFixtures.subscriptions("20.00", 2))
            .build();
    WrappedGoal goal = engine.recommend(summary, Optional.empty(), "");
    assertThat(goal.message()).doesNotContain("subscriptions");
  }

  @Test
  void suggestsSavingTenPercentWhenSavingsRateIsLow() {
    MonthlyFinancialSummary summary =
        WrappedTestFixtures.summary()
            .totalIncome("2000.00")
            .totalSavingsContribution("50.00")
            .build();

    WrappedGoal goal = engine.recommend(summary, Optional.empty(), "");

    assertThat(goal.message()).contains("10%");
  }

  @Test
  void congratulatesFinishingUnderBudgetWhenSavingsRateIsAlreadyHealthy() {
    MonthlyFinancialSummary summary =
        WrappedTestFixtures.summary()
            .totalIncome("2000.00")
            .totalSavingsContribution("400.00") // 20%, clears the low-savings rule
            .budgets(List.of(WrappedTestFixtures.budget("300.00", "60.00", BudgetStatus.OK)))
            .build();

    WrappedGoal goal = engine.recommend(summary, Optional.empty(), "");

    assertThat(goal.message()).contains("under budget");
  }

  @Test
  void congratulatesSavingsMomentumWhenNothingElseApplies() {
    MonthlyFinancialSummary summary =
        WrappedTestFixtures.summary()
            .totalIncome("2000.00")
            .totalSavingsContribution("400.00")
            .previousMonthIncome("2000.00")
            .previousMonthSavingsContribution("100.00")
            .build();

    WrappedGoal goal = engine.recommend(summary, Optional.empty(), "");

    assertThat(goal.message()).contains("momentum");
  }

  @Test
  void fallsBackToAGenericSupportiveMessageWhenNoRuleApplies() {
    MonthlyFinancialSummary summary = WrappedTestFixtures.summary().build();
    WrappedGoal goal = engine.recommend(summary, Optional.empty(), "");
    assertThat(goal.message()).isNotBlank();
  }

  @Test
  void neverShamesAHighEssentialSpendingOrLowIncomeMonth() {
    MonthlyFinancialSummary summary =
        WrappedTestFixtures.summary()
            .totalIncome("800.00")
            .totalExpense("750.00")
            .leafCategoryBreakdown(
                List.of(leaf("Rent", "600.00", 1), leaf("Electricity", "150.00", 1)))
            .build();

    WrappedGoal goal = engine.recommend(summary, Optional.empty(), "");

    String lower = goal.message().toLowerCase();
    assertThat(lower)
        .doesNotContain(
            "shame", "bad", "wasteful", "overspending", "should not have", "irresponsible");
  }
}
