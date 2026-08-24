/**
 * V2 Phase 9 — Fixed Assets (spec section 50; the master prompt's own literal Phase 9 bullet list:
 * asset register, depreciation, disposal, journal generation).
 *
 * <p>Accumulated depreciation is never a stored, manually mutable column — the same
 * computed-never-stored discipline as {@code inventory.InventoryValuationService} and every ledger
 * balance in {@code accounting}. Each posted period is an append-only {@link
 * AssetDepreciationEntry} row; accumulated depreciation is always {@code SUM(amount)} over an
 * asset's entries, and net book value is always {@code cost - accumulated}.
 *
 * <p>Depends on {@code accounting} (three new {@code AutomaticPostingService} methods —
 * acquisition, depreciation, disposal — reusing Phase 6's already-seeded "Fixed Assets" account
 * plus two new seeds this phase adds, "Accumulated Depreciation" and "Depreciation Expense") and
 * {@code bizbanking} (the optional business account a purchase was paid from, or disposal proceeds
 * were received into). Nothing depends back on {@code assets} — unlike {@code inventory}, no other
 * module's write path (e.g. an invoice being issued) needs to know an asset exists.
 *
 * <p>Every posting method here is the same best-effort no-op-when-unmapped pattern {@code
 * AutomaticPostingService} uses everywhere else: a space that hasn't seeded a chart of accounts
 * keeps registering, depreciating, and disposing of assets exactly as before, just without the
 * automatic journal entries.
 */
package com.duitlah.api.assets;
