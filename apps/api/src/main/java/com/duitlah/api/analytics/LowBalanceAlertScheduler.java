package com.duitlah.api.analytics;

import com.duitlah.api.notifications.NotificationRule;
import com.duitlah.api.notifications.NotificationRuleService;
import com.duitlah.api.notifications.NotificationRuleType;
import com.duitlah.api.notifications.NotificationService;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/**
 * "Notification rules" (V2 Phase 13) — the new {@code LOW_BALANCE} trigger. Unlike {@code
 * BILL_DUE_SOON}/{@code BILL_OVERDUE}/{@code LOW_STOCK_ALERT}/{@code BUDGET_EXCEEDED}, this is
 * opt-in (see {@code NotificationRuleService#defaultEnabled}): only users who've explicitly set a
 * threshold are ever scanned, via {@link NotificationRuleService#findEnabledWithThreshold}, rather
 * than checking every user's balance daily. Dedup lives on the rule row itself ({@code
 * NotificationRule#lastTriggeredAt}) since — unlike a low-stock product or an exceeded budget —
 * there's no other per-entity row a "currently below threshold" flag could hang on.
 */
@Component
public class LowBalanceAlertScheduler {

  private final NotificationRuleService notificationRuleService;
  private final NotificationService notificationService;
  private final DashboardService dashboardService;

  public LowBalanceAlertScheduler(
      NotificationRuleService notificationRuleService,
      NotificationService notificationService,
      DashboardService dashboardService) {
    this.notificationRuleService = notificationRuleService;
    this.notificationService = notificationService;
    this.dashboardService = dashboardService;
  }

  @Scheduled(cron = "0 25 0 * * *")
  public void checkLowBalances() {
    for (NotificationRule rule :
        notificationRuleService.findEnabledWithThreshold(NotificationRuleType.LOW_BALANCE)) {
      var balance = dashboardService.forUser(rule.getUserId()).availableBalance();
      boolean belowThreshold = balance.compareTo(rule.getThresholdAmount()) < 0;

      if (belowThreshold && rule.getLastTriggeredAt() == null) {
        notificationService.notify(
            rule.getUserId(),
            "LOW_BALANCE",
            "Your balance is running low",
            "Your available balance is RM"
                + balance
                + ", below your RM"
                + rule.getThresholdAmount()
                + " alert threshold.");
        notificationRuleService.markTriggered(rule);
      } else if (!belowThreshold && rule.getLastTriggeredAt() != null) {
        notificationRuleService.clearTriggered(rule);
      }
    }
  }
}
