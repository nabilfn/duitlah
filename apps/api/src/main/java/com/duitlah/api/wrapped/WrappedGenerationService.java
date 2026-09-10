package com.duitlah.api.wrapped;

import com.duitlah.api.common.error.ApiException;
import java.time.Instant;
import java.time.YearMonth;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Orchestrates the four engines into one persisted {@link WrappedResult} per (user, month) — the
 * {@code WrappedGenerationService} the spec names. Generated once, never silently regenerated (spec
 * section 22): a later edit to an old transaction does not retroactively rewrite an already-issued
 * Wrapped. {@code monthly_wrapped}'s own {@code UNIQUE(user_id, year, month)} constraint is the
 * real backstop against a duplicate under concurrent requests; the in-transaction re-check is just
 * the common-case fast path.
 */
@Service
public class WrappedGenerationService {

  private final MonthlyWrappedRepository wrappedRepository;
  private final MonthlyAggregationService aggregationService;
  private final MoneyPersonaEngine personaEngine;
  private final MonthlyInsightEngine insightEngine;
  private final GoalRecommendationEngine goalEngine;

  public WrappedGenerationService(
      MonthlyWrappedRepository wrappedRepository,
      MonthlyAggregationService aggregationService,
      MoneyPersonaEngine personaEngine,
      MonthlyInsightEngine insightEngine,
      GoalRecommendationEngine goalEngine) {
    this.wrappedRepository = wrappedRepository;
    this.aggregationService = aggregationService;
    this.personaEngine = personaEngine;
    this.insightEngine = insightEngine;
    this.goalEngine = goalEngine;
  }

  @Transactional
  public WrappedResult getOrGenerate(UUID userId, int year, int month) {
    requireCompletedMonth(year, month);
    return wrappedRepository
        .findByUserIdAndYearAndMonth(userId, year, month)
        .map(MonthlyWrapped::toResult)
        .orElseGet(() -> generateAndPersist(userId, year, month));
  }

  /**
   * Called directly by {@link MonthlyWrappedScheduler} for last month, which is always already
   * completed by the time the 1st-of-the-month job runs, so no validation is needed here.
   */
  @Transactional
  public WrappedResult generateAndPersist(UUID userId, int year, int month) {
    MonthlyFinancialSummary summary = aggregationService.summarize(userId, year, month);
    Optional<PersonaScore> primary = personaEngine.choosePrimary(summary);
    String personaLabel = primary.map(score -> definitionFor(score.id()).displayName()).orElse("");
    WrappedPersona persona =
        primary.map(score -> WrappedPersona.from(definitionFor(score.id()), score)).orElse(null);
    List<WrappedInsight> insights = insightEngine.rank(summary);
    WrappedGoal goal = goalEngine.recommend(summary, primary, personaLabel);

    WrappedResult result =
        new WrappedResult(
            year,
            month,
            WrappedResult.CURRENT_VERSION,
            Instant.now(),
            summary.hasSufficientData(),
            WrappedOverview.from(summary),
            persona,
            insights,
            goal,
            WrappedStoryData.from(summary, primary.map(score -> definitionFor(score.id())).orElse(null), aggregationService.categoryCounts(userId, summary)));

    try {
      wrappedRepository.save(new MonthlyWrapped(userId, year, month, result));
      return result;
    } catch (DataIntegrityViolationException raceLost) {
      return wrappedRepository
          .findByUserIdAndYearAndMonth(userId, year, month)
          .map(MonthlyWrapped::toResult)
          .orElseThrow(() -> raceLost);
    }
  }

  public List<WrappedHistoryItemResponse> history(UUID userId) {
    return wrappedRepository.findByUserIdOrderByYearDescMonthDesc(userId).stream()
        .map(
            row ->
                new WrappedHistoryItemResponse(
                    row.getYear(),
                    row.getMonth(),
                    row.getPersonaId(),
                    row.getPersonaId() == null ? null : personaDisplayName(row.getPersonaId()),
                    row.getViewedAt() != null))
        .toList();
  }

  /**
   * The Home promo card's data source (spec section 4) — only ever looks at what already exists;
   * never generates a Wrapped as a side effect of a screen that just wants to know whether to show
   * a teaser. If the monthly schedule hasn't produced last month's Wrapped yet, the card simply
   * doesn't appear until it has.
   */
  public WrappedPromoResponse pendingPromo(UUID userId) {
    YearMonth lastMonth = YearMonth.now().minusMonths(1);
    return wrappedRepository
        .findByUserIdAndYearAndMonth(userId, lastMonth.getYear(), lastMonth.getMonthValue())
        .filter(row -> row.getViewedAt() == null)
        .filter(MonthlyWrapped::isSufficientData)
        .map(
            row ->
                new WrappedPromoResponse(
                    true, row.getYear(), row.getMonth(), personaDisplayName(row.getPersonaId())))
        .orElseGet(WrappedPromoResponse::none);
  }

  @Transactional
  public void markViewed(UUID userId, int year, int month) {
    wrappedRepository
        .findByUserIdAndYearAndMonth(userId, year, month)
        .filter(row -> row.getViewedAt() == null)
        .ifPresent(
            row -> {
              row.setViewedAt(Instant.now());
              wrappedRepository.save(row);
            });
  }

  private void requireCompletedMonth(int year, int month) {
    YearMonth requested = YearMonth.of(year, month);
    if (!requested.isBefore(YearMonth.now())) {
      throw new ApiException(
          HttpStatus.BAD_REQUEST,
          "MONTH_NOT_COMPLETED",
          "Monthly Wrapped is only available for a completed month.");
    }
  }

  private MoneyPersonaDefinition definitionFor(MoneyPersonaId id) {
    return personaEngine.definitions().stream()
        .filter(definition -> definition.id() == id)
        .findFirst()
        .orElseThrow();
  }

  private String personaDisplayName(String personaId) {
    return definitionFor(MoneyPersonaId.valueOf(personaId)).displayName();
  }
}
