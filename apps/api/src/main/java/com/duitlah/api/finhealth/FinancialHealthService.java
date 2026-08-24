package com.duitlah.api.finhealth;

import com.duitlah.api.analytics.AnalyticsService;
import com.duitlah.api.analytics.MonthlyTrendResponse;
import com.duitlah.api.bills.BillStatus;
import com.duitlah.api.bills.PersonalBillRepository;
import com.duitlah.api.budgets.BudgetResponse;
import com.duitlah.api.budgets.BudgetService;
import com.duitlah.api.budgets.BudgetStatus;
import com.duitlah.api.finance.AccountResponse;
import com.duitlah.api.finance.AccountService;
import com.duitlah.api.finance.AccountType;
import com.duitlah.api.liabilities.CreditCardService;
import com.duitlah.api.networth.NetWorthResponse;
import com.duitlah.api.networth.NetWorthService;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;
import org.springframework.stereotype.Service;

@Service
public class FinancialHealthService {

  private static final BigDecimal HUNDRED = BigDecimal.valueOf(100);

  private final AccountService accountService;
  private final AnalyticsService analyticsService;
  private final NetWorthService netWorthService;
  private final CreditCardService creditCardService;
  private final PersonalBillRepository bills;
  private final BudgetService budgetService;

  public FinancialHealthService(
      AccountService accountService,
      AnalyticsService analyticsService,
      NetWorthService netWorthService,
      CreditCardService creditCardService,
      PersonalBillRepository bills,
      BudgetService budgetService) {
    this.accountService = accountService;
    this.analyticsService = analyticsService;
    this.netWorthService = netWorthService;
    this.creditCardService = creditCardService;
    this.bills = bills;
    this.budgetService = budgetService;
  }

  public FinancialHealthResponse compute(UUID userId) {
    List<MonthlyTrendResponse> trend6 = analyticsService.monthlyTrend(userId, 6);
    List<MonthlyTrendResponse> trend3 = trend6.subList(3, 6);

    List<HealthComponent> components = new ArrayList<>();
    components.add(savingsRate(trend3));
    components.add(emergencyFund(userId, trend3));
    components.add(debtToIncome(userId, trend3));
    creditUtilization(userId).ifPresent(components::add);
    billPaymentStatus(userId).ifPresent(components::add);
    budgetAdherence(userId).ifPresent(components::add);
    components.add(cashFlowStability(trend6));

    BigDecimal totalWeight =
        components.stream().map(HealthComponent::weight).reduce(BigDecimal.ZERO, BigDecimal::add);
    BigDecimal weightedSum =
        components.stream()
            .map(c -> c.score().multiply(c.weight()))
            .reduce(BigDecimal.ZERO, BigDecimal::add);
    BigDecimal score =
        totalWeight.signum() == 0
            ? BigDecimal.ZERO
            : weightedSum.divide(totalWeight, 2, RoundingMode.HALF_UP);

    return new FinancialHealthResponse(score, components, recommendationsFor(components));
  }

  private HealthComponent savingsRate(List<MonthlyTrendResponse> trend3) {
    BigDecimal income = sumIncome(trend3);
    BigDecimal savings = income.subtract(sumExpense(trend3));
    BigDecimal rate =
        income.signum() == 0 ? BigDecimal.ZERO : savings.divide(income, 4, RoundingMode.HALF_UP);
    BigDecimal score = clamp(rate.multiply(BigDecimal.valueOf(200)));
    return new HealthComponent(
        "SAVINGS_RATE",
        "Savings rate",
        score,
        BigDecimal.valueOf(20),
        "Saved " + percent(rate) + "% of income over the last 3 months.");
  }

