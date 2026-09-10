# Architecture

Duitlah is a monorepo with three deployable applications and shared infrastructure config at the root.

```text
Duitlah/
  apps/
    mobile/  Flutter app (Dart) — PRIMARY client as of Phase 9.5
    web/     Next.js frontend (TypeScript, Tailwind, shadcn/ui) — secondary/web companion
    api/     Spring Boot backend (Java 17, modular monolith) — sole authoritative backend
  docs/
  docker-compose.yml
```

## Phase 9.5: Flutter as primary client

As of Phase 9.5, `apps/mobile` (Flutter/Dart, iOS + Android) is the
**primary** client and `apps/web` is **secondary** — a web companion for
guest Bagilah access (no app install required), a future admin dashboard,
and landing/marketing pages. Neither change alters `apps/api`: the same
Spring Boot backend, the same `/api/v1` surface, the same database, is the
single authoritative implementation both clients consume identically.

**One-source-of-truth rule (non-negotiable):** all business/financial
logic — the Bagilah calculation engine, settlement/debt-simplification,
bill-state transitions, authorization — lives exclusively in
`com.duitlah.api.*` (see below). Neither `apps/web` nor `apps/mobile` may
independently compute a split, a total, a settlement obligation, or a
payment state; both are presentation layers over the same API. A Phase 9.5
audit of the entire `apps/web` frontend (grep for arithmetic, aggregation,
percentage/split computation, and any Next.js server-side code path)
confirmed this was already true going into the pivot — no logic needed to
move, so `apps/mobile` was built directly against the existing API rather
than requiring backend changes first.

`apps/mobile` reuses every existing backend mechanism rather than adding
new ones:

- **Auth** — the same JWT-access-token + httpOnly-style refresh-token
  model (`docs/security.md`), via a Dio `PersistCookieJar` backed by
  `flutter_secure_storage` instead of a browser cookie jar.
- **Realtime** — the same SSE endpoints (`BillEventBroadcaster`), consumed
  by streaming a Dio response and splitting on blank lines in Dart, the
  same buffering approach as the web app's `use-bill-events.ts`.
- **Guest Bagilah** — the same `BagilahGuestController` endpoints and
  24-hour opaque guest token, called directly from a native screen (no
  WebView) so a guest never needs to install the app.
- **Invite links/QR** — the same invite-token string the backend already
  returns (`GET /bills/{id}/invite-token`); the QR code is rendered
  locally by whichever client displays it (`qrcode.react` on web,
  `qr_flutter` on mobile) from that one shared URL,
  `{webOrigin}/bagilah/join?token=...`. Opening it on a phone with the app
  installed opens the app (once real universal-link verification —
  Apple's App Site Association file, Android's `assetlinks.json` — is
  deployed against a real domain/Team ID); without the app, it falls back
  to the existing `apps/web` guest flow untouched.

See `apps/mobile`'s own structure below the frontend section, and
[security.md](security.md) for the mobile auth/biometric details.

## Backend: modular monolith

`apps/api` is a single Spring Boot application organized into modules under
`com.duitlah.api.*`, one package per domain area (see each package's
`package-info.java` for its responsibility):

```text
auth, users, profiles, finance, transactions, budgets, goals, groups,
bagilah, settlements, receipts, notifications, analytics, recurring,
subscriptions, ai, audit, feedback, telemetry, spaces, autotrack, statements,
bills, liabilities, networth, finhealth, exports, personaltax
```

The Phase 0 scaffold originally planned a separate `bills` package for
"bill/receipt lifecycle shared by manual splitting and Bagilah," distinct
from `bagilah` itself — that split never happened. `Bill`/`ReceiptItem`
and everything else in the calculation engine landed in `bagilah` in
Phase 6 because there was never a real second consumer of a standalone
"bill" concept to justify carving it out; the empty `bills` package-info
was deleted in Phase 8 rather than left as a stale, misleading claim
about where things live.

Plus two cross-cutting packages:

- `common` — conventions shared by every module: `ApiError`/`ApiException`
  and `GlobalExceptionHandler` (see [api.md](api.md)); `common.jpa`'s
  `AuditableEntity` (created_at/updated_at) and `OneTimeToken`
  (hash-stored, expiring, single-use tokens) mapped superclasses, meant to
  be extended rather than reimplemented per-entity; `common.security`'s
  `SecureTokens` for generating/hashing opaque tokens; `common.mail`'s
  `EmailSender` interface (only implementation today is `LoggingEmailSender`
  — see [security.md](security.md)); `common.storage`'s `ObjectStorage`
  interface (S3-compatible — see the Phase 8 note below).
- `config` — application-wide Spring configuration (security, CORS, OpenAPI).

Modules should depend on each other's public service/DTO surface only, not
internal classes — this is what keeps future extraction into separate
services possible without a rewrite. No module boundaries are enforced by
tooling yet; this is a discipline to maintain as modules gain real code in
later phases.

`finance` (accounts, categories) and `transactions` are intentionally
bidirectionally coupled — `TransactionService` depends on `finance`'s
`AccountService`/`CategoryService` for ownership and category-type
validation, and `finance`'s `AccountService` depends on `transactions`'
`TransactionRepository` to compute a balance (see
[database.md](database.md)). A personal ledger is genuinely one concept
split across two packages for readability, not two independent domains;
introducing a third "ledger" abstraction to avoid the cross-dependency
would be premature structure for what these two modules actually do today.
`analytics`'s `DashboardService` depends on both for the same reason — a
basic monthly summary is a read-only composite view, not its own domain.

`budgets` follows the same pattern: `BudgetService` depends on `finance`'s
`CategoryService` (to validate a budget's category and resolve it to
itself-or-its-children — see [database.md](database.md)) and
`transactions`' `TransactionRepository` (to compute how much has been
spent). `goals` stands alone — it doesn't touch transactions at all,
since goal progress is tracked via its own `goal_contributions` ledger,
not derived from the transaction history (a deliberate simplification;
"log RM500 toward Japan Trip" is a separate action from "spend RM500,"
not the same one viewed two ways).

