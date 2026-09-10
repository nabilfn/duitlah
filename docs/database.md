# Database

## Engine

PostgreSQL 16. Local development runs it via `docker-compose.yml`
(service `postgres`); production uses a managed Postgres instance.

## Migrations

All schema changes go through Flyway. Migration files live at:

```text
apps/api/src/main/resources/db/migration/V<N>__<description>.sql
```

Rules:

- Never rely on Hibernate's `ddl-auto: update` — it is set to `validate`
  (`apps/api/src/main/resources/application.yml`), so entity mappings must
  always match a Flyway migration that already ran.
- Migrations are immutable once merged. A mistake gets fixed with a new
  migration, not an edit to an old one.
- `V1__init.sql` enables the `pgcrypto` extension (used for `gen_random_uuid()`
  primary keys). `V2__auth.sql` adds the auth/users tables: `users`,
  `auth_sessions` (one row per refresh token in circulation — see
  [security.md](security.md)), `email_verification_tokens`, and
  `password_reset_tokens`. `V3__personal_finance.sql` adds `accounts`,
  `categories` (system defaults + user-custom, self-referencing `parent_id`
  for a deliberately shallow two-level tree), and `transactions`.
  `V4__budgets_and_goals.sql` adds `budgets` (a nullable `category_id` means
  "overall monthly budget" — see the partial-unique-index note below),
  `goals`, and `goal_contributions`. `V5__groups.sql` adds `groups`,
  `group_members`, `group_expenses`, and `group_expense_shares`.
  `V6__bagilah.sql` adds `bills`, `receipt_items`, `bill_participants`,
  `item_claims`, `bill_payments`, and `bill_final_amounts`.
  `V7__bagilah_collaboration.sql` adds `bills.invite_token_hash` and
  `bill_guest_sessions`. `V8__receipts.sql` adds `receipt_scans`.
  `V9__settlements.sql` adds `settlements` and `settlement_payments`.
  `V13__audit_logs.sql` adds `audit_logs` (Phase 14). `V14__hardening_constraints.sql`
  adds three `CHECK` constraints to `group_expenses`' Trip-mode currency
  snapshot columns (Phase 14). `V15__feedback.sql` adds `feedback`
  (Phase 15). `V16__financial_spaces.sql` adds `financial_spaces`,
  `space_members`, and `business_profiles`, plus a backfill inserting one
  `PERSONAL` space and `OWNER` membership per existing user (V2 Phase 1 —
  see [financial-spaces.md](financial-spaces.md)). `V17__autotrack.sql`
  adds `receipts` (the Receipt Vault), `statement_imports`, and
  `transaction_candidates` (V2 Phase 2 — see [autotrack.md](autotrack.md)).
  `V18__personal_gap_closure_ii.sql` adds `personal_bills`,
  `credit_card_details`, `liabilities`, `liability_payments`,
  `other_assets`, `net_worth_snapshots`, `notification_records`, plus new
  columns on the existing `budgets` (`cycle_type`, `period_start_date`,
  `period_end_date`) and `transactions` (`original_currency`,
  `original_amount`, `exchange_rate`, `converted_at`) tables (V2 Phase 3
  — see [personal-gap-closure-ii.md](personal-gap-closure-ii.md)).
  `V19__personal_tax_centre.sql` adds `tax_years`, `tax_brackets`,
  `tax_relief_rules`, `tax_rebate_rules`, `personal_income_records`,
  `pcb_payments`, `zakat_payments`, `personal_tax_documents`,
  `tax_relief_candidates`, and `confirmed_tax_reliefs`;
  `V20__seed_tax_years.sql` seeds YA2024-YA2026 with a good-faith
  approximation of the published LHDN structure — see the migration's own
  header and [personal-tax.md](personal-tax.md) for the explicit honesty
  note about where those figures come from (V2 Phase 4).
  `V21__business_core.sql` adds `business_accounts`,
  `business_account_entries`, `customers`, `suppliers`, `products`,
  `business_expenses`, `expense_payments`, `quotations`,
  `quotation_line_items`, `invoices`, `invoice_line_items`,
  `invoice_payments`, and `credit_notes` (V2 Phase 5 — see
  [business-core.md](business-core.md)). Deliberately absent: any
  Chart-of-Accounts/journal/ledger table — that's Phase 6's migration, not
  this one; see business-core.md's "scope boundary" section.
  `V22__accounting_engine.sql` adds `chart_of_accounts`,
  `accounting_periods`, `journal_entries`, and `journal_lines` (plus a
  deferred constraint trigger enforcing every entry's debits equal its
  credits), and two nullable `chart_of_accounts_id` columns on the
  existing `business_accounts`/`business_expenses` tables (V2 Phase 6 —
  see [accounting-engine.md](accounting-engine.md)).
  `V23__reconciliation.sql` adds `business_statement_imports`,
  `business_statement_lines`, `reconciliation_sessions`, and
  `reconciliation_line_allocations` (V2 Phase 7 — see
  [reconciliation.md](reconciliation.md)). Reuses the existing
  `audit_logs` table (V13) via new `AuditAction` values rather than a
  second audit mechanism.
  `V24__inventory_and_costing.sql` adds `inventory_movements` and
  `product_recipe_items`, five new columns on the existing `products`
  table (`description`, `cost`, `tax_classification`, `track_inventory`,
  `reorder_point`, `low_stock_notified_at`), and widens
  `journal_entries.source_type`'s CHECK constraint to add
  `INVENTORY_PURCHASE`/`INVENTORY_COGS` (V2 Phase 8 — see
  [inventory-and-costing.md](inventory-and-costing.md)). No new ledger
  accounts needed seeding — Phase 6's Chart of Accounts already had
  "Inventory" (`1030`) and "Cost of Goods Sold" (`5000`) seeded but
  unused until now.
  `V25__fixed_assets.sql` adds `fixed_assets` and
  `asset_depreciation_entries` (append-only, `UNIQUE(asset_id, period)`),
  and widens `journal_entries.source_type`'s CHECK constraint again to
  add `ASSET_ACQUIRED`/`ASSET_DEPRECIATION`/`ASSET_DISPOSAL` (V2 Phase 9
  — see [fixed-assets.md](fixed-assets.md)). "Fixed Assets" (`1500`) was
  already seeded in Phase 6, unused until now; this migration doesn't
  touch the seed list itself — the three brand-new accounts
  (Accumulated Depreciation, Depreciation Expense, Gain/Loss on Disposal
  of Assets) are added in `DefaultChartOfAccounts` code, seeded per-space
  the same way every other default account is, bringing the seeded
  count from 24 to 27.
  `V26__business_tax_and_einvoice.sql` adds `einvoice_mandate_rules`,
  `sst_rates`, `einvoice_documents`, and `einvoice_provider_logs`
  (append-only), plus `business_profiles.annual_revenue`. Unlike every
  prior phase, this one never touches `journal_entries.source_type`'s
  CHECK constraint — e-Invoice submission doesn't post accounting
  entries of its own, so no new journal source type was needed.
  `V27__seed_business_tax_rules.sql` seeds the
  current SST rates and e-Invoice mandate threshold history (V2 Phase
  10 — see [business-tax-and-einvoice.md](business-tax-and-einvoice.md));
  both tables are global reference data, not space-scoped, the same
  shape as `personaltax`'s `tax_brackets`/`tax_years`.
  `V28__cross_space_accounting.sql` adds `cross_space_links` and widens
  `journal_entries.source_type`'s CHECK constraint to add
  `BUSINESS_ADVANCE`/`REIMBURSEMENT`/`OWNER_CONTRIBUTION`/`OWNER_DRAWING`
  (V2 Phase 11 — see
  [cross-space-accounting.md](cross-space-accounting.md)). "Due to
  Owner" is the one new Chart of Accounts seed this phase adds (code
  `2030`, added in `DefaultChartOfAccounts` code, seeded per-space like
  every other default account, bringing the seeded count from 27 to
  28) — "Owner's Capital"/"Owner's Drawings" were already seeded in
  Phase 6, unused by automatic posting until now.
  Remaining domain tables are added module-by-module in later phases, not
  all at once.
