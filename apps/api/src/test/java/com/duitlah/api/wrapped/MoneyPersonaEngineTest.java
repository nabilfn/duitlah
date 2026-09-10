package com.duitlah.api.wrapped;

import static com.duitlah.api.wrapped.WrappedTestFixtures.leaf;
import static org.assertj.core.api.Assertions.assertThat;

import com.duitlah.api.budgets.BudgetStatus;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import org.junit.jupiter.api.Test;

/** Deterministic Money Persona scoring (spec section 35's own required test list). */
class MoneyPersonaEngineTest {

  private final MoneyPersonaEngine engine = new MoneyPersonaEngine();

  @Test
  void cafeHunterWinsWhenCafeSpendingDominatesDiscretionarySpending() {
    MonthlyFinancialSummary summary =
        WrappedTestFixtures.summary()
            .transactionCount(12)
            .distinctSpendingDays(15)
            .totalExpense("900.00")
            .discretionaryTotal("600.00")
            .leafCategoryBreakdown(
                List.of(
                    leaf("Cafe", "486.00", 8, "zus", "starbucks", "coffeebean"),
                    leaf("Groceries", "300.00", 4, "tesco"),
                    leaf("Fuel", "114.00", 2, "petronas")))
            .historicalAverageLeafCategoryAmount(Map.of("Cafe", new BigDecimal("300.00")))
            .build();

    var primary = engine.choosePrimary(summary);

    assertThat(primary).isPresent();
    assertThat(primary.get().id()).isEqualTo(MoneyPersonaId.CAFE_HUNTER);
    assertThat(primary.get().amount()).isEqualByComparingTo("486.00");
    assertThat(primary.get().denominatorLabel()).isEqualTo("of discretionary spending");
  }

  @Test
  void checkoutChampionWinsWhenShoppingCategoriesDominate() {
    MonthlyFinancialSummary summary =
        WrappedTestFixtures.summary()
            .transactionCount(15)
            .distinctSpendingDays(16)
            .totalExpense("1200.00")
            .discretionaryTotal("900.00")
            .leafCategoryBreakdown(
                List.of(
                    leaf("Online Shopping", "500.00", 6, "shopee", "lazada"),
                    leaf("Clothing", "200.00", 3, "uniqlo"),
                    leaf("Groceries", "300.00", 4, "tesco")))
            .historicalAverageLeafCategoryAmount(Map.of())
            .build();

    var primary = engine.choosePrimary(summary);

    assertThat(primary).isPresent();
    assertThat(primary.get().id()).isEqualTo(MoneyPersonaId.CHECKOUT_CHAMPION);
  }

  @Test
  void budgetNinjaWinsWhenEveryBudgetStaysOnTrackAndNoOtherStrongSignalExists() {
    MonthlyFinancialSummary summary =
        WrappedTestFixtures.summary()
            .transactionCount(11)
            .distinctSpendingDays(14)
            .totalExpense("500.00")
            .discretionaryTotal("200.00")
            .leafCategoryBreakdown(List.of(leaf("Groceries", "500.00", 11, "tesco")))
            .budgets(
                List.of(
                    WrappedTestFixtures.budget("300.00", "200.00", BudgetStatus.OK),
                    WrappedTestFixtures.budget("200.00", "100.00", BudgetStatus.OK)))
            .build();

    var primary = engine.choosePrimary(summary);

    // Groceries is essential (spec section 14), so it scores zero share of discretionary
    // spending under every category persona, correctly none of which claim it — Budget Ninja
    // (2/2 budgets on track = 100 score) is the only real signal left.
    assertThat(primary).isPresent();
    assertThat(primary.get().id()).isEqualTo(MoneyPersonaId.BUDGET_NINJA);
    assertThat(primary.get().score()).isEqualByComparingTo("100.00");
  }

  @Test
  void tabungTitanWinsWithAStrongConsistentSavingsRate() {
    MonthlyFinancialSummary summary =
        WrappedTestFixtures.summary()
            .transactionCount(10)
            .distinctSpendingDays(14)
            .totalIncome("3000.00")
            .totalExpense("500.00")
            .discretionaryTotal("200.00")
            .totalSavingsContribution("900.00")
            .previousMonthSavingsContribution("400.00")
            .leafCategoryBreakdown(List.of(leaf("Groceries", "500.00", 10, "tesco")))
            .build();

    var primary = engine.choosePrimary(summary);

    assertThat(primary).isPresent();
    assertThat(primary.get().id()).isEqualTo(MoneyPersonaId.TABUNG_TITAN);
    // 900/3000 = 30% -> full rate score (100) + 10 consecutive-month bonus, capped at 100.
    assertThat(primary.get().score()).isEqualByComparingTo("100.00");
  }

  @Test
  void noPersonaIsAssignedBelowTheMinimumDataThreshold() {
    MonthlyFinancialSummary tooFewTransactions =
        WrappedTestFixtures.summary()
            .transactionCount(5)
            .distinctSpendingDays(20)
            .totalExpense("500.00")
            .leafCategoryBreakdown(List.of(leaf("Cafe", "500.00", 5, "zus")))
            .build();
    assertThat(engine.choosePrimary(tooFewTransactions)).isEmpty();

    MonthlyFinancialSummary tooFewDays =
        WrappedTestFixtures.summary()
            .transactionCount(20)
            .distinctSpendingDays(5)
            .totalExpense("500.00")
            .leafCategoryBreakdown(List.of(leaf("Cafe", "500.00", 20, "zus")))
            .build();
    assertThat(engine.choosePrimary(tooFewDays)).isEmpty();
  }

  @Test
  void zeroSpendingMonthNeverThrowsAndNeverAssignsAPersona() {
    MonthlyFinancialSummary emptyMonth = WrappedTestFixtures.summary().build();

    List<PersonaScore> scores = engine.scoreAll(emptyMonth);

    assertThat(scores).hasSize(10);
    assertThat(scores).allSatisfy(s -> assertThat(s.score()).isEqualByComparingTo(BigDecimal.ZERO));
    assertThat(engine.choosePrimary(emptyMonth)).isEmpty();
  }

  @Test
  void scoringTheSameSummaryTwiceProducesTheIdenticalResult() {
    MonthlyFinancialSummary summary =
        WrappedTestFixtures.summary()
            .transactionCount(12)
            .distinctSpendingDays(15)
            .totalExpense("900.00")
            .discretionaryTotal("600.00")
            .leafCategoryBreakdown(List.of(leaf("Cafe", "486.00", 8, "zus", "starbucks")))
            .build();

    List<PersonaScore> first = engine.scoreAll(summary);
    List<PersonaScore> second = engine.scoreAll(summary);

    assertThat(first).isEqualTo(second);
    assertThat(engine.choosePrimary(summary)).isEqualTo(engine.choosePrimary(summary));
  }

  @Test
  void autoRenewRoyaltyNeedsAtLeastOneActiveSubscription() {
    MonthlyFinancialSummary noSubs =
        WrappedTestFixtures.summary()
            .subscriptions(WrappedTestFixtures.subscriptions("0.00", 0))
            .build();
    List<PersonaScore> scores = engine.scoreAll(noSubs);
    PersonaScore autoRenew =
        scores.stream()
            .filter(s -> s.id() == MoneyPersonaId.AUTO_RENEW_ROYALTY)
            .findFirst()
            .orElseThrow();
    assertThat(autoRenew.score()).isEqualByComparingTo(BigDecimal.ZERO);
  }
}
