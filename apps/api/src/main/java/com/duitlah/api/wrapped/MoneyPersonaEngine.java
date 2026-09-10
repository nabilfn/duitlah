package com.duitlah.api.wrapped;

import com.duitlah.api.budgets.BudgetResponse;
import com.duitlah.api.budgets.BudgetStatus;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Optional;
import java.util.Set;
import org.springframework.stereotype.Service;

/**
 * Deterministic Money Persona scoring (spec sections 10-15). The same {@link
 * MonthlyFinancialSummary} always produces the same {@link PersonaScore}s and the same winner — no
 * LLM, no randomness, nothing time-of-day-dependent. Every persona is evaluated every month; the
 * highest-scoring one that also clears its own minimum-evidence bar becomes {@code primaryPersona}.
 * If the month itself doesn't clear {@link MonthlyFinancialSummary#hasSufficientData()}, or not one
 * persona clears its own bar, no persona is assigned at all (spec section 15) rather than guessing
 * from too little signal.
 *
 * <p>Seven personas share one scoring shape (a leaf-category match against real seeded categories —
 * see {@code V3__personal_finance.sql} — never a merchant-name guess): 40% share of discretionary
 * spending, 30% transaction frequency, 20% change against this user's own 3-month historical
 * average, 10% merchant variety (spec section 13's example weights). The other three each have a
 * genuinely different signal — subscriptions, savings rate, budget adherence — so they're scored
 * separately rather than forced into the same category-share shape.
 */
@Service
public class MoneyPersonaEngine {

  private static final List<MoneyPersonaDefinition> DEFINITIONS =
      List.of(
          new MoneyPersonaDefinition(
              MoneyPersonaId.CAFE_HUNTER,
              "Cafe Hunter",
              "You know every cafe before Google Maps does.",
              "cafe_hunter",
              Set.of("cafe")),
          new MoneyPersonaDefinition(
              MoneyPersonaId.CHECKOUT_CHAMPION,
              "Checkout Champion",
              "Add to cart is your love language.",
              "checkout_champion",
              Set.of("clothing", "electronics", "personal", "online shopping")),
          new MoneyPersonaDefinition(
              MoneyPersonaId.JALAN_JALAN_CEO,
              "Jalan-Jalan CEO",
              "Your wallet has seen more places than your passport.",
              "jalan_jalan_ceo",
              Set.of("grab", "public transport", "travel", "toll", "fuel")),
          new MoneyPersonaDefinition(
              MoneyPersonaId.AUTO_RENEW_ROYALTY,
              "Auto-Renew Royalty",
              "Your subscriptions have subscriptions.",
              "auto_renew_royalty",
              Set.of()),
          new MoneyPersonaDefinition(
              MoneyPersonaId.TABUNG_TITAN,
              "Tabung Titan",
              "Your future self is your favourite person.",
              "tabung_titan",
              Set.of()),
          new MoneyPersonaDefinition(
              MoneyPersonaId.BUDGET_NINJA,
              "Budget Ninja",
              "Every ringgit has a mission.",
              "budget_ninja",
              Set.of()),
          new MoneyPersonaDefinition(
              MoneyPersonaId.MEMORY_COLLECTOR,
              "Memory Collector",
              "You collect experiences, not just receipts.",
              "memory_collector",
              Set.of("entertainment", "sports")),
          new MoneyPersonaDefinition(
              MoneyPersonaId.LIFE_ADMIN_LEGEND,
              "Life Admin Legend",
              "Bills paid. Groceries stocked. Life handled.",
              "life_admin_legend",
              Set.of("groceries", "electricity", "water", "internet", "phone", "rent")),
          new MoneyPersonaDefinition(
              MoneyPersonaId.MAKAN_MISSION_SPECIALIST,
              "Makan Mission Specialist",
              "You don't eat out. You explore the menu.",
              "makan_mission_specialist",
              Set.of("restaurants", "delivery")),
          new MoneyPersonaDefinition(
              MoneyPersonaId.DIGITAL_LOOT_GOBLIN,
              "Digital Loot Goblin",
              "The battle pass won. Again.",
              "digital_loot_goblin",
              Set.of("gaming", "software")));

  private static final BigDecimal HUNDRED = BigDecimal.valueOf(100);

  public List<MoneyPersonaDefinition> definitions() {
    return DEFINITIONS;
  }

  /** Every persona's score, in definition order — callers pick the winner. */
  public List<PersonaScore> scoreAll(MonthlyFinancialSummary summary) {
    List<PersonaScore> scores = new ArrayList<>();
    for (MoneyPersonaDefinition definition : DEFINITIONS) {
      scores.add(
          switch (definition.id()) {
            case AUTO_RENEW_ROYALTY -> scoreAutoRenewRoyalty(summary);
            case TABUNG_TITAN -> scoreTabungTitan(summary);
            case BUDGET_NINJA -> scoreBudgetNinja(summary);
            default -> scoreCategoryPersona(definition, summary);
          });
    }
    return scores;
  }

