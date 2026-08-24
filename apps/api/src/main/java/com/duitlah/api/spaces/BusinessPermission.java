package com.duitlah.api.spaces;

/**
 * Server-enforced Business RBAC (V2 spec section 33: "do not rely on hiding buttons for
 * authorization"). Every write endpoint across the Business Core modules (crm, catalog, bizbanking,
 * bizexpenses, sales, accounting) calls {@link SpaceService#requirePermission} with one of these
 * before touching data — never a client-side-only check.
 */
public enum BusinessPermission {
  /** Invite/remove members, change roles — OWNER only, deliberately not even ADMIN. */
  MANAGE_TEAM,
  MANAGE_CUSTOMERS,
  MANAGE_SUPPLIERS,
  MANAGE_PRODUCTS,
  RECORD_EXPENSES,
  MANAGE_SALES_DOCUMENTS,
  RECORD_PAYMENTS,
  MANAGE_BANKING,
  VIEW_REPORTS,
  /**
   * Chart of accounts, accounting periods, manual journal entries, ledger↔record mappings (V2 Phase
   * 6) — spec section 33's "Books" (ACCOUNTANT) / "accounting" (FINANCE).
   */
  MANAGE_BOOKS
}
