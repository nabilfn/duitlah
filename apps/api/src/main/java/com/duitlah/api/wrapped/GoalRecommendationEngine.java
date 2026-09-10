package com.duitlah.api.wrapped;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Optional;
import org.springframework.stereotype.Service;

/**
 * Deterministic next-month suggestions (spec sections 20-21) — first matching rule wins, in a fixed
 * order from "most specific and actionable" to "generic and always safe to say." Every message is
 * supportive/neutral; never a shame message for high essential spending, low income, or a difficult
 * month (spec section 20's own explicit ban).
 */
@Service
public class GoalRecommendationEngine {

  private static final BigDecimal SUBSCRIPTION_REVIEW_THRESHOLD = BigDecimal.valueOf(3);
  private static final BigDecimal LOW_SAVINGS_RATE_THRESHOLD = BigDecimal.TEN;
  private static final BigDecimal MATERIAL_INCREASE_AMOUNT = BigDecimal.valueOf(300);
  private static final BigDecimal MATERIAL_INCREASE_PERCENT = BigDecimal.valueOf(20);

  public WrappedGoal recommend(
      MonthlyFinancialSummary summary, Optional<PersonaScore> primaryPersona, String personaLabel) {
    return personaCategoryLimit(summary, primaryPersona, personaLabel)
        .or(() -> subscriptionReview(summary))
        .or(() -> lowSavingsRate(summary))
        .or(() -> finishedUnderBudget(summary))
        .or(() -> savingsMomentum(summary))
        .orElseGet(GoalRecommendationEngine::fallback);
  }

  private Optional<WrappedGoal> personaCategoryLimit(
      MonthlyFinancialSummary summary, Optional<PersonaScore> primaryPersona, String personaLabel) {
    if (primaryPersona.isEmpty()) return Optional.empty();
    PersonaScore persona = primaryPersona.get();
    BigDecimal historicalAverage =
        summary.historicalAverageLeafCategoryAmount().values().stream()
            .reduce(BigDecimal.ZERO, BigDecimal::add);
    // A rough but explainable "did this persona's spending materially jump" check: the persona's
    // own amount is compared against this user's own historical average across all categories it
    // draws from, exactly the same figures used to score the persona in the first place.
    if (historicalAverage.signum() <= 0) return Optional.empty();
    BigDecimal increase = persona.amount().subtract(historicalAverage);
    if (increase.compareTo(MATERIAL_INCREASE_AMOUNT) < 0) return Optional.empty();
    BigDecimal increasePercent =
        increase
            .divide(historicalAverage, 4, RoundingMode.HALF_UP)
            .multiply(BigDecimal.valueOf(100));
    if (increasePercent.compareTo(MATERIAL_INCREASE_PERCENT) < 0) return Optional.empty();

    BigDecimal suggestedLimit =
        persona.amount().multiply(BigDecimal.valueOf(0.9)).setScale(0, RoundingMode.HALF_UP);
    return Optional.of(
        new WrappedGoal(
            "Try keeping "
                + personaLabel.toLowerCase()
                + " spending below RM"
                + suggestedLimit
                + " next month."));
  }

  private Optional<WrappedGoal> subscriptionReview(MonthlyFinancialSummary summary) {
    int count = summary.subscriptions().subscriptions().size();
    if (BigDecimal.valueOf(count).compareTo(SUBSCRIPTION_REVIEW_THRESHOLD) < 0)
      return Optional.empty();
    return Optional.of(
        new WrappedGoal(
            "Review your " + count + " active subscriptions — one might not be earning its keep."));
  }

  private Optional<WrappedGoal> lowSavingsRate(MonthlyFinancialSummary summary) {
    if (summary.totalIncome().signum() <= 0) return Optional.empty();
    if (summary.savingsRate().compareTo(LOW_SAVINGS_RATE_THRESHOLD) >= 0) return Optional.empty();
    return Optional.of(
        new WrappedGoal(
            "Try saving 10% of next month's income — small, steady contributions add up."));
  }

  private Optional<WrappedGoal> finishedUnderBudget(MonthlyFinancialSummary summary) {
    if (summary.budgets().isEmpty()) return Optional.empty();
    boolean allOnTrack =
        summary.budgets().stream()
            .allMatch(b -> b.status() != com.duitlah.api.budgets.BudgetStatus.EXCEEDED);
    BigDecimal totalRemaining =
        summary.budgets().stream().map(b -> b.remaining()).reduce(BigDecimal.ZERO, BigDecimal::add);
    if (!allOnTrack || totalRemaining.signum() <= 0) return Optional.empty();
    return Optional.of(
        new WrappedGoal(
            "You finished RM"
                + totalRemaining.setScale(0, RoundingMode.HALF_UP)
                + " under budget. Keep the same target next month."));
  }

  private Optional<WrappedGoal> savingsMomentum(MonthlyFinancialSummary summary) {
    if (summary.savingsRate().compareTo(summary.previousSavingsRate()) <= 0)
      return Optional.empty();
    return Optional.of(new WrappedGoal("Your savings rate improved. Keep the momentum going."));
  }

  private static WrappedGoal fallback() {
    return new WrappedGoal(
        "Keep tracking your spending — small, consistent habits add up over time.");
  }
}