  /**
   * The highest-scoring persona that clears its own minimum-evidence bar, or empty if the month
   * lacks enough data overall, or if literally nothing cleared any bar.
   */
  public Optional<PersonaScore> choosePrimary(MonthlyFinancialSummary summary) {
    if (!summary.hasSufficientData()) {
      return Optional.empty();
    }
    return scoreAll(summary).stream()
        .filter(score -> score.score().signum() > 0)
        .max((a, b) -> a.score().compareTo(b.score()));
  }

  private PersonaScore scoreCategoryPersona(
      MoneyPersonaDefinition definition, MonthlyFinancialSummary summary) {
    Set<String> matchNames = definition.matchLeafCategoryNames();
    List<LeafCategoryStats> matched =
        summary.leafCategoryBreakdown().stream()
            .filter(row -> matchNames.contains(row.categoryName().toLowerCase(Locale.ROOT)))
            .toList();

    BigDecimal amount =
        matched.stream().map(LeafCategoryStats::amount).reduce(BigDecimal.ZERO, BigDecimal::add);
    int transactionCount = matched.stream().mapToInt(LeafCategoryStats::transactionCount).sum();

    if (amount.signum() <= 0 || transactionCount == 0) {
      return new PersonaScore(
          definition.id(),
          BigDecimal.ZERO,
          BigDecimal.ZERO,
          BigDecimal.ZERO,
          "of spending",
          List.of());
    }

    BigDecimal denominator =
        summary.discretionaryTotal().signum() > 0
            ? summary.discretionaryTotal()
            : summary.totalExpense();
    String denominatorLabel =
        summary.discretionaryTotal().signum() > 0 ? "of discretionary spending" : "of spending";
    BigDecimal spendingSharePercent = percent(amount, denominator);

    BigDecimal transactionFrequencyScore =
        min(
                BigDecimal.valueOf(transactionCount)
                    .divide(BigDecimal.TEN, 4, RoundingMode.HALF_UP),
                BigDecimal.ONE)
            .multiply(HUNDRED);

    BigDecimal historicalAverage =
        matched.stream()
            .map(
                row ->
                    summary
                        .historicalAverageLeafCategoryAmount()
                        .getOrDefault(row.categoryName(), BigDecimal.ZERO))
            .reduce(BigDecimal.ZERO, BigDecimal::add);
    BigDecimal historicalChangeScore = historicalChangeScore(amount, historicalAverage);

    Set<String> merchants = new LinkedHashSet<>();
    matched.forEach(row -> merchants.addAll(row.merchants()));
    merchants.remove("");
    BigDecimal merchantVarietyScore =
        min(
                BigDecimal.valueOf(merchants.size())
                    .divide(BigDecimal.valueOf(5), 4, RoundingMode.HALF_UP),
                BigDecimal.ONE)
            .multiply(HUNDRED);

    BigDecimal score =
        weighted(spendingSharePercent, "0.40")
            .add(weighted(transactionFrequencyScore, "0.30"))
            .add(weighted(historicalChangeScore, "0.20"))
            .add(weighted(merchantVarietyScore, "0.10"));

    List<String> evidence =
        List.of(
            "RM"
                + amount.setScale(2, RoundingMode.HALF_UP)
                + " across "
                + transactionCount
                + " transaction(s)",
            spendingSharePercent.setScale(0, RoundingMode.HALF_UP) + "% " + denominatorLabel,
            merchants.size() + " different merchant(s)");

    return new PersonaScore(
        definition.id(),
        score.setScale(2, RoundingMode.HALF_UP),
        amount,
        spendingSharePercent,
        denominatorLabel,
        evidence);
  }

  private PersonaScore scoreAutoRenewRoyalty(MonthlyFinancialSummary summary) {
    BigDecimal amount = summary.subscriptions().estimatedMonthlyTotal();
    int count = summary.subscriptions().subscriptions().size();
    if (count == 0 || amount.signum() <= 0) {
      return new PersonaScore(
          MoneyPersonaId.AUTO_RENEW_ROYALTY,
          BigDecimal.ZERO,
          BigDecimal.ZERO,
          BigDecimal.ZERO,
          "of spending",
          List.of());
    }
    BigDecimal shareOfSpending = percent(amount, summary.totalExpense());
    BigDecimal countScore =
        min(
                BigDecimal.valueOf(count).divide(BigDecimal.valueOf(5), 4, RoundingMode.HALF_UP),
                BigDecimal.ONE)
            .multiply(HUNDRED);
    BigDecimal score =
        weighted(countScore, "0.5").add(weighted(min(shareOfSpending, HUNDRED), "0.5"));
    List<String> evidence =
        List.of(
            "RM"
                + amount.setScale(2, RoundingMode.HALF_UP)
                + "/month across "
                + count
                + " active subscription(s)");
    return new PersonaScore(
        MoneyPersonaId.AUTO_RENEW_ROYALTY,
        score.setScale(2, RoundingMode.HALF_UP),
        amount,
        shareOfSpending,
        "of spending",
        evidence);
  }

