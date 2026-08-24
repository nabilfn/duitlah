# Duitlah

**Money made social.**

A personal + shared finance platform for Malaysian users. Its flagship
feature, **Bagilah** (*Scan. Claim. Settle.*), lets a group scan a
receipt, claim what they had, and get an exact split — reconciled to the
cent against the real receipt total.

This repository is at **Phase 15: Public Launch** — Phases 0-14
(foundation, design system, auth, personal finance, budgets/goals,
groups, Bagilah's calculation engine, collaboration/guest access, receipt
scanning, settlement, mobile migration, advanced personal finance,
special group modes, AI financial assistant, premium subscriptions,
hardening) are complete. This is the last phase in the product spec's
own phase plan. **Flutter (`apps/mobile`) is the primary client**, with
Next.js (`apps/web`) now also serving as Duitlah's public-facing site
(landing page, privacy, terms, help centre, FAQ, status) alongside its
existing secondary-app role (guest Bagilah access, the authenticated
dashboard at `/dashboard`). `apps/api` remains the single authoritative
backend for both — see [docs/architecture.md](docs/architecture.md)'s
Phase 9.5 section for the full one-source-of-truth rationale, and its
Phase 10/11/12/13/14/15 sections for how that plays out for phases
built mobile-only, backend-only, or web-only.

## Stack

- **Mobile** (`apps/mobile`) — Flutter/Dart (iOS + Android), Riverpod,
  Dio, GoRouter, `flutter_secure_storage`. **Primary client.**
- **Web** (`apps/web`) — Next.js, TypeScript, Tailwind CSS, shadcn/ui,
  TanStack Query, Zustand, React Hook Form, Zod. Secondary/web companion.
- **Backend** (`apps/api`) — Java 17, Spring Boot 4 (modular monolith),
  Spring Data JPA, Spring Security, PostgreSQL, Flyway, Redis. Sole
  authoritative backend for both clients.
- **Infra** — Docker Compose for local dev; see [docs/deployment.md](docs/deployment.md).

## Quick start

```bash
cp .env.example .env
docker compose up -d
```

- Web: http://localhost:3001 — see `/design-system` for the full component/token reference
- API: http://localhost:8080 (health: `/actuator/health`, docs: `/swagger-ui.html`)
- Mobile: `cd apps/mobile && flutter pub get && flutter run` — see
  [docs/deployment.md](docs/deployment.md)'s Mobile section for
  simulator/emulator base-URL details and Android license setup.

See [docs/deployment.md](docs/deployment.md) for port details and
non-Docker setup.

## Documentation

- [PRODUCT.md](PRODUCT.md) — register, users, positioning, brand personality, anti-references
- [DESIGN.md](DESIGN.md) — color system, typography, component conventions, and why
- [docs/architecture.md](docs/architecture.md) — module structure, why it's shaped this way
- [docs/database.md](docs/database.md) — migrations, money types, test DB strategy
- [docs/api.md](docs/api.md) — versioning, response/error format
- [docs/security.md](docs/security.md) — auth architecture (JWT + refresh sessions, rate limiting, reuse detection)
- [docs/bagilah-engine.md](docs/bagilah-engine.md) — the core invariant the split engine must uphold
- [docs/deployment.md](docs/deployment.md) — local dev and future production targets
- [docs/contributing.md](docs/contributing.md) — checks to run before committing
- [docs/financial-spaces.md](docs/financial-spaces.md) — the V2 Financial Spaces workspace model
- [docs/autotrack.md](docs/autotrack.md) — the V2 AutoTrack pipeline, statement import, and Receipt Vault
- [docs/personal-gap-closure-ii.md](docs/personal-gap-closure-ii.md) — V2 Bills, Loans/Credit Cards, Net Worth, Financial Health, and more
- [docs/personal-tax.md](docs/personal-tax.md) — the V2 Personal Tax Centre (read this before trusting any tax number)
- [docs/business-core.md](docs/business-core.md) — the V2 Business Core: team RBAC, customers/suppliers/products, business accounts, expenses, sales
- [docs/accounting-engine.md](docs/accounting-engine.md) — the V2 double-entry Accounting Engine: Chart of Accounts, journals, automatic posting, reports
- [docs/reconciliation.md](docs/reconciliation.md) — the V2 Bank Reconciliation: statement import, matching engine, sessions, match/create/ignore/split
- [docs/inventory-and-costing.md](docs/inventory-and-costing.md) — the V2 Inventory & Costing: stock movements, Weighted Average Cost, COGS, recipe costing, low-stock alerts
- [docs/fixed-assets.md](docs/fixed-assets.md) — the V2 Fixed Assets: asset register, depreciation, disposal, journal generation
- [docs/business-tax-and-einvoice.md](docs/business-tax-and-einvoice.md) — the V2 Business Tax & e-Invoice: SST, the MyInvois provider abstraction, and the submission workflow
- [docs/cross-space-accounting.md](docs/cross-space-accounting.md) — the V2 Cross-Space Accounting: personal-paid business expense, reimbursement, owner contribution/drawing, combined net worth
- [docs/v2-audit.md](docs/v2-audit.md) — the V2 upgrade audit and phase plan

## Status

**Phase 0** (foundation) complete: frontend and backend scaffolded, Postgres +
Redis wired up, Flyway baseline migration, API error/response conventions,
frontend API client + query provider, Docker Compose for local dev,
formatting/linting/tests on both sides, GitHub Actions CI.

**Phase 1** (design system) complete: OKLCH brand color system (light + dark,
verified against WCAG 2.1 AA), typography scale, dark mode via next-themes,
and component primitives — buttons, inputs, cards, modal/drawer, desktop
sidebar + mobile bottom nav, toasts, empty states, skeletons, status pills,
a Phase-1 logo placeholder. See `/design-system` for the live reference and
[DESIGN.md](DESIGN.md) for the reasoning.

**Phase 2** (authentication) complete: JWT access tokens + httpOnly
refresh-token sessions with rotation and stolen-token reuse detection,
register/login/logout/logout-all, email verification, password reset,
device session list with per-device revoke, profile editing, Redis-backed
rate limiting on sensitive endpoints. Frontend has full auth pages
(`/login`, `/register`, `/forgot-password`, `/reset-password`,
`/verify-email`, `/profile`) and a `RequireAuth` client-side route guard;
the API client handles silent access-token refresh transparently. 13
backend integration tests cover the security-sensitive flows (refresh
rotation/reuse, rate limiting, session revocation scoping). See
[docs/security.md](docs/security.md) for the architecture.