- **Every FK to `users(id)` uses `ON DELETE CASCADE`, with exactly one
  deliberate exception** — this was violated once by accident
  (`group_expenses.paid_by_user_id`/`created_by_user_id` and
  `group_expense_shares.user_id` were plain `REFERENCES users(id)`,
  caught when a test's `userRepository.deleteAll()` hit a live FK
  violation) and fixed to match every other user-owned table in this
  schema. `audit_logs.actor_user_id` (V13, Phase 14) is the one table
  that deliberately uses `ON DELETE SET NULL` instead — an audit trail
  must outlive the actor who triggered it, so deleting a user's account
  must never delete or orphan-cascade the history of what they did; see
  [security.md](security.md). If a future table's FK to `users(id)`
  doesn't cascade and isn't `audit_logs`, that's a bug, not a deliberate
  choice.
- Enum-like columns (`accounts.type`, `categories.type`, `transactions.type`,
  `transactions.direction`) use `VARCHAR` + `CHECK`, not a native Postgres
  enum type — changing a `CHECK` constraint is a plain migration; widening a
  native enum needs `ALTER TYPE` and is far more disruptive as the domain
  grows. Match the Java side's mapping: `@Enumerated(EnumType.STRING)`, a
  plain `String`/`VARCHAR` column — not `CHAR`, which Hibernate schema
  validation will reject as a type mismatch (bpchar vs varchar) even though
  the data itself would work.

### Assumption: default income categories

The product spec (section 23) lists default *expense* categories exactly
(Food, Transport, Shopping, Lifestyle, Bills, Education, Financial) but
gives no equivalent for income. `V3__personal_finance.sql` adds a small,
reasonable default set (Salary, Freelance, Business, Gifts, Investment
Returns, Other Income) as a documented assumption, not a spec requirement —
revisit if the product spec is later extended to name these explicitly.

## Money

Every monetary column must be `NUMERIC`/`DECIMAL` with an explicit scale —
never `FLOAT`/`DOUBLE`. On the Java side this maps to `BigDecimal`. This
applies without exception to anything representing an amount: prices,
totals, balances, allocations, rounding adjustments.

## Personal finance design decisions

- **Account balance is computed, never stored.** `AccountService.balanceOf`
  is `openingBalance + SUM(signed transaction amounts for that account)`,
  queried fresh every time — there is no `current_balance` column. A
  denormalized running balance needs every write path (create, edit,
  delete) to update it in lockstep; miss one and the number silently drifts
  from the truth. At personal-finance transaction volumes, correct-by-
  construction beats cached-and-maybe-wrong.
- **A transfer is two transaction rows, not one.** Each row affects exactly
  one account (`direction: IN` or `OUT`), and both rows share a
  `transfer_group_id`. This keeps "an account's balance is the sum of its
  own rows" true without special-casing transfers, and each account's
  history naturally shows its own side of the transfer. Deleting a
  transfer deletes both rows together (see `TransactionService.delete`).
- `transactions.amount` is always a positive magnitude; `direction` (not a
  signed amount) carries the sign. Nothing downstream ever has to reason
  about negative amounts.
- **Goal progress follows the same computed-not-stored pattern as account
  balance**: `goals` has no `current_amount` column — it's
  `SUM(goal_contributions.amount)` for that goal, computed on read
  (`GoalService.currentAmount`). Unlike a transaction's amount,
  `goal_contributions.amount` is signed — a negative entry is a correction
  or a withdrawal, not a separate "type."
- **A budget's `category_id` can be NULL** (the overall monthly budget) —
  which breaks a naive `UNIQUE(user_id, category_id, period_year,
  period_month)` constraint, because SQL treats every `NULL` as distinct
  from every other `NULL`; two overall budgets for the same month would
  never collide. `V4__budgets_and_goals.sql` uses two partial unique
  indexes instead (one filtered to `category_id IS NULL`, one to `IS NOT
  NULL`) to actually enforce "one budget per category per month" in both
  cases.
- **A category budget rolls up its children's spending.** Transactions are
  only ever tagged to a leaf category (Restaurants, Cafe, ...), never a
  parent (Food) — so a budget set on "Food" (matching the product spec's
  own example) would always show RM0 spent if it only matched its own
  category id literally. `CategoryService.expandToSelfAndChildren` resolves
  a budget's category to itself-or-its-children before the spend query
  runs (`TransactionRepository.sumAmountByUserIdAndTypeAndCategoryIdInAndOccurredOnBetween`).

## Groups design decisions

- **A group's invite is one persistent, regeneratable token**, not
  per-invitation single-use tokens — `groups.invite_token_hash`, hash-only
  like the Phase 2 auth tokens (`common.security.SecureTokens`). Simplest
  model that satisfies "create a shareable join link"; Bagilah's guest
  links (Phase 7) are a different, bill-scoped mechanism and don't need
  this to be more elaborate than it is.
- **`common.money.EqualSplitter`** splits an amount N ways so the shares
  always sum back to the original exactly (floor-divide, then hand the
  leftover cents to the first N participants one cent each) — the same
  reconciliation invariant the product spec requires of the Bagilah engine
  (see [bagilah-engine.md](bagilah-engine.md)), built now because group
  expense splitting needs it first. Bagilah's own claim-based splitting
  (Phase 6) is a different, richer algorithm, but should reuse this for
  its equal-share case rather than reimplementing rounding reconciliation
  a second time.
- **Group balance (`GroupService.getBalances`) is `totalPaid -
  totalShare` per member** — a net position, not a simplified "who owes
  whom" debt graph. Debt simplification (collapsing A→B→C chains) is the
  `settlements` module's job (Phase 9), not Groups'.

## Bagilah design decisions (Phase 6: manual splitting)

See [bagilah-engine.md](bagilah-engine.md) for the calculation engine
itself. Schema-level decisions:

