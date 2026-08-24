# Advanced Automation

Implemented in **V2 Phase 13** (the master prompt's own literal Phase
13 "Implement:" bullet list: recurring invoices, transaction rules,
automatic categorization, Smart Capture improvements,
statement-learning, receipt automation, intelligent reconciliation,
notification rules), continuing from
[ai-assistant-v2.md](ai-assistant-v2.md)'s V2 Phase 12 foundation.

Research before writing any code confirmed every one of these eight
bullets was a genuine gap — nothing to extend, only existing
infrastructure to build on top of (`recurring.RecurringTransaction`'s
schedule shape, `autotrack.CategorySuggestionService`'s one heuristic,
`reconciliation.MatchingService`'s deterministic matcher,
`notifications.NotificationService`'s fan-out). Three of the eight
bullets turned out to be one coherent feature; the rest are each a
small, targeted addition to an existing module.

## Transaction rules, automatic categorization, and statement-learning — one mechanism

New `transactionrules` module. Before this phase, the *only*
"automatic categorization" in the whole codebase was
`CategorySuggestionService.suggest`: "whatever category this user chose
last time they logged a transaction at the exact same merchant
string" — no rules, no memory beyond that one live query.

`TransactionRuleService.suggestCategory` is now consulted first
(highest-priority active rule wins; an exact `MERCHANT_EQUALS` match
beats `MERCHANT_CONTAINS` at the same priority); the original
last-merchant lookup is the fallback when no rule matches. That's
"transaction rules" (a CRUD surface at `/api/v1/transaction-rules`) and
"automatic categorization" (the widened suggestion source) as one
mechanism.

"Statement-learning" is the same mechanism's other half:
`TransactionRuleService.learnFromConfirmation` upserts a
`MERCHANT_EQUALS` rule every time `autotrack.TransactionCandidateService
#confirm` resolves a candidate with a category — keyed on `(userId,
matchValue)`, so confirming the same merchant again *reinforces* the
existing learned rule rather than accumulating duplicates. A
user-authored rule for the same merchant is never silently overwritten
by a learned one. Every learned rule is exactly as visible and editable
as a hand-written one (`learned: true` on the response) — there is no
hidden model behind it, matching this codebase's consistent "no
black-box AI" posture.

## Recurring invoices

New classes inside `sales`: `RecurringInvoice` /
`RecurringInvoiceLineItem` (the schedule and its line-item templates)
and `RecurringInvoiceService.materializeAllDue`, structurally identical
to `recurring.RecurringTransactionService.materializeAllDue` — same
catch-up loop (a missed run posts one invoice per elapsed period rather
than skipping), same `nextOccurrenceDate` advance, reusing
`recurring.RecurrenceFrequency`/`RecurrenceCalculator` directly rather
than duplicating them (both are already public module surface with no
personal-finance-specific coupling).

**Every materialized invoice is created `DRAFT`, never auto-`SENT`.**
`InvoiceService.createFromRecurring` (a package-private sibling of the
existing `createFromQuotation`) never calls `changeStatus`, so nothing
posts to accounting or moves inventory until a human reviews and
explicitly sends it — the same manual-issue discipline the one-off
invoice flow already has. A `RecurringInvoiceScheduler` (`@Scheduled`,
00:15 daily, staggered after the personal recurring-transaction and
bill schedulers) runs it, under the rule's own `createdByUserId` as the
acting user, since a background job has no request-scoped user of its
own.

## Smart Capture improvements

No feature literally named "Smart Capture" existed anywhere in the
codebase or its docs — the real receipt-OCR flow (`receipts.
ReceiptScanService`/`ReceiptVaultService`) already computed an
`overallConfidence` per scan but never used it for anything: a
low-confidence parse was handed to the user for review exactly like a
high-confidence one, with the "should I flag this for double-checking?"
judgment left entirely to whichever client happened to render it.

`ParsedReceipt.needsReview()` is now the one server-computed threshold
(`overallConfidence < 0.7`) both `ReceiptScanResponse` and
`ReceiptResponse` (Vault) expose, so every client applies the same rule
instead of guessing its own cutoff. The Vault gained its own
`overall_confidence` column (the Bagilah scan flow already had one) so
this is consistent across both OCR entry points.

## Receipt automation

Two previously-manual-only gaps closed:

- **`ReceiptVaultService.suggestTransactionMatches`** — given a receipt
  with a real amount and date, suggests (never auto-links) existing
  expense transactions that could correspond to it. Same deterministic
  EXACT/PROBABLE two-tier shape as `reconciliation.MatchingService`
  (same amount + same date = EXACT; same amount within a 5-day window,
  or same date within RM1.00, = PROBABLE) — no fuzzy text matching,
  matching this codebase's established "deterministic, explainable"
  posture for every suggestion feature. Attaching still requires the
  existing explicit `POST .../attach` call; this only narrows down what
  a human picks from.
- **`PersonalBill.receiptId`** — a column that existed since personal
  bills shipped but had no write path anywhere in the codebase.
  `PersonalBillService.attachReceipt` wires it up, reusing
  `ReceiptVaultService.get` to verify the receipt actually belongs to
  the caller (rather than trusting a client-supplied id at face value)
  before linking it.

## Intelligent reconciliation

`reconciliation`'s own package-info states its matching engine is
"deliberately simple and deterministic... no fuzzy scoring" — a
design decision from V2 Phase 7 this phase respects rather than
overturns. "Intelligent" here means removing manual toil from the
*unambiguous* cases, not introducing fuzzy text similarity:
`ReconciliationActionService.autoMatchExact` is a single explicit,
user-triggered action (`POST .../auto-match`) that scans every
`UNMATCHED` line in an import and auto-applies any line with **exactly
one** EXACT suggestion, by reusing the existing `match(...)` method
directly — so every auto-applied match gets the identical audit trail
(`RECONCILIATION_LINE_MATCHED`) a manual match would. A line with zero
or more than one EXACT candidate stays untouched; PROBABLE suggestions
are never auto-applied. Nothing runs silently in the background — it's
one button a user presses, same as every other reconciliation action.

## Notification rules

Before this phase, `NotificationService.notify` fanned out
unconditionally to every channel for every call — three hardcoded
triggers (`BILL_DUE_SOON`/`BILL_OVERDUE` in
`bills.PersonalBillScheduler`, `LOW_STOCK_ALERT` in `inventory.
LowStockAlertScheduler`) with zero user configurability, and two gaps
research confirmed were never wired up at all: a budget crossing into
`EXCEEDED` and a low account balance never notified anyone, despite
`BudgetStatus.EXCEEDED` and a computed balance both already existing.

New `NotificationRuleType` enum (`BILL_DUE_SOON`, `BILL_OVERDUE`,
`LOW_STOCK_ALERT`, `BUDGET_EXCEEDED`, `LOW_BALANCE`) and
`NotificationRule` (one row per `(user, type)` the user has ever
changed from its default). `NotificationService.notify` now consults
`NotificationRuleService.isEnabledFor` before fanning out — a single
choke point, so none of the existing scheduler call sites needed to
change at all. A missing row means the type's own default: `true` for
the first four (nothing regresses for an existing user who's never
touched this screen), `false` for `LOW_BALANCE` — it needs a
user-supplied threshold to mean anything, so it's opt-in rather than
opt-out.

The two new triggers:

- **`BUDGET_EXCEEDED`** — `BudgetService.evaluateBudgetAlerts`, run
  daily by `BudgetAlertScheduler`, checks every budget whose period
  covers today. Dedup lives on the budget row itself
  (`Budget.budgetExceededNotifiedAt`) — the exact same "notify once per
  dip, clear once it resolves" pattern `catalog.Product.
  lowStockNotifiedAt` already established.
- **`LOW_BALANCE`** — `analytics.LowBalanceAlertScheduler`, run daily,
  only ever scans users who've explicitly configured a threshold
  (`NotificationRuleService.findEnabledWithThreshold`) rather than
  checking every user's balance — true opt-in, not opt-out-by-default.
  Dedup lives on the rule row's own `lastTriggeredAt`, since — unlike a
  product or a budget — there's no other per-entity row to hang a
  timestamp on.

## Endpoints

`GET/PUT /api/v1/notification-rules/{type}`; `POST/GET
/api/v1/transaction-rules`, `PUT/DELETE
/api/v1/transaction-rules/{id}`; `POST/GET
/api/v1/spaces/{spaceId}/recurring-invoices`, `GET/PATCH/DELETE
.../{id}`; `GET /api/v1/receipts/vault/{id}/match-suggestions`; `POST
/api/v1/personal-bills/{id}/receipt`; `POST
/api/v1/spaces/{spaceId}/reconciliation/statement-imports/{importId}/auto-match`.

## Tests

`TransactionRuleFlowTests` (4), `RecurringInvoiceFlowTests` (5),
`ReceiptAutomationFlowTests` (5), `ReconciliationAutoMatchFlowTests`
(2), `NotificationRuleFlowTests` (5) — 21 new integration tests, all
pass; full backend regression suite (388 tests total, every prior
phase) reconfirmed clean. Live-verified against a rebuilt Docker image:
transaction rule CRUD, a recurring invoice materializing a real `DRAFT`
invoice, default notification-rule state (four enabled, `LOW_BALANCE`
opt-in disabled), and a receipt's `needsReview` field and its
attachment to a personal bill.
