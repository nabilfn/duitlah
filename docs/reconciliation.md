# Bank Reconciliation

Implemented in **V2 Phase 7** (spec section 38; the master prompt's own
literal Phase 7 "Implement:" bullet list: business statement import,
matching engine, reconciliation sessions, match/create/ignore/split,
audit trail), continuing from
[accounting-engine.md](accounting-engine.md)'s V2 Phase 6 foundation.

## Reuse over reinvention

Two existing pieces of infrastructure are reused directly rather than
duplicated:

- **Parsing** — `statements.StatementParser`/`ParsedStatementRow`/
  `StatementProvider` (Phase 2) do the actual CSV/XLSX/PDF parsing.
  `reconciliation` injects the same `List<StatementParser>` beans
  `statements.StatementImportService` does; this module adds no second
  parsing code path, only the business-scoped tables that track
  reconciliation *state* across a session's lifetime, which
  `autotrack`'s one-shot "become a transaction candidate" flow has no
  equivalent of.
- **Audit trail** — the phase's own "persist reconciliation history"
  requirement is satisfied by extending the *existing* generic
  `audit_logs` table (Phase 14) with five new `AuditAction` values
  (`RECONCILIATION_LINE_MATCHED`, `_TRANSACTION_CREATED`, `_IGNORED`,
  `_SPLIT`, `_DIFFERENCE_RESOLVED`), not a second, reconciliation-
  specific audit mechanism.

## Data model

- **`BusinessStatementImport`** — one upload (space + business account +
  provider + file), append-only (status is decided once at parse time).
- **`BusinessStatementLine`** — one normalized row (signed `amount`,
  exactly like `statements.ParsedStatementRow` — positive = money in,
  negative = money out), whose `status`
  (UNMATCHED/MATCHED/CREATED/IGNORED/SPLIT) genuinely mutates across the
  reconciliation workflow.
- **`ReconciliationSession`** — one per import (1:1, enforced by a
  `UNIQUE` constraint), the working process of reconciling that
  import's lines, with its own `IN_PROGRESS`/`COMPLETED` lifecycle and
  an optional user-entered `statementEndingBalance`.
- **`ReconciliationLineAllocation`** — append-only join between one
  statement line and one `bizbanking.business_account_entries` row. A
  plain Match or Create Transaction produces exactly one row; a Split
  produces several, one per new ledger entry the line's amount was
  divided into.

## The matching engine

Deterministic, no fuzzy scoring or machine-learning "smart" matching —
the same posture this codebase has held everywhere else a real number
is at stake (`finhealth.FinancialHealthService`,
`accounting.JournalEntryService`). For an `UNMATCHED` line,
`MatchingService` looks at not-yet-allocated
`business_account_entries` for the same business account:

- **EXACT** — same date, same signed amount.
- **PROBABLE** — same amount within a 5-day window, or same date within
  a RM1.00 tolerance.

An entry already consumed by a previous allocation is never suggested
again — each ledger entry backs at most one allocation.

## The four line-level actions

- **Match** — link an existing ledger entry to this line (`409
  LEDGER_ENTRY_ALREADY_ALLOCATED` if someone else already claimed it).
- **Create Transaction** — the books never recorded this at all; post a
  brand-new `business_account_entries` row for exactly this line's
  date/amount/description via the existing `bizbanking.
  BusinessAccountService.addEntry`.
- **Ignore** — not a real business transaction (a bank's own marker
  row); no ledger entry, no allocation.
- **Split** — one lump-sum statement line was actually several separate
  transactions; portions must sum exactly to the line's amount (`409
  SPLIT_PORTIONS_DO_NOT_SUM_TO_LINE_AMOUNT` otherwise, mirroring
  `accounting.JournalEntryService`'s own debit=credit rigor), each
  portion becoming its own new ledger entry.

Every action is only valid while a line is still `UNMATCHED` — acting
on an already-resolved line is `409 STATEMENT_LINE_ALREADY_RESOLVED`.

## Resolve Difference (session-level, not line-level)

A real bank statement shows an ending balance; the generic CSV/XLSX/PDF
parsers only extract line rows, not a header/footer figure, so
`statementEndingBalance` is user-entered (honest, not fabricated — the
same posture as the Personal Tax Centre's seeded-rate disclaimer, just
for a much smaller claim). `ledgerBalance` is the business account's
*current* computed balance — this phase assumes a session works
through the most recent statement rather than threading an as-of-date
balance through `bizbanking` for a point-in-time comparison, the same
direct-method simplification `accounting.CashFlowService` already makes
for its own report. Resolving a non-zero difference posts one
adjustment ledger entry for exactly that gap and completes the session.

## Endpoints

`POST/GET /api/v1/spaces/{spaceId}/reconciliation/statement-imports`,
`GET .../statement-imports/{id}/lines`; `GET
.../lines/{id}/suggestions`; `POST .../lines/{id}/{match,
create-transaction,ignore,split}`; `GET/POST
/api/v1/spaces/{spaceId}/reconciliation/sessions[/{id}]`, `GET
.../sessions/{id}/summary`, `POST .../sessions/{id}/resolve-difference`.
All writes require `MANAGE_BANKING`.

## Mobile

A new `reconciliation` feature module: a hub screen (past imports/
sessions, an "Import Statement" action reusing `file_picker` exactly
like the existing personal-finance statement-import screen) and a
session screen (summary header, statement lines with per-line actions,
a live running-total-vs-target indicator on the Split form mirroring
the Journal Entry form's balance indicator from Phase 6, and a Resolve
Difference action). Reached from the Business Dashboard, alongside
Phase 5/6's own entries.

## Tests

`BusinessStatementImportFlowTests` (2 — a successful import opening a
session, a failed/empty import opening none), `ReconciliationAction
FlowTests` (5 — an exact-match suggestion confirmed as a match, create-
transaction posting a real ledger entry, ignore, split producing
multiple entries summing correctly, and a rejected mis-summed split),
`ReconciliationSessionFlowTests` (3 — summary counts and ledger
balance, resolve-difference posting a real adjustment entry and
completing the session, and a real cross-role 403) — 10 new integration
tests, all pass; full backend regression suite (every prior phase)
reconfirmed clean alongside them. `flutter analyze` clean.
