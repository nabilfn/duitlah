package com.duitlah.api.ai;

import com.duitlah.api.analytics.AnalyticsService;
import com.duitlah.api.analytics.ForecastResponse;
import com.duitlah.api.bills.BillStatus;
import com.duitlah.api.bills.PersonalBillService;
import com.duitlah.api.budgets.BudgetResponse;
import com.duitlah.api.budgets.BudgetService;
import com.duitlah.api.finance.Account;
import com.duitlah.api.finance.AccountService;
import com.duitlah.api.goals.GoalResponse;
import com.duitlah.api.goals.GoalService;
import com.duitlah.api.liabilities.CreditCardService;
import com.duitlah.api.liabilities.LiabilityResponse;
import com.duitlah.api.liabilities.LiabilityService;
import com.duitlah.api.liabilities.LiabilityStatus;
import com.duitlah.api.settlements.SettlementService;
import com.duitlah.api.settlements.SettlementSummaryResponse;
import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;

/**
 * "Can I afford this?" (product spec section 41) is real financial math, not an AI judgment call --
 * every number here is computed the same way the rest of the backend computes money, reusing the
 * same services the rest of the app already uses for these figures, never a new calculation
 * invented for this feature -- and {@code narrative} is a plain Java string template filled in with
 * those numbers. There is no LLM involvement anywhere in this class: even with no AI provider
 * configured at all, affordability checks keep working, and with one configured, {@link
 * AiChatService} may relay this same response through a model for phrasing but can never change the
 * numbers themselves. This split is the concrete enforcement of the product spec's "never let the
 * AI become the source of truth for financial calculations."
 *
 * <p>{@code canAfford} is a deliberately simple rule: the purchase doesn't push the projected
 * month-end balance below the sum of every real obligation due by then -- what's already owed to
 * others, upcoming bills, and debt repayments (spec section 68's widened input set). Credit
 * utilization, savings goals, and remaining budget are surfaced as informational context rather
 * than folded into that check -- see {@link AffordabilityResponse}'s class comment for why. It is
 * not a substitute for real financial advice -- see {@code disclaimer}.
 */
@Service
public class AffordabilityService {

  private final AnalyticsService analyticsService;
  private final SettlementService settlementService;
  private final PersonalBillService personalBillService;
  private final LiabilityService liabilityService;
  private final AccountService accountService;
  private final CreditCardService creditCardService;
  private final GoalService goalService;
  private final BudgetService budgetService;

  public AffordabilityService(
      AnalyticsService analyticsService,
      SettlementService settlementService,
      PersonalBillService personalBillService,
      LiabilityService liabilityService,
      AccountService accountService,
      CreditCardService creditCardService,
      GoalService goalService,
      BudgetService budgetService) {
    this.analyticsService = analyticsService;
    this.settlementService = settlementService;
    this.personalBillService = personalBillService;
    this.liabilityService = liabilityService;
    this.accountService = accountService;
    this.creditCardService = creditCardService;
    this.goalService = goalService;
    this.budgetService = budgetService;
  }

  public AffordabilityResponse check(UUID userId, AffordabilityRequest request) {
    ForecastResponse forecast = analyticsService.forecast(userId);
    SettlementSummaryResponse settlements = settlementService.getSummary(userId);

    BigDecimal amount = request.amount();
    BigDecimal projectedBalanceIfWaited = forecast.projectedBalance();
    BigDecimal projectedBalanceIfPurchased = projectedBalanceIfWaited.subtract(amount);
    BigDecimal totalOwedToOthers = settlements.totalIOwe();
    BigDecimal upcomingBillsTotal = upcomingBillsTotal(userId, forecast.targetDate());
    BigDecimal debtRepaymentsTotal = debtRepaymentsTotal(userId, forecast.targetDate());
    BigDecimal totalObligations =
        totalOwedToOthers.add(upcomingBillsTotal).add(debtRepaymentsTotal);
    boolean canAfford = projectedBalanceIfPurchased.subtract(totalObligations).signum() >= 0;

    BigDecimal averageCreditUtilization = averageCreditUtilization(userId);
    BigDecimal totalSavingsGoalsRemaining = totalSavingsGoalsRemaining(userId);
    BigDecimal budgetRemainingThisPeriod = budgetRemainingThisPeriod(userId, forecast.targetDate());

    String narrative =
        buildNarrative(request, forecast, projectedBalanceIfPurchased, totalObligations, canAfford);

    return new AffordabilityResponse(
        amount,
        forecast.currentBalance(),
        projectedBalanceIfWaited,
        projectedBalanceIfPurchased,
        totalOwedToOthers,
        upcomingBillsTotal,
        debtRepaymentsTotal,
        totalObligations,
        averageCreditUtilization,
        totalSavingsGoalsRemaining,
        budgetRemainingThisPeriod,
        canAfford,
        narrative,
        "This is an estimate based on your recurring transactions, forecasted spending, upcoming "
            + "bills, debt repayments, and existing debts -- not professional financial advice.");
  }

