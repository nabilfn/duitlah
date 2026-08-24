# Business Accounting Engine

Implemented in **V2 Phase 6** (spec sections 34-36, plus the master prompt's
own literal Phase 6 "Implement:" bullet list: Chart of Accounts, journals,
journal lines, posting rules, accounting periods, General Ledger, Trial
Balance, P&L, Balance Sheet, Cash Flow, accounting exports), continuing
from [business-core.md](business-core.md)'s V2 Phase 5 foundation.

## Scope boundary (confirmed by re-reading the spec, not assumed)

Sections 34-36 appear in the spec document *before* section 39
(Customers) — numerically ahead of Phase 5's own module list — but
Phase 5's literal bullet list has no Chart-of-Accounts/journal item, and
Phase 6's own bullet list is exactly this accounting material. This
module is therefore built on top of an already-complete, already-tested
Phase 5, not interleaved with it.

## Double-entry is non-negotiable (section 34)

Every posted `journal_entries` row must have `journal_lines` whose
DEBITs sum to its CREDITs. This is enforced **twice**, deliberately:

1. **Database level** — a deferred `CONSTRAINT TRIGGER` on
   `journal_lines` (`V22__accounting_engine.sql`). It's deferred so it
   only checks at COMMIT, after every line of a multi-line entry has
   been inserted (Hibernate issues one `INSERT` per row, not a single
   multi-row statement) — an immediate trigger would reject the first
   line of any entry before its balancing line ever arrives.
2. **Service level** — `JournalEntryService.post` sums debits/credits in
   Java and throws a clean `409 JOURNAL_ENTRY_NOT_BALANCED` before ever
   attempting an insert, so the common case never even reaches the raw
   SQL exception the trigger would otherwise produce.

`JournalEntryFlowTests` proves both independently — one test drives the
real HTTP endpoint with mismatched debit/credit lines (service-level
409), and a separate test bypasses the service entirely via raw JDBC to
prove the trigger itself rejects an unbalanced insert at commit.

`journal_entries`/`journal_lines` are append-only, the same discipline
as every other ledger table in this codebase (`goal_contributions`,
`business_account_entries`, `expense_payments`, `invoice_payments`) —
there is no update/delete path for a posted line.

## Chart of Accounts (section 35)

`LedgerAccount` (table `chart_of_accounts`, one per business space) has
a `code`, `name`, `type` (ASSET/LIABILITY/EQUITY/REVENUE/EXPENSE), a
`systemDefault` flag, and a `cashEquivalent` flag (see Cash Flow below).
Named `LedgerAccount`, not `Account`, to avoid colliding with
`finance.Account` and `bizbanking.BusinessAccount` — neither of which
this is.

`DefaultChartOfAccounts` seeds a 24-account Malaysian SME-friendly
starting chart (Cash/Bank/Receivable/Inventory/Fixed Assets;
Payable/Accrued/SST-GST Payable/Loans; Owner's Capital/Retained
Earnings/Drawings; Sales/Service/Other Revenue; COGS and seven expense
categories) via `POST .../accounting/chart-of-accounts/seed-defaults` —
**deliberately not seeded automatically at business-space creation**,
since that would silently write books data a user never asked for;
seeding is an explicit, once-only action (`409
CHART_OF_ACCOUNTS_ALREADY_SEEDED` on a second attempt). These codes/
names are a reasonable general-purpose default, not a statutory or
LHDN-mandated numbering — unlike the Personal Tax Centre's tax
brackets, a chart of accounts is a business convention, freely
renameable/extensible after seeding ("allow controlled customization").

"Prevent deletion of accounts already used in posted journals" is
satisfied by this codebase's existing discipline of never hard-deleting
anything — `archive` is always soft and reversible-in-spirit, and an
archived account's historical `journal_lines` rows are completely
unaffected (no FK cascade); only the picker for *new* postings excludes
archived accounts.

## Automatic posting (section 36)

An ordinary user never sees "debit"/"credit" for everyday workflows —
`AutomaticPostingService` turns an already-existing Phase 5 business
action into a real journal entry underneath:

| Business action | Debit | Credit |
|---|---|---|
| Expense payment recorded | the expense's mapped account (or system "Other Operating Expenses") | the paying business account's mapped account |
| Invoice marked SENT (once) | system Accounts Receivable | system Sales Revenue (+ SST/GST Payable for any tax) |
| Invoice payment recorded | the receiving business account's mapped account | system Accounts Receivable |
| Credit note issued against an invoice | system Sales Revenue | system Accounts Receivable |

**This is a best-effort enhancement, never a hard requirement** — a
space that hasn't seeded its Chart of Accounts, or hasn't mapped a
specific `business_accounts`/`business_expenses` row to a ledger
account, keeps using every Phase 5 feature exactly as it worked before
this phase existed; `AutomaticPostingService` silently skips posting
wherever a required mapping is missing rather than blocking or erroring
the underlying action. Books are opt-in, not a gate in front of
features that already worked without them. Each posting method is also
idempotent (`JournalEntryRepository.existsBySpaceIdAndSourceTypeAndSourceId`)
so re-triggering the same business event (e.g. re-saving an
already-SENT invoice) never double-posts.

