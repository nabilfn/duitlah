package com.duitlah.api.transactions;

/**
 * Every row's effect on its own account's balance. INCOME is always IN, EXPENSE always OUT; a
 * TRANSFER's two rows are one of each.
 */
public enum TransactionDirection {
  IN,
  OUT
}
