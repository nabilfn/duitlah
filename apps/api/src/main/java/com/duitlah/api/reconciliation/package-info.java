/**
 * Bank reconciliation for business accounts (V2 Phase 7, spec section 38; the master prompt's own
 * literal "business statement import, matching engine, reconciliation sessions, match/create/
 * ignore/split, audit trail" bullet list).
 *
 * <p>Reuses {@code statements.StatementParser}/{@code ParsedStatementRow}/{@code StatementProvider}
 * (Phase 2) directly for the actual CSV/XLSX/PDF parsing — this module adds no second parsing code
 * path, only the business-scoped import/session/line/allocation tables that track reconciliation
 * *state* across the life of a session, which {@code autotrack}'s one-shot "become a transaction
 * candidate" flow has no equivalent of.
 *
 * <p>Dependency shape: this module depends on {@code statements} (parsing), {@code bizbanking}
 * (validating/creating {@code business_account_entries}), and {@code audit} (recording each of the
 * five user actions against the existing generic audit trail — no separate reconciliation-specific
 * audit table). Nothing depends back on this module.
 *
 * <p>The matching engine ({@link com.duitlah.api.reconciliation.MatchingService}) is deliberately
 * simple and deterministic — an EXACT match (same date, same amount) or a PROBABLE match (same
 * amount within a date window, or same date within a small amount tolerance) against not-yet-
 * allocated {@code business_account_entries} rows for the same account. No fuzzy description
 * matching, no machine-learning "smart" scoring — matching this codebase's established posture of
 * deterministic, explainable calculations wherever a real number is at stake (see {@code
 * finhealth.FinancialHealthService}, {@code accounting.JournalEntryService}).
 */
package com.duitlah.api.reconciliation;
