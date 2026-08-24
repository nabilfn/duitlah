package com.duitlah.api.ai;

import com.duitlah.api.analytics.AnalyticsService;
import com.duitlah.api.analytics.CategorySpendingResponse;
import com.duitlah.api.analytics.DashboardResponse;
import com.duitlah.api.analytics.DashboardService;
import com.duitlah.api.analytics.ForecastResponse;
import com.duitlah.api.analytics.MerchantSpendingResponse;
import com.duitlah.api.analytics.MonthlyTrendResponse;
import com.duitlah.api.budgets.BudgetResponse;
import com.duitlah.api.budgets.BudgetService;
import com.duitlah.api.goals.GoalResponse;
import com.duitlah.api.goals.GoalService;
import com.duitlah.api.settlements.SettlementService;
import com.duitlah.api.settlements.SettlementSummaryResponse;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;

/**
 * The "Finance Query Layer" from the product spec's AI assistant architecture (section 40): {@code
 * User Question -> Permission + Intent -> Finance Query Layer -> Structured Financial Summary -> AI
 * -> Natural Language Explanation}. Every method here is a thin, read-only pass-through to an
 * existing, already-authorized service -- this class adds no new business logic and touches no
 * repository directly. That's the actual safety boundary the spec means by "the AI MUST NOT receive
 * unrestricted database access": {@link ClaudeAiChatService} can only ever call these named, fixed
 * queries, scoped to the one {@code userId} it was invoked with, and can never issue an arbitrary
 * query against anything else.
 */
@Service
public class FinanceQueryService {

  private final DashboardService dashboardService;
  private final AnalyticsService analyticsService;
  private final BudgetService budgetService;
  private final GoalService goalService;
  private final SettlementService settlementService;

  public FinanceQueryService(
      DashboardService dashboardService,
      AnalyticsService analyticsService,
      BudgetService budgetService,
      GoalService goalService,
      SettlementService settlementService) {
    this.dashboardService = dashboardService;
    this.analyticsService = analyticsService;
    this.budgetService = budgetService;
    this.goalService = goalService;
    this.settlementService = settlementService;
  }

  public DashboardResponse dashboardSummary(UUID userId) {
    return dashboardService.forUser(userId);
  }

  public List<CategorySpendingResponse> spendingByCategory(UUID userId, int year, int month) {
    return analyticsService.spendingByCategory(userId, year, month);
  }

  public List<MonthlyTrendResponse> monthlyTrend(UUID userId, int months) {
    return analyticsService.monthlyTrend(userId, months);
  }

  public List<MerchantSpendingResponse> topMerchants(UUID userId, int year, int month) {
    return analyticsService.topMerchants(userId, year, month);
  }

  public ForecastResponse forecast(UUID userId) {
    return analyticsService.forecast(userId);
  }

  public List<BudgetResponse> budgets(UUID userId, int year, int month) {
    return budgetService.listForPeriod(userId, year, month);
  }

  public List<GoalResponse> goals(UUID userId) {
    return goalService.listForUser(userId);
  }

  public SettlementSummaryResponse settlementsSummary(UUID userId) {
    return settlementService.getSummary(userId);
  }
}
