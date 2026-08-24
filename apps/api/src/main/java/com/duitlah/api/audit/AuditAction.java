package com.duitlah.api.audit;

/**
 * Exactly the action list the product spec calls out (section 50) -- not an exhaustive taxonomy.
 * The five RECONCILIATION_* values are V2 Phase 7's own addition, satisfying that phase's explicit
 * "persist reconciliation history" requirement by extending this existing audit trail rather than
 * building a second, reconciliation-specific one. The five EINVOICE_* values are V2 Phase 10's own
 * addition, satisfying spec section 56's "all provider interactions must be auditable" the same
 * way.
 */
public enum AuditAction {
  BILL_FINALIZED,
  TRANSACTION_CREATED,
  TRANSACTION_MODIFIED,
  PAYMENT_MARKED,
  PARTICIPANT_REMOVED,
  RECEIPT_EDITED,
  ACCOUNT_INFO_CHANGED,
  SECURITY_SETTINGS_CHANGED,
  RECONCILIATION_LINE_MATCHED,
  RECONCILIATION_TRANSACTION_CREATED,
  RECONCILIATION_LINE_IGNORED,
  RECONCILIATION_LINE_SPLIT,
  RECONCILIATION_DIFFERENCE_RESOLVED,
  EINVOICE_SUBMITTED,
  EINVOICE_VALIDATED,
  EINVOICE_INVALID,
  EINVOICE_CANCELLED,
  EINVOICE_REJECTED
}
