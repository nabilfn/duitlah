package com.duitlah.api.receipts;

/**
 * What a vault receipt is evidence for (spec section 15). {@code BAGILAH} here is tagging only — it
 * does not create a Bagilah bill; that flow stays exclusively {@link ReceiptScanService}'s, via
 * {@code POST /api/v1/receipts/scans}, unchanged by this phase.
 */
public enum ReceiptPurpose {
  PERSONAL_EXPENSE,
  BUSINESS_EXPENSE,
  TAX_EVIDENCE,
  BAGILAH,
  UNSPECIFIED
}
