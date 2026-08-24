# Fixed Assets

Implemented in **V2 Phase 9** (spec section 50; the master prompt's own
literal Phase 9 "Implement:" bullet list: asset register, depreciation,
disposal, journal generation), continuing from
[inventory-and-costing.md](inventory-and-costing.md)'s V2 Phase 8
foundation.

## Computed-never-stored, again

Accumulated depreciation is never a stored, manually mutable column —
the same discipline as every other derived balance in this codebase
(`inventory.InventoryValuationService`, every ledger balance in
`accounting`). Each posted period is an append-only
`AssetDepreciationEntry` row; accumulated depreciation is always
`SUM(amount)` over an asset's entries, and net book value is always
`cost - accumulated`.

## Data model

- **`FixedAsset`** — the asset register itself: name, category,
  acquisition date, cost, salvage value, useful life (months),
  depreciation method, and status (`ACTIVE`/`DISPOSED`). `cost`,
  `salvageValue`, `usefulLifeMonths`, `depreciationMethod`, and
  `acquisitionDate` become immutable once any depreciation has been
  posted against the asset — changing them retroactively would silently
  invalidate every period already depreciated, the same "don't switch
  valuation methods historically" discipline Phase 8 applies to
  Weighted Average Cost. `name`/`category` stay editable regardless.
- **`AssetDepreciationEntry`** — append-only, one row per period
  actually posted, `UNIQUE(asset_id, period)` so the same month can
  never be double-posted.

## Depreciation methods

Two literal, well-known formulas — never a fabricated or estimated
figure, the same "deterministic, explainable calculation" discipline
applied everywhere else a real number is at stake:

- **Straight-Line**: `(cost - salvageValue) / usefulLifeMonths` every
  period, flat.
- **Double Declining Balance**: `netBookValue * (2 / usefulLifeMonths)`
  every period — the standard "double" variant of the reducing-balance
  method, named exactly so the rate is never ambiguous (a generic
  unqualified "declining balance" could mean several different rates).

Both are floored so an asset is never depreciated below its salvage
value, regardless of rounding across periods — the last period's amount
is whatever remains, not the formula's raw output.

## Automatic posting

Three new `AutomaticPostingService` methods, the same best-effort
no-op-when-unmapped pattern every other automatic posting method uses:

- **`postAssetAcquired`** — debit Fixed Assets (already seeded in Phase
  6, code `1500`, unused until now), credit the paying business
  account's mapped ledger account, or Accounts Payable if bought on
  credit.
- **`postAssetDepreciation`** — debit Depreciation Expense (`6100`,
  new), credit Accumulated Depreciation (`1510`, new).
- **`postAssetDisposal`** — removes the asset from the books in one
  balanced entry: credit Fixed Assets for the original cost, debit
  Accumulated Depreciation to clear it, debit the receiving business
  account for any proceeds, and post the remaining gain or loss
  (`proceeds - netBookValue`) to Gain/Loss on Disposal of Assets
  (`4910`, new). Requires a business account whenever proceeds are
  non-zero — the journal's cash leg has to have a real destination, so
  this is validated (`400 PROCEEDS_ACCOUNT_REQUIRED`) rather than
  silently dropped.

Accumulated Depreciation and Gain/Loss on Disposal are both seeded as
plain `ASSET`/`REVENUE` account types respectively, not a new contra-
account type: `NormalBalance.signedAmount` already reports a credited
`ASSET` account as negative, which is exactly contra-asset behavior,
and a debited `REVENUE` account as negative, which is exactly how a
loss should read on the Income Statement — no new account-type concept
needed for either.

## Endpoints

`POST/GET /api/v1/spaces/{spaceId}/assets[/{id}]`, `PUT .../{id}`
(rejects financial-field changes once depreciated with `409
ASSET_FINANCIALS_LOCKED`), `POST .../{id}/dispose` (`409
ASSET_ALREADY_DISPOSED` if already disposed, `400
PROCEEDS_ACCOUNT_REQUIRED` as above); `POST
.../{id}/depreciation/run` (`409 PERIOD_ALREADY_DEPRECIATED`, `409
ASSET_FULLY_DEPRECIATED`, `409 ASSET_ALREADY_DISPOSED`), `GET
.../{id}/depreciation-entries`. All writes require `MANAGE_BOOKS` —
Fixed Assets sits inside the same Accounting domain as Chart of
Accounts and Journal Entries, so it reuses that permission rather than
adding a new one.

## Scheduler

`AssetDepreciationScheduler` runs monthly (`0 0 3 1 * *`), the same
thin `@Scheduled` wrapper around a plain, independently-callable method
shape as `bills.PersonalBillScheduler`: it posts the current month's
depreciation for every `ACTIVE` asset across every business space that
hasn't had that period posted yet, skipping any asset already fully
depreciated. The manual `POST .../depreciation/run` endpoint and the
scheduler both route through the identical `DepreciationService`
methods, so an accountant can always backfill or run ahead of the
schedule by hand.

## Chart of Accounts

Three new seeds this phase — Accumulated Depreciation (`1510`),
Depreciation Expense (`6100`), Gain/Loss on Disposal of Assets
(`4910`) — bringing the seeded Chart of Accounts from Phase 6's
original 24 accounts to 27. "Fixed Assets" (`1500`) was already seeded
in Phase 6, unused until this phase gave it a real purpose, the same
story as Phase 8's Inventory/COGS accounts.

## Tests

`FixedAssetFlowTests` (5 — acquisition posting to a mapped business
account, acquisition on credit crediting Accounts Payable, zero
accumulated depreciation before any is posted, the once-depreciated
financials lock while name/category stay editable, a real cross-role
403), `DepreciationFlowTests` (5 — Straight-Line's flat monthly amount
and journal, Double Declining Balance shrinking correctly across two
periods, a rejected double-post of the same period, a fully-depreciated
asset rejecting further runs, the scheduler's batch method posting for
every due asset and being a no-op on a second call), `AssetDisposalFlowTests`
(6 — a gain, a loss, a full write-off with zero proceeds, proceeds
without a business account rejected, disposing an already-disposed
asset rejected, depreciating a disposed asset rejected) — 16 new
integration tests, all pass; full backend regression suite (every
prior phase) reconfirmed clean alongside them, including the existing
Chart of Accounts seed-count test updated from 24 to 27.