  private HealthComponent emergencyFund(UUID userId, List<MonthlyTrendResponse> trend3) {
    BigDecimal liquidAssets =
        accountService.listForUser(userId).stream()
            .filter(a -> !a.archived() && LIQUID_TYPES.contains(a.type()))
            .map(AccountResponse::balance)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
    BigDecimal avgMonthlyExpense =
        sumExpense(trend3).divide(BigDecimal.valueOf(trend3.size()), 2, RoundingMode.HALF_UP);
    BigDecimal monthsCovered =
        avgMonthlyExpense.signum() == 0
            ? BigDecimal.valueOf(6)
            : liquidAssets.divide(avgMonthlyExpense, 2, RoundingMode.HALF_UP);
    BigDecimal score =
        clamp(
            monthsCovered.divide(BigDecimal.valueOf(6), 4, RoundingMode.HALF_UP).multiply(HUNDRED));
    return new HealthComponent(
        "EMERGENCY_FUND",
        "Emergency fund",
        score,
        BigDecimal.valueOf(20),
        "Liquid savings cover about "
            + monthsCovered
            + " month(s) of average expenses (target: 6).");
  }

  private HealthComponent debtToIncome(UUID userId, List<MonthlyTrendResponse> trend3) {
    NetWorthResponse netWorth = netWorthService.compute(userId);
    BigDecimal annualIncome =
        sumIncome(trend3)
            .divide(BigDecimal.valueOf(trend3.size()), 2, RoundingMode.HALF_UP)
            .multiply(BigDecimal.valueOf(12));
    BigDecimal ratio =
        annualIncome.signum() == 0
            ? BigDecimal.ONE
            : netWorth.totalLiabilities().divide(annualIncome, 4, RoundingMode.HALF_UP);
    BigDecimal score = clamp(HUNDRED.subtract(ratio.multiply(HUNDRED)));
    return new HealthComponent(
        "DEBT_TO_INCOME",
        "Debt-to-income",
        score,
        BigDecimal.valueOf(15),
        "Total debt is about " + percent(ratio) + "% of estimated annual income.");
  }

  private Optional<HealthComponent> creditUtilization(UUID userId) {
    List<com.duitlah.api.finance.Account> cards =
        accountService.listCreditCardAccountEntities(userId);
    return creditCardService
        .averageUtilizationForUser(cards)
        .map(
            utilization -> {
              BigDecimal excess = utilization.subtract(new BigDecimal("0.30")).max(BigDecimal.ZERO);
              BigDecimal score =
                  clamp(
                      HUNDRED.subtract(
                          excess
                              .divide(new BigDecimal("0.70"), 4, RoundingMode.HALF_UP)
                              .multiply(HUNDRED)));
              return new HealthComponent(
                  "CREDIT_UTILIZATION",
                  "Credit utilization",
                  score,
                  BigDecimal.valueOf(15),
                  "Using " + percent(utilization) + "% of available credit (under 30% is ideal).");
            });
  }

  private Optional<HealthComponent> billPaymentStatus(UUID userId) {
    long total = bills.findByUserIdOrderByDueDateAsc(userId).size();
    if (total == 0) {
      return Optional.empty();
    }
    long overdue = bills.findByUserIdAndStatusOrderByDueDateAsc(userId, BillStatus.OVERDUE).size();
    BigDecimal score =
        clamp(
            HUNDRED
                .multiply(BigDecimal.valueOf(total - overdue))
                .divide(BigDecimal.valueOf(total), 4, RoundingMode.HALF_UP));
    return Optional.of(
        new HealthComponent(
            "BILL_PAYMENT_STATUS",
            "Bill payment status",
            score,
            BigDecimal.valueOf(15),
            overdue + " of " + total + " tracked bill(s) are currently overdue."));
  }

  private Optional<HealthComponent> budgetAdherence(UUID userId) {
    LocalDate now = LocalDate.now();
    List<BudgetResponse> budgets =
        budgetService.listForPeriod(userId, now.getYear(), now.getMonthValue());
    if (budgets.isEmpty()) {
      return Optional.empty();
    }
    long onTrack = budgets.stream().filter(b -> b.status() != BudgetStatus.EXCEEDED).count();
    BigDecimal score =
        clamp(
            HUNDRED
                .multiply(BigDecimal.valueOf(onTrack))
                .divide(BigDecimal.valueOf(budgets.size()), 4, RoundingMode.HALF_UP));
    return Optional.of(
        new HealthComponent(
            "BUDGET_ADHERENCE",
            "Budget adherence",
            score,
            BigDecimal.valueOf(10),
            onTrack + " of " + budgets.size() + " budget(s) this month are within limit."));
  }

