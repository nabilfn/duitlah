# Duitlah V2 Upgrade Audit (Phase 0)

Produced per the V2 master upgrade prompt's own "Starting Instruction": inspect the
existing repository before writing any V2 code, and do not proceed past Phase 0
until this audit exists. Nothing in this document changes behavior — it is pure
research.

---

## 1. Current architecture

```text
Flutter Mobile App  ──┐
                      │  HTTP/JSON + JWT
Next.js Web App     ──┼──▶  Spring Boot API ──▶ PostgreSQL
                      │                     ├──▶ Redis
                      │                     └──▶ MinIO (S3-compatible)
```

- **Backend is the sole source of financial truth.** Neither client computes an
  authoritative balance, split, or settlement — this is already the project's
  first architectural law (see `docs/architecture.md`), and V2's "clients remain
  presentation and intent layers" principle is a continuation, not a new rule.
- **Flutter is the primary client** (`apps/mobile`) as of the Phase 9.5 migration.
  `apps/web` (Next.js) is a secondary companion: guest Bagilah access, an
  authenticated dashboard mirror, and — as of Phase 15 — the product's public
  marketing/legal surface (landing page, privacy, terms, help, FAQ, status).
- **Infra**: Docker Compose runs `api`, `postgres`, `redis`, `minio`, `web`
  locally. Flyway is the only schema-authoring path; Hibernate is pinned to
  `ddl-auto: validate`, never `update`.

## 2. Current modules

Backend packages under `com.duitlah.api.*`, one per bounded context:

```text
auth            JWT issuance, refresh rotation + reuse detection, sessions,
                password reset, email verification, rate limiting
users           Profile, account deletion (password-confirmed, blocked while
                owning an active group)
profiles        Empty placeholder (package-info.java only) — never built out
finance         Accounts, categories (system + user-custom, 2-level tree)
transactions    Personal ledger (transfers included)
budgets         Monthly budgets, category-scoped or overall
goals           Personal + shared savings goals, goal_contributions ledger
groups          Groups (7 types incl. HOUSEMATES/COUPLE/TRIP), group expenses,
                group goals, group budgets, special-mode sections
bagilah         The flagship bill-splitting engine — bills, receipt items,
                participants (auth'd + guest), item claims (whole/qty/%/custom),
                discounts, tax, service charge, finalize snapshots
settlements     Debt simplification, settlement payments (partial/full),
                dispute/cancel, counterparty summaries
receipts        Upload → OCR (Claude Vision or Unavailable fallback) →
                structured parse → user review → confirms into an ordinary
                bagilah bill
recurring       Recurring transactions/subscriptions, calendar projection
analytics       Dashboard summary, forecast, monthly trends
subscriptions   Duitlah+ entitlements (FREE/PLUS), usage-scoped by ownership
                not membership
ai              Claude-backed chat + affordability check, both routed through
                a fixed read-only FinanceQueryService — the LLM never touches
                a repository directly
audit           Append-only audit_logs (actor SET NULL on delete, not CASCADE)
                for the 8 actions product spec section 50 names
feedback        User-submitted feedback (Phase 15) — append-only, no
                admin-facing browse/triage yet
telemetry       Error monitoring + product analytics — Logging* fallback +
                optional generic-webhook implementation, never a fake
                integration
notifications   Empty placeholder — never built out
common          Cross-cutting: idempotency (Redis SETNX + response replay),
                mail (LoggingEmailSender), storage (S3ObjectStorage), security
                (SecureTokens), money (rounding/allocation utilities), jpa
                (AuditableEntity), error (ApiException hierarchy + global
                handler), response (ApiError shape)
config          Security filter chain, CORS, OpenAPI
```

Mobile (`apps/mobile/lib/features/*`, feature-first): `auth`, `home`,
`accounts`, `transactions`, `budgets`, `goals`, `groups`, `bagilah`, `receipts`,
`settlements`, `notifications`, `recurring`, `insights`, `assistant`,
`subscriptions`, `profile`, `feedback`. Shared design system lives in
`lib/core/` (theme, widgets, api client, routing).

Web (`apps/web/src/app`): `(marketing)` route group (landing, privacy, terms,
help, faq, status — public, no auth), `(auth)` (login/register/reset/verify),
then `dashboard`, `accounts`, `transactions`, `budget`, `goals`, `groups`,
`bagilah`, `settlements`, `profile` as the authenticated companion surface.

## 3. Current database schema

30 tables across 15 migrations, **every primary key is `UUID DEFAULT
gen_random_uuid()`** — no auto-increment integer PKs anywhere, which matters
directly for V2: a `financial_spaces`/`space_members` schema can foreign-key
against every existing table's `id`/`user_id` columns without a PK-type
migration.