`groups` depends on `users`' `UserRepository` directly (not through a
service) purely to batch-resolve display names/emails for member lists,
expense payers, and balances — a read-only lookup, not a business
dependency. It does not depend on `finance`/`transactions` at all: a group
expense is tracked entirely in its own `group_expenses` /
`group_expense_shares` ledger (see [database.md](database.md)), separate
from personal accounts. Whether/how a settled group expense should also
show up in personal transaction history is a `settlements`-phase question
(Phase 9), not decided here.

`bagilah` depends on `users`' `UserRepository` (same read-only display-name
lookup as `groups`) and on `groups`' `GroupMemberRepository` — a bill can
optionally be scoped to a group (`bills.group_id`), and creating one
checks the requester is actually a member via that repository directly,
the same "depend on the other module's repository for a plain lookup, not
a business rule" pattern already established by `groups`→`users`. It does
not depend on `finance`/`transactions`: a bill's items/claims/payments are
their own ledger (`receipt_items`, `item_claims`, `bill_payments`,
`bill_final_amounts` — see [database.md](database.md) and
[bagilah-engine.md](bagilah-engine.md)), separate from personal accounts
and from Groups' own lighter equal-split expense mechanism. The
calculation engine itself (`BagilahCalculationEngine`) is intentionally
free of any Spring/JPA dependency (it only uses `common.money`'s pure
utilities) so it can be property-tested as plain Java, independent of
`BillService`'s persistence and authorization concerns.

`bagilah` also depends on `auth`'s `JwtService` (Phase 7) — but only to
manually check for an optional Bearer token on the one public join
endpoint (`BagilahJoinController`), the same validation
`JwtAuthenticationFilter` already does for every authenticated route.
This is a read-only utility call, not a security-boundary dependency:
guest identity (`bill_guest_sessions`) is resolved entirely separately,
by direct repository lookup in `BillService`, and never flows through
`JwtService`, `JwtAuthenticationFilter`, or Spring Security's
`Authentication` at all — see [database.md](database.md) and
[bagilah-engine.md](bagilah-engine.md) for why that separation is
deliberate rather than incidental.

Bagilah's real-time updates (`BillEventBroadcaster`, Phase 7) hold live
SSE connections in an in-memory `Map` inside the single API process.
This is fine for how the app actually runs today — one `api` container in
`docker-compose.yml` — but would silently stop working correctly the
moment a second instance existed behind a load balancer (an emitter
registered on instance A can't be reached by an event published on
instance B). A future horizontally-scaled deployment would need this
backed by Redis pub/sub instead (Redis is already provisioned for cache/
rate-limiting — see below), not something to build now for a scaling
scenario that doesn't exist yet.

`receipts` (Phase 8: upload → OCR → structured items → user verification
→ Bagilah, product spec section 10) depends on `bagilah`'s `BillService`
for exactly one thing: turning a confirmed scan into a real bill.
`ReceiptScanService.confirm` calls `BillService.create`/`addItem`/`update`
directly — the same public methods a manual "New bill" dialog calls — so
a confirmed scan is an ordinary Phase 6/7 bill from that point on, not a
parallel data model. `receipts` also depends on `common.storage`'s
`ObjectStorage` (the receipt image) and defines its own
`ReceiptOcrService` interface (the vision/OCR provider) — see
[bagilah-engine.md](bagilah-engine.md) for both. Nothing in `bagilah`
depends back on `receipts`.

`settlements` (Phase 9: who-owes-whom, debt simplification, payment
status — product spec section 9) is depended on by both `bagilah` and
`groups`, never the other way: `BillService.finalizeBill` and
`GroupService.settleGroup` each compute their own net positions and hand
them to `SettlementService.generateSettlements`, which knows nothing
about bills or groups beyond the opaque `sourceType`/`sourceId` it's
given. This mirrors `receipts`→`bagilah`: the module that *produces* a
settlement-worthy event depends on the module that *records*
settlements, not the reverse — `settlements` has no knowledge of, and no
dependency on, `bagilah` or `groups` at all. `DebtSimplifier` (the
greedy who-owes-whom reduction — see [database.md](database.md)) is a
pure utility with the same "no Spring/JPA, directly unit-testable" shape
as `BagilahCalculationEngine`/`common.money`'s allocators.