**Phase 3** (personal finance MVP) complete: accounts (cash/bank/e-wallet/
credit card/savings/investment), a two-level category tree (system
defaults matching the product spec + user-custom categories), income/
expense/transfer transactions, and a dashboard (available balance, this
month's income/expense, recent transactions). Account balances are always
computed from transaction history, never stored, so they can't drift out
of sync — see [docs/database.md](docs/database.md) for that and the
transfer-as-linked-rows design. Frontend has `/accounts` and
`/transactions` pages with create/transfer dialogs, and `/` is now a real
dashboard. 9 backend integration tests cover balance correctness, transfer
linking/deletion, category-type validation, and cross-user authorization
(404, not 403 — never confirm another user's data exists).

**Phase 4** (budgets & goals) complete: overall and per-category monthly
budgets with computed spend/remaining/status (OK/WARNING/EXCEEDED at
80%/100% thresholds — a signal for the UI to render, not a notification,
since no push/email delivery infrastructure exists yet); a budget set on a
parent category (e.g. "Food") correctly rolls up spending across its
children, since transactions are only ever tagged to a leaf category.
Savings goals (emergency fund, travel, device, house deposit, car,
education, wedding, custom) track progress via a signed contribution
ledger — same computed-not-stored pattern as account balances — so
corrections/withdrawals are just a negative entry, not a special case.
Frontend has `/budget` and `/goals` pages. 7 new backend integration tests
cover the category rollup, status escalation, duplicate-budget rejection,
and contribution math including withdrawals (29 backend tests total).

**Phase 5** (groups) complete: create a group (housemates/couple/trip/
friends/family/team/event), invite via a persistent shareable link, join,
list members, and log shared expenses split equally among chosen
participants. Group balance is `totalPaid - totalShare` per member,
matching the product spec's own worked example exactly. Splitting reuses
a new `common.money.EqualSplitter` utility that guarantees shares always
sum back to the original amount exactly — the same reconciliation
discipline the Bagilah engine will need, built now because Groups needs
it first (see [docs/database.md](docs/database.md)). Frontend has
`/groups`, a group detail page, and a `/groups/join?token=` auto-join
link. 9 new backend integration tests cover invite/join, equal-split
rounding, balance math, owner-can't-be-removed, and expense-delete
permissions (38 backend tests total). One real bug caught before
shipping: three `group_*` foreign keys to `users` were missing
`ON DELETE CASCADE` (inconsistent with every other user-owned table in
the schema) and crashed on user deletion — fixed.

**Phase 6** (Bagilah manual splitting) complete: the calculation engine —
built and exhaustively tested *before* OCR, per the product spec's own
phase ordering. A bill has manually-entered receipt items (with optional
per-item discounts), participants (registered users or typed-in guests,
no account needed), and claims: whole item, split quantity, custom
percentage, or custom RM amount, all reconciled to the exact cent via a
new `common.money.ProportionalAllocator` (largest-remainder method,
reused for tax/service/discount allocation too). Unclaimed and
overallocated items block finalization; tax and service charge default to
proportional-to-subtotal (equal-split optional); a receipt-wide discount
is always proportional; a manually-entered "what the receipt actually
says" total reconciles any real-world rounding discrepancy (Malaysian
cash-rounding included) as an explicit, recorded adjustment — never a
silently dropped cent. Finalizing snapshots each participant's amount
into `bill_final_amounts`, a deliberate one-off exception to this
schema's usual computed-not-stored rule, since a finalized bill is meant
to freeze history, not keep recalculating it. Settlement here is
intentionally narrow — net paid-vs-owed per bill, not a "who owes whom"
graph or payment-status tracking, both Phase 9's job. Frontend has
`/bagilah` and a bill detail page covering the full manual flow: add
items/participants, claim (equal-split or custom), record who paid, and
finalize. 17 pure calculation-engine tests plus 18 backend integration
tests cover the product spec's own test matrix (1/2/10 participants,
shared items/quantities, tax/service/discount combinations, rounding
discrepancies, zero-price items, multiple payers) — 83 backend tests
total.

**Phase 7** (Bagilah collaboration) complete: a bill gets a persistent,
regeneratable invite link with a QR code (`qrcode.react`), the same
shareable-link model as Groups. Anyone with the link can join — an
already-logged-in user joins as themselves, an account-less guest just
types a name and gets a 24-hour guest session token
(`bill_guest_sessions`) instead, resolved entirely outside the real-user
JWT/Spring Security path so guest identity can never be mistaken for a
real user id (see [docs/security.md](docs/security.md)). Claiming is now
collaborative: any participant of a draft bill — owner, joined user, or
guest — can add or adjust any claim, not just their own; item/
participant/charge management, payments, and finalize/cancel stay
owner-only. Live updates ("Ameer joined," "Ameer claimed Chicken Chop")
arrive over Server-Sent Events (`BillEventBroadcaster`) rather than
polling. Frontend has `/bagilah/join` (auto-joins logged-in users,
prompts guests for a name), a guest-only bill view at
`/bagilah/[id]/guest`, and an invite dialog with a QR code on the owner's
bill page. 11 new backend integration tests cover invite/join (both
authenticated and guest), guest claiming, collaborative claiming by a
non-owner participant, non-participant rejection, joining/claiming
blocked once finalized, and SSE subscription (94 backend tests total).

**Phase 8** (receipt scanning) complete: upload a receipt photo (camera
capture on mobile, file picker otherwise) and it's parsed synchronously
into structured items with a per-field confidence score, using Claude's
vision API behind a swappable `ReceiptOcrService` interface — when no
`ANTHROPIC_API_KEY` is configured, every scan just comes back blank and
opens straight into manual entry, the same "optional external provider"
posture as SMTP (`LoggingEmailSender`). Structured extraction is forced
via a JSON-schema-constrained tool call rather than "ask for JSON in
prose and hope," and the response is still walked defensively
field-by-field — one bad field degrades to null, not the whole scan.
Every field the product spec requires (merchant, item names/prices/
quantities, add/delete items, tax, service, discount, final total) is
correctable in the review form before confirming; confirming just calls
the same `BillService.create`/`addItem`/`update` a manual "New bill"
uses, so a confirmed scan is an ordinary Phase 6/7 bill from that point
on — every existing capability (collaborative claiming, invite links,
guest access, finalize) already works on it with no extra code. Receipt
images are stored in MinIO (S3-compatible, new `docker-compose.yml`
service), never Postgres, with private presigned URLs for viewing.
Frontend has `/bagilah/scan` (camera/upload) and `/bagilah/scan/[id]`
(the review-and-correct form, with a "double-check this" hint on
low-confidence fields). 5 new backend integration tests — run against a
real MinIO container, not a mocked object store — cover upload, unsupported
file types, confirm-into-a-real-bill, double-confirm rejection, and
cross-user access (99 backend tests total).

Full end-to-end Bagilah (scan a receipt → split it exactly → settle up)
is functionally complete as of this phase. Remaining phases add
richness (settlement/debt-simplification polish, advanced personal
finance, special group modes, AI assistant, premium subscriptions) on
top of a working core.

