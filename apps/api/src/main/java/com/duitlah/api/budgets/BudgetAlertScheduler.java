package com.duitlah.api.budgets;

import java.time.LocalDate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/**
 * Same "thin {@code @Scheduled} wrapper around a plain, independently-callable/testable method"
 * shape as {@code recurring.RecurringTransactionScheduler}/{@code bills.PersonalBillScheduler}.
 */
@Component
public class BudgetAlertScheduler {

  private final BudgetService budgetService;

  public BudgetAlertScheduler(BudgetService budgetService) {
    this.budgetService = budgetService;
  }

  @Scheduled(cron = "0 20 0 * * *")
  public void checkBudgetAlerts() {
    budgetService.evaluateBudgetAlerts(LocalDate.now());
  }
}
