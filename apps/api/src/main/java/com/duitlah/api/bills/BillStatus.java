package com.duitlah.api.bills;

/** Exactly the 5 statuses the spec names (section 16). */
public enum BillStatus {
  UPCOMING,
  DUE,
  PAID,
  OVERDUE,
  SKIPPED
}