`recurring` (Phase 10: recurring transactions and subscriptions —
product spec's Advanced Personal Finance section) depends on
`transactions`' `Transaction`/`TransactionRepository` directly, the same
"reach into the module that owns the ledger" shape as `budgets` and
`finance`↔`transactions`: `RecurringTransactionService.materializeAllDue`
constructs and saves ordinary `Transaction` rows (tagged via
`transactions.recurring_transaction_id`, see [database.md](database.md))
rather than maintaining any parallel balance or history of its own. It
does not depend on `bagilah`/`groups`/`settlements` at all — a recurring
rule only ever produces personal-ledger transactions. `analytics` depends
on `recurring` for exactly two read paths — the calendar view (blending
posted transactions with `RecurrenceCalculator.occurrencesBetween`
projections of not-yet-due rules) and the forecast (`scheduledIncome`/
`scheduledExpense` derived from active rules) — the same "read-only
composite view" relationship `analytics` already had with `finance`/
`transactions` since Phase 0. `RecurrenceCalculator`, like
`DebtSimplifier`/`BagilahCalculationEngine`, is pure Spring/JPA-free date
math, unit-tested directly.

The recurring-transaction materialization job
(`RecurringTransactionScheduler`, `@Scheduled`, added via a new
`config.SchedulingConfig`/`@EnableScheduling`) is, like
`BillEventBroadcaster`'s SSE connections, an in-process, single-instance
mechanism — correct for the one `api` container `docker-compose.yml` runs
today, and something a future horizontally-scaled deployment would need
to revisit (a distributed lock, or moving materialization to an external
scheduler) rather than something solved speculatively now.

`groups` (Phase 11: Special Group Modes — Trip, Housemate, Couple, Shared
Goals) gained new sibling classes (`GroupGoal`/`GroupGoalService`,
`GroupBudget`) rather than a new module, since every Phase 11 feature is
inherently a group sub-resource with the exact same membership-based
authorization `GroupService` already implements — there was no real
second domain here to justify carving one out, the same reasoning that
kept `bagilah`'s calculation engine inside `bagilah` rather than a
separate `billing` module in earlier phases. `GroupGoalService` is a
sibling service in the same package (not a method on `GroupService`
itself) because shared goals have their own sub-resource lifecycle
(create/list/update a goal, add/list/delete contributions) distinct
enough to warrant a dedicated class, mirroring how `com.duitlah.api.goals`
is its own package rather than living inside `finance`. Couple mode adds
no new backend code at all — see [database.md](database.md) for why "Mine
· Yours · Ours" is already satisfied by existing mechanisms.

`ai` (Phase 12: AI Financial Assistant — product spec sections 40-42)
depends on `analytics`, `budgets`, `goals`, and `settlements`, but only
through one new class, `FinanceQueryService`, which is nothing more than
a named set of read-only pass-through methods to those modules' existing
services. This is the literal implementation of the spec's own
architecture diagram (`User Question -> Permission + Intent -> Finance
Query Layer -> Structured Financial Summary -> AI -> Natural Language
Explanation`): `ClaudeAiChatService`'s tool-use loop can only ever call
one of `FinanceQueryService`'s fixed methods, scoped to the one userId the
request was made with, so there's no path for the model to reach a
repository or run its own query. `AffordabilityService` sits beside it
depending on the same modules for the same reason, but is intentionally
*not* AI code — see [database.md](database.md) for why its math and the
`ai` package's LLM calls are kept structurally separate. Same "optional
external provider" shape as `receipts.ReceiptOcrService`/`common.mail.
EmailSender`: `ClaudeAiChatService` (real, raw-HTTP against Anthropic's
Messages API, same style as `receipts.ClaudeVisionOcrService`) and
`UnavailableAiChatService` (fallback) both implement `AiChatService`,
selected by whether `duitlah.ai.chat.anthropic-api-key` is configured.

`subscriptions` (Phase 13: Premium Subscriptions — product spec sections
53-57) is the first module with a real two-way dependency: it depends on
`groups`' and `receipts`' *repositories* directly (read-only usage
counts — active group ownership, monthly receipt scans — the same "plain
lookup, not a business dependency" shape as `groups`→`users.
UserRepository`), while `GroupService`/`ReceiptScanService` in turn depend
on `subscriptions.SubscriptionService` for enforcement before creating a
group or running an OCR scan. This isn't circular in the way that matters
to Spring: `SubscriptionService` never calls back into `GroupService` or
`ReceiptScanService`, only their repositories, so there's no cycle in the
actual bean-instantiation graph, just a mutual relationship between two
packages — see [database.md](database.md) for why the limits themselves
(3 active *owned* groups, 5 receipt scans/month) are enforced the way they
are. `SubscriptionVerifier` (Apple/Google/Web) is unconditionally wired to
`UnavailableSubscriptionVerifier` today — this phase's spec explicitly
asks to "prepare" that architecture, not integrate real store accounts
this repository has no credentials for; see database.md's Phase 13
section for the full reasoning.

`audit` (Phase 14: Hardening — product spec section 50) is a genuinely
one-directional cross-cutting dependency: `bagilah`, `transactions`,
`settlements`, `groups`, `receipts`, `users`, and `auth` each depend on
`audit`'s `AuditLogService` (a single `record(...)` method call inline at
the 8 call sites the spec names), and `audit` depends on nothing else —
no service, no repository outside its own `AuditLogRepository`. This is
the same shape `common.mail.EmailSender` and `common.storage.
ObjectStorage` already have (many modules call in, the callee calls
nothing back), which is why it's a plain package rather than `common`
itself: it has real domain state (`audit_logs`) of its own, unlike
`common`'s stateless utilities. `AuditLogService.record` deliberately
swallows its own exceptions (see [database.md](database.md)) so this
fan-in can never turn a broken audit write into a broken business
operation for any of its seven callers.

`common.idempotency` (Phase 14) is the other new cross-cutting piece,
but it isn't a module any service depends on at all — `IdempotencyFilter`
sits in the Spring Security filter chain itself
(`config.SecurityConfig`, right after `JwtAuthenticationFilter`), acting
on the raw `Idempotency-Key` header before a request ever reaches a
controller. No controller or service anywhere calls into it; it's
transparent to every module the same way `JwtAuthenticationFilter`
already is. See [api.md](api.md) and [security.md](security.md) for the
actual deduplication mechanism.

`feedback` (Phase 15: Public Launch) is a small, standalone module —
one entity, one repository, one service, one controller — with no
dependency on, or from, any other module. It doesn't reuse `audit`'s
table or service despite both being "record something that happened":
`audit_logs` exists to reconstruct what a user *did* to real financial
data (system-of-record, append-only, actor-scoped by the 8 named
actions), while `feedback` is a user *telling* Duitlah something,
structurally closer to a support ticket than a security log. Conflating
the two would make `audit_logs` a dumping ground for anything
loosely "worth recording," eroding the one property that makes it
useful (see [database.md](database.md)).

`telemetry` (Phase 15) is the other new cross-cutting package, matching
`audit`'s one-directional fan-in shape: `common.error.
GlobalExceptionHandler` depends on `ErrorReportingService`, and `auth`/
`subscriptions` depend on `ProductAnalyticsService`, but `telemetry`
depends on nothing else. It's deliberately not named `analytics` —
that package name was already taken by the user-facing personal-finance
dashboard feature (forecasts, monthly trends) since Phase 0; reusing it
for engineering observability would have made both meanings ambiguous
at every import site. Both `ErrorReportingService` and
`ProductAnalyticsService` follow the same "optional external provider,
honest fallback" shape as `common.mail.EmailSender`/`receipts.
ReceiptOcrService`/`ai.AiChatService`: a `Logging*` implementation is
always active, and a `Webhook*` implementation (a generic JSON POST, not
one vendor's proprietary protocol — see the class Javadocs) takes over
only once a URL is actually configured. Posting to that webhook is
fire-and-forget (`HttpClient.sendAsync`, not `.send`) specifically
because `ErrorReportingService.report` is called from exception-handling
code already returning an error response to the caller — it must never
add its own latency, or its own failure, to that response.

`spaces` (V2 Phase 1: Financial Spaces — see [financial-spaces.md](financial-spaces.md))
is the first module belonging to the Duitlah V2 upgrade rather than the
original 15-phase product spec. It depends on nothing but `users`
(`AuthService.register` calls `SpaceService.createPersonalSpaceForNewUser`
immediately after saving the new user row) and nothing yet depends on it
— no existing module reads `space_id` from anywhere, since no existing
table has one. This is deliberate: V2 Phase 1 introduces the workspace
concept in isolation, verified on its own, before any later V2 phase
wires existing or new modules to it.

`autotrack` (V2 Phase 2: Duitlah AutoTrack — see [autotrack.md](autotrack.md))
is a genuinely one-directional fan-in module, the same shape `audit`/
`settlements` already have: `receipts` and `statements` each depend on
`autotrack.TransactionCandidateService` to record a suggestion, and
`autotrack` depends on nothing from either — only on `transactions`
(`TransactionService.create`, the same public entry point a manual "Add
transaction" uses) and `finance`/`spaces` for account/space lookups.
`statements` (bank statement CSV/XLSX/PDF import) depends on `autotrack`,
`finance` (account ownership), `spaces` (personal-space tagging), and
`common.storage`. `receipts` gained a second entity, `Receipt` (the
Receipt Vault), alongside its existing Bagilah-only `ReceiptScan` — the
two are deliberately separate rows/tables/flows sharing only the same
`ReceiptOcrService` interface, not a merged concept; `ReceiptScanService`
and everything Bagilah-facing is completely unchanged by this phase.

`bills`, `liabilities`, `networth`, `finhealth`, and `exports` (V2 Phase
3 — see [personal-gap-closure-ii.md](personal-gap-closure-ii.md)) form a
small dependency fan-in: `finhealth.FinancialHealthService` reads from
`analytics`, `finance`, `budgets`, `bills`, and `liabilities` but nothing
reads from it; `networth.NetWorthService` reads from `finance` and
`liabilities`; `liabilities.CreditCardService` extends `finance.Account`
(a card stays an ordinary account, extended by a one-to-one companion
row) rather than introducing a parallel liability concept for cards, so
purchases/repayments reuse the existing transaction/transfer machinery
untouched; `exports.ExportService` reads from `transactions`, `bills`,
`liabilities`, `networth`, and `budgets` to produce CSV/XLSX/PDF files,
writing nothing back to any of them. `notifications` (previously an
empty Phase 9.5 placeholder — see the package's own Javadoc) is now real:
`NotificationService` fans out to every `NotificationProvider` bean, and
is depended on by `bills.PersonalBillScheduler` for due-date reminders.

`personaltax` (V2 Phase 4 — see [personal-tax.md](personal-tax.md)) is
another fan-in module: it reads from `receipts` (a real Vault entry can
feed it) and depends on `exports.PdfExportWriter` for its preparation
summary, but nothing reads from it. The one two-way relationship is with
`receipts` itself — `ReceiptVaultService.upload` calls into
`personaltax.TaxReliefCandidateService.createFromReceipt` for a
`TAX_EVIDENCE`-tagged upload, the same "producer depends on recorder"
shape `autotrack`'s relationship with `receipts`/`statements` already
established (see docs/autotrack.md), just one hop further out.

V2 Phase 5 (see [business-core.md](business-core.md)) adds six new
modules (`crm`, `catalog`, `bizbanking`, `bizexpenses`, `sales`,
`bizdashboard`) that turn a Business space from Phase 1's
name-and-profile shell into a working workspace, plus a real RBAC
extension to the existing `spaces` module
(`SpaceService.requirePermission`, previously unenforced since the
`SpaceRole` enum's own Javadoc deferred that to "module-by-module as
each Business feature... arrives in later phases" — this is that
arrival). Dependency shape: `crm`/`catalog`/`bizbanking` are the
foundation layer (no dependencies on each other's siblings);
`bizexpenses` depends on `crm.SupplierService.requireOwned` and
`bizbanking.BusinessAccountService` for payment posting; `sales`
depends on `crm.CustomerService.requireOwned`, `catalog.ProductService.
requireOwned`, and `bizbanking.BusinessAccountService`; `bizdashboard`
is a pure fan-in reading from all of the above through their own public
service methods, nothing reads from it. No module in this phase reads
or writes any accounting-ledger concept — there isn't one yet; see
business-core.md's own "scope boundary" section for why the section
34-36 double-entry material is explicitly Phase 6's, not this phase's.

V2 Phase 6 (see [accounting-engine.md](accounting-engine.md)) adds one
new module, `accounting` (Chart of Accounts, journal entries/lines,
accounting periods, General Ledger/Trial Balance/P&L/Balance Sheet/
Cash Flow reports, exports), and inverts the dependency direction Phase
5's own text predicted: `bizbanking`, `bizexpenses`, and `sales` each
gained a new dependency *on* `accounting` (for chart-of-accounts
mapping and automatic double-entry posting), while `accounting` itself
depends on nothing from any of the three — the same one-directional
"producer depends on recorder" shape as `receipts` → `personaltax`,
applied three times over. The double-entry invariant (every entry's
debits equal its credits) is enforced both in the database (a deferred
constraint trigger on `journal_lines`) and in `JournalEntryService`
before an insert is attempted — see accounting-engine.md for why both
layers matter. Automatic posting is a best-effort enhancement: a space
that hasn't seeded a chart of accounts, or hasn't mapped a specific
business account/expense to a ledger account, keeps using every Phase
5 feature exactly as it worked before this phase existed.

V2 Phase 7 (see [reconciliation.md](reconciliation.md)) adds one new
module, `reconciliation` (business statement import, a deterministic
matching engine, reconciliation sessions, the four line-level Match/
Create Transaction/Ignore/Split actions, and session-level Resolve
Difference). It depends on `statements` (reusing Phase 2's parser
adapters directly rather than a second parsing code path), `bizbanking`
(validating/creating `business_account_entries`), and `audit` (five new
`AuditAction` values extend the existing generic audit trail rather than
a reconciliation-specific one) — nothing depends back on it. Unlike
Phase 6's automatic posting, reconciliation state (`UNMATCHED`/
`MATCHED`/`CREATED`/`IGNORED`/`SPLIT`) genuinely persists and mutates
across a session's lifetime, which is why it's a full module rather
than another `AutomaticPostingService`-style enhancement bolted onto an
existing action.

V2 Phase 8 (see [inventory-and-costing.md](inventory-and-costing.md))
adds one new module, `inventory` (stock movements, Weighted Average
Cost, COGS, ingredient/recipe costing, low-stock alerts). It depends on
`catalog` (the `Product` entity gained `trackInventory`/`reorderPoint`/
etc.), `accounting` (two new `AutomaticPostingService` methods reusing
Phase 6's already-seeded Inventory/COGS system accounts), and `spaces`
(a new system-use-only `listActiveMemberUserIdsWithPermission` method
for the low-stock scheduler). The one exception to "producer depends on
recorder": `sales.InvoiceService` depends on `inventory`, not the
reverse, so that issuing an invoice for a tracked-inventory product can
auto-post a SALE movement and COGS — here `sales` is the producer of a
sale event that `inventory` needs to know about, the same direction as
`receipts` → `personaltax`. Like every derived balance in this
codebase, quantity on hand and Weighted Average Cost are computed on
read from `inventory_movements`, never stored.

V2 Phase 9 (see [fixed-assets.md](fixed-assets.md)) adds one new
module, `assets` (the asset register, depreciation, disposal, journal
generation). It depends on `accounting` (three new
`AutomaticPostingService` methods — acquisition, depreciation,
disposal — reusing Phase 6's already-seeded but previously-unused
"Fixed Assets" account, plus two new seeds this phase adds,
"Accumulated Depreciation" and "Depreciation Expense") and `bizbanking`
(the optional business account an asset was paid from, or disposal
proceeds were received into). Nothing depends back on `assets` — unlike
`inventory`, no other module's write path needs to know an asset
exists. Accumulated depreciation is computed on read from an
append-only `asset_depreciation_entries` ledger, the same
computed-never-stored discipline as every other balance in this
codebase; Accumulated Depreciation and Gain/Loss on Disposal are both
seeded as plain `ASSET`/`REVENUE` account types rather than a new
contra-account concept, since `NormalBalance`'s existing
signed-relative-to-normal-side convention already produces the correct
negative balance for a credited asset or a debited revenue account.

V2 Phase 10 (see
[business-tax-and-einvoice.md](business-tax-and-einvoice.md)) adds two
new modules. `businesstax` (business tax infrastructure, SST,
e-Invoice readiness rules) depends on `spaces` (almost every field
spec section 57's readiness checklist needs already existed on
`BusinessProfile`) and `accounting` (SST reporting reuses the General
Ledger rather than a second tax-tracking mechanism). `einvoice` (the
MyInvois provider abstraction and submission workflow) depends on
`sales` — the one further exception to "producer depends on recorder"
alongside Phase 8's: submission is a distinct user-initiated action on
an already-issued invoice, not an automatic side effect of issuing it,
so `einvoice` reads `sales.Invoice` rather than `sales` calling into
`einvoice`. Nothing depends back on either new module. `EInvoiceProvider`
is a swappable interface (`MyInvoisProvider`/`UnavailableEInvoiceProvider`
in production code, `MockEInvoiceProvider` in test sources only) —
`UnavailableEInvoiceProvider` is the default bean everywhere until a
space configures real LHDN credentials, so "production must never
return fake success" holds by construction, not by convention.

V2 Phase 11 (see
[cross-space-accounting.md](cross-space-accounting.md)) adds one new
module, `crossspace` (personal-paid business expense, reimbursement,
owner contribution, owner drawing, and a consolidated read-only
Personal+Business net worth view). It depends on `transactions` (the
Personal side being linked — an existing row, never synthesized),
`accounting` (four new `AutomaticPostingService` methods, plus
`BalanceSheetService`'s equity figure for the combined view),
`bizbanking` (the real cash-ledger movement that accompanies
reimbursement/contribution/drawing), `spaces`, and `networth`. Nothing
depends back on `crossspace` — like `assets` and `businesstax`/`einvoice`
before it, this module only reads from and posts into modules that
already existed, rather than anything depending on it in turn. A
Personal transaction can only ever be linked by the user who owns it —
the module has no path for one member of a business to reference
another person's private transaction data.

V2 Phase 12 (see [ai-assistant-v2.md](ai-assistant-v2.md)) doesn't add a
new module — it generalizes `ai` itself. The single hardcoded
Personal-only tool switch inside `ClaudeAiChatService` became a
pluggable `AiToolProvider` interface (matching the `EInvoiceProvider`/
`NotificationProvider` shape), with three implementations —
`PersonalAiToolProvider`, `BusinessAiToolProvider`, `SharedAiToolProvider`
— each scoped to an `AiToolContext` and each still nothing more than a
named set of read-only pass-through methods, the same discipline
`FinanceQueryService` established for V1. `BusinessAiToolProvider` pulls
in `bizdashboard`, `accounting`, `sales`, `bizexpenses`, `inventory`,
`businesstax`, and `reconciliation`; `SharedAiToolProvider` pulls in
`groups`, `settlements`, and `bagilah` — none of which `ai` depended on
before. `ChatRequest.activeSpaceId` (spec section 66, "AI must understand
active Financial Space") decides which providers are active per request:
`ClaudeAiChatService` resolves it via `spaces.SpaceService.getSpace`
(the same membership-enforcing chokepoint every other module uses) and
activates `BusinessAiToolProvider` only once that resolves to a real
`BUSINESS` space the caller belongs to; Personal and Shared providers are
always active. `AiToolContext.SHARED` is not a third `SpaceType` — Groups/
Bagilah/Settlements were never tied to a `FinancialSpace` to begin with,
so "Shared" tools just read those existing modules directly.
`AffordabilityService` (spec section 68) gained five more dependencies
(`bills`, `liabilities`, `finance.AccountService`, `goals`, `budgets`) to
widen its inputs, but is still deliberately not AI code — no LLM call was
added to that class. Nothing depends back on `ai`.

V2 Phase 13 (see [advanced-automation.md](advanced-automation.md)) adds
one new module, `transactionrules`, and extends five existing ones
rather than adding further new packages. `transactionrules` depends on
`finance` (category validation) and is in turn depended on by
`autotrack` (`CategorySuggestionService` now consults it first,
`TransactionCandidateService` calls its `learnFromConfirmation` on
every candidate confirmation) — the reverse of `ai`'s shape from the
phase before it, where a new package was the thing everything else
started depending on. `sales` gained `RecurringInvoice`/
`RecurringInvoiceLineItem`/`RecurringInvoiceService` as sibling classes
in the same package (not a new module), reusing `recurring`'s
`RecurrenceFrequency`/`RecurrenceCalculator` directly — the same
"already-public module surface, no reason to duplicate" reasoning
`crossspace` applied to `accounting`'s constants in Phase 11.
`reconciliation` gained one new orchestration method
(`ReconciliationActionService.autoMatchExact`) that composes its own
existing `MatchingService.suggestMatches` and `match(...)` rather than
introducing a new matching algorithm. `receipts` gained a
transaction-matching suggestion method and a `bills` gained a new
one-directional dependency on `receipts` (`PersonalBillService.
attachReceipt` calls `ReceiptVaultService.get` to verify ownership) —
the first new cross-module dependency `bills` has taken on since it was
introduced. `notifications` gained `NotificationRuleService`, consulted
by `NotificationService.notify` itself; `budgets` gained a new
scheduler depending on `notifications`, and a new
`analytics.LowBalanceAlertScheduler` depends on both `notifications`
and `analytics`'s own `DashboardService` — the same "scheduler lives in
the domain that owns the triggering condition" shape `inventory.
LowStockAlertScheduler` and `bills.PersonalBillScheduler` already
established. Nothing depends back on `transactionrules` beyond
`autotrack`'s one consultation call, and nothing new depends on `ai`.

## Phase 10: mobile-only feature work

Phase 10 (Advanced Personal Finance: recurring transactions,
subscriptions, calendar, analytics, cash-flow forecasting) is the first
phase built entirely under the Phase 9.5 client hierarchy rather than
migrating into it after the fact: the backend gained the usual new
module (`recurring`, above) and new `analytics` endpoints as always, but
the *only* new client UI is in `apps/mobile` — three new screens
(Recurring & Subscriptions, Insights, Calendar) plus a forecast teaser on
Home. `apps/web` was deliberately not touched for any of it. This is a
direct, explicit consequence of Flutter being the primary client as of
Phase 9.5: building the same feature twice into both a primary and a
secondary client is the kind of duplicated-effort default that made sense
in the Next.js-only era and no longer does, so from Phase 10 onward, new
client-facing features are Flutter-first (and Flutter-only, unless a
feature specifically needs a `apps/web` surface — e.g. the guest Bagilah
flow, the future admin dashboard). The backend remains the single
authoritative implementation for both clients regardless, per the
Phase 9.5 one-source-of-truth rule above; this only changes which
client(s) bother to render a given feature's UI.

Phase 11 (Special Group Modes) continues this pattern exactly: new
backend logic in `groups` as always, and the only new client UI is inside
`apps/mobile`'s existing `groups` feature (no new Flutter feature module
needed — Trip/Housemate/Shared-Goals UI are new sections within the
existing `GroupDetailScreen`, conditional on `group.type`). `apps/web`
again untouched.

Phase 12 (AI Financial Assistant) is the same pattern once more, but with
a new Flutter feature module this time (`features/assistant`) since,
unlike Trip/Housemate mode, the assistant isn't a section within an
existing screen — it's its own chat surface plus an affordability check,
reached from the More menu. `apps/web` remains untouched.

Phase 13 (Premium Subscriptions) again adds one new Flutter feature
module (`features/subscriptions`): a Duitlah+ screen showing current
plan/usage, and a reusable `showUpgradeDialog` shown from any screen that
hits a FREE-tier limit (today: creating a group, scanning a receipt) —
see [database.md](database.md) for why those two limits exist and how
they're computed. The dialog is deliberately the only paywall UI in the
app; there's no "Subscribe" button anywhere; since no real store
integration exists yet (see the `subscriptions` module note above), a
purchase button would have nothing real to do. `apps/web` remains
untouched.

## Frontend

`apps/web` is a standard Next.js App Router project. State/data conventions:

- **Server state** (anything from the API) goes through TanStack Query via
  `src/lib/api-client.ts`, a typed fetch wrapper that throws `ApiRequestError`
  on non-2xx responses, matching the backend's `ApiError` shape. It also
  owns the access-token-refresh-and-retry dance for authenticated requests
  (see [security.md](security.md)) — routes never need to think about it.
- **Auth state** (`src/stores/auth-store.ts`, Zustand) holds the in-memory
  access token, current user, and a `loading | authenticated |
  unauthenticated` status, bootstrapped once on app start
  (`Providers`'s `AuthBootstrap`) by trading the httpOnly refresh cookie
  for a fresh access token. `<RequireAuth>` (`components/auth/`) gates
  protected pages on that status — client-side UX only, not the real
  security boundary, which is always the API.
- **Forms** use React Hook Form + Zod (`src/lib/validation/`).

**Phase 15 (Public Launch) split `/` in two.** Before Phase 15, `/` was
the authenticated dashboard itself — a logged-out visitor hitting the
bare domain just bounced straight to `/login` with no public content at
all, which defeats the entire purpose of a public launch. The dashboard
moved, unchanged, to `/dashboard`; `/` is now a real marketing landing
page, and a new `(marketing)` route group (`/`, `/privacy`, `/terms`,
`/help`, `/faq`, `/status`) holds every logged-out, publicly-indexable
page behind its own `layout.tsx` (`MarketingHeader`/`MarketingFooter`),
deliberately with no `RequireAuth`/`AppShell` — those assume a session
exists, which a first-time visitor by definition doesn't have. Every
internal link that used to assume "`/` is the dashboard" (`NAV_ITEMS`,
the sidebar logo, the post-login/post-register redirect, the
post-verify-email "continue" link) was updated to point at `/dashboard`
explicitly; only the *failure*-path "back to Duitlah" link on a failed
email verification still points at `/`, since a broken link is a
recovery moment, not a "continue where you left off" one. `/status` is
a real, live client-side check against the API's own
`/actuator/health` (see [security.md](security.md)) — refreshed on an
interval, not a static "all systems operational" claim.

## Mobile (Phase 9.5, primary client)

`apps/mobile` is a feature-first Flutter project:

```text
lib/
  core/       api (Dio client, SSE client), auth (biometric lock),
              config (env), errors, routing (GoRouter, deep links),
              storage (flutter_secure_storage), theme, utils, widgets
              (the design system: buttons, amount text, balance card,
              rows, chips, avatars, state views, dialogs)
  features/   auth, home, accounts, transactions, budgets, goals,
              groups, bagilah, receipts, settlements, notifications,
              recurring, insights, assistant, subscriptions, profile,
              feedback, spaces, autotrack, bills, liabilities, networth,
              finhealth, exports, personaltax, business — each split into data/
              (repositories talking to ApiClient), application/ (Riverpod
              providers), and presentation/ (screens/widgets)
```

`recurring` and `insights` (Phase 10) are the first two feature modules
built with no `apps/web` counterpart — see the Phase 10 section above.
`insights` covers everything read from the `analytics` backend module
beyond the original Phase 0 dashboard summary (category breakdown,
monthly trend, top merchants, forecast, calendar), grouped under one
Flutter feature since they're all read-only views over the same backend
module, even though the backend itself doesn't have a matching
`insights` package. `assistant` (Phase 12) follows the same "one Flutter
feature per read-only surface, regardless of backend package boundaries"
shape — its two screens (chat, affordability check) both live in one
feature since they're both just views over `ai`'s endpoints, with chat
history held only in the screen's own widget state (`_AssistantScreenState`),
never in a Riverpod provider, since nothing else in the app needs it and
it doesn't survive navigation away from the screen. `subscriptions`
(Phase 13) holds the entitlement provider and the shared
`showUpgradeDialog` — other features (`groups`, `bagilah`) import that
dialog function directly rather than `subscriptions` reaching into them,
keeping the dependency one-directional on the Flutter side even though
the backend's `groups`/`receipts`↔`subscriptions` relationship is
two-way (see the backend module section above). `feedback` (Phase 15)
holds two screens rather than one: `FeedbackScreen` (the actual API
call) and `HelpSupportScreen`, which is mostly a `url_launcher` fan-out
to `apps/web`'s new marketing pages (Help Centre, FAQ, Privacy, Terms)
plus a `mailto:` support link — only "Send feedback" inside it is a
real in-app action, everything else deliberately just launches out to
the page that already owns that content (see the Frontend section
above for why those live in `apps/web`, not duplicated here). The
domain model is named `UserFeedback`, not `Feedback` — `package:flutter/
material.dart` already exports a `Feedback` class (tap/long-press
haptics) that would otherwise collide with any screen importing both.
`spaces` (V2 Phase 1) is the first Flutter feature module built for the
V2 upgrade rather than the original product spec — a `SpacesScreen`
(Personal + Business list), `CreateBusinessSpaceScreen`, and a read-only
`BusinessProfileScreen`, reachable via a new "Workspaces" entry, first in
the More menu. See [financial-spaces.md](financial-spaces.md) for why it
originally didn't offer a "switch active workspace" control — V2 Phase 5
(below) is the phase that changes this, once real business data exists
behind one.
`autotrack` (V2 Phase 2) holds three screens — `AutoTrackCandidatesScreen`
(review/confirm/reject/merge), `StatementImportScreen` (`file_picker` for
CSV/XLSX/PDF), and the Receipt Vault's `ReceiptVaultScreen`/
`VaultReceiptDetailScreen` (added to the existing `receipts` feature
module alongside its unchanged Bagilah scan screens, mirroring the
backend's own "same module, second entity" shape) — see
[autotrack.md](autotrack.md).

V2 Phase 3 (see [personal-gap-closure-ii.md](personal-gap-closure-ii.md))
added `bills`, `liabilities`, `networth`, `finhealth`, and `exports` as
new Flutter feature modules, and replaced `notifications`' Phase 9.5
placeholder screen with a real one backed by the new API. Credit card
details are reached by tapping a `CREDIT_CARD`-type account in the
existing `accounts` feature's own screen — a detail view of that account,
not a new top-level concept — the same "extend, don't parallel" shape as
the backend's `CreditCardDetails`. `budgets`' create form gained a
cycle-type picker; transaction multi-currency fields are deliberately not
exposed in the mobile "add transaction" form yet (a documented scope
choice, not an oversight — see personal-gap-closure-ii.md).

V2 Phase 4 (see [personal-tax.md](personal-tax.md)) added `personaltax` —
one feature module covering the whole Tax Centre (Income, PCB, Zakat, Tax
Reliefs, Documents, plus a calculation/readiness overview screen), rather
than five separate top-level More-menu entries, matching the spec's own
single-Tax-Centre structure.

V2 Phase 5 (see [business-core.md](business-core.md)) added `business` —
one feature module for every business-space-scoped screen (customers,
suppliers, products, business accounts + entries/transfers, expenses +
payments, quotations + convert-to-invoice, invoices + payments + credit
notes, and a dashboard hub), plus team management folded into the
existing `spaces` feature rather than a seventh top-level entry, since it
edits the same space the user is already inside. Unlike every other
feature module, `business` is scoped by a `spaceId` route parameter
throughout — there is no global "current business" selector — and the
`SpacesScreen`'s business-space card now opens the dashboard directly
instead of only the read-only profile screen. No screen in this module
hides an action by role; a `403 INSUFFICIENT_PERMISSION` from the server
surfaces as a plain error message, matching section 33's "don't rely on
hiding buttons" requirement at the client too.

V2 Phase 6 (see [accounting-engine.md](accounting-engine.md)) added
`accounting` — Chart of Accounts, Accounting Periods, Journal Entries
(with a live debit/credit-balance indicator on the manual-entry form so
a user sees an imbalance before submitting, not after a rejected
request), and a Reports hub (General Ledger, Trial Balance, P&L,
Balance Sheet, Cash Flow, each with CSV/XLSX/PDF export/share reusing
the same download pattern the `exports` feature already established).
Two small additions went into Phase 5's own `business_account_detail_
screen`/`expense_detail_screen` rather than new screens: a "map to
ledger account" action, since that mapping is what lets Phase 5's
existing "record payment"/"receive payment" actions start producing
real journal entries automatically once set.

V2 Phase 7 (see [reconciliation.md](reconciliation.md)) added
`reconciliation` — a hub screen (past statement imports/sessions, an
"Import Statement" action reusing `file_picker` exactly like the
existing personal-finance `autotrack.StatementImportScreen`, just
business-account-scoped) and a session screen (a summary header, the
parsed statement lines with per-line Match/Create Transaction/Ignore/
Split actions, a live running-total-vs-target indicator on the Split
form mirroring Phase 6's own manual-journal-entry balance indicator,
and a Resolve Difference action). Reached from the Business Dashboard
alongside Phase 5/6's own entries.

- **State/data**: Riverpod (`flutter_riverpod`) for UI/session/API-cache/
  navigation state only — exactly mirroring the constraint on the web
  app's Zustand/TanStack Query usage. `ApiClient` (`core/api/api_client.dart`)
  is the one Dio instance every repository goes through: same base-URL
  convention as `NEXT_PUBLIC_API_URL` (via `API_BASE_URL`/`--dart-define`),
  same Bearer-header-plus-cookie auth, same 401-refresh-retry dance with a
  shared in-flight future, same `ApiError` shape surfaced as `AppException`.
  Financial write repository methods accept an `idempotencyKey` and send it
  as an `Idempotency-Key` header — see the note in [api.md](api.md); the
  backend doesn't act on it yet, so today this is forward-compatible
  client discipline, not an enforced guarantee.
- **Amounts arrive as JSON numbers, not strings.** Jackson serializes
  every `BigDecimal` field as a bare numeric literal (`"tax":0.00`), not a
  quoted string — the opposite of what `apps/web`'s own TypeScript types
  claim (`string`), a mismatch that's invisible on the web side only
  because JavaScript never enforces its declared types at runtime. Dart's
  `json_serializable` does enforce types, so every amount field in
  `apps/mobile`'s domain models carries `@AmountConverter()` /
  `@NullableAmountConverter()` (`core/utils/amount_converter.dart`), which
  normalizes either shape into a Dart `String` before `json_serializable`
  even sees a type mismatch. Caught by hitting a real docker-compose
  backend directly rather than assuming the web app's types were accurate —
  see this phase's final report for the rest of what live-testing caught.
- **Auth**: `features/auth` + `core/auth/biometric_lock_service.dart`. The
  refresh cookie lives in a `cookie_jar` `PersistCookieJar` whose storage
  backend (`core/storage/secure_cookie_storage.dart`) is
  `flutter_secure_storage`, not the package's default plaintext file —
  see [security.md](security.md).
- **Navigation**: GoRouter, with a `StatefulShellRoute.indexedStack` bottom
  nav (Home / Transactions / Bagilah / Groups / More) so each tab keeps its
  own stack, and a `redirect` callback driven by the auth Riverpod state
  (loading/unauthenticated/authenticated) via a small `ChangeNotifier`
  bridge (`_RouterRefreshNotifier`).
- **Deep links**: `core/routing/deep_link_service.dart` (package
  `app_links`) listens for the same invite URL path
  (`/bagilah/join?token=...`) the web app builds — one URL surface, not a
  parallel scheme. `BagilahJoinScreen` resolves it: an authenticated user
  joins immediately by identity; anyone else gets the same guest
  name-and-join flow as the web guest page.
- **Bagilah on mobile**: `features/bagilah` + `features/receipts` cover
  the full flow — camera/gallery capture (`image_picker`) → upload →
  OCR review (editable, same "never trust OCR completely" posture as the
  web review form) → confirm into a bill → item claiming (whole/equal-
  split/custom quantity-percentage-amount, via `ClaimItemSheet`) → live
  breakdown over SSE → finalize → balances. `mobile_scanner` handles
  scanning an invite QR; `qr_flutter` + `share_plus` handle generating and
  sharing one.
- **Tests**: `test/` covers unit-level logic (e.g. `Money` display
  formatting never touching arithmetic) plus widget/integration tests for
  the priority flows named in the Phase 9.5 migration doc; see that
  document's own final report for exact coverage and gaps.

## Infrastructure

- **PostgreSQL** — system of record for all financial data. Schema is
  managed exclusively through Flyway migrations (`apps/api/src/main/resources/db/migration`);
  Hibernate is configured with `ddl-auto: validate`, never `update`.
- **Redis** — cache and ephemeral state only (rate limiting, OTP/session
  state). Never the source of truth for anything.
- **MinIO** (Phase 8) — S3-compatible object storage for receipt images,
  local stand-in for a real AWS S3 bucket or Supabase Storage in
  production (`common.storage.ObjectStorage`/`S3ObjectStorage`). Images
  never touch Postgres, per the product spec's explicit "do not store
  large binary files inside PostgreSQL." `StorageProperties` deliberately
  splits `endpoint` (what the API container uses — the `minio` hostname,
  reachable only inside the Compose network) from `publicEndpoint` (what
  a presigned URL is signed against — `http://localhost:9000`, the only
  address a browser running on the host can actually reach). Getting this
  wrong silently produces presigned URLs a real user's browser can never
  load; a real deployment (AWS S3, Supabase Storage) would just set both
  to the same public value.