**Phase 9** (settlement) complete: finalizing a Bagilah bill now
automatically turns each real-user participant's net position into
fixed, independent debt obligations via a new `DebtSimplifier` utility
(the product spec's own example: collapse A→B, B→C into a direct A→C,
not "everyone pays everyone"). Groups get a parallel, repeatable "Settle
up" action — owner-only, since generating a settlement is the one part
of this that isn't symmetric between the two parties. Once generated, a
settlement is tracked independently through its own append-only payment
history — partial payments, full payments, cancel, dispute — entirely
decoupled from whatever new group expenses accumulate afterward
(`GroupService.getBalances` now reports the *currently unsettled*
position, not lifetime totals, a refinement that doesn't change any
existing test's numbers since the subtraction is zero until something
is actually settled). Either party — the ower or the one owed — can mark
a payment, cancel, or dispute; only the bill/group action that produces
a settlement is owner-gated. A new "who owes me" dashboard aggregates
outstanding amounts per counterparty across every bill and group,
netting bidirectional debts into one number per person, with days-
outstanding shown per the product spec's own example. External payment
handoff is a swappable interface (`PaymentHandoffService`) — honest
about not fabricating a working DuitNow integration, returning manual
transfer instructions instead, the same "optional external provider"
posture as email/OCR/storage; Duitlah still never holds funds. Guests
are deliberately excluded from settlement generation (documented, not an
oversight) — a settlement needs a real account to view a dashboard from.
Frontend has `/settlements` (summary + outstanding + history, with
mark-paid/cancel/dispute actions) and a "Settle up" button on the group
page. 15 new backend tests (6 pure `DebtSimplifier` reconciliation tests
+ 9 integration tests covering both generation paths, payment history,
cancel/dispute, cross-user authorization, and summary aggregation) — 114
backend tests total.

**Scan → Claim → Settle, the full Bagilah pipeline, is functionally
complete as of this phase.** Remaining phases add richness (advanced
personal finance, special group modes, AI assistant, premium
subscriptions, production hardening) on top of a working core.

**Phase 9.5** (mobile migration) complete: a full-featured Flutter app
(`apps/mobile`, iOS + Android) is now the primary client, built directly
against the existing, unmodified `apps/api` — a business-logic audit of
the entire Next.js frontend found zero client-side financial logic to
migrate, so Phase 9.5 went straight to building rather than a remediation
detour. It covers every Phase 0-9 feature: auth (with an optional
biometric device lock via `local_auth`, never replacing server auth),
personal finance (accounts/transactions/budgets/goals), groups, and the
full Bagilah flow end to end — camera/gallery receipt capture, editable
OCR review, manual bill creation, item claiming (whole/equal-split/custom
quantity-percentage-amount), QR invite generation and scanning, deep-link
and guest joining (no app install required, falling back to the existing
`apps/web` guest flow), live updates over the same SSE endpoints, finalize,
and settlements (record/cancel/dispute payments, "who owes me" summary).
Auth reuses the exact JWT-plus-refresh-cookie model (`flutter_secure_storage`-backed
cookie jar) and realtime reuses the exact SSE endpoints — no backend
changes were needed for either. `apps/web` continues operating unchanged
as the secondary web companion. `flutter analyze` and `flutter test` are
clean (12 tests), and the app builds successfully for both iOS (simulator)
and Android (debug APK). Live-testing every repository against a real
docker-compose backend caught 11 real request-shape bugs before shipping —
several endpoints expecting different HTTP verbs or field names than
initially assumed (`invite-token` is POST not GET, bill payments are `PUT
.../payments/{participantId}` not `POST .../payments`, budget creation
sends `amountLimit` not `limit`, guest join sends `guestName` not
`displayName`, among others) and a systemic one where every backend
decimal field is serialized as a bare JSON number rather than the string
the web app's own TypeScript types (incorrectly) claim — all fixed and
verified against the live API before this phase was considered done. See
[docs/architecture.md](docs/architecture.md)'s Mobile section for the
full picture and this phase's own final report for what's deferred (real
FCM push notifications, verified universal/app links requiring a real
domain and signing credentials, and server-side idempotency-key
enforcement — the mobile client already sends the header, but the backend
doesn't yet act on it).

**Phase 10** (advanced personal finance) complete, and the first phase
built per the post-migration pattern: all new server logic lives in
`apps/api` as always, but the only new client UI is in `apps/mobile` —
`apps/web` is intentionally untouched, per the explicit instruction to
adapt implementation to Flutter now being the primary client rather than
duplicating every feature into both clients. Recurring transactions
(`recurring_transactions` table, `RecurrenceCalculator` pure utility) back
both arbitrary recurring rules and subscriptions (`is_subscription = true`
on the same rows, no separate table); a daily `@Scheduled` job
materializes due occurrences into real `transactions` rows so account
balances need no special-casing. New analytics endpoints add
spending-by-category (reusing `CategoryService.expandToSelfAndChildren`
for parent/child rollup), a 6-month income/expense/savings trend, top
merchants, a calendar view blending posted transactions with projected
recurring occurrences, and a cash-flow forecast that explicitly separates
deterministic scheduled amounts from a historical-average guess and
always carries a `disclaimer` string — never presented as a guarantee.
Flutter gained three new screens (Recurring & Subscriptions, Insights,
Calendar) plus a forecast teaser card on Home, all built against
Freezed/Riverpod exactly like the rest of the app. 19 new backend tests
(133 total) and 6 new Flutter tests (18 total) all pass; live
verification against a real docker-compose backend, including screenshots
from a real Android emulator, confirmed all three new screens render
correctly against live seeded data. That same live-testing pass also
caught and fixed a genuine pre-existing Phase 9.5 bug unrelated to Phase
10 itself: GoRouter's `redirect` let Home render during the auth
bootstrap's `loading` state, racing a live API call against the
not-yet-set access token and flashing a raw "Authentication required"
error — fixed with a dedicated `SplashScreen` that the router now parks
on until auth resolves.

**Phase 11** (special group modes) complete, continuing the mobile-only
pattern: all four modes build on a `groups.type` column that has existed
unused since Phase 5, so this phase is additive UI/logic rather than a
new classification system. Shared goals (any group type, not just Trip)
mirror personal goals almost exactly — same "current amount is
SUM(contributions), never stored" rule, same signed-ledger discipline,
now with a per-member contribution breakdown. Trip mode adds a single
flat group budget (spent/remaining derived from expenses, never stored)
plus an optional per-expense currency snapshot (original currency/amount/
exchange rate) that is purely display metadata — the real MYR `amount`
every balance/settlement computation uses is untouched, an honest choice
over building a live multi-currency ledger the spec doesn't actually ask
for. Housemate mode adds a monthly paid/unpaid dashboard across 8 fixed
household categories, derived from whether any expense in that category
was logged that month. Couple mode required no new backend code at all —
"Mine · Yours · Ours" is already satisfied by a Couple-typed group's
existing shared expenses/goals plus each partner's already-private
personal transactions; Flutter adds only a one-line framing caption.
6 new backend tests (139 total) and 5 new Flutter tests (23 total) all
pass. Live verification against a real docker-compose backend and a real
Android emulator confirmed Trip budget tracking, shared-goal contribution
and per-member breakdown, and the Housemate paid/unpaid dashboard all
render and update correctly — that pass also caught and fixed a real bug:
the "Add expense" bottom sheet overflowed once Trip mode's optional
currency fields were shown with the keyboard open, fixed by making the
sheet's content scrollable.

**Phase 12** (AI financial assistant) complete. The product spec's own
architecture (`User Question -> Permission + Intent -> Finance Query
Layer -> Structured Financial Summary -> AI -> Natural Language
Explanation`) is implemented literally: a new `FinanceQueryService` is a
fixed set of read-only pass-through methods to existing services
(dashboard, spending-by-category, monthly trend, top merchants, forecast,
budgets, goals, settlements) — the AI can only ever call one of these
named queries, scoped to the requesting user, never anything broader.
`ClaudeAiChatService` runs an agentic tool-use loop against Claude's
Messages API (same raw-HTTP style as the existing receipt-OCR
integration, no SDK dependency) with a system prompt that forbids
guessing numbers, guaranteeing returns, or claiming to move money.
Affordability ("Can I afford this?") is deliberately *not* AI-dependent:
`AffordabilityService` computes every number from the same forecast/debt
math already trusted elsewhere and fills in a plain Java narrative
template, so it keeps working with real numbers whether or not an AI
provider is even configured — the concrete enforcement of "never let the
AI become the source of truth for financial calculations." Both features
share the existing `ANTHROPIC_API_KEY`; unset, they fall back to an
honest "not configured" reply rather than fabricating an insight. Flutter
gained one new feature module (`assistant`): a chat screen plus an
affordability-check bottom sheet, reachable from the More menu. 4 new
backend tests (143 total) and 3 new Flutter tests (26 total) all pass.
Live verification on a real Android emulator found and fixed a real bug:
the affordability sheet's result/loading state was declared *inside* a
`StatefulBuilder`'s builder callback, so it reset to its initial values on
every rebuild instead of persisting — the computed answer would flash and
immediately vanish. Fixed by hoisting that state to the enclosing scope;
also fixed a low-contrast disclaimer text discovered in the same pass.

**Phase 13** (premium subscriptions) complete. Implements exactly the
product spec's Phase 13 scope — FREE and PLUS entitlements, with Apple/
Google/Web subscription architecture *prepared* rather than fully
integrated (no real store credentials exist in this repository, so
`SubscriptionVerifier` is honestly wired to
`UnavailableSubscriptionVerifier` for every source — the same "don't
fake a working integration" posture as the settlement module's
`PaymentHandoffService`). Server-side entitlement verification is real:
`GET /api/v1/subscriptions/me` and `POST /api/v1/subscriptions/verify`
compute the user's tier from a verified `user_subscriptions` row (absent
= FREE), never from anything the client claims. FREE's two limits — up
to 3 actively-owned groups, ~5 receipt scans/month — are enforced
server-side at the actual write points (`GroupService.create`/`update`,
`ReceiptScanService.upload`), counting group *ownership* specifically so
joining someone else's group or Bagilah bill never counts against an
unrelated free user's own quota, per the spec's explicit "never destroy
the social growth loop through excessive paywalls" principle. Flutter
gained one feature module (`subscriptions`): a Duitlah+ screen showing
real plan/usage, and a shared upgrade dialog shown wherever a FREE limit
is hit, linking to that screen — deliberately with no purchase button
anywhere, since there's no real store integration yet for one to trigger.
5 new backend tests (148 total) and 3 new Flutter tests (29 total) all
pass. Live verification on a real Android emulator confirmed the full
loop: hitting the group limit at 3/3, the upgrade dialog appearing with
the exact backend message, and "See plans" landing on the Duitlah+ screen
showing the real usage bars.