`business_accounts.chart_of_accounts_id` and
`business_expenses.chart_of_accounts_id` (both nullable, added by this
phase's migration) are the two mapping points; a standalone credit note
(no `invoiceId`) posts nothing, since there's no prior recognized
revenue for it to reverse against.

**Dependency shape**: `accounting` depends only on `spaces`
(permissions). `bizbanking`, `bizexpenses`, and `sales` each gained a
new dependency *on* `accounting` (for mapping validation and posting)
— the same one-directional "producer depends on recorder" shape this
codebase has used since `receipts` → `personaltax` in Phase 4, applied
three times over. `accounting` itself has zero knowledge of any of
those three modules.

## Accounting periods

`AccountingPeriod` (OPEN/CLOSED) is a simple, explicit lock: closing a
period (`POST .../periods/{id}/close`) rejects any *new* journal entry
— manual or automatic — dated inside it (`409
ACCOUNTING_PERIOD_CLOSED`), enforced purely at the service level (no DB
trigger needed for this one; "closed" is a business rule, not a
cross-row data-integrity invariant like the debit=credit check). There
is no reopen endpoint by design.

## Reports

- **General Ledger** (`GeneralLedgerService`) — one account, a date
  range, opening balance, every line with a running balance, closing
  balance. Balances are shown relative to each account's own *normal*
  side (`NormalBalance.signedAmount`) — ASSET/EXPENSE increase on
  DEBIT, LIABILITY/EQUITY/REVENUE increase on CREDIT — so a healthy
  Sales Revenue account reads as a positive number even though every
  line touching it is a CREDIT.
- **Trial Balance** (`TrialBalanceService`) — the literal, un-normalized
  debit/credit convention: each account's raw debit-total-minus-
  credit-total nets into exactly one column, so the report's own
  bottom line (`totalDebit == totalCredit`) is a visible, self-checking
  demonstration of section 34's core invariant.
- **P&L / Income Statement** (`IncomeStatementService`) — Revenue minus
  Expense accounts over a period, normal-balance-signed so both totals
  read positive.
- **Balance Sheet** (`BalanceSheetService`) — Assets = Liabilities +
  Equity, as of a date. There's no formal period-close step this phase
  that rolls net income into Retained Earnings, so cumulative
  revenue-minus-expense since inception is shown as its own "Current
  Earnings" equity line — exactly what makes the sheet balance without
  a closing entry every reporting period. A documented simplification,
  not an oversight.
- **Cash Flow** (`CashFlowService`) — a direct-method summary (total in
  vs. total out) over accounts flagged `cashEquivalent`, deliberately
  not categorized into formal Operating/Investing/Financing sections.
  `cashEquivalent` is a flag on `LedgerAccount` itself (not a query
  against `bizbanking.business_accounts`), keeping `accounting`
  self-contained — `bizbanking` already depends on `accounting` for
  posting, so the reverse would cycle.
- **Exports** (`AccountingExportService`) — Trial Balance, P&L, and
  Balance Sheet as CSV/XLSX/PDF, reusing `exports.TabularData` and its
  three existing writers (Phase 3) rather than a second
  file-writing code path.

There's no JPA association between `JournalLine` and `JournalEntry`
(this codebase deliberately links tables by plain UUID fields, never
`@ManyToOne`) — every report goes through `LedgerQueryService`, which
fetches entries for a space/date-range first, then their lines, and
joins the two in Java rather than in a query.

## Endpoints

`POST .../accounting/chart-of-accounts/seed-defaults`; `POST/GET/PUT/
DELETE .../accounting/chart-of-accounts[/{id}]`; `POST/GET
.../accounting/periods`, `POST .../periods/{id}/close`; `POST/GET
.../accounting/journal-entries[/{id}]`; `GET
.../accounting/reports/{general-ledger,trial-balance,income-statement,
balance-sheet,cash-flow}`; `GET
.../accounting/exports/{trial-balance,income-statement,balance-sheet}`;
`PATCH .../business-accounts/{id}/chart-of-accounts-mapping` (owned by
`bizbanking`); `PATCH .../expenses/{id}/chart-of-accounts-mapping`
(owned by `bizexpenses`).

## Mobile

A new `accounting` feature module (Chart of Accounts, Accounting
Periods, Journal Entries with a live debit/credit-balance indicator on
the manual-entry form, and a Reports hub with five report screens plus
CSV/XLSX/PDF export/share), plus two small additions to Phase 5's
existing Business Account and Expense detail screens letting a user map
either to a ledger account. No client-side permission hiding — a 403
surfaces as a plain error message, per section 33.

## Tests

`ChartOfAccountsFlowTests` (5, including seed/re-seed/403/duplicate-code/
archive), `AccountingPeriodFlowTests` (3, including the closed-period
posting guard), `JournalEntryFlowTests` (3 — a balanced manual entry, a
service-level imbalance rejection, and a raw-JDBC test proving the
database trigger itself is real), `AutomaticPostingFlowTests` (3 —
unmapped-skip, a mapped expense payment, and a full issue→pay invoice
cycle whose trial balance nets to a hand-verified 1060/1060), `Accounting
ReportsFlowTests` (3 — balance sheet balances, cash flow reflects a
manual capital injection, a real CSV export downloads) — 17 new
integration tests, all pass; full backend regression suite (all prior
phases) reconfirmed clean alongside them. `flutter analyze` clean.
