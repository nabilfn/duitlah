package com.duitlah.api.bills;

/** How a bill's next occurrence is generated once the current one is marked paid. */
public enum BillRecurrence {
  NONE,
  WEEKLY,
  MONTHLY,
  YEARLY
}
