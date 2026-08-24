package com.duitlah.api.receipts;

/**
 * Same two-tier deterministic shape as {@code reconciliation.MatchConfidence} — never fuzzy text
 * matching, just exact-vs-tolerance amount/date comparison (see {@link
 * ReceiptVaultService#suggestTransactionMatches}).
 */
public enum ReceiptMatchConfidence {
  EXACT,
  PROBABLE
}
