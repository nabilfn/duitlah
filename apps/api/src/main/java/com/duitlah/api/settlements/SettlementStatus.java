package com.duitlah.api.settlements;

/**
 * Never stored — always derived from {@code amount} vs. payment history, plus the two explicit
 * override timestamps. See {@code Settlement.effectiveStatus} and docs/database.md.
 */
public enum SettlementStatus {
  UNPAID,
  PARTIALLY_PAID,
  PAID,
  CANCELLED,
  DISPUTED
}
