/**
 * Quotations, invoices, payments and credit notes (V2 Phase 5, spec section 31). An invoice's own
 * {@code status} column is deliberately limited to DRAFT/SENT/VOID — the explicit actions a user
 * takes — mirroring {@code settlements.Settlement}: PAID/PARTIALLY_PAID/OVERDUE are never stored,
 * only ever computed on read from {@code total} vs. the append-only {@link
 * com.duitlah.api.sales.InvoicePayment} ledger (minus applied credit notes) vs. {@code dueDate}.
 * See {@link com.duitlah.api.sales.InvoiceService} for where that computation lives.
 *
 * <p>Double-entry bookkeeping (Chart of Accounts, journals, General Ledger, Trial Balance, P&amp;L,
 * Balance Sheet) is explicitly NOT part of this package — that's Phase 6's scope.
 */
package com.duitlah.api.sales;