Every FK to `users(id)` is `ON DELETE CASCADE` with exactly one deliberate
exception: `audit_logs.actor_user_id` is `ON DELETE SET NULL` (an audit trail
must outlive the actor). This rule was violated once by accident in Phase 11
(`group_expenses`/`group_expense_shares` used plain `REFERENCES`) and fixed —
worth remembering as a checklist item for every new FK V2 adds.

Money columns are `NUMERIC`/`DECIMAL`, never floating point, already matching
V2 section 4's requirement. `V14__hardening_constraints.sql` added `CHECK`
constraints on Trip-mode's currency-snapshot columns after a full
column-by-column review found that was the only numeric column set missing
one — the same review discipline V2 will need for every new business/tax
numeric column.

Full table list:

```text
users, auth_sessions, email_verification_tokens, password_reset_tokens
accounts, categories, transactions
budgets, goals, goal_contributions
groups, group_members, group_expenses, group_expense_shares
group_budgets, group_goals, group_goal_contributions
bills, receipt_items, bill_participants, item_claims, bill_payments,
  bill_final_amounts, bill_guest_sessions
receipt_scans
settlements, settlement_payments
recurring_transactions
user_subscriptions
audit_logs
feedback
```

## 4. Existing migrations

```text
V1  init (pgcrypto extension for gen_random_uuid())
V2  auth (users, auth_sessions, email_verification_tokens, password_reset_tokens)
V3  personal_finance (accounts, categories, transactions)
V4  budgets_and_goals (budgets, goals, goal_contributions)
V5  groups (groups, group_members, group_expenses, group_expense_shares)
V6  bagilah (bills, receipt_items, bill_participants, item_claims,
             bill_payments, bill_final_amounts)
V7  bagilah_collaboration (invite_token_hash, bill_guest_sessions)
V8  receipts (receipt_scans)
V9  settlements (settlements, settlement_payments)
V10 recurring_transactions
V11 special_group_modes (group_budgets, group_goals, group_goal_contributions,
                          Trip-mode currency snapshot columns on group_expenses)
V12 subscriptions (user_subscriptions)
V13 audit_logs
V14 hardening_constraints (CHECK constraints on Trip-mode currency columns)
V15 feedback
```

V2's first real migration will be **V16**.

## 5. Current API structure

All routes under `/api/v1`, JWT bearer auth via `JwtAuthenticationFilter`
(`@AuthenticationPrincipal UUID userId` in every controller), stateless
sessions, CSRF disabled (bearer-token API, not cookie-session). Ownership/
membership checks return **404, never 403**, for anyone without access — a
pattern V2 must extend to space membership, not replace.

```text
POST   /api/v1/auth/register|login|refresh|logout|logout-all
GET    /api/v1/auth/sessions          DELETE /api/v1/auth/sessions/{id}
POST   /api/v1/auth/verify-email(/resend)
POST   /api/v1/auth/password-reset/request|confirm

GET    /api/v1/users/me   PATCH /api/v1/users/me   DELETE /api/v1/users/me
POST   /api/v1/users/me/change-password

/api/v1/accounts, /api/v1/categories, /api/v1/transactions
/api/v1/budgets, /api/v1/goals(/{id}/contributions)
/api/v1/groups (+ special-mode sub-resources: goals, budget, trip-summary,
  housemate-dashboard)
/api/v1/bagilah/join (public), /api/v1/bagilah/guest/** (public)
/api/v1/bills/**  (owner/participant surface)
/api/v1/receipts/scans
/api/v1/settlements
/api/v1/recurring-transactions
/api/v1/subscriptions/me, /api/v1/subscriptions/verify
/api/v1/ai/chat, /api/v1/ai/affordability
/api/v1/feedback, /api/v1/feedback/me
/api/v1/dashboard, /api/v1/analytics/**
/api/v1/version (VersionController)
```

Idempotency: any `POST`/`PUT`/`PATCH` carrying an `Idempotency-Key` header is
deduplicated by a blanket `IdempotencyFilter` (Redis `SETNX` claim + exact
response replay, 24h TTL) — already exactly the mechanism V2 section 72 asks
to extend to invoice issuance, journal posting, MyInvois submission, etc. No
new idempotency infrastructure is needed, only new call sites.

## 6. Existing mobile structure

Feature-first: `data/` (repositories over a single Dio `ApiClient`),
`application/` (Riverpod providers), `presentation/` (screens/widgets), per
feature. GoRouter with a `StatefulShellRoute.indexedStack` bottom nav (Home /
Transactions / Bagilah / Groups / More). `flutter_secure_storage` for the
refresh cookie jar; access token is memory-only.