**Phase 14** (hardening) complete. This phase closed real, previously
just-documented gaps rather than adding new user-facing features:

- **Idempotency** (product spec section 51) — `IdempotencyFilter`
  deduplicates any `POST`/`PUT`/`PATCH` carrying an `Idempotency-Key`
  header, scoped per-`(userId, key)`, backed by a Redis `SET NX` claim
  (24-hour TTL) and exact-response replay on retry. This had been
  documented since Phase 6 as "not yet implemented server-side" —
  `apps/mobile` was already sending the header with nothing on the
  backend reading it. `IdempotencyFlowTests` verifies it under genuine
  concurrent load: 5 threads racing one key produce exactly 1 real
  transaction, not 5.
- **Audit logs** (section 50) — a new append-only `audit_logs` table
  (V13) records the exact 8 actions the spec names (bill finalized,
  transaction created/modified, payment marked, participant removed,
  receipt edited, account info changed, security settings changed),
  wired into 7 existing services with zero circular dependencies.
  `actor_user_id` uses `ON DELETE SET NULL` — the one deliberate
  exception to this schema's usual cascade-on-user-delete rule — so the
  trail outlives a deleted account.
- **Permission review** — every controller's ownership/membership-scoped
  lookup was checked by hand against its request-mapping count. Zero
  IDOR gaps found.
- **Database constraint review** — every numeric column across all 14
  migrations was checked for a matching `CHECK`. One real gap found:
  Trip mode's currency-snapshot columns (V11) had none. Fixed with a new
  migration (V14) plus tightened application-layer validation
  (`originalCurrency` now normalizes to uppercase and is rejected if it
  doesn't match a 3-letter shape).
- **Security review** — confirmed live (not assumed) that
  `X-Content-Type-Options: nosniff` and `X-Frame-Options: DENY` are
  already present on every response via Spring Security's defaults; no
  SQL is ever raw/string-concatenated anywhere in the codebase; a
  Content-Security-Policy header was deliberately not added (this API
  serves no user-rendered HTML — Swagger UI is the one exception and a
  CSP strict enough to matter would break its own bundled scripts for no
  real security gain); receipt photo uploads gained a real magic-byte
  signature check alongside the existing content-type allowlist, closing
  a real gap where only the client's *declared* content-type was ever
  trusted.
- **Calculation audit** — spot-checked `AffordabilityService` and
  `SubscriptionService`'s newer computation/counting logic (both reuse
  existing, already-tested engines rather than inventing new math). No
  defects found.
- **Performance/load testing, accessibility testing, and backup/restore
  testing** are honestly out of scope for what this environment can
  execute — no load-testing tool, screen reader, or managed-database
  backup/restore infrastructure is available here. "Mobile testing" for
  this phase means confirming the *unchanged* Flutter client still works
  correctly against the now-hardened backend, which the live curl
  verification below already exercised directly (the same endpoints and
  payloads the app itself sends).

7 new backend tests (idempotency + audit logs), plus a magic-byte upload
test and a currency-validation test added to existing suites — 157
backend tests total, all passing. Flutter's 28 tests are unchanged and
still pass (no client code changed this phase). Live-verified against a
rebuilt Docker image: idempotent replay (same transaction ID returned
twice, exactly one row persisted), the resulting audit log row, Trip-mode
currency normalization/rejection, and the new upload content-mismatch
rejection — all confirmed via direct `curl`/`psql` against the running
stack, not assumed from code review alone.

**Phase 15** (public launch) complete — the last phase in the product
spec's own phase plan:

- **Landing page** — `/` was, before this phase, the *authenticated*
  dashboard itself: a logged-out visitor hitting the bare domain just
  bounced to `/login` with no public content at all. The dashboard
  moved to `/dashboard` unchanged; `/` is now a real marketing page
  (hero, the Bagilah "Scan. Claim. Settle." flow, a personal-finance
  feature list, an honest "we never hold your money" trust section, and
  a real FREE/Duitlah+ pricing comparison), alongside a new
  `(marketing)` route group holding every other public page behind a
  shared header/footer.