  private BigDecimal upcomingBillsTotal(UUID userId, java.time.LocalDate targetDate) {
    return personalBillService.list(userId, null).stream()
        .filter(
            bill ->
                bill.status() == BillStatus.UPCOMING
                    || bill.status() == BillStatus.DUE
                    || bill.status() == BillStatus.OVERDUE)
        .filter(bill -> !bill.dueDate().isAfter(targetDate))
        .map(bill -> bill.expectedAmount())
        .reduce(BigDecimal.ZERO, BigDecimal::add);
  }

  private BigDecimal debtRepaymentsTotal(UUID userId, java.time.LocalDate targetDate) {
    List<LiabilityResponse> liabilities = liabilityService.list(userId);
    return liabilities.stream()
        .filter(liability -> liability.status() == LiabilityStatus.ACTIVE)
        .filter(
            liability ->
                liability.nextDueDate() != null && !liability.nextDueDate().isAfter(targetDate))
        .map(LiabilityResponse::instalmentAmount)
        .reduce(BigDecimal.ZERO, BigDecimal::add);
  }

  private BigDecimal averageCreditUtilization(UUID userId) {
    List<Account> creditCardAccounts = accountService.listCreditCardAccountEntities(userId);
    return creditCardService.averageUtilizationForUser(creditCardAccounts).orElse(null);
  }

  private BigDecimal totalSavingsGoalsRemaining(UUID userId) {
    return goalService.listForUser(userId).stream()
        .filter(goal -> !goal.archived())
        .map(GoalResponse::remaining)
        .reduce(BigDecimal.ZERO, BigDecimal::add);
  }

  private BigDecimal budgetRemainingThisPeriod(UUID userId, java.time.LocalDate targetDate) {
    List<BudgetResponse> budgets =
        budgetService.listForPeriod(userId, targetDate.getYear(), targetDate.getMonthValue());
    return budgets.stream().map(BudgetResponse::remaining).reduce(BigDecimal.ZERO, BigDecimal::add);
  }

  private String buildNarrative(
      AffordabilityRequest request,
      ForecastResponse forecast,
      BigDecimal projectedBalanceIfPurchased,
      BigDecimal totalObligations,
      boolean canAfford) {
    String subject =
        request.description() == null || request.description().isBlank()
            ? "this RM" + request.amount() + " purchase"
            : "the RM" + request.amount() + " purchase (" + request.description() + ")";

    StringBuilder sb = new StringBuilder();
    if (canAfford) {
      sb.append("You can afford ").append(subject).append(", but it would reduce your ");
    } else {
      sb.append("You probably can't afford ")
          .append(subject)
          .append(" right now -- it would take your ");
    }
    sb.append("projected balance on ")
        .append(forecast.targetDate())
        .append(" from RM")
        .append(forecast.projectedBalance())
        .append(" to RM")
        .append(projectedBalanceIfPurchased)
        .append(".");

    if (totalObligations.signum() > 0) {
      sb.append(" You also currently have RM")
          .append(totalObligations)
          .append(" in obligations due by then (money owed to others, upcoming bills, and debt")
          .append(" repayments), which isn't reflected in that projection unless it's already")
          .append(" scheduled.");
    }
    if (!canAfford) {
      sb.append(" Waiting until you have a larger buffer would be safer.");
    }
    return sb.toString();
  }
}