  private PersonaScore scoreTabungTitan(MonthlyFinancialSummary summary) {
    BigDecimal amount = summary.totalSavingsContribution();
    if (amount.signum() <= 0) {
      return new PersonaScore(
          MoneyPersonaId.TABUNG_TITAN,
          BigDecimal.ZERO,
          BigDecimal.ZERO,
          BigDecimal.ZERO,
          "of income saved",
          List.of());
    }
    BigDecimal rate = summary.savingsRate();
    BigDecimal rateScore =
        min(rate.divide(BigDecimal.valueOf(30), 4, RoundingMode.HALF_UP), BigDecimal.ONE)
            .multiply(HUNDRED);
    boolean consecutive = summary.previousMonthSavingsContribution().signum() > 0;
    BigDecimal score = min(rateScore.add(consecutive ? BigDecimal.TEN : BigDecimal.ZERO), HUNDRED);
    List<String> evidence =
        List.of(
            "RM" + amount.setScale(2, RoundingMode.HALF_UP) + " saved this month",
            rate.setScale(0, RoundingMode.HALF_UP) + "% of income",
            consecutive ? "Contributed for 2 months running" : "First month contributing");
    return new PersonaScore(
        MoneyPersonaId.TABUNG_TITAN,
        score.setScale(2, RoundingMode.HALF_UP),
        amount,
        rate,
        "of income saved",
        evidence);
  }

  private PersonaScore scoreBudgetNinja(MonthlyFinancialSummary summary) {
    List<BudgetResponse> budgets = summary.budgets();
    if (budgets.isEmpty()) {
      return new PersonaScore(
          MoneyPersonaId.BUDGET_NINJA,
          BigDecimal.ZERO,
          BigDecimal.ZERO,
          BigDecimal.ZERO,
          "of budgets on track",
          List.of());
    }
    long okCount = budgets.stream().filter(b -> b.status() == BudgetStatus.OK).count();
    BigDecimal ratio = percent(BigDecimal.valueOf(okCount), BigDecimal.valueOf(budgets.size()));
    BigDecimal amountUnderBudget =
        budgets.stream()
            .map(b -> b.remaining().max(BigDecimal.ZERO))
            .reduce(BigDecimal.ZERO, BigDecimal::add);
    List<String> evidence =
        List.of(
            okCount + " of " + budgets.size() + " budget(s) stayed on track",
            "RM" + amountUnderBudget.setScale(2, RoundingMode.HALF_UP) + " under budget overall");
    return new PersonaScore(
        MoneyPersonaId.BUDGET_NINJA,
        ratio.setScale(2, RoundingMode.HALF_UP),
        amountUnderBudget,
        ratio,
        "of budgets on track",
        evidence);
  }

  private static BigDecimal historicalChangeScore(BigDecimal amount, BigDecimal historicalAverage) {
    if (historicalAverage.signum() <= 0) {
      return amount.signum() > 0 ? HUNDRED : BigDecimal.ZERO;
    }
    BigDecimal changePercent =
        amount
            .subtract(historicalAverage)
            .divide(historicalAverage, 4, RoundingMode.HALF_UP)
            .multiply(HUNDRED);
    BigDecimal clamped = max(min(changePercent, HUNDRED), BigDecimal.valueOf(-100));
    return clamped.add(HUNDRED).divide(BigDecimal.valueOf(2), 4, RoundingMode.HALF_UP);
  }

  private static BigDecimal percent(BigDecimal part, BigDecimal whole) {
    if (whole.signum() <= 0) return BigDecimal.ZERO;
    return min(part.divide(whole, 4, RoundingMode.HALF_UP).multiply(HUNDRED), HUNDRED);
  }

  private static BigDecimal weighted(BigDecimal value, String weight) {
    return value.multiply(new BigDecimal(weight));
  }

  private static BigDecimal min(BigDecimal a, BigDecimal b) {
    return a.compareTo(b) <= 0 ? a : b;
  }

  private static BigDecimal max(BigDecimal a, BigDecimal b) {
    return a.compareTo(b) >= 0 ? a : b;
  }
}