- **`bill_participants` has no `join_token`/`status` columns yet.** Phase 6
  is manual splitting — the bill owner adds items, participants, and
  claims themselves in one sitting; there's no self-serve guest join or
  live multi-user claiming yet (that's Phase 7). Adding unused columns now
  "for later" would be building ahead of the phase that actually needs
  them.
- **A participant is exactly one of a registered user or a typed guest
  name** (`CHECK ((user_id IS NOT NULL AND guest_name IS NULL) OR ...)`).
  A guest here is just a name the owner typed in on someone else's behalf
  — no account, no join link. Guests joining themselves via QR/URL is
  Phase 7's job.
- **`bills.status` is a deliberately small subset** of the product spec's
  full state machine (DRAFT/SCANNING/REVIEW/OPEN/CLAIMING/READY/
  FINALIZED/SETTLING/SETTLED/CANCELLED): just `DRAFT`, `FINALIZED`,
  `CANCELLED`. `SCANNING` needs OCR (Phase 8); `OPEN`/`CLAIMING`/`READY`
  only matter once participants can claim independently of the owner and
  live (Phase 7) — until then there's no real distinction between "items
  added" and "claiming in progress," and "all items validly claimed" is
  checked at the moment `finalize()` is called rather than persisted as
  its own state. `SETTLING`/`SETTLED` need payment-status tracking
  (Phase 9).
- **Re-claiming an item you already claimed updates your existing claim
  instead of creating a duplicate** (`UNIQUE(receipt_item_id,
  participant_id)`) — adjusting your share is naturally an edit, not a
  second claim to reconcile against the first.
- **`bill_final_amounts` is written once at `finalize()` time and never
  updated afterward** — the one deliberate exception to this schema's
  "computed, never stored" rule. Every other balance here (account,
  goal, group) is a live view over an ever-growing ledger; finalizing a
  bill is meant to freeze one specific calculation as history, the same
  way a bank statement isn't recomputed after the fact. A correction is a
  new bill, not a rewrite of the snapshot.
- **`bills.group_id` is `ON DELETE SET NULL`, not `CASCADE`** — a bill's
  financial history shouldn't be destroyed just because the group it was
  logged under gets deleted (groups today can only be archived, not
  deleted, so this is a forward-looking choice more than a live concern).
  Every FK to `users(id)` in this table still follows the no-exceptions
  cascade rule above.

## Bagilah design decisions (Phase 7: collaboration)

- **`bills.invite_token_hash`** is the same persistent, regeneratable,
  hash-only token model as `groups.invite_token_hash` — one shareable
  link/QR code per bill, not per-invitation single-use tokens. Simplest
  model that satisfies "create a shareable join link" (section 12); no
  reason for a bill's invite to be more elaborate than a group's.
- **`bill_guest_sessions` is a session, not a one-time token** — deliberately
  not built on `common.jpa.OneTimeToken` (the mapped superclass behind
  `email_verification_tokens`/`password_reset_tokens`), because a guest
  reuses the same token for every request across their whole 24-hour
  window instead of consuming it once. It's also not scoped to a
  `user_id` like `OneTimeToken` requires — a guest has no user row at all,
  only a `bill_participants` row — so it holds `bill_id`/`participant_id`
  directly instead. Structurally it's closer to `auth_sessions` (a living
  session) than to a verification token, just without rotation/revocation,
  since a guest has no refresh mechanism to rotate through — an expired
  session just means re-joining via the link.
- **Guest identity never touches the real-user JWT/Spring Security path.**
  The guest session token is validated by `BillService` doing a direct
  repository lookup, not by anything resembling `JwtAuthenticationFilter`
  or a custom `Authentication` principal type. This was a deliberate
  choice over minting a second JWT "type": the existing JWT's `subject`
  claim is blindly parsed as a real user `UUID` by the filter with no
  claim distinguishing token purpose, so reusing that machinery for a
  non-user identity risked a guest's participant id being silently
  treated as a user id somewhere downstream. Keeping guest auth as a
  wholly separate, narrower mechanism (its own controller, its own
  permitAll routes — see `SecurityConfig` — its own session table) makes
  that class of confusion structurally impossible rather than merely
  avoided by convention.
- **Claiming is participant-gated, not owner-gated** (Phase 6 had every
  claim mutation behind `requireOwnedDraftBill`; Phase 7 relaxes
  `addClaim`/`equalSplitItem`/`removeClaim` to `requireParticipantDraftBill`
  instead) — see `BagilahCalculationEngine`'s companion doc in
  [bagilah-engine.md](bagilah-engine.md) for why this is participant-gated
  rather than gated per-claim-owner too. Item/participant/charge
  management and payments/finalize/cancel stay owner-only; only the act
  of claiming becomes collaborative.

## Receipts design decisions (Phase 8: scanning)

- **`receipt_scans.parsed_result_json` is a loosely-shaped `TEXT` blob,
  not its own normalized set of tables.** A scan's parsed OCR result is
  ephemeral working data — it exists to populate a review form, gets
  corrected by the user, and then becomes real `bills`/`receipt_items`
  rows on confirm (see [bagilah-engine.md](bagilah-engine.md)). Building
  a rigid `scanned_items` table (with its own FKs, its own claim-adjacent
  columns) for data that's thrown away the moment it's confirmed would be
  structure with no lasting use. `receipts.ParsedReceiptCodec`
  hand-rolls the JSON conversion (not generic Jackson record
  deserialization) specifically so a single malformed field from the OCR
  provider degrades to null rather than breaking the whole read.
- **No image bytes in this table, or any table** — `image_storage_key`
  points at an object in `common.storage.ObjectStorage` (MinIO locally),
  never a blob column. This is the product spec's own explicit
  requirement (section 9: "Do NOT store large binary files inside
  PostgreSQL") and the reason MinIO exists in `docker-compose.yml` at
  all.
- **`receipt_scans.bill_id` is nullable and `ON DELETE SET NULL`** — a
  scan can exist un-confirmed (status `PARSED`/`FAILED`, no bill yet) or
  point at the real bill it became (`CONFIRMED`). Deleting a bill (not
  currently possible — bills are only ever cancelled, never hard-deleted)
  shouldn't be blocked by an old scan record referencing it.
- **Status is `PARSED`/`FAILED`/`CONFIRMED`, no `PENDING`/`PROCESSING`.**
  OCR runs synchronously inside the upload request (one small image, one
  API call — nothing here justifies a background job queue yet, see
  section 73/Phase 13+), so there's no observable in-between state to
  persist. "OCR provider not configured" and "OCR provider failed" both
  produce the same `FAILED`-with-blank-result outcome deliberately: the
  review UI's job is identical either way ("nothing was auto-filled,
  fill it in"), so there's no reason to distinguish them anywhere a user
  would see it.

## Settlements design decisions (Phase 9)

- **`settlements` has no `status` column.** UNPAID/PARTIALLY_PAID/PAID is
  always derived by comparing `amount` against `SUM(settlement_payments.amount)`
  — storing it would just be a second source of truth that could drift
  from the real payment ledger, the exact class of bug the "computed,
  never stored" rule (account balance, goal progress, group balance, bill
  breakdown) exists to prevent. `cancelled_at`/`disputed_at` are the only
  stored fields, because those genuinely are user decisions with no
  payment-math equivalent to derive them from — `Settlement.effectiveStatus`
  (service-layer only) folds all of this into the one status a client sees.
- **`settlement_payments` is append-only** — same "never edited, a
  correction is a new entry" discipline as every other history table in
  this schema (`goal_contributions`, `bill_final_amounts`'s write-once
  snapshot). There's no real money movement to reconcile against (section
  19: "do not hold funds"), so a payment record is inherently a
  self-report; the ledger's job is an honest, ordered history of what was
  claimed, not a source of settled truth beyond that.
- **A `Settlement`, once generated, is fixed and independent of its
  source's ongoing activity** — the same "freeze it at the moment of
  truth" philosophy as `bill_final_amounts`, extended to Groups (which,
  unlike a Bagilah bill, never has a single finalize moment of its own).
  `GroupService.getBalances`'s `net` is therefore *currently unsettled*
  position, not lifetime totals: `(totalPaid - totalShare)` minus
  whatever a previous `settleGroup` call already carved out into fixed
  Settlement rows (`SettlementRepository.netAlreadyGeneratedForUser`).
  This refinement doesn't change any Phase 5 test's expected numbers —
  before a group is ever settled, the subtraction is always zero — but it
  is a real behavior change from that point on, documented here rather
  than left implicit.
- **Guests are excluded from settlement generation.** A `Settlement` is
  meant to be visible from its own owner's "who owes me" dashboard, which
  requires a real account to log into — a Bagilah guest has neither. A
  guest's net position stays visible only on that bill's own
  `BillBalanceResponse` (see [bagilah-engine.md](bagilah-engine.md)); it's
  a real, documented limitation, not an oversight.
