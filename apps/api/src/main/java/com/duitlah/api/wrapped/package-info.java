/**
 * Duitlah Monthly Wrapped: a Spotify-Wrapped-paced but never Spotify-styled recap of one user's one
 * completed calendar month, built from two coordinated systems (per the feature's own product
 * brief): a deterministic, explainable, testable financial engine ({@link
 * com.duitlah.api.wrapped.MonthlyAggregationService}, {@link
 * com.duitlah.api.wrapped.MoneyPersonaEngine}, {@link
 * com.duitlah.api.wrapped.MonthlyInsightEngine}, {@link
 * com.duitlah.api.wrapped.GoalRecommendationEngine}) feeding a story-paced mobile presentation this
 * package never renders itself.
 *
 * <p>Every figure is derived from tables that already exist ({@code transactions}, {@code budgets},
 * {@code goals}, {@code recurring_transactions}) via services that already compute them ({@code
 * analytics.AnalyticsService}, {@code budgets.BudgetService}, {@code goals.GoalService}, {@code
 * recurring.RecurringTransactionService}) — this package adds no new way to read a transaction,
 * only a new way to summarize, score and persist what those already answer. No LLM is involved
 * anywhere in scoring a persona, ranking an insight, or recommending a goal — see each engine's own
 * class comment for why, matching this codebase's established "the AI must never become the source
 * of truth for a financial calculation" discipline.
 *
 * <p>Module boundary: code outside this package should depend only on this module's public
 * service/DTO surface, not its internal classes.
 */
package com.duitlah.api.wrapped;