- **Privacy policy, Terms of Service, Help Centre, FAQ** — real content
  grounded in what the product actually does (no funds custody, no
  advertising use of financial data, exactly which security measures are
  real), not templated boilerplate. The Privacy Policy explains account
  deletion (below) and is honest that self-service data export doesn't
  exist yet — only a support-assisted request does.
- **Status page** — a genuinely live client-side check against the
  API's own `/actuator/health`, refreshed every 30 seconds, not a static
  "all systems operational" claim.
- **Feedback system** — a new `feedback` module end-to-end: append-only
  table, `POST /api/v1/feedback` / `GET /api/v1/feedback/me`, and a real
  Flutter screen reachable from a new "Help & Support" entry in the More
  menu (which otherwise fans out to the new web pages via `url_launcher`
  — a `mailto:` support link included).
- **Error monitoring & analytics** — a new `telemetry` package
  (deliberately not named `analytics`, since that name was already the
  personal-finance dashboard feature) with `ErrorReportingService`/
  `ProductAnalyticsService`, each defaulting to structured server logs
  and optionally posting to a configured webhook — the same "optional
  provider, honest fallback, never a fake integration" shape as every
  external dependency in this codebase. Wired into `GlobalExceptionHandler`
  (every genuinely unhandled 5xx) and two real lifecycle events
  (`user_registered`, `subscription_purchased`).
- **Account deletion** — real and self-service
  (`DELETE /api/v1/users/me`, password-confirmed), not something the
  Privacy Policy could otherwise honestly promise. Building this
  surfaced a real, previously-unreachable consequence in the schema:
  `groups.owner_user_id` cascades on delete, so removing your own
  account would have silently deleted an entire shared group's history
  for every other member in it. Fixed with a pre-check
  (`409 OWNS_ACTIVE_GROUPS`) rather than a schema change — the cascade
  itself is correct everywhere else it applies.
- **A real bug found via this phase's own browser-console
  verification, not by inspection**: an unauthenticated `GET
  /api/v1/dashboard` fetch from `apps/web` failed as a CORS error, not a
  plain 401. Root cause: Spring Security's `.anyRequest().authenticated()`
  was rejecting the CORS *preflight* (`OPTIONS`) itself with 401 — a
  preflight has no `Authorization` header by design, so the browser
  read the 401 as "this origin isn't allowed" and never sent the real
  request. Fixed by explicitly `permitAll()`-ing `OPTIONS` in
  `SecurityConfig`; `CorsFilter` still enforces the actual allowed-origin
  check on every request.

12 new backend tests (feedback, telemetry webhooks, account deletion)
plus 6 existing tests updated for the new dependency wiring — 166
backend tests total, all passing. Flutter: 1 new test (29 total), all
passing; `flutter analyze` clean. Live-verified against a rebuilt Docker
image and a real Playwright browser session (not just curl): feedback
submission end-to-end, account deletion correctly blocked while owning
an active group then succeeding once resolved, wrong-password rejection,
the CORS preflight fix confirmed both via raw `OPTIONS` curl and a real
browser console (zero errors across every new/changed page after the
fix), and the status page's live health check genuinely reflecting the
backend's real state. Android emulator screenshots were not available
in this environment for this phase (no `adb`/Android SDK present) — the
new mobile screens (`FeedbackScreen`, `HelpSupportScreen`, the delete-
account confirmation dialog) are verified via `flutter analyze`,
`flutter test`, and direct backend live-verification of the exact
endpoints they call, a real but lighter-weight bar than prior phases'
full emulator walkthroughs; this is stated plainly rather than implied
otherwise.

This is the final phase in the product spec's numbered phase plan.
Remaining spec sections beyond Phase 15 (MVP definition, product/Bagilah
priority, UI copy, empty states, "do not do these," engineering quality,
code quality, documentation, required output format) are cross-cutting
guidance this project has followed throughout every phase above, not
further build phases of their own.

## Duitlah V2: Personal + Business + Shared finance platform

Following Phase 15, a separate "DUITLAH V2 — MASTER SYSTEM UPGRADE"
specification extends Duitlah from a personal+shared finance app into a
full Personal + Business + Shared platform (multi-tenant workspaces,
double-entry accounting, Malaysian tax centres, LHDN/MyInvois
e-invoicing, and more), while preserving 100% of Phase 0-15 functionality
unchanged. Its own starting instruction required an audit before any
code: [docs/v2-audit.md](docs/v2-audit.md) is that audit, and names the
proposed low-risk, incremental migration path each V2 phase below
follows.

**V2 Phase 1** (Financial Spaces) complete: a `FinancialSpace` (`PERSONAL`
| `BUSINESS`) is the workspace every later V2 module will scope itself
to. Every existing user gets exactly one `PERSONAL` space — enforced by a
partial unique index, and backfilled for every pre-existing user by the
new migration itself — and can additionally create any number of
`BUSINESS` spaces, each with its own `BusinessProfile` (legal name,
registration number, TIN, industry, SST number, and more, all optional
beyond legal name) and role-based membership (`OWNER`/`ADMIN`/`FINANCE`/
`ACCOUNTANT`/`SALES`/`STAFF`/`VIEWER`). No existing table gained a
`space_id` column this phase, and no existing query changed — this is
deliberately additive-only, verified in isolation before any later V2
phase wires existing or new features to it. A non-member gets `404`, not
`403`, for a space they don't belong to, the same convention every other
ownership check in this API already follows. `apps/mobile` gained one new
feature module (`spaces`): a real "Workspaces" list (Personal + Business),
a create-business-space form, and a read-only business profile view —
deliberately with no "switch active workspace" control yet, since nothing
is space-scoped for it to switch between (see
[financial-spaces.md](docs/financial-spaces.md) for why that's a
deliberate anti-placeholder choice, not an oversight). 4 new backend
tests (170 total) and 2 new Flutter tests (31 total) all pass. Live-
verified against a rebuilt Docker image via direct `curl`: registering a
new user auto-creates its Personal space, creating a Business space
persists correctly alongside it, its profile round-trips exactly as
sent, and a second real user genuinely cannot see or fetch the first
user's Business space (404).

**V2 Phase 2** (Personal Gap Closure I: Duitlah AutoTrack, statement
import, Receipt Vault) complete: a generalized transaction-ingestion
pipeline implementing the spec's own diagram literally — a bank statement
(CSV/XLSX/PDF, via a real adapter architecture — provider-specific
Maybank/CIMB/RHB parsers are the documented extension point, not built
without real export samples to parse correctly) or a Receipt Vault upload
each produce `TransactionCandidate` rows, server-side duplicate detection
flags (never silently discards) a possible match against existing
transactions, and a human always confirms, rejects, or resolves a flagged
duplicate (Keep Both / Merge / Ignore) before anything becomes a real
transaction — no candidate is ever auto-posted, regardless of confidence.
The Receipt Vault is a second, independent entity inside the existing
`receipts` module, sharing only the OCR engine with Bagilah's own
scan-and-confirm flow, which this phase leaves entirely unchanged — a
Vault upload can be tagged personal/business/tax-evidence/Bagilah-
reference, organized into folders/tags, searched by merchant, uploaded in
batches, and attached to an existing transaction afterward. 3 new backend
unit tests (duplicate-scoring, Spring-free) and 11 new integration tests
(184 total) plus 3 new Flutter JSON tests (34 total) all pass; `flutter
analyze` clean. A real bug was caught and fixed by this phase's own
integration tests before shipping: a nullable bind parameter inside a JPQL
`CONCAT`/`LIKE` expression made Postgres's JDBC driver unable to infer a
parameter type, failing with `function lower(bytea) does not exist` —
fixed by pre-computing the wildcard search pattern in application code
instead of concatenating it inside the query. Live-verified against a
rebuilt Docker image via direct `curl`: a CSV statement upload produced
real `PENDING` candidates, confirming one created a real transaction,
uploading a matching statement row against an existing transaction
correctly flagged it as a possible duplicate, and a Receipt Vault upload
persisted with its folder/tags searchable.