- **`source_id` is a plain UUID column, not a foreign key** — it can point
  at either `bills.id` or `groups.id` depending on `source_type`, and
  Postgres has no native polymorphic FK. Referential integrity for it is
  enforced in application code (`SettlementService` only ever receives
  `sourceId` values from `BillService`/`GroupService`, which own real
  rows), the same tradeoff every polymorphic-reference design makes.

## Recurring transactions design decisions (Phase 10)

- **`recurring_transactions` is a rule table, not a parallel ledger.** It
  stores the pattern (`frequency`, `interval_count`, `start_date`,
  `end_date`, `next_occurrence_date`) and the template fields to stamp onto
  each generated row (`account_id`, `type`, `direction`, `category_id`,
  `amount`, `merchant`, `description`, `notes`). It never itself represents
  money that moved — every occurrence still becomes a real row in
  `transactions`, so account balances (`openingBalance + SUM(signed
  amounts)`) keep working unchanged with no special-casing for recurring
  vs. one-off money.
- **`transactions.recurring_transaction_id` is a nullable, `ON DELETE SET
  NULL` self-describing back-reference**, not the other way around. A
  materialized transaction is a normal transaction in every other respect
  (editable, deletable, shows up in every existing query) that happens to
  remember which rule produced it, so a subscriptions view or "generated
  from a recurring rule" badge can look it up without the reverse being
  true — deleting a rule never deletes or corrupts the transactions it
  already produced.
- **"Subscription" is not its own table — it's `is_subscription = true` on
  a `recurring_transactions` row.** A subscription is a recurring
  transaction with no additional structure of its own (no trial period, no
  provider metadata); modeling it as a boolean avoids a second table and a
  second CRUD surface for what is, at the schema level, the same rule with
  a different label on the UI. `SubscriptionsSummaryResponse` and its
  `estimatedMonthlyTotal` are a service-layer view over that same filtered
  set, computed by normalizing every frequency to a monthly-equivalent
  (`RecurringTransactionService.monthlyEquivalent` — DAILY×30,
  WEEKLY×4.345, MONTHLY×1, YEARLY÷12), never stored.
- **Materialization is idempotent per rule, driven by
  `next_occurrence_date`, not a cron-computed "should fire today" check.**
  `RecurringTransactionService.materializeAllDue(LocalDate asOf)` loops
  each due rule with a `while` (not an `if`), advancing
  `next_occurrence_date` via the pure `RecurrenceCalculator.advance()` and
  inserting one transaction per step, until the rule's own
  `next_occurrence_date` is back in the future or past `end_date` (which
  also flips `active = false`). This makes the job safe to run late, run
  twice, or catch up after the API was down for several days — it always
  converges on the same set of transactions a same-day run would have
  produced, rather than silently dropping missed occurrences.
- **The materialization job (`RecurringTransactionScheduler`, `@Scheduled(cron
  = "0 5 0 * * *")`) is a single-instance, in-process cron job**, the same
  operational shape as the existing SSE broadcaster: correct today because
  there is exactly one API instance, and a real constraint to revisit
  (e.g. a distributed lock, or moving it to an external scheduler) before
  ever running more than one instance. Documented here rather than solved
  speculatively.
- **`RecurrenceCalculator` and its calendar/forecast counterparts in
  `AnalyticsService` are pure, Spring-free utility code** (`advance()`,
  `occurrencesBetween()`), the same testability pattern as
  `BagilahCalculationEngine`/`DebtSimplifier`/`ProportionalAllocator` — date
  math this fiddly (interval counts, month-end rollovers, inclusive range
  boundaries) is covered by fast unit tests instead of only being
  exercised indirectly through integration tests.
- **The forecast (`GET /api/v1/analytics/forecast`) is explicitly an
  estimate, never a promise.** `AnalyticsService.forecast()` separates
  `scheduledIncome`/`scheduledExpense` (from recurring rules due before the
  target date — deterministic) from `predictedVariableExpense` (a
  historical average of non-recurring spend — a guess), and every response
  carries a `disclaimer` string precisely so a client can never present
  `projectedBalance` as guaranteed. This follows the same "don't let a
  derived number imply more certainty than it has" instinct as the
  computed-not-stored balance/goal-progress rules elsewhere in this file,
  just applied to a number that's inherently probabilistic instead of
  inherently exact.

## Special group modes design decisions (Phase 11)

- **`groups.type` already existed since Phase 5** — HOUSEMATES/COUPLE/TRIP were
  always valid values, just without any specialized behavior attached.
  Phase 11 is therefore additive UI/logic on top of a type the schema
  already tracked, not a new group-classification system.
- **`group_expenses.category` is one shared, permissive column across every
  group type**, not per-type tables or a per-type CHECK constraint. A
  FRIENDS group tagging an expense `GROCERIES` isn't prevented — there's no
  real harm in it, and gating categories by group type would be brittle
  cross-validation for no real benefit. Housemate/Trip dashboards simply
  read whichever categories exist for a given group.
- **Trip mode's currency fields (`original_currency`/`original_amount`/
  `exchange_rate`) are an entry-time display snapshot, not a live-converted
  multi-currency ledger.** `amount` remains the real MYR figure every
  balance/settlement computation already uses unchanged; the snapshot
  exists purely so a client can show "this was originally ¥1,800 at
  0.0305" without any of that flowing back into real money math. This is
  the same "don't fabricate a capability that isn't really there" honesty
  as `PaymentHandoffService` returning manual transfer instructions
  instead of a fake DuitNow integration — full multi-currency (live rates,
  FX-aware balances) would be a materially bigger undertaking than what
  the product spec's "exchange-rate snapshots" phrase actually asks for.
- **`group_budgets` is intentionally not the `budgets` table with an added
  `group_id`.** `budgets` (Phase 4) is a monthly-recurring-per-category
  model; a trip has no month/period, just one flat target for its
  lifetime. Reusing `budgets` would force a schema built for a different
  shape onto Trip mode's simpler "one number, spent-down" semantics —
  the same "don't force-fit an existing abstraction that doesn't actually
  match" discipline as `bagilah` not reusing Groups' lighter expense
  mechanism. `spent` is always `SUM(group_expenses.amount)` for the group,
  computed on read, never stored.
- **`group_goals`/`group_goal_contributions` mirror the personal
  `goals`/`goal_contributions` shape almost exactly** (see "Personal
  finance design decisions" above) — same "current amount is
  SUM(contributions), never stored" rule, same signed-ledger discipline (a
  negative contribution is a correction/withdrawal, never an edit). The
  duplication is deliberate: a shared goal genuinely is the group-scoped
  analogue of a personal goal, not a variant that could reuse the same
  table with a nullable `user_id`/`group_id` swap, since personal and
  group goals have different membership/authorization models
  (`GoalService` checks single-user ownership; `GroupGoalService` checks
  group membership).
- **Couple mode has no dedicated schema at all.** "Mine · Yours · Ours"
  (product spec section 31) is fully satisfied by mechanisms that already
  exist once Phase 11's other pieces land: "Ours" is just a COUPLE-typed
  group's existing `group_expenses`/`group_goals` (shared, visible to both
  members); "Mine"/"Yours" is each partner's own already-private personal
  transactions (Phase 3), never exposed to the other by anything in this
  schema. Building a parallel "couple-scoped" data model would duplicate
  Groups for no real gain — the privacy guarantee the spec asks for is
  already the default, not something to construct.

## AI assistant design decisions (Phase 12)

