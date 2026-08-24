/**
 * Personal Bills (V2 Phase 3, spec section 16) — utility/subscription bills with due dates,
 * distinct from {@code recurring.RecurringTransaction} (a schedule that materializes transactions
 * automatically) and from {@code bagilah.Bill} (Bagilah's split-receipt feature, an entirely
 * different domain that happens to share the English word "bill"). The table is named {@code
 * personal_bills} specifically to avoid colliding with the latter.
 *
 * <p>Each due occurrence is its own row rather than a rule-plus-materialized-occurrences split —
 * bills don't need {@code recurring}'s full calendar-materialization machinery; marking one paid
 * simply creates the next occurrence's row when the bill recurs. {@link
 * com.duitlah.api.bills.PersonalBillService#markPaid} calls {@code
 * transactions.TransactionService#create}, the same entry point every other transaction-creating
 * flow in this codebase uses, so a paid bill's linked transaction is an ordinary transaction from
 * that point on.
 */
package com.duitlah.api.bills;
