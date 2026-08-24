package com.duitlah.api.transactions;

/**
 * Only the types a user can actually create through the API today. Refund/Settlement/Adjustment
 * (mentioned in the wider product spec) are added when the phases that produce them — settlements,
 * Bagilah — exist; an enum value nothing can create yet is dead code, not preparation.
 */
public enum TransactionType {
  INCOME,
  EXPENSE,
  TRANSFER
}