A full visual redesign (Plus Jakarta Sans, teal/navy/orange palette, light +
dark mode, a lifted Bagilah nav button) was completed just before this V2
prompt arrived — the design system (`lib/core/theme/*`) is current and
already forward-compatible with a workspace switcher, since nothing in it
assumes a single financial context.

## 7. Existing web structure

Next.js App Router, TanStack Query + a typed `api-client.ts` wrapper, Zustand
for auth state only. `(marketing)` route group (public) is fully separate from
the authenticated app (`/dashboard` + feature routes), added in Phase 15
specifically so a logged-out visitor has a real landing page instead of
bouncing straight to `/login`.

## 8. Existing tests

166 backend test files' worth of methods across 23 test source files
(Testcontainers-backed: real Postgres/Redis/MinIO, not mocks), 29 Flutter
tests (mostly JSON-parsing contract tests + a handful of widget tests). Every
phase this session completed ended with a full green run of both suites
before being reported done — that discipline should continue unchanged into
V2's phases.

Notably present already: genuine concurrency tests (idempotency race-tested
with 5 real threads), and a running "calculation audit" habit (spot-checking
new numeric logic against existing, already-hardened engines like
`BagilahCalculationEngine`/`DebtSimplifier` rather than re-testing from
scratch).

## 9. Features already complete (map to V2 sections)

| V2 asks for | Already exists as |
|---|---|
| §4 exact-money invariants | `common.money` allocators, Bagilah/Debt-simplifier engines, V14's constraint review |
| §62-64 preserve Bagilah/Groups/Settlements | Fully implemented, this session's own Phases 6-11 |
| §65 AI tool-boundary | `FinanceQueryService` fixed read-only surface, `AffordabilityService` LLM-free |
| §71 audit logging | `audit` module, append-only, actor `SET NULL` |
| §72 idempotency | `IdempotencyFilter`, already blanket-applied |
| §73-74 security/404-not-403 | Auth module, ownership checks, this session's own permission review found zero gaps |
| §75 file upload security | Receipt uploads already check magic bytes + declared MIME + size (Phase 14 fix) |
| §86 entitlement architecture | `subscriptions` module, server-authoritative, real verifier interface honestly unimplemented |
| §87-88 provider adapters, graceful degradation | `EmailSender`, `ReceiptOcrService`, `AiChatService`, `SubscriptionVerifier`, `telemetry` — all Logging/Unavailable-fallback pattern already established |
| §94 no fake success | Established discipline all session (Duitlah+ "coming soon" instead of fake checkout, etc.) |

## 10. Features partially complete

- **`notifications` and `profiles` packages** — placeholders only
  (`package-info.java`, no code). V2 §24 wants a real `NotificationService`
  with provider abstraction; this is a from-scratch build, not an upgrade.
- **Multi-currency** — Trip-mode has a currency *display snapshot* only
  (original amount/currency/rate, purely cosmetic; the real ledger amount is
  always MYR). V2 §22 wants this generalized across accounts, which is a real
  behavior change, not just wider display.
- **Duitlah+ entitlement checks** — real and server-side, but
  `SubscriptionVerifier` has no working provider (`UnavailableSubscriptionVerifier`
  everywhere) — V2 §86's new tiers still need a real store integration this
  repo doesn't have credentials for.
- **Receipt OCR** — real (Claude Vision or Unavailable), but scoped
  specifically to Bagilah. V2 §14 wants a reusable Receipt domain that also
  feeds personal/business expenses and tax evidence.

## 11. V2 features missing entirely

Everything under sections 6-61 and 65-70 (Business side) and the tax
sections (25-30, 53-57) has **zero existing backend/schema/UI** — this is
correctly scoped by the prompt itself as new bounded contexts, not an
upgrade of something partial:

```text
FinancialSpace / SpaceMember / workspace switcher
Transaction ingestion (candidates, duplicate detection, statement import)
Receipt Vault, Personal Bills, Loans/BNPL/Credit cards, Net Worth,
  Financial Health Score, custom budget cycles
Personal Tax Centre (YA-versioned rules, reliefs, PCB, zakat, filing readiness)
Business: profile, RBAC, double-entry accounting engine, Chart of Accounts,
  banking, reconciliation, customers/suppliers, products/inventory/COGS,
  quotations/invoices/credit notes, AR/AP aging, fixed assets, reports
  (P&L/Balance Sheet/Cash Flow/Trial Balance/GL)
Business Tax Centre, SST, MyInvois provider integration
Cross-space transactions (reimbursable, owner contribution/drawing)
```