- **No new schema at all.** The AI assistant (product spec sections 40-42)
  reads exclusively through `com.duitlah.api.ai.FinanceQueryService` — a
  thin pass-through to services (`DashboardService`, `AnalyticsService`,
  `BudgetService`, `GoalService`, `SettlementService`) that already exist
  and already enforce ownership. There was nothing to persist: chat
  history is held only in the Flutter client's memory and resent on every
  request (see [architecture.md](architecture.md)), and every number the
  assistant can ever mention was already computed and stored (or
  derived) by an earlier phase. This is the concrete, schema-level
  enforcement of "the AI MUST NOT receive unrestricted database access" —
  there's no broader surface for it to reach even if it wanted to; the
  Finance Query Layer's fixed set of methods is the entire boundary.
- **Affordability is real arithmetic, not a model's guess.**
  `AffordabilityService` computes every number in `AffordabilityResponse`
  from `AnalyticsService.forecast()` and
  `SettlementService.getSummary()` — the same forecast/debt math already
  trusted elsewhere — and formats the narrative as a Java string
  template. No LLM call happens anywhere in that class, so `POST
  /api/v1/ai/affordability` keeps working (and keeps being exactly as
  trustworthy) whether or not an AI provider is even configured. This is
  the same "don't let the AI become the source of truth for financial
  calculations" rule applied at the class-boundary level, not just as a
  prompt instruction.

## Subscriptions design decisions (Phase 13)

- **No row means FREE.** `user_subscriptions.user_id` is unique but a row
  only gets created once a user actually verifies a real PLUS purchase —
  there's no row-per-user-at-registration for a tier that's already the
  default, the same "absence has a clear meaning" choice already made for
  `group_budgets` (Phase 11) and personal goals having no default row
  either.
- **The subscription provider never becomes the app's permission model**
  (product spec section 56) — `SubscriptionTier`/`SubscriptionStatus` are
  Duitlah's own enums, computed from a verified record, not a live mirror
  of Apple/Google/Stripe's own subscription object. `SubscriptionVerifier`
  is deliberately unimplemented for every source today (see
  `UnavailableSubscriptionVerifier`) — the product spec's own wording for
  this phase is "prepare" the architecture, not integrate real store
  accounts this repository has no credentials for. This is the same
  "optional external provider, honest fallback" posture as
  `common.mail.EmailSender`/`receipts.ReceiptOcrService`/`settlements.
  PaymentHandoffService` — never fabricate a working integration.
- **"Active groups" counts ownership, not membership.** FREE's 3-group
  limit (product spec section 53) is enforced against
  `groups.owner_user_id`, not every group a user has merely joined —
  being invited into someone else's group must never count against an
  unrelated free user's own quota. This is the direct schema-level
  enforcement of the spec's own "do NOT prevent free users from
  participating in premium-created Bagilah sessions" and "never destroy
  the social growth loop through excessive paywalls" principles (sections
  53/57), generalized from Bagilah specifically to Groups.
  `GroupRepository.countByOwnerUserIdAndArchivedAtIsNull` is the one
  query both `SubscriptionService.getEntitlement` (read) and
  `GroupService.create`/`update` (enforcement) share.
- **Receipt scan quota counts every scan attempt this calendar month**,
  regardless of whether OCR actually parsed anything (`PARSED` or
  `FAILED` both count) — the limit protects the paid OCR call itself
  (product spec section 54: "fair-use limits for expensive AI/OCR
  functionality"), not just successful ones.
- **Reactivating an archived group re-checks the limit.** `GroupService.
  update` only calls `requireActiveGroupCapacity` when a group is
  transitioning from archived to active — renaming or editing an
  already-active group never re-checks, since nothing about the user's
  active-group count changed. Without this, a FREE user could archive one
  of 3 groups, create a new one (now still at 3), then reactivate the
  archived one to sit at 4 — the same class of bypass the initial
  create-time check exists to prevent.

## Hardening design decisions (Phase 14)

- **`audit_logs` is append-only.** The `AuditLog` entity exposes no
  setters beyond its constructor — there is no code path in this
  codebase that updates or deletes a row once written. `actor_user_id`
  uses `ON DELETE SET NULL` rather than the schema's usual `CASCADE` (see
  the migrations note above) specifically so the trail outlives a
  deleted account instead of disappearing with it.
- **`AuditLogService.record(...)` swallows its own exceptions.** It
  participates in the caller's ambient transaction (not
  `REQUIRES_NEW`) and logs a warning rather than propagating a failure —
  a broken audit write must never break the real business operation
  it's attached to. This is a deliberate trade: a rare audit-write
  failure is invisible to the end user, in exchange for audit logging
  never being able to take down bill finalization, transactions, or any
  of the other 8 actions it's wired into.
- **Trip-mode's currency snapshot gets real `CHECK` constraints (V14),
  closing a gap V11 left open.** `group_expenses.original_amount`,
  `exchange_rate`, and `original_currency` were only ever validated by
  the application layer (`@DecimalMin`/`@Size`); a full review of every
  numeric column in the schema found this was the one column set with
  no database-level backstop. All three constraints are `NULL`-permissive
  (the snapshot itself is still optional — see V11's own comment) and
  only constrain the non-null case. `original_currency`'s constraint
  checks shape (`^[A-Z]{3}$`), not the real ISO 4217 list, matching the
  application-layer check added alongside it in `GroupService.createExpense`.

## Public launch design decisions (Phase 15)

- **`feedback` is append-only**, the same shape as `audit_logs` (Phase 14)
  and `goal_contributions`/`settlement_payments` before it — no code path
  updates or deletes a row once submitted. Unlike `audit_logs`,
  `feedback.user_id` uses the schema's ordinary `ON DELETE CASCADE`
  (V15), not `SET NULL` — an audit trail has to outlive the actor by
  design, but a user's own submitted feedback is exactly the kind of
  personal data that should disappear when they delete their account
  (see the account-deletion section below), so the two tables
  deliberately differ here.
- **Account deletion (`AuthService.deleteAccount`) is blocked while the
  user owns any active group.** `groups.owner_user_id` has always been
  `ON DELETE CASCADE` (V5) — deleting the owner's row would silently
  delete the entire shared group, including every other member's
  expenses and history, not just the deleting user's own data. This was
  a real, reachable consequence the moment a self-service delete
  endpoint existed at all, not a hypothetical: Phase 15 is what first
  made deleting a `users` row possible outside a test/admin context.
  The fix is a pre-check (`GroupRepository.
  countByOwnerUserIdAndArchivedAtIsNull(userId) > 0` → `409
  OWNS_ACTIVE_GROUPS`), not a schema change — the cascade itself is
  still correct and desired for every other table it touches.

## Financial Spaces design decisions (V2 Phase 1)

See [financial-spaces.md](financial-spaces.md) for the full design
reasoning. Schema-level decisions:

- **Exactly one `PERSONAL` space per owner is enforced by a partial
  unique index** (`idx_financial_spaces_one_personal_per_owner ON
  financial_spaces(owner_user_id) WHERE type = 'PERSONAL'`), the same
  "SQL treats every NULL/every non-matching row as distinct, so a plain
  UNIQUE can't express a conditional constraint" reasoning behind the
  Phase 4 budgets partial unique indexes above. A user can still own any
  number of `BUSINESS` spaces — the index only filters `PERSONAL` rows.
- **No `space_id` column was added to any existing table this phase.**
  `accounts`, `transactions`, `budgets`, `goals`, and everything else
  from Phase 0-15 still key off `user_id` exactly as before. Wiring them
  to a space is deferred to whichever later V2 phase actually needs a
  space-scoped query to exist — see financial-spaces.md for why doing it
  now would be speculative structure.
- **`space_members.status` (`ACTIVE`/`REMOVED`) is a soft-remove, not a
  deleted row** — a removed member's history (who did what while they
  were a member) shouldn't disappear the moment their access is revoked,
  the same "history outlives the actor's current standing" reasoning as
  `audit_logs.actor_user_id` using `ON DELETE SET NULL` rather than
  cascading (Phase 14, above).
