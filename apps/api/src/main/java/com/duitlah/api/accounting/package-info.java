/**
 * The double-entry accounting engine (V2 Phase 6, spec sections 34-36; the master prompt's own
 * literal "Chart of Accounts, journals, journal lines, posting rules, accounting periods, General
 * Ledger, Trial Balance, P&amp;L, Balance Sheet, Cash Flow, accounting exports" bullet list).
 *
 * <p>This module has exactly one dependency direction: it reads/writes only its own tables plus
 * {@code spaces} (membership/permission checks) — nothing here depends on {@code crm}, {@code
 * catalog}, {@code bizbanking}, {@code bizexpenses}, or {@code sales}. Those modules instead depend
 * on this one ({@code AutomaticPostingService}) to turn "record an expense payment" / "issue an
 * invoice" / "receive a payment" into a real journal entry underneath, matching section 36's
 * explicit instruction: an ordinary user never sees "debit"/"credit" for everyday workflows, the
 * engine posts on their behalf.
 *
 * <p><b>Automatic posting is a best-effort enhancement, never a hard requirement.</b> A business
 * space that hasn't set up its Chart of Accounts yet (or hasn't mapped a specific bank account or
 * expense to a ledger account) keeps working exactly as Phase 5 shipped it — {@link
 * com.duitlah.api.accounting.AutomaticPostingService} silently skips posting wherever a required
 * mapping is missing, rather than blocking or erroring the underlying business action. Books are
 * opt-in, not a gate in front of features that already worked without them.
 *
 * <p>The double-entry invariant (every entry's debits equal its credits) is enforced twice by
 * design: once in the database (a deferred constraint trigger on {@code journal_lines}, see {@code
 * V22__accounting_engine.sql}) and once in {@link com.duitlah.api.accounting.JournalEntryService}
 * before an insert is even attempted, so a bad manual entry fails with a clean validation error
 * rather than a raw SQL exception.
 */
package com.duitlah.api.accounting;