- **Docker Compose** (root `docker-compose.yml`) runs all five services
  (`postgres`, `redis`, `minio`, `api`, `web`) for local development.

## Why the api container is built with `mvn package`, not the wrapper cache

The `apps/api/Dockerfile` build stage runs Maven fresh inside the image
rather than copying a host-built jar in, so the container image is
reproducible without depending on local build state.

## V2 Phase 14: final hardening

Phase 14 adds no domain module and no migration. It strengthens settlement
payments with locked aggregate validation, adds fixed financial/tax
regressions, and supplies deployment smoke gates for latency and PostgreSQL
recovery. See [final-hardening.md](final-hardening.md).

## Duitlah Monthly Wrapped

A standalone post-Phase-15 feature, not part of the numbered V2 master
spec. `com.duitlah.api.wrapped` is a single new backend module composing
four already-existing services (`AnalyticsService`, `BudgetService`,
`RecurringTransactionService`, plus one new `GoalContributionRepository`
query) through one aggregation entry point
(`MonthlyAggregationService.summarize`) rather than introducing a
parallel read path into any of them. Its own four internal engines
(`MoneyPersonaEngine`, `MonthlyInsightEngine`, `GoalRecommendationEngine`,
plus the orchestrating `WrappedGenerationService`) are deliberately
LLM-free and deterministic — the one place in this codebase's feature set
where "AI-feeling" output is produced entirely by ordinary Java scoring
logic. See [monthly-wrapped.md](monthly-wrapped.md).