- **`business_profiles.space_id` is a unique FK, not the primary key
  itself** — a one-to-one relationship modeled as its own table (rather
  than extra nullable columns on `financial_spaces` itself) so a
  `PERSONAL` space's row never carries a dozen always-null
  business-only columns.

## AutoTrack / statement import / Receipt Vault design decisions (V2 Phase 2)

See [autotrack.md](autotrack.md) for the full design reasoning. Schema-level
decisions:

- **`transaction_candidates.receipt_id`/`statement_import_id` are concrete
  nullable FKs, not an opaque `source_type`/`source_id` pair** — unlike
  `settlements.source_id` (which genuinely spans two unrelated tables,
  `bills` and `groups`, with no common parent), this phase's two producers
  are both known upfront, so a real FK to each (exactly one set per row,
  by construction) gives referential integrity the database can actually
  enforce, rather than trading it away for a generality this phase doesn't
  need.
- **`detected_amount` is a hard filter in duplicate detection, not a scored
  signal** — see autotrack.md's reasoning; the `transaction_candidates`
  schema itself stores `duplicate_confidence` as a separate nullable column
  from `confidence` (the candidate's own suggestion confidence) precisely
  because they answer two different questions ("how sure is this reading
  correct" vs. "how sure is this the same as an existing transaction") that
  must never be conflated into one number.
- **`receipts.tags` is a native Postgres `TEXT[]`**, not a join table — a
  receipt's tags are simple, unordered, user-typed labels with no tag-level
  metadata of their own (no color, no per-user tag registry), so a join
  table would be structure with no real behavior to justify it, the same
  "don't force-fit a heavier abstraction than the data needs" discipline
  as `group_expenses.category` being one shared column rather than a
  per-type table (Phase 11).
- **A nullable bind parameter inside a JPQL `CONCAT`/`LIKE` expression
  breaks on Postgres** — `ReceiptRepository.search`'s merchant filter
  originally built the `%term%` wildcard pattern inside the query itself
  (`LOWER(r.merchant) LIKE LOWER(CONCAT('%', :merchant, '%'))`); when
  `:merchant` is bound `null` (the "no filter" branch of the surrounding
  `OR`), Postgres's JDBC driver can't infer a type for that parameter and
  the query fails with `function lower(bytea) does not exist` — a real
  bug caught by this phase's own integration tests, not a hypothetical.
  Fixed by pre-computing the full `%term%` pattern (or `null`) in
  `ReceiptVaultService` and binding it as a single already-complete string
  parameter, so the query itself never needs to concatenate around a
  possibly-null bind variable.
- **`statement_imports.account_id` is required, not suggested** — unlike a
  Receipt Vault upload (where the paying account genuinely isn't known
  until a human says so), a bank statement import is inherently *for* one
  specific account the user is importing history into; treating it as a
  "suggestion" would manufacture uncertainty the upload flow doesn't
  actually have.

## Personal Gap Closure II design decisions (V2 Phase 3)

See [personal-gap-closure-ii.md](personal-gap-closure-ii.md) for the full
reasoning. Schema-level decisions:

- **`personal_bills`, not `bills`** — `bills` has belonged to Bagilah's
  split-receipt feature since V6; a genuine naming collision avoided on
  purpose, the same care taken when `settlements`/`autotrack` avoided
  reusing `bill_payments`.
- **`credit_card_details` is a one-to-one companion to `accounts`, not a
  new liability table** — a card's own account balance already carries
  its outstanding amount (a purchase pushes it negative, a repayment
  transfer brings it back); this table only adds the metadata
  (limit/statement dates) that balance alone can't express.
- **`liabilities`/`liability_payments` mirror `goals`/`goal_contributions`
  and `settlements`/`settlement_payments` exactly** — a running total
  computed from an append-only ledger, never stored.
- **`budgets.cycle_type` defaults to `CALENDAR_MONTH`, and every column it
  adds is nullable** — the migration itself changes no existing row's
  meaning; `period_year`/`period_month` stay authoritative for every
  budget that predates this migration.
- **`transactions`' four new multi-currency columns are all nullable**,
  the same additive-only shape as the `budgets` cycle columns above —
  an ordinary same-currency transaction (the overwhelming majority) is
  entirely unaffected.
- **`notification_records` has no `updated_at`** — a notification is
  never edited, only marked read (`read_at`), so it doesn't extend
  `AuditableEntity`; the same "only the fields a row's lifecycle actually
  needs" discipline as `LiabilityPayment` (append-only, `created_at`
  only).

## Personal Tax Centre design decisions (V2 Phase 4)

See [personal-tax.md](personal-tax.md) for the full reasoning, including
the explicit honesty note about the seeded tax rates. Schema-level
decisions:

- **No generic `TaxRule` table** — `tax_brackets`/`tax_relief_rules`/
  `tax_rebate_rules` are already the three concrete forms a "tax rule"
  takes in this domain; a fourth umbrella table over them would be
  structure with no behavior of its own, the same discipline behind
  `bills` not splitting recurring bills into a separate rule-vs-occurrence
  model.
- **`personal_tax_documents.receipt_id`/`storage_key` are both nullable,
  exactly one expected to be set** — the same "flexible metadata, not a
  CHECK-enforced either/or" posture as `receipts.linked_transaction_id`/
  `linked_bill_id`.
- **`confirmed_tax_reliefs` is `UNIQUE(user_id, year_of_assessment,
  category)`, upserted on re-confirm** — a relief category has exactly one
  current confirmed amount per YA; correcting it is an update, not a
  second competing row.
- **`tax_relief_candidates.category` is nullable** — a receipt-vault-
  triggered candidate genuinely doesn't know its category yet (the user
  assigns one when confirming); a manually-created candidate may specify
  one upfront.

## Business Core design decisions (V2 Phase 5)

See [business-core.md](business-core.md) for the full reasoning. Schema-
level decisions:

- **`business_accounts` is a brand-new table, not an extension of
  `finance.accounts`** — a business account belongs to a `space_id`, not
  a `user_id`, and spec section 37 explicitly requires business/personal
  money to stay structurally isolated even though the type enum
  (BANK/CASH/E_WALLET/CREDIT_CARD) overlaps.
- **`business_account_entries.linked_expense_payment_id`/
  `linked_invoice_payment_id` carry no FK constraint** — both point at
  rows in tables created later in the same migration file
  (`expense_payments`/`invoice_payments`), so enforcing the FK would
  require reordering the whole file around a circular-looking dependency
  for two nullable, purely-informational back-references; ownership is
  already guaranteed by the application code that sets them, not the
  database.
- **`business_expenses.status` is genuinely stored**, unlike almost every
  other status field added in this project (`invoices.status`,
  `settlements` before it) — it only transitions inside the same
  transaction that inserts an `expense_payments` row, and the table's own
  CHECK constraint enumerates the exact three states (UNPAID/
  PARTIALLY_PAID/PAID), so there's no drift risk a computed value would
  otherwise need to guard against.
- **`invoices.status` CHECK only allows DRAFT/SENT/VOID** — deliberately
  narrower than the richer status vocabulary a user actually sees
  (PARTIALLY_PAID/PAID/OVERDUE), which is why those three never appear in
  the CHECK: they're computed in `InvoiceService`, never written to this
  column.
- **`quote_number`/`invoice_number`/`credit_note_number` are each
  `UNIQUE(space_id, ...)`, not globally unique** — two different business
  spaces can both have a "Q-00001"; the numbers are per-space sequences,
  generated server-side by counting existing rows, not client-supplied.
