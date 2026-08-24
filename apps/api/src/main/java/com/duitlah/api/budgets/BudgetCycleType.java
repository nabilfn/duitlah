package com.duitlah.api.budgets;

/**
 * V2 Phase 3 (spec section 21). {@code CALENDAR_MONTH} is the default and the only value every
 * budget created before this phase has — for those, {@code periodYear}/{@code periodMonth} remain
 * fully authoritative and {@code periodStartDate}/{@code periodEndDate} stay null. {@code PAYDAY}
 * and {@code CUSTOM} require an explicit {@code periodStartDate}/{@code periodEndDate} instead (a
 * payday cycle is just a custom range that happens to repeat monthly on a non-1st day — this app
 * doesn't need a separate mechanism for it).
 */
public enum BudgetCycleType {
  CALENDAR_MONTH,
  PAYDAY,
  CUSTOM
}
