package com.duitlah.api.notifications;

/**
 * The five notification triggers that exist in this codebase (V2 Phase 13). The first three ({@code
 * BILL_DUE_SOON}, {@code BILL_OVERDUE}, {@code LOW_STOCK_ALERT}) already fired unconditionally
 * before this phase — a missing {@link NotificationRule} row now defaults them to enabled, so
 * nothing regresses for an existing user. {@code BUDGET_EXCEEDED} and {@code LOW_BALANCE} are new
 * triggers this phase adds (see {@code budgets.BudgetAlertScheduler} and {@code
 * analytics.LowBalanceAlertScheduler}); {@code LOW_BALANCE} is opt-in by nature (see {@link
 * NotificationRuleService}), since it needs a user-supplied threshold to mean anything.
 */
public enum NotificationRuleType {
  BILL_DUE_SOON,
  BILL_OVERDUE,
  LOW_STOCK_ALERT,
  BUDGET_EXCEEDED,
  LOW_BALANCE
}
