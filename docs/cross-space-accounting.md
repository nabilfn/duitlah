# Cross-Space Accounting

Implemented in **V2 Phase 11** (spec sections 58-61; the master
prompt's own literal Phase 11 "Implement:" bullet list: personal-paid
business expense, reimbursement, owner contribution, owner drawing,
due to/from owner, cross-space references, consolidated personal
reporting), continuing from
[business-tax-and-einvoice.md](business-tax-and-einvoice.md)'s V2
Phase 10 foundation.

## "Allow a transaction to be linked across spaces without merging
books" — taken literally

Section 58's own words are the whole design brief. `cross_space_links`
only ever records that an *already-existing* Personal `transactions`
row produced a real Business `journal_entries` row; neither ledger is
ever merged, duplicated, or mutated into the other's shape. A Personal
transaction must already exist — created the normal way, via AutoTrack,
manual entry, or import — before it can be linked; this module never
synthesizes a fake transaction on a user's behalf, the same "always
real, always user-recorded" discipline the `transactions` table has
everywhere else in this codebase.

## Privacy: a link always belongs to the acting user

Every one of the four actions below requires `personalTransactionId`
to resolve under the *caller's own* `userId` (`404
TRANSACTION_NOT_FOUND` otherwise). A business's staff or accountant can
request these actions on a business they have the right permission on,
but can never reference another person's private personal transaction
data by guessing or being given its id — there is no "act on someone
else's personal transaction" path anywhere in this module.

## The four linked actions

Each posts one balanced journal entry via new `AutomaticPostingService`
methods, reusing Phase 6's already-seeded but previously-unused
"Owner's Capital"/"Owner's Drawings" accounts plus one new seed this
phase adds, "Due to Owner":

- **Business advance** (`POST .../crossspace/business-advance`,
  requires `MANAGE_BOOKS`) — a personal-paid business expense (spec
  section 58's own example: "Software Expense RM1,299 / Due to Owner
  RM1,299"). Debits the chosen expense account, credits Due to Owner.
  No business cash actually moves (the owner paid personally), so
  unlike the other three actions this posting is **not** best-effort —
  the Chart of Accounts must genuinely have a Due to Owner account, or
  `409 DUE_TO_OWNER_ACCOUNT_MISSING` is returned; a silent skip would
  leave nothing behind at all.
- **Reimbursement** (`POST .../crossspace/reimbursement`, requires
  `MANAGE_BANKING`) — debits Due to Owner (clearing the liability),
  credits the paying business account. Real cash leaves the business
  account (a `business_account_entries` row is posted, same as every
  other cash-moving action in this codebase), and the Personal side's
  "+amount" inflow is never classified as income. `relatedLinkId`
  optionally points back at the original business-advance link it
  settles, and is validated to actually be one (`409
  CROSS_SPACE_LINK_TYPE_MISMATCH` otherwise).
- **Owner contribution** (`POST .../crossspace/owner-contribution`,
  requires `MANAGE_BANKING`) — debits the receiving business account,
  credits Owner's Capital. Never Business Revenue (spec section 59).
- **Owner drawing** (`POST .../crossspace/owner-drawing`, requires
  `MANAGE_BANKING`) — debits Owner's Drawings, credits the paying
  business account. Never a normal business expense (spec section 60).

For reimbursement/contribution/drawing, the journal posting is the
same best-effort no-op-when-unmapped pattern every other automatic
posting method uses (matching precedent, since the cash-ledger
movement already happened and is the "real" primary effect regardless
of bookkeeping setup) — only business-advance, which has no cash-ledger
fallback, requires the account to genuinely exist.

## Due to/from owner, in one account

"Due to Owner" is a single `LIABILITY` account that covers both
directions via its own signed balance — the same trick `accounting`'s
contra-asset and loss accounts already use (Accumulated Depreciation,
Gain/Loss on Disposal from Phase 9). No separate asset-side "Due from
Owner" account was needed.

## Combined Personal View (spec section 61)

`GET /api/v1/crossspace/net-worth` — purely informational, composing
the existing `networth.NetWorthService` (Personal) with a business
space's own computed equity (Business Ownership Value) rather than a
new computation. A business space the caller lacks `VIEW_REPORTS` on
is silently excluded from the list rather than failing the whole view
for every other space. Never merges the underlying Personal/Business
bookkeeping — this is a read composition only.

**A real bug was caught here during live verification, not by the
automated tests written alongside the feature**: a business's
ownership value was computed as `BalanceSheetService.generate(...)
.totalEquity()` alone. Phase 6's own Balance Sheet reports current net
income as a separate `currentEarnings` field precisely because there
is no period-close step that rolls it into Retained Earnings —
`totalEquity` on its own excludes it. A live-verified business with
RM20,000 of capital and a real RM3,000 expense correctly showed
`totalEquity=20000, currentEarnings=-3000` on its own Balance Sheet,
but the combined net-worth view reported an ownership value of RM20,000
instead of the true RM17,000, silently overstating the business's real
worth by whatever its current-period profit or loss happened to be.
Fixed by summing `totalEquity + currentEarnings`; covered by a new
regression test asserting the combined figure against a scenario with
both a capital injection and a real expense, and re-verified live.

## Endpoints

`POST /api/v1/spaces/{spaceId}/crossspace/{business-advance,
reimbursement, owner-contribution, owner-drawing}`; `GET
.../crossspace/links` (business-scoped) and `GET /api/v1/crossspace/links`
(every link the caller has personally created, across all their
businesses); `GET /api/v1/crossspace/net-worth`.

## Tests

`CrossSpaceFlowTests` (8 — a business advance posting the exact
debit/credit and generating a real journal entry, a genuinely-missing
Due to Owner account rejected with a clear error, a reimbursement
clearing the liability and reducing the business account's real
balance, a reimbursement with a wrongly-typed related link rejected, an
owner contribution crediting Capital and never Revenue while increasing
the balance, an owner drawing debiting Drawings and never an expense
while decreasing the balance, a real cross-user privacy guard, and both
list endpoints), `CrossSpaceReportFlowTests` (2 — a solo user with no
business spaces sees only their personal net worth, and personal net
worth correctly combines with a real business's computed equity) — 10
new integration tests, all pass; full backend regression suite (every
prior phase) reconfirmed clean alongside them.
