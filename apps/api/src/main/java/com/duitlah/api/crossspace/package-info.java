/**
 * V2 Phase 11 — Cross-Space Accounting (spec sections 58-61; the master prompt's own literal Phase
 * 11 bullet list: personal-paid business expense, reimbursement, owner contribution, owner drawing,
 * due to/from owner, cross-space references, consolidated personal reporting).
 *
 * <p>Section 58, verbatim: "Allow a transaction to be linked across spaces without merging books."
 * That is taken literally — {@code cross_space_links} only ever records that an already-existing
 * Personal {@code transactions} row produced a real Business {@code journal_entries} row; neither
 * ledger is ever merged, duplicated, or mutated into the other's shape. A Personal transaction must
 * already exist (created the normal way, via AutoTrack/manual entry/import) before it can be linked
 * — this module never synthesizes a fake transaction on a user's behalf, the same "always real,
 * always user-recorded" discipline the {@code transactions} table has everywhere else.
 *
 * <p>Every linked Personal transaction must belong to the *acting* user — a business's staff or
 * accountant can request the four actions below on a business they have {@code MANAGE_BOOKS} on,
 * but can never reference another person's private personal transaction data; this is enforced by
 * requiring the personal transaction id to resolve under the caller's own {@code userId}.
 *
 * <p>Four linked actions, each producing one balanced journal entry via new {@code
 * AutomaticPostingService} methods (which reuse Phase 6's already-seeded but previously-unused
 * "Owner's Capital"/"Owner's Drawings" accounts, plus one new seed this phase adds, "Due to
 * Owner"): {@link CrossSpaceService#recordBusinessAdvance} (section 58), {@link
 * CrossSpaceService#recordReimbursement} (section 58 — "do not classify... as income or... as a new
 * business expense"), {@link CrossSpaceService#recordOwnerContribution} (section 59 — "not Business
 * Revenue"), {@link CrossSpaceService#recordOwnerDrawing} (section 60 — "not normal business
 * expenses"). "Due to Owner" is a single {@link com.duitlah.api.accounting.AccountType#LIABILITY}
 * account that covers both directions via its own signed balance (spec's "due to/from owner"), the
 * same trick {@code accounting}'s contra-asset/loss accounts already use — no separate asset-side
 * account needed.
 *
 * <p>{@link CrossSpaceReportService#combinedNetWorth} is section 61's "Combined Personal View" —
 * purely informational, composing the existing {@code networth.NetWorthService} (Personal) with
 * {@code accounting.BalanceSheetService}'s own {@code totalEquity} (Business Ownership Value, per
 * space) rather than a new computation; never merges the underlying bookkeeping.
 *
 * <p>Depends on {@code transactions} (the Personal side being linked), {@code accounting} (posting
 * and the Balance Sheet), {@code bizbanking} (the business account's own cash ledger —
 * reimbursement/ contribution/drawing all move real cash through a business account, exactly like
 * every other cash-moving action in this codebase gets both an informal ledger row and a formal
 * journal entry), {@code spaces}, and {@code networth}. Nothing depends back on {@code crossspace}.
 */
package com.duitlah.api.crossspace;
