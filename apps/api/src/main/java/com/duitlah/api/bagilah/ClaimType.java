package com.duitlah.api.bagilah;

/**
 * How a claim's {@code value} should be read: a slice of the item's quantity, a percentage of its
 * total, or a direct RM amount. All claims on the same receipt item must share one type — mixing
 * them (e.g. one participant by quantity, another by percentage) has no unambiguous reconciliation
 * and is rejected rather than guessed at.
 */
public enum ClaimType {
  QUANTITY,
  PERCENTAGE,
  AMOUNT
}