**V2 Phase 3** (Personal Gap Closure II: Bills, Loans/BNPL/Credit Cards,
Net Worth, Financial Health Score, custom budget cycles, multi-currency,
exports, notification infrastructure) complete. Personal Bills track
due-date status (`UPCOMING`/`DUE`/`OVERDUE`/`PAID`/`SKIPPED`) with a real
scheduler-driven reminder wired into a genuinely new notification
architecture, replacing the Phase 9.5 placeholder. Loans/BNPL/PTPTN track
outstanding principal computed from an append-only payment ledger, the
same discipline as goals/settlements; credit cards deliberately stay
ordinary accounts extended by a companion details row rather than a
second liability record, so purchases and repayments reuse the existing
transaction/transfer machinery with zero new money-movement code — the
exact literal implementation of the spec's own "purchases affect spending
when purchased, repayments move liability/cash, never a second expense."
Net Worth (`Assets - Liabilities`) and the Financial Health Score are both
computed fresh on every read from data already tracked elsewhere — the
score is fully deterministic (seven weighted, individually-explained
components; never a black box, never a credit score) and gracefully
excludes components a user's data can't yet support (no credit cards, no
tracked bills, no budgets) rather than penalizing them for it. Custom
budget cycles (payday/custom date ranges) and multi-currency transaction
snapshots are both purely additive — every budget/transaction created
before this phase, and every ordinary one created after it, is completely
unaffected. Exports produce real CSV/XLSX files (and a plain PDF) for
transactions/bills/loans/net-worth/budgets, plus a full-archive ZIP;
broader export types the spec also names (tax, business accounting,
Bagilah/Groups/settlements) are an honest, documented deferral, not an
oversight. 31 new backend integration tests (215 total) and 9 new Flutter
JSON tests (43 total) all pass; `flutter analyze` clean. Live-verified
against a rebuilt Docker image.

**V2 Phase 4** (Personal Tax Centre: YA-versioned rules, PCB, zakat, tax
reliefs, tax documents, deterministic calculation, filing readiness)
complete. The tax-rule tables (brackets, relief ceilings, a
chargeable-income rebate) are versioned per Year of Assessment exactly as
the spec demands — a stale or wrong rate is a data correction, never a
code change, and never something that invalidates an already-computed
prior year. **Honesty note, stated plainly rather than buried:** the
seeded YA2024-YA2026 figures reflect the assistant's general knowledge of
the published LHDN structure, not a live feed or an official dataset —
every calculation carries an explicit disclaimer, and this is a real
limitation to verify against official LHDN circulars before relying on
for actual filing, not boilerplate. The tax-relief pipeline
(Transaction/Receipt/Document → Candidate → Review → Confirmed) reuses a
genuinely real signal — a Receipt Vault upload the user already tagged
`TAX_EVIDENCE` (Phase 2) — rather than a fabricated merchant-category
guess; a candidate never becomes a real relief without an explicit
confirm, which also clamps the claimed amount to that category's legal
ceiling. The calculation service is fully deterministic (no model call
anywhere in it) and returns every intermediate figure in the pipeline,
not just the final number, with the disclaimer always present. Filing
readiness is an explainable checklist reflecting only real, actionable
data (recorded income/EA/PCB, and whether a relief candidate is still
sitting unreviewed) — never a guess about what a user "should" have. The
PDF preparation summary reuses Phase 3's `PdfExportWriter` rather than a
second PDF-writing code path, and is explicitly a reference document, not
an LHDN submission. 18 new backend integration tests (233 total,
including hand-computed progressive-bracket and zakat-clamping math
against the seeded rules) and 4 new Flutter JSON tests (47 total) all
pass; `flutter analyze` clean. Live-verified against a rebuilt Docker
image.

**V2 Phase 5** (Business Core: team RBAC, customers, suppliers, products,
business accounts, expenses/payables, quotations, invoices, credit
notes, business dashboard) complete. `SpaceRole` has existed unenforced
since Phase 1; this phase adds real server-side `BusinessPermission`
checks (a genuine `403 INSUFFICIENT_PERMISSION`, never a hidden button)
so a business's team actually has teeth. Business accounts are
structurally isolated from personal accounts per spec, with the same
computed-never-stored balance discipline as everywhere else in this
codebase. Payables run through `BusinessExpense` (a supplier bill IS an
expense with a supplier attached — no separate Purchases module this
phase); an invoice's own stored status is deliberately just DRAFT/SENT/
VOID, with PARTIALLY_PAID/PAID/OVERDUE always computed fresh from its
payment/credit-note history, the same precedent `settlements` set
earlier. An accepted quotation converts to a real draft invoice,
copying customer/lines/tax across. The double-entry accounting engine
(Chart of Accounts, journals, General Ledger, Trial Balance, P&L,
Balance Sheet) described elsewhere in the spec is explicitly **not**
part of this phase — that's Phase 6's own scope, confirmed by re-reading
Phase 6's literal bullet list, not assumed. 41 new backend integration
tests (274 total, including a real cross-role 403 and the sole-owner
guard) all pass; `flutter analyze` clean. Live-verified against a
rebuilt Docker image.

