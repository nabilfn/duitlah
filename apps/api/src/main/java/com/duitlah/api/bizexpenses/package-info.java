/**
 * Business expenses and their payments (V2 Phase 5, spec section 31). This is also Phase 5's
 * payables mechanism — there is no separate Purchases/supplier-bill module in this phase; a {@link
 * com.duitlah.api.bizexpenses.BusinessExpense} with a {@code supplierId} set IS the bill, and its
 * append-only {@link com.duitlah.api.bizexpenses.ExpensePayment} ledger tracks what's been settled.
 * Unlike account/goal balances elsewhere in this codebase, the expense's {@code status} column is
 * deliberately stored (not computed on read) — it only ever transitions on an explicit payment
 * write, and the migration's own CHECK constraint enumerates the exact three states.
 */
package com.duitlah.api.bizexpenses;
