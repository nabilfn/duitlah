package com.duitlah.api.accounting;

/**
 * What business action produced a {@link JournalEntry} — purely informational (see {@code
 * journal_entries.source_id}'s own comment for why there's no FK).
 */
public enum JournalSourceType {
  MANUAL,
  INVOICE_ISSUED,
  INVOICE_PAYMENT,
  EXPENSE_PAYMENT,
  CREDIT_NOTE,
  INVENTORY_PURCHASE,
  INVENTORY_COGS,
  ASSET_ACQUIRED,
  ASSET_DEPRECIATION,
  ASSET_DISPOSAL,
  BUSINESS_ADVANCE,
  REIMBURSEMENT,
  OWNER_CONTRIBUTION,
  OWNER_DRAWING
}