## 12. Database migration risks

- **Every existing table already uses UUID PKs** — low risk for FK'ing new
  `financial_spaces`/`space_members` tables against them.
- **Real risk: retrofitting `space_id` onto 30 existing tables is exactly
  what V2 §7 itself warns against** ("do not blindly add `space_id` to every
  table immediately"). The safest reading: Personal data stays keyed by
  `user_id` as it is today (a user's Personal space is 1:1 with their
  `users.id`, so no new column is needed there at all — the Personal
  `FinancialSpace` row can simply carry `owner_user_id = users.id` and every
  existing query keeps filtering by `user_id` exactly as now). Only
  genuinely new Business-side tables need `space_id` from day one.
- **`groups`/`bagilah` do not need `space_id`** at all under this reading —
  Shared stays exactly as it is; V2 §63-64 explicitly says "preserve," not
  "migrate into Financial Spaces."
- **CHECK constraint discipline** (established V14 pattern) must extend to
  every new business numeric column (invoice totals, journal amounts,
  inventory costs) — this is a real, recurring cost of the accounting engine,
  not a one-time task.
- **Double-entry invariant (`debits = credits`) cannot be a pure application
  check** — a concurrent bug could post an unbalanced entry. This needs a
  database-level safeguard (e.g. a deferred constraint trigger summing
  `journal_lines` per `journal_entry_id`), not just service-layer validation,
  the same reasoning that led this session to add real DB `CHECK` constraints
  rather than trusting application code alone (V14).

## 13. Authentication/authorization migration risks

- Current authorization is entirely **user-scoped** (`@AuthenticationPrincipal
  UUID userId` + a direct ownership/membership repository check per
  controller). Business RBAC needs a **second authorization axis** — "does
  this user have role X in space Y" — that doesn't yet exist anywhere in the
  codebase.
- Risk: bolting space-membership checks onto existing per-user checks
  inconsistently. The safer path is a single new cross-cutting concern (e.g.
  a `@RequireSpaceRole` method-level check or a `SpaceContext` resolved once
  per request from a header/claim) applied uniformly to every new Business
  controller from the start, mirroring how `JwtAuthenticationFilter` is the
  *one* place identity is resolved today.
- Risk: Personal-space endpoints must **not** start requiring a space
  header/context — they must keep working exactly as today for existing
  clients per V2 §77 ("prefer extending `/api/v1` where backward
  compatibility is possible").

## 14. Personal-space migration approach

Given finding #12 above (Personal doesn't need a `space_id` column at all),
the migration for existing users can be nearly free:

1. `V16` creates `financial_spaces` and `space_members`.
2. A one-time backfill inserts one `PERSONAL` `financial_spaces` row per
   existing `users` row (`owner_user_id = users.id`), and one
   `space_members` row (the user, role `OWNER`).
3. No existing table gains a new column. No existing query changes. Existing
   users lose nothing and notice nothing — the audit's own required outcome
   (V2 §85: "must not require users to recreate data").
4. The workspace switcher becomes additive UI: for a user with only a
   Personal space, it can even stay hidden entirely until they create (or are
   invited to) a Business space.

## 15. Proposed FinancialSpace architecture

```sql
CREATE TABLE financial_spaces (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    type           VARCHAR(20) NOT NULL CHECK (type IN ('PERSONAL','BUSINESS')),
    name           VARCHAR(120) NOT NULL,
    owner_user_id  UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    status         VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE space_members (
    id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    space_id     UUID NOT NULL REFERENCES financial_spaces(id) ON DELETE CASCADE,
    user_id      UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role         VARCHAR(20) NOT NULL,
    status       VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    joined_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (space_id, user_id)
);
```

A new `spaces` backend module owns these two tables and nothing else — same
"plain repository dependency, not a business dependency" shape `groups`
already uses against `users.UserRepository`. Every future Business
controller depends on `spaces` for authorization the same way every
controller today depends on `JwtAuthenticationFilter`'s principal.

## 16. Proposed Business bounded context

A new top-level package family, siblings to today's `groups`/`bagilah`, not
nested inside them: `business` (profile, RBAC), `accounting` (COA, journals,
periods, reports), `sales` (customers, quotations, invoices, credit notes,
AR), `purchases` (suppliers, bills, AP), `inventory` (products, stock
movements, COGS), `assets` (fixed assets/depreciation), `tax` (shared
YA-versioned rule engine used by both Personal and Business tax), `myinvois`
(provider adapter). Each is its own bounded context per V2 §99's own
"clear bounded contexts, small focused services" rule — mirroring how
`bagilah`, `settlements`, and `groups` are already separate today rather than
one mega-module.

## 17. Proposed accounting architecture

```sql
CREATE TABLE chart_of_accounts (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    space_id   UUID NOT NULL REFERENCES financial_spaces(id) ON DELETE CASCADE,
    code       VARCHAR(20) NOT NULL,
    name       VARCHAR(120) NOT NULL,
    type       VARCHAR(20) NOT NULL CHECK (type IN
                 ('ASSET','LIABILITY','EQUITY','REVENUE','EXPENSE')),
    is_active  BOOLEAN NOT NULL DEFAULT true,
    UNIQUE (space_id, code)
);

CREATE TABLE journal_entries (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    space_id      UUID NOT NULL REFERENCES financial_spaces(id) ON DELETE CASCADE,
    entry_date    DATE NOT NULL,
    memo          VARCHAR(255),
    source_type   VARCHAR(40),   -- e.g. 'INVOICE', 'EXPENSE', 'MANUAL'
    source_id     UUID,
    posted_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE journal_lines (
    id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    journal_entry_id  UUID NOT NULL REFERENCES journal_entries(id) ON DELETE CASCADE,
    account_id        UUID NOT NULL REFERENCES chart_of_accounts(id),
    debit             NUMERIC(14,2) NOT NULL DEFAULT 0 CHECK (debit >= 0),
    credit            NUMERIC(14,2) NOT NULL DEFAULT 0 CHECK (credit >= 0)
);
```

Mirrors this codebase's existing "opaque `sourceType`/`sourceId`, producer
depends on recorder" pattern from `settlements` (which already accepts
opaque source references from both `bagilah` and `groups` without knowing
either exists) — `journal_entries` plays the exact same role for every
future Business action (invoice issued, expense recorded, reconciliation
matched) without the accounting engine needing to know what produced it.

## 18. Proposed tax architecture

```text
tax_years          (year_of_assessment, effective range)
tax_brackets        (tax_year_id, income_from, income_to, rate)
tax_relief_rules     (tax_year_id, category, max_amount)
tax_rebate_rules     (tax_year_id, condition, amount)
```

A `PersonalTaxCalculationService` (Personal) and future `BusinessTaxService`
both read from these versioned tables, never a hardcoded constant — same
"never let the AI/a single hardcoded value become the source of truth"
discipline already applied to `AffordabilityService` (deterministic, reuses
real engines) and `SubscriptionService` (real entitlement rows, not client
claims).

## 19. Proposed implementation sequence

Following the master prompt's own Phase 1-14 order exactly (see the source
document) — Financial Spaces first, then Personal gap-closure, then Personal
Tax, then Business Core, then the Accounting Engine, then Reconciliation,
Inventory, Fixed Assets, LHDN/MyInvois, Cross-Space Accounting, AI V2,
Automation, and Final Hardening. No reordering is proposed here; the
sequence already puts the riskiest shared foundation (Financial Spaces) first
and the riskiest external integration (MyInvois) appropriately late, after
the accounting engine it depends on already exists.