**V2 Phase 6** (Business Accounting Engine: Chart of Accounts, journal
entries/lines, accounting periods, automatic posting, General Ledger,
Trial Balance, P&L, Balance Sheet, Cash Flow, accounting exports)
complete. Double-entry is enforced twice — a deferred database
constraint trigger on `journal_lines` (checked at commit, since a
multi-line entry's rows insert one at a time) and a service-level check
before that, so the common case gets a clean `409
JOURNAL_ENTRY_NOT_BALANCED` rather than a raw SQL error; a dedicated
test bypasses the service via raw JDBC to prove the database trigger
itself is real, not just decorative. `bizbanking`, `bizexpenses`, and
`sales` each gained a new dependency on the new `accounting` module (for
chart-of-accounts mapping and automatic posting) while `accounting`
itself depends on none of them — the same one-directional "producer
depends on recorder" shape as `receipts` → `personaltax` in Phase 4,
applied three times over. Automatic posting is deliberately a
best-effort enhancement, never a gate: a space that hasn't seeded a
chart of accounts, or hasn't mapped a specific bank account or expense
to a ledger account, keeps using every Phase 5 feature exactly as it
worked before this phase existed — `AutomaticPostingService` silently
skips wherever a mapping is missing. The seeded 24-account Malaysian
SME-friendly Chart of Accounts is a reasonable general-purpose default,
not a statutory numbering, and is fully renameable/extensible after
seeding. The Balance Sheet shows cumulative net income as its own
"Current Earnings" equity line (there's no formal period-close step
this phase that rolls it into Retained Earnings) so it balances without
a closing entry every period — a documented simplification, same as
Cash Flow's direct-method (not Operating/Investing/Financing-categorized)
summary. 17 new backend integration tests (291 total) all pass;
`flutter analyze` clean. Live-verified against a rebuilt Docker image.

**V2 Phase 7** (Reconciliation: business statement import, a
deterministic matching engine, reconciliation sessions, Match/Create
Transaction/Ignore/Split, session-level Resolve Difference) complete.
Reuses two existing pieces of infrastructure directly rather than
duplicating them: Phase 2's `statements.StatementParser` adapters do
the actual CSV/XLSX/PDF parsing (no second parsing code path), and the
phase's own "persist reconciliation history" requirement is satisfied
by extending the existing generic `audit_logs` table (Phase 14) with
five new action types rather than building a second audit mechanism.
The matching engine is deliberately deterministic — an EXACT match
(same date, same amount) or a PROBABLE one (amount matches within a
date window, or date matches within a small tolerance) against
not-yet-allocated ledger entries, no fuzzy scoring. A reconciliation
session auto-opens on every successful statement import (1:1); Resolve
Difference compares a user-entered statement ending balance (the
generic parsers extract line rows, not a header/footer figure, so
asking the user is honest rather than fabricated) against the business
account's current computed balance, posting one real adjustment ledger
entry for any gap. 10 new backend integration tests (301 total) all
pass; `flutter analyze` clean. Live-verified against a rebuilt Docker
image.

**V2 Phase 8** (Inventory & Costing: stock movements, product
inventory, Weighted Average Cost, COGS, ingredient/recipe costing,
low-stock alerts) complete. Quantity on hand, Weighted Average Cost,
and total inventory value are never stored — all three are computed on
read from the append-only `inventory_movements` table, the same
discipline as every other balance in this codebase. A movement's own
*sign*, not its type, decides how its unit cost is set: an inbound
movement requires the caller to supply the real cost paid; an outbound
movement always has its cost computed server-side from the current
Weighted Average Cost, so a past sale's locked-in cost can never be
second-guessed by a client. Two new `AutomaticPostingService` methods
reuse Phase 6's already-seeded but previously-unused "Inventory"
(`1030`) and "Cost of Goods Sold" (`5000`) system ledger accounts — no
new seed needed. Issuing an invoice for a tracked-inventory product now
auto-posts a real SALE movement and COGS
(`sales.InvoiceService`→`inventory`, the one place a producer module
depends on inventory rather than the reverse), idempotent per invoice
line item so re-issuing never double-counts a sale. Ingredient/recipe
costing is deliberately optional and one level deep: a product with no
recipe rows simply has no recipe cost to report. A new daily
`LowStockAlertScheduler` notifies every member who can manage products
once a tracked product's stock dips to or below its reorder point,
deduped so a sustained dip sends exactly one alert. 16 new backend
integration tests (317 total) all pass; full regression suite
reconfirmed clean. Live-verified against a rebuilt Docker image.

**V2 Phase 9** (Fixed Assets: asset register, depreciation, disposal,
journal generation) complete. Accumulated depreciation is never stored
— it's computed on read from an append-only `asset_depreciation_entries`
ledger, the same discipline as every other balance in this codebase.
Two depreciation methods, both literal and deterministic: Straight-Line
(`(cost - salvageValue) / usefulLifeMonths`, flat every period) and
Double Declining Balance (`netBookValue * (2 / usefulLifeMonths)`,
shrinking every period) — named precisely rather than a generic
"declining balance" so the exact rate is never ambiguous, both floored
so an asset never depreciates below its salvage value. Three new
`AutomaticPostingService` methods cover acquisition (debit Fixed
Assets, reusing Phase 6's already-seeded but previously-unused account),
depreciation (debit Depreciation Expense, credit Accumulated
Depreciation), and disposal (one balanced entry removing the asset from
the books and posting the resulting gain or loss). Accumulated
Depreciation and Gain/Loss on Disposal are both seeded as plain
`ASSET`/`REVENUE` account types rather than a new contra-account
concept — this codebase's existing "signed relative to the account's
own normal side" convention already produces correct contra-asset and
loss behavior with no schema change needed. Cost, salvage value, useful
life, method, and acquisition date lock once any depreciation has
posted (renaming or recategorizing stays open) — changing them
retroactively would silently invalidate every period already
depreciated. Disposal proceeds require a real receiving business
account whenever non-zero, so the journal's cash leg is never silently
dropped. 16 new backend integration tests (333 total) all pass; full
regression suite reconfirmed clean. Live-verified against a rebuilt
Docker image.

**V2 Phase 14** (Final Hardening) complete. Audited authorization boundaries,
data isolation, financial/accounting/tax invariants, migrations, API docs, and
the documented mobile/web scopes. Closed a settlement-overpayment race with a
parent-row lock and remaining-balance guard; added historical-YA and
credit-card-spending regressions; added executable latency and PostgreSQL
backup/restore smoke gates; and added keyboard skip navigation to both web
shells. See `docs/final-hardening.md`. No database migration was required.

**V2 Phase 10** (LHDN / MyInvois / SST: business tax infrastructure,
SST, MyInvois adapter, TIN handling, document submission, status
tracking, validated document handling, cancellation/rejection,
readiness rules) complete. Spec section 56 explicitly demanded "use
current official LHDN specifications at implementation time" — a live
web search and fetch against the official MyInvois SDK site at
implementation time (August 2026) immediately validated the sibling
warning against a single hardcoded e-Invoice threshold: the real
exemption threshold had changed from RM500,000 to RM1,000,000 since
this phase was originally scoped. `EInvoiceMandateRule` and `SstRate`
are both versioned reference tables for exactly that reason. The
provider abstraction follows spec section 55's own named shape —
`EInvoiceProvider` / `MyInvoisProvider` / `UnavailableEInvoiceProvider`
/ `MockEInvoiceProvider` (test-only) — with `UnavailableEInvoiceProvider`
as the real default bean in every environment until a space configures
genuine LHDN credentials: every one of its methods fails with a clear
`503`, matching the spec's "production must never return fake success"
literally rather than as an aspiration. `MyInvoisProvider` is a real
HTTP client against the documented OAuth2 login and document
submission/status/cancel/reject endpoints — with one stated scope
boundary: LHDN's required certificate-based document signature isn't
implemented, so a real go-live submission would still need that piece
added, exactly the kind of honest limitation this project states
outright rather than papers over. Business tax readiness (spec section
57's onboarding checklist) turned out to already be nearly complete —
`spaces.BusinessProfile` from Phase 5 already carried `tin`,
`registrationNumber`, `sstNumber`, `businessType`, `industry`, and
financial year; only `annualRevenue` was missing, and `BusinessProfile`
gained its first-ever update endpoint in the process. SST reporting
reuses the existing "SST/GST Payable" ledger account and General Ledger
report rather than a second tax-tracking mechanism. A real bug was
caught during live Docker verification, not by the automated tests:
the log of a *failed* provider attempt was being rolled back along
with the request that threw, silently defeating spec section 56's "all
provider interactions must be auditable" for exactly the interactions
most worth keeping a record of — fixed with a `REQUIRES_NEW`-propagated
recorder so the log commits independently, then covered by a new
regression test and re-verified live. 14 new backend integration tests
(347 total) all pass; full regression suite reconfirmed clean.
Live-verified against a rebuilt Docker image.

**V2 Phase 11** (Cross-Space Accounting: personal-paid business
expense, reimbursement, owner contribution, owner drawing, due
to/from owner, cross-space references, consolidated personal
reporting) complete. Section 58's own words — "allow a transaction to
be linked across spaces without merging books" — are the literal
design: `cross_space_links` only ever records that an already-existing
Personal transaction produced a real Business journal entry; neither
ledger is ever merged, duplicated, or mutated into the other's shape,
and this module never synthesizes a fake Personal transaction on a
user's behalf. Every linked transaction must belong to the acting user
— a real privacy boundary, not just an ownership check, since a
business's staff could otherwise reference another person's private
financial data. "Due to/from owner" is a single new liability account
("Due to Owner") that covers both directions via its own signed
balance, the same trick Phase 9's contra-asset/loss accounts already
established — no separate asset-side account needed. Owner
contribution and owner drawing reuse Phase 6's already-seeded but
previously-unused "Owner's Capital"/"Owner's Drawings" accounts.
Testing the "missing Due to Owner account" path surfaced a genuinely
useful distinction: archiving an existing seeded account instead
surfaces `accounting.JournalEntryService`'s own pre-existing, more
specific `409 LEDGER_ACCOUNT_ARCHIVED` guard — correct, existing
behavior, not a bug — so the test was rewritten to use a truly custom
Chart of Accounts that never seeded the account at all. The
consolidated "Combined Personal View" (spec section 61) composes the
existing Personal net worth computation with each Business space's
computed equity — informational only, exactly as the spec insists,
never merging the underlying bookkeeping. A second real bug was caught
here during live verification: the combined view initially summed only
`BalanceSheetService`'s `totalEquity`, silently excluding
`currentEarnings` — Phase 6's own separate field for current-period
net income, since there's no period-close step rolling it into
Retained Earnings — which understated every business's true ownership
value by exactly its current profit or loss. Fixed, covered by a new
regression test spanning both a capital injection and a real expense,
and re-verified live. 10 new backend integration tests (357 total) all
pass; full regression suite reconfirmed clean. Live-verified against a
rebuilt Docker image.

**V2 Phase 12** (AI Financial Assistant V2: workspace-aware tools,
widened affordability inputs) complete. This phase discovered an entire
pre-existing "AI V1" implementation (`com.duitlah.api.ai`, from the
original pre-V2 spec numbering) that already matched section 65's exact
required pipeline ("Question -> Approved read-only tools -> Structured
financial facts -> LLM -> Explanation") — so this phase extended it
rather than rebuilding it. The single hardcoded Personal-only tool
switch became a pluggable `AiToolProvider` interface (matching the
`EInvoiceProvider`/`NotificationProvider` shape), with
`PersonalAiToolProvider` (14 tools: the original 9 plus 5 new —
net worth, loans, bills, tax summary, tax reliefs),
`BusinessAiToolProvider` (10 new tools: dashboard, P&L, balance sheet,
cash flow, receivables, payables, overdue invoices, inventory, SST/
e-Invoice readiness, reconciliation status), and `SharedAiToolProvider`
(3 new tools over Groups/Bagilah/Settlements — a structurally separate
"money split between people" concept, not a third `SpaceType`). A new
`ChatRequest.activeSpaceId` field, resolved through the same
membership-enforcing `SpaceService.getSpace` every other module uses,
decides which providers are active per request: Personal and Shared
tools are always available, Business tools only once the active space
is confirmed to be a real business the caller belongs to. Every tool
provider is still a thin pass-through to an already-existing,
already-authorized service — no new schema, no repository the model
can reach directly. `AffordabilityService` (spec section 68) widened
its inputs to fold upcoming bills and debt repayments into the same
deterministic `canAfford` check as existing settlement debts, while
surfacing credit utilization, savings goals, and remaining budget as
informational context rather than mixing them into the pass/fail math.
10 new backend integration tests (367 total) all pass; full regression
suite reconfirmed clean. Live-verified against a rebuilt Docker image,
including the upgraded affordability endpoint's new obligation fields
against real transaction and bill data.

**V2 Phase 13** (Advanced Automation: recurring invoices, transaction
rules, automatic categorization, Smart Capture improvements,
statement-learning, receipt automation, intelligent reconciliation,
notification rules) complete. Research before writing any code
confirmed all eight spec bullets were genuine gaps, and that three of
them collapse into one mechanism: a new `transactionrules` module's
`TransactionRuleService.suggestCategory` (user-defined merchant rules,
consulted ahead of the existing last-merchant-transaction heuristic)
covers "transaction rules" and "automatic categorization" at once,
while `learnFromConfirmation` — which upserts a rule every time a
user confirms an AutoTrack candidate with a category — is
"statement-learning": every learned rule is exactly as visible and
editable as a hand-authored one, no hidden model behind it. Recurring
invoices mirror `recurring.RecurringTransaction`'s exact schedule
shape inside `sales`, reusing its `RecurrenceFrequency`/
`RecurrenceCalculator` directly; every materialized invoice is
`DRAFT`, never auto-sent, so nothing posts to accounting until a human
reviews it. "Smart Capture improvements" turned out to name no
pre-existing feature at all — the real gap was `ParsedReceipt`'s own
`overallConfidence` never being used for anything; it now drives a
server-computed `needsReview` flag on both receipt-scan flows, so
every client applies the same "double-check this" threshold instead
of guessing its own. "Receipt automation" adds an EXACT/PROBABLE
transaction-match suggestion endpoint for the Receipt Vault (same
deterministic two-tier shape reconciliation's own matcher uses,
advisory only) and wires up `PersonalBill.receiptId`, a column that
existed with no write path anywhere in the codebase. "Intelligent
reconciliation" respects reconciliation's own documented "no fuzzy
scoring" design decision from Phase 7 — it adds one explicit,
user-triggered bulk-auto-match action that applies only genuinely
unambiguous EXACT suggestions (exactly one candidate), leaving
anything ambiguous for a human, by reusing the existing match action
directly so the audit trail is identical either way. "Notification
rules" gates the existing `NotificationService.notify` behind a new
per-user, per-type enable/disable check — a single choke point, so
none of the three existing hardcoded triggers needed to change — and
brings two long-missing triggers online for the first time
(`BUDGET_EXCEEDED`, dedup on the budget row itself; `LOW_BALANCE`,
opt-in only since it needs a user-supplied threshold to mean
anything). 21 new backend integration tests (388 total) all pass; full
regression suite reconfirmed clean. Live-verified against a rebuilt
Docker image.