- **No Chart-of-Accounts/journal/ledger table anywhere in this
  migration** — deliberately deferred to Phase 6; see
  business-core.md's "scope boundary" section for the exact reasoning.

## Business Accounting Engine design decisions (V2 Phase 6)

See [accounting-engine.md](accounting-engine.md) for the full reasoning.
Schema-level decisions:

- **The double-entry invariant gets a real database-level safeguard, not
  just a service-level one** — a `DEFERRABLE INITIALLY DEFERRED`
  `CONSTRAINT TRIGGER` on `journal_lines`, checked at COMMIT rather than
  per-statement, since Hibernate inserts a multi-line entry's rows one
  `INSERT` at a time and an immediate trigger would reject the first line
  before its balancing line ever arrives. This is the one deferred
  constraint trigger in the entire schema; every other cross-row
  invariant elsewhere in this codebase is service-level only.
- **`journal_entries.source_id` carries no FK** — it can point at rows in
  several different tables (an invoice, an expense payment, ...)
  depending on `source_type`, and it's purely informational for tracing a
  journal entry back to the action that produced it; every real
  invariant this system needs already lives on `journal_lines`.
- **`chart_of_accounts.cash_equivalent` is a plain flag on the ledger
  account itself, not a query against `business_accounts`** — the Cash
  Flow report needs to know which ledger accounts are cash/bank-like,
  but `bizbanking` already depends on `accounting` (for posting), so
  having `accounting` query `bizbanking` back would create a cycle. A
  self-contained flag avoids it entirely.
- **`business_accounts.chart_of_accounts_id`/
  `business_expenses.chart_of_accounts_id` are both nullable, added via
  plain `ALTER TABLE`** — additive, safe, and invisible to Phase 5 code
  that never references them; a space that hasn't mapped either keeps
  working exactly as Phase 5 shipped it, with automatic posting simply
  skipping wherever a mapping is absent.
- **No `@ManyToOne` between `JournalLine` and `JournalEntry`** — same
  discipline as every other table relationship in this codebase (plain
  UUID foreign-key fields, not JPA associations); report services fetch
  entries for a space/date-range first, then their lines, and join the
  two in Java (`accounting.LedgerQueryService`) rather than reaching for
  a native SQL join.

## Reconciliation design decisions (V2 Phase 7)

See [reconciliation.md](reconciliation.md) for the full reasoning.
Schema-level decisions:

- **`reconciliation_sessions.business_statement_import_id` is
  `UNIQUE`** — exactly one session per import. The spec names "business
  statement import" and "reconciliation sessions" as separate bullets,
  so they stay separate tables, but this phase doesn't need many
  sessions working the same import concurrently.
- **`business_statement_lines.amount` is signed**, matching `statements.
  ParsedStatementRow`'s own convention (positive = money in, negative =
  money out) rather than this codebase's more common direction-enum-
  plus-unsigned-magnitude pattern (`business_account_entries.direction`/
  `.amount`) — a parsed bank statement row is inherently signed at the
  source, so normalizing it into a direction/magnitude pair here would
  be a conversion with no purpose until the line actually becomes a real
  ledger entry (at which point the service layer does exactly that
  conversion).
- **`reconciliation_line_allocations` is the only table connecting a
  statement line to a ledger entry** — no separate "split" table. A
  plain Match or Create Transaction produces exactly one allocation row;
  a Split produces several. Unifying all three actions into "N
  allocations against N entries" (N=1 or N&gt;1) avoids a parallel,
  mostly-duplicate schema just for the split case.
- **No new audit table** — five new `AuditAction` enum values (Phase 14's
  own audit_logs) satisfy the phase's "persist reconciliation history"
  requirement directly.

## Inventory & Costing design decisions (V2 Phase 8)

See [inventory-and-costing.md](inventory-and-costing.md) for the full
reasoning. Schema-level decisions:

- **No stored `quantity_on_hand`/`weighted_average_cost` column
  anywhere** — spec section 47's own words: "inventory quantity derives
  from movements. Do not store a manually mutable quantity as the sole
  source of truth." `inventory_movements` is the sole source; everything
  else is computed on read.
- **`inventory_movements.unit_cost` is `NOT NULL`, never nullable** —
  even an outbound movement gets a real, server-computed unit cost
  before the row is ever written; there's no "cost pending" state.
- **`inventory_movements.quantity` has a `CHECK (quantity &lt;&gt; 0)`
  constraint** — a zero-quantity movement carries no information and
  would silently corrupt nothing, but is still nonsensical, so it's
  rejected at both the service layer (`400 ZERO_QUANTITY`) and the
  database.
- **`product_recipe_items` has `CHECK (product_id &lt;&gt; ingredient_product_id)`
  plus a service-layer check with the same rule** — belt-and-braces
  against a product being its own ingredient, the same double-enforcement
  posture as the journal-balance invariant in Phase 6 (service-layer
  validation for a fast, friendly error; a database constraint as the
  real, unbypassable guarantee).
- **`journal_entries.source_type`'s CHECK constraint was widened, not
  replaced with a lookup table** — same approach Phase 6 established for
  itself; Postgres's default auto-generated constraint name
  (`journal_entries_source_type_check`) made the migration a plain
  drop-and-recreate.

## Fixed Assets design decisions (V2 Phase 9)

See [fixed-assets.md](fixed-assets.md) for the full reasoning.
Schema-level decisions:

- **No stored `accumulated_depreciation` column anywhere** — the same
  "derive it, don't store a manually mutable figure" rule Phase 8
  applies to inventory quantity. `asset_depreciation_entries` is the
  sole source; accumulated depreciation is always `SUM(amount)` over an
  asset's own entries.
- **`asset_depreciation_entries` has `UNIQUE(asset_id, period)`** — the
  database-level guarantee behind the same month never being posted
  twice for the same asset, backing up the service-layer
  `existsByAssetIdAndPeriod` check the same "fast friendly error at the
  service layer, real guarantee at the database layer" pattern as every
  other CHECK constraint in this schema.
- **`fixed_assets.salvage_value &lt;= cost` is a CHECK constraint** —
  an asset can't be worth less than nothing at the end of its useful
  life; caught at the database layer even if a future code path forgets
  to validate it.
- **No new `AccountType` for contra-assets** — Accumulated Depreciation
  is seeded as a plain `ASSET` and Gain/Loss on Disposal as a plain
  `REVENUE`; `NormalBalance.signedAmount`'s existing "signed relative to
  the account's own normal side" convention already makes a credited
  asset read negative and a debited revenue account read negative,
  which is exactly contra-asset and loss behavior respectively — no
  schema or enum change needed to represent either.

## Business Tax & e-Invoice design decisions (V2 Phase 10)

See [business-tax-and-einvoice.md](business-tax-and-einvoice.md) for
the full reasoning. Schema-level decisions:

- **`sst_rates` and `einvoice_mandate_rules` carry no `space_id`** —
  both are global, versioned reference data (national tax rates and a
  national rollout schedule), the same shape as `personaltax`'s
  `tax_brackets`/`tax_years`, not a per-business setting.
- **`einvoice_documents.invoice_id` is `UNIQUE`** — only one active
  e-Invoice document exists per invoice at a time, mirroring
  `reconciliation_sessions.business_statement_import_id`'s own 1:1
  `UNIQUE` constraint from Phase 7.
