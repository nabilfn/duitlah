# Personal Gap Closure II

Implemented in **V2 Phase 3** (spec sections 16-24), continuing from
[autotrack.md](autotrack.md)'s V2 Phase 2 foundation. Nine sub-features,
all additive to the existing schema — no existing table's meaning changed,
only new tables and new nullable columns.

## Personal Bills (section 16)

`com.duitlah.api.bills` — table `personal_bills`, deliberately not named
`bills` (Bagilah's own split-receipt feature has owned that name since
V6; a different domain, a genuine naming collision avoided on purpose).

Each due occurrence is its own row rather than a rule-plus-materialized-
occurrences split, unlike `recurring.RecurringTransaction` — a bill
doesn't need that machinery. `PersonalBillService.markPaid` calls
`TransactionService.create` (the same entry point a manual "Add
transaction" uses) and, if the bill recurs, creates the next occurrence's
row directly with its due date advanced. `PersonalBillScheduler`
(`@Scheduled`, same shape as `RecurringTransactionScheduler`) flips
`UPCOMING → DUE` (within 3 days of the due date) and `→ OVERDUE` (past
due), and sends a reminder via the new `notifications` module each time —
the spec's own "reminders" requirement, wired into a real channel rather
than left as a TODO.

## Loans, BNPL, Credit Cards (sections 17-18)

`com.duitlah.api.liabilities`:

- **`Liability`** covers every type the spec names except `CREDIT_CARD`
  (personal/car/housing/education loans, PTPTN, BNPL, other). Outstanding
  principal is always `originalAmount - SUM(LiabilityPayment.principalPortion)`
  — computed, never stored, the same discipline as account balance and
  goal progress elsewhere in this schema. `LiabilityPayment` is
  append-only, same shape as `goal_contributions`/`settlement_payments`.
- **A credit card stays an ordinary `finance.Account`** with `type =
  CREDIT_CARD`, extended by a one-to-one `CreditCardDetails` row (credit
  limit, statement day, payment due day, minimum payment %) — not a
  second, parallel liability record. This is the load-bearing design
  decision of this whole section: a card's purchases are already ordinary
  `EXPENSE` transactions (spec: "credit-card purchases should affect
  spending when purchased"), and a repayment is an ordinary `TRANSFER`
  from a cash account into the card account (spec: "repayments should
  move liability/cash rather than become a second expense") — both
  requirements are satisfied by mechanisms that already existed, with
  zero new transaction-writing code. `currentOutstanding`,
  `availableCredit`, and `utilization` are all derived from
  `AccountService#balanceOf`/`#balanceAsOf` on read, never stored.

## Net Worth (section 19)

`com.duitlah.api.networth` — `Assets - Liabilities`, always computed
fresh (`NetWorthService#compute`): assets are every non-archived,
non-`CREDIT_CARD` account balance plus manually-entered `OtherAsset` rows
(property/vehicle/other — `accounts` already covers cash/bank/e-wallet/
investment/savings); liabilities are every `CREDIT_CARD` account's
outstanding plus every `ACTIVE` `Liability`'s outstanding principal.
`NetWorthSnapshot` is the one deliberate stored exception — written only
when a user explicitly asks for one (`POST /api/v1/net-worth/snapshots`),
the same "freeze it at the moment of truth" choice as
`bill_final_amounts`/`settlements`.

## Financial Health Score (section 20)

`com.duitlah.api.finhealth.FinancialHealthService` — fully deterministic,
no model call anywhere in it (the same "don't let the AI become the
source of truth for financial calculations" discipline as
`ai.AffordabilityService`). Seven weighted components, each a plain
arithmetic formula over data already computed elsewhere:

| Component | Weight | Source |
|---|---|---|
| Savings rate | 20 | `analytics.monthlyTrend` (last 3 months) |
| Emergency fund | 20 | liquid account balances ÷ average monthly expense |
| Debt-to-income | 15 | `NetWorthService` liabilities ÷ estimated annual income |
| Credit utilization | 15 | `CreditCardService`, only cards with details configured |
| Bill payment status | 15 | share of `personal_bills` not `OVERDUE` |
| Budget adherence | 10 | share of this month's budgets not `EXCEEDED` |
| Cash-flow stability | 5 | std. deviation of net cash flow ÷ average expense (6 months) |

Credit utilization, bill payment status, and budget adherence are
**excluded from the weighted average** (not scored as a failure) when the
user has no credit cards, no tracked bills, or no budgets respectively —
a feature never used isn't the same as a feature used badly. The API
returns `score`, `components` (each with its own `weight` and a
plain-language `explanation`), and `recommendations` (generated from the
lowest-scoring components) — never presented as, or confusable with, a
credit score.

## Custom Budget Cycles (section 21)

`budgets.cycle_type` (`CALENDAR_MONTH` default / `PAYDAY` / `CUSTOM`) plus
nullable `period_start_date`/`period_end_date` columns, added to the
existing `budgets` table. **Every budget created before this migration,
and every `CALENDAR_MONTH` budget created after it, is completely
untouched** — `periodYear`/`periodMonth` remain fully authoritative for
that cycle type, exactly as before. `PAYDAY`/`CUSTOM` budgets instead
require an explicit `periodStartDate`/`periodEndDate` and skip the
calendar-month duplicate-budget check (which doesn't generalize cleanly
to arbitrary overlapping ranges — a deliberate permissiveness, not an
oversight).

## Multi-Currency (section 22)

`transactions` gained four nullable columns — `original_currency`,
`original_amount`, `exchange_rate`, `converted_at` — generalizing Trip
mode's `group_expenses` currency-snapshot columns (V11) from Groups to
every personal transaction directly. `amount` remains the one real
base-currency figure every balance/report computation uses; the
snapshot is captured once at creation time and never recomputed, so a
historical report can never silently change when exchange rates move
later (the spec's own explicit requirement).

## Exports (section 23)

`com.duitlah.api.exports` — real CSV (Commons CSV) and XLSX (Apache POI)
exports for transactions, personal bills, loans, net worth, and budgets,
plus a full-archive ZIP bundling all five as CSV. PDF export
(`PdfExportWriter`, Apache PDFBox) is a plain, unstyled text table — real
and correct, not a branded report; building the latter would need a
layout engine this app doesn't otherwise depend on. The spec's own wider
export list (tax summary, business accounting, invoices, Bagilah, Groups,
settlements) is deliberately not built here: tax and business accounting
don't exist as features yet (later V2 phases), and Bagilah/Groups/
settlements exports are a real, separate scope decision left for
whichever phase actually prioritizes them.

## Notification Infrastructure (section 24)

`com.duitlah.api.notifications` — replacing the Phase 9.5 placeholder
screen with the real provider architecture the spec's own diagram names:
`NotificationService.notify` fans out to every `NotificationProvider`
bean. `InAppNotificationProvider` (persisted, real) and
`EmailNotificationProvider` (via the existing `common.mail.EmailSender`,
real) are active today; `PushNotificationProvider` is honestly
unimplemented — real push needs a device-token registration endpoint
(none exists yet) and real Firebase Cloud Messaging credentials this
repository doesn't have, the same "don't fabricate a working integration"
posture as `subscriptions.UnavailableSubscriptionVerifier`. It logs
rather than silently doing nothing, so the gap stays visible.

## Endpoints

See each module's controller for the full list; the notable ones:
`POST/GET /api/v1/personal-bills`, `.../mark-paid`, `.../skip`;
`POST/GET /api/v1/liabilities`, `.../payments`;
`PUT/GET /api/v1/accounts/{id}/credit-card-details`;
`GET /api/v1/net-worth`, `POST/GET .../snapshots`, `POST/GET/DELETE
.../other-assets`; `GET /api/v1/financial-health`;
`GET /api/v1/exports/{transactions,bills,loans,net-worth,budgets,archive}`;
`GET/POST /api/v1/notifications`, `.../unread-count`, `.../{id}/read`.

## Mobile

Six new feature modules (`bills`, `liabilities`, `networth`, `finhealth`,
`exports`) plus a real `notifications` feature replacing its own Phase
9.5 placeholder screen, all reachable from the More menu. Credit card
details are reached by tapping a `CREDIT_CARD`-type account in the
existing Accounts screen, not a separate top-level entry — it's a detail
view of that account, not a new concept. The budget creation form gained
a cycle-type picker (calendar month vs. payday, with date pickers for the
latter); transaction multi-currency fields are deliberately not exposed
in the mobile "add transaction" form yet — most transactions are
same-currency, and this is a documented, honest deferral rather than
clutter added to the primary entry flow for a rarely-used case. Exports
are shared off-device via `share_plus`, writing the downloaded bytes to a
temp file first (no new dependency — `Directory.systemTemp`, not
`path_provider`).

## Tests

Backend: `PersonalBillFlowTests` (5), `LiabilityFlowTests` (4),
`CreditCardFlowTests` (4), `NetWorthFlowTests` (3),
`FinancialHealthFlowTests` (2), `BudgetCustomCycleFlowTests` (3),
`TransactionMultiCurrencyFlowTests` (3), `ExportFlowTests` (4),
`NotificationFlowTests` (3) — 31 new integration tests (215 total).
Mobile: 9 new JSON round-trip tests across 6 new/extended domain models
(43 total). `flutter analyze` clean.