  private HealthComponent cashFlowStability(List<MonthlyTrendResponse> trend6) {
    List<BigDecimal> nets = trend6.stream().map(MonthlyTrendResponse::savings).toList();
    BigDecimal mean =
        nets.stream()
            .reduce(BigDecimal.ZERO, BigDecimal::add)
            .divide(BigDecimal.valueOf(nets.size()), 4, RoundingMode.HALF_UP);
    BigDecimal variance =
        nets.stream()
            .map(n -> n.subtract(mean).pow(2))
            .reduce(BigDecimal.ZERO, BigDecimal::add)
            .divide(BigDecimal.valueOf(nets.size()), 4, RoundingMode.HALF_UP);
    BigDecimal stdDev = BigDecimal.valueOf(Math.sqrt(variance.doubleValue()));
    BigDecimal avgExpense =
        trend6.stream()
            .map(MonthlyTrendResponse::expense)
            .reduce(BigDecimal.ZERO, BigDecimal::add)
            .divide(BigDecimal.valueOf(trend6.size()), 2, RoundingMode.HALF_UP);
    BigDecimal volatility =
        avgExpense.signum() == 0
            ? BigDecimal.ZERO
            : stdDev.divide(avgExpense, 4, RoundingMode.HALF_UP);
    BigDecimal score = clamp(HUNDRED.subtract(volatility.multiply(HUNDRED)));
    return new HealthComponent(
        "CASH_FLOW_STABILITY",
        "Cash-flow stability",
        score,
        BigDecimal.valueOf(5),
        "Month-to-month net cash flow has varied by about "
            + percent(volatility)
            + "% of average spending over 6 months.");
  }

  private static List<String> recommendationsFor(List<HealthComponent> components) {
    return components.stream()
        .filter(c -> c.score().compareTo(BigDecimal.valueOf(60)) < 0)
        .sorted((a, b) -> a.score().compareTo(b.score()))
        .map(FinancialHealthService::recommendationFor)
        .toList();
  }

  private static String recommendationFor(HealthComponent component) {
    return switch (component.key()) {
      case "SAVINGS_RATE" -> "Try to save a larger share of your income each month.";
      case "EMERGENCY_FUND" -> "Build up liquid savings toward 6 months of expenses.";
      case "DEBT_TO_INCOME" -> "Focus on paying down existing debt before taking on more.";
      case "CREDIT_UTILIZATION" -> "Pay down credit card balances to bring utilization under 30%.";
      case "BILL_PAYMENT_STATUS" -> "Catch up on overdue bills to avoid late fees and interest.";
      case "BUDGET_ADHERENCE" -> "Review categories that went over budget this month.";
      case "CASH_FLOW_STABILITY" -> "Look for ways to smooth out large swings in monthly spending.";
      default -> "Review this area of your finances.";
    };
  }

  private static BigDecimal sumIncome(List<MonthlyTrendResponse> trend) {
    return trend.stream()
        .map(MonthlyTrendResponse::income)
        .reduce(BigDecimal.ZERO, BigDecimal::add);
  }

  private static BigDecimal sumExpense(List<MonthlyTrendResponse> trend) {
    return trend.stream()
        .map(MonthlyTrendResponse::expense)
        .reduce(BigDecimal.ZERO, BigDecimal::add);
  }

  private static BigDecimal clamp(BigDecimal value) {
    return value.max(BigDecimal.ZERO).min(HUNDRED).setScale(2, RoundingMode.HALF_UP);
  }

  private static BigDecimal percent(BigDecimal ratio) {
    return ratio.multiply(HUNDRED).setScale(1, RoundingMode.HALF_UP);
  }

  private static final Set<AccountType> LIQUID_TYPES =
      Set.of(AccountType.CASH, AccountType.BANK, AccountType.E_WALLET);
}