- **`einvoice_provider_logs` is a separate table from `audit_logs`,
  not a reuse of the existing generic audit trail** — the one deliberate
  exception to this codebase's usual "extend the existing audit enum"
  precedent (Phase 7's `RECONCILIATION_*` values, this phase's own
  `EINVOICE_*` values). Every *state transition* still goes through
  `audit.AuditLogService` as usual; `einvoice_provider_logs` additionally
  captures every raw *attempt* at a provider call, including ones that
  fail before any state changes — spec section 56's "all provider
  interactions must be auditable" is a stricter bar than "log completed
  actions." A real bug was caught here during live verification: the
  first implementation saved a failed attempt's log row in the same
  transaction as the request that then threw and rolled back, silently
  losing the very record the spec required — fixed by recording through
  a dedicated `REQUIRES_NEW`-propagated method so the log commits
  independently of the outer transaction's outcome.
- **No `business_tax_profile` table** — spec section 57's readiness
  checklist is answered almost entirely by fields `spaces.business_profiles`
  already had from Phase 5 (`tin`, `registration_number`,
  `sst_number`, `business_type`, `industry`,
  `financial_year_start`/`end`); only `annual_revenue` was missing and
  got added to the existing table rather than starting a second one.

## Cross-Space Accounting design decisions (V2 Phase 11)

See [cross-space-accounting.md](cross-space-accounting.md) for the
full reasoning. Schema-level decisions:

- **`cross_space_links.personal_transaction_id` is `NOT NULL`** — spec
  section 58's own words ("allow a transaction to be *linked*") mean an
  existing Personal transaction is always required; this module never
  creates one on a user's behalf.
- **One `LIABILITY` account ("Due to Owner") covers both directions of
  "due to/from owner"** — the same signed-balance trick Phase 9 already
  used for its own contra-asset/loss accounts, so no separate
  asset-side "Due from Owner" account was needed.
- **`related_link_id` is a self-referencing FK, not a separate junction
  table** — a reimbursement optionally points at the business-advance
  link it settles; one column is enough since each reimbursement
  settles at most one advance.
- **A pre-existing guard, not a new one, was the right fix for archived
  system accounts**: while testing the "Due to Owner account missing"
  path, archiving an existing seeded account was found to surface
  `accounting.JournalEntryService`'s own already-correct `409
  LEDGER_ACCOUNT_ARCHIVED` before this module's own "missing account"
  check is ever reached — `findByCode` was never meant to (and
  correctly does not) filter out archived accounts, since posting
  against one should fail with a specific, actionable error rather
  than silently behave as if the account didn't exist at all. The test
  originally written for "missing account" was rewritten to use a
  space with a genuinely custom Chart of Accounts that never seeded a
  Due to Owner account in the first place, rather than archiving one
  Phase 6 already seeded.

## AI Assistant V2 design decisions (V2 Phase 12)

See [ai-assistant-v2.md](ai-assistant-v2.md) for the full reasoning.
Schema-level decisions:

- **Still no new schema at all.** This phase generalized the pre-existing
  V1 AI assistant (originally documented above as "Phase 12" under the
  product spec's earlier numbering) from a single hardcoded Personal-only
  tool switch into a pluggable `AiToolProvider` architecture covering
  Personal/Business/Shared contexts — every tool is still a thin
  pass-through to an already-existing, already-authorized service, so
  there was nothing new to persist. `AffordabilityService`'s widened
  inputs (upcoming bills, debt repayments, credit utilization, savings
  goals, budget) are the same story: every figure is read from an
  existing table via an existing service.
- **`AiToolContext.SHARED` is not a `spaces.space_type` value.** The
  `space_type` CHECK constraint still only allows `PERSONAL`/`BUSINESS`
  (see Financial Spaces, V2 Phase 1) — "Shared" tools (group balances,
  settlements, Bagilah) read the pre-existing Groups/Bagilah/Settlements
  tables, which were never tied to a `financial_spaces` row to begin
  with. No third space type was added.

## Advanced Automation design decisions (V2 Phase 13)

See [advanced-automation.md](advanced-automation.md) for the full
reasoning. Schema-level decisions:

- **One learned rule per `(user_id, match_value)`, enforced by a
  partial unique index** (`uq_transaction_rules_learned_merchant`,
  `WHERE learned = TRUE AND match_type = 'MERCHANT_EQUALS'`) — confirming
  the same merchant again reinforces the existing row instead of
  accumulating duplicates, while a user is still free to hand-author as
  many overlapping rules as they like (the constraint only applies to
  auto-learned rows).
- **`recurring_invoices` reuses `recurring_transactions`' exact
  schedule shape** (`frequency`, `interval_count`, `start_date`,
  `end_date`, `next_occurrence_date`, `active`) rather than inventing a
  parallel one — same reasoning as reusing the Java
  `RecurrenceFrequency`/`RecurrenceCalculator` classes directly.
  `invoices.source_recurring_invoice_id` is the same "source_*_id"
  precedent as `invoices.converted_from_quotation_id`.
- **Dedup for the two new notification triggers lives in two different
  places, deliberately**: `BUDGET_EXCEEDED` uses a new
  `budgets.budget_exceeded_notified_at` column (the same per-entity
  "notified, cleared once resolved" pattern as
  `catalog.products.low_stock_notified_at`, since a budget row is the
  natural per-entity granularity there); `LOW_BALANCE` uses
  `notification_rules.last_triggered_at` on the rule row itself, since
  a user's balance has no other per-entity row to hang a timestamp on.
- **`notification_rules` has no row for a type until the user changes
  it from its default** — the same "absence has a clear, type-specific
  meaning" choice as `subscriptions.user_subscriptions` and
  `group_budgets` before it, just with a default that varies by type
  (`true` for four types, `false` for `LOW_BALANCE`) rather than a
  single global default.
- **No new schema for "receipt automation"'s transaction-matching
  suggestions or "intelligent reconciliation"'s bulk auto-match** —
  both are computed fresh on every call from existing tables
  (`transactions`, `business_account_entries` via the existing
  allocation table), the same "never persisted, computed fresh"
  discipline `reconciliation.MatchingService.suggestMatches` already
  established. `receipts.overall_confidence` is the one new column
  needed for the Vault to catch up to a value the Bagilah scan flow
  already persisted.

## Testing against a real database

`DuitlahApiApplicationTests` (and any future test needing the database)
uses Testcontainers with `@ServiceConnection` (see
`apps/api/src/test/java/com/duitlah/api/TestcontainersConfiguration.java`)
to run tests against a real, disposable Postgres container rather than an
in-memory substitute like H2. This avoids the class of bugs where tests
pass against a fake database but fail against real Postgres-specific
behavior (types, constraints, locking).

## Final hardening design decisions (V2 Phase 14)

No migration was required. Payment writes lock their parent `settlements`
row before summing the append-only `settlement_payments` ledger and enforcing
the remaining-balance cap. This serializes concurrent writers without adding
a cached paid-total column.

Backup/restore uses PostgreSQL custom format without owner/privilege metadata.
The smoke check restores into an isolated `duitlah_restore_check` database,
compares Flyway version and public-table count, then drops only that database.

## Monthly Wrapped design decisions

`V30__monthly_wrapped.sql` adds a single `monthly_wrapped` table:
`user_id` + `year` + `month` (`UNIQUE`, the real backstop against a
duplicate under concurrent requests), a denormalized `persona_id` so the
history list can render "August — Cafe Hunter" without deserializing
every row's full payload, `sufficient_data`, a `payload TEXT` column
holding the full `WrappedResult` as a JSON blob — the same "hand the
whole computed artifact to a JSON column" precedent as
`receipts.parsed_result_json`, chosen because this data is a versioned,
read-only computed artifact only ever fetched whole and rendered, never
queried by individual field — plus `wrapped_version`, `generated_at`,
and a nullable `viewed_at`. No join tables: a dozen tightly-coupled
tables for the persona/insights/goal breakdown would add real schema
complexity this codebase never needs to query relationally. See
[monthly-wrapped.md](monthly-wrapped.md).