## 20. Files expected to change in Phase 1

```text
New:
  apps/api/.../db/migration/V16__financial_spaces.sql
  apps/api/.../spaces/  (FinancialSpace, SpaceMember, SpaceRepository,
    SpaceMemberRepository, SpaceService, SpaceController, DTOs)
  apps/mobile/lib/features/spaces/  (domain/data/application/presentation)
  apps/web/src/app/(business)/  (new route group, if Business web work
    starts this phase — likely deferred to Phase 5 per the sequence above)

Modified:
  apps/api/.../auth/AuthController.java or a new onboarding endpoint
    (Personal/Business/Both choice)
  apps/mobile/lib/features/auth/**  (onboarding flow)
  apps/mobile/lib/core/routing/*  (workspace-aware shell, if Business nav
    starts this phase)
  docs/architecture.md, docs/database.md, docs/api.md, README.md
  New: docs/financial-spaces.md

Unchanged (verified safe by finding #12/#14 above):
  Every existing table, every existing controller's request/response shape,
  every existing mobile/web screen's data layer.
```

---

**Scale note**: sections 5-14 of the source prompt alone (Business Core
through MyInvois) describe a genuine multi-month, production-grade
accounting + tax system — a real double-entry ledger, AR/AP aging,
inventory costing, and a regulated government e-invoicing integration are
each substantial systems in their own right, not features. This audit
does not shrink that scope; it only confirms the existing repository is a
sound, UUID-consistent, already-disciplined (real audit logs, real
idempotency, real 404-not-403, zero fake integrations) foundation to build
it on, and identifies the one genuinely free step (Personal space
backfill) versus the many genuinely new bounded contexts still ahead.
