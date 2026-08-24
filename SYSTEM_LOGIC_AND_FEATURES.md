# Duitlah — System Logic and Existing Features

This document describes the system as it exists in this repository. It covers the three applications, the main request and data flows, domain rules, security boundaries, infrastructure, and all currently implemented user-facing features. It also distinguishes completed functionality from provider-dependent integrations and placeholders.

## 1. Product and system overview

Duitlah is a Malaysian personal and shared-finance platform. Its primary client is the Flutter mobile app. The Next.js web app is a secondary authenticated client, the public marketing site, and the no-install guest entry point for Bagilah. Both clients use one Spring Boot API, which is the only authoritative implementation of financial and authorization logic.

The core product areas are:

- Personal money: accounts, categories, transactions, transfers, budgets, goals, recurring transactions, subscriptions, analytics, calendar, and forecasting.
- Social money: groups, shared expenses, group modes, shared goals, balances, and settlements.
- Bagilah: receipt capture or manual bill creation, participant joining, item claiming, exact allocation, finalization, and settlement.
- Assistance and account operations: AI chat, deterministic affordability checks, subscription entitlements, feedback, profile/security management, and account deletion.

The non-negotiable architectural rule is that clients display data and submit intent; they do not calculate authoritative balances, splits, settlements, or entitlement decisions. Those calculations happen in `apps/api`.

## 2. Runtime architecture

```text
Flutter mobile app (primary) ─┐
                              ├─ HTTP/JSON + Bearer JWT ── Spring Boot API
Next.js web app (secondary) ──┘             │
                                            ├─ PostgreSQL: durable domain data
                                            ├─ Redis: rate limits + idempotency
                                            ├─ MinIO/S3: private receipt images
                                            ├─ SSE: live Bagilah change signals
                                            └─ Optional providers: Anthropic/webhooks
```

### Applications

| Application | Role | Main technology |
|---|---|---|
| `apps/mobile` | Primary iOS/Android client | Flutter, Dart, Riverpod, Dio, GoRouter, secure storage |
| `apps/web` | Public site, authenticated web companion, guest Bagilah | Next.js, TypeScript, Tailwind, shadcn/ui, TanStack Query |
| `apps/api` | Sole business-logic and persistence authority | Java 17, Spring Boot, Spring Security, JPA, Flyway |

### Local infrastructure

Docker Compose starts:

- PostgreSQL 16 on port 5432.
- Redis 7 on host port 6380.
- MinIO on port 9000.
- The API on port 8080.
- The web app on port 3001.

Flyway owns the database schema through migrations `V1`–`V15`. Hibernate validates the schema but does not create or mutate it. Database timestamps/JPA operate in UTC; presentation can localize them for the user.

## 3. General request lifecycle

For a normal authenticated operation:

1. The client submits an HTTP request to `/api/v1/...` with an access JWT in the `Authorization` header.
2. CORS processes the origin. `OPTIONS` preflights are allowed through Spring Security so the CORS layer can answer them correctly.
3. `JwtAuthenticationFilter` validates the access token and establishes the authenticated user identity.
4. For mutating `POST`, `PUT`, or `PATCH` calls with an `Idempotency-Key`, the idempotency filter uses Redis to claim the `(user, key)` pair.
5. A controller validates the request DTO and delegates to a domain service.
6. The service enforces ownership/membership/state rules, performs calculations, and writes through repositories inside a transaction where required.
7. Sensitive actions may append an audit log and lifecycle events may emit product telemetry.
8. The controller returns JSON. Domain errors use the shared API error envelope; unhandled errors are reported through the telemetry abstraction before a safe 5xx response is returned.
9. An idempotent response is stored for 24 hours and replayed exactly if the same user retries the same key.

Cross-user resources are generally returned as `404`, rather than `403`, to avoid confirming that another user's record exists.

## 4. Authentication, identity, and account lifecycle

### Registration and login

1. A user registers with their identity and credentials.
2. Passwords are hashed with BCrypt.
3. The system creates the user, starts the verification flow, records telemetry, and returns the auth result.
4. Login verifies the credentials and creates a refresh session.
5. The client receives a short-lived access JWT (15 minutes by default).
6. The long-lived opaque refresh token (30 days by default) is placed in an HTTP-only cookie. On mobile, Dio's persistent cookie jar stores it using `flutter_secure_storage`.

### Refresh rotation and reuse detection

1. When an access token expires, the client calls `/api/v1/auth/refresh` with the refresh cookie.
2. The server validates the stored refresh-session token hash.
3. A successful refresh rotates the token: the old value becomes unusable and a new access/refresh pair is issued.
4. Reuse of an already-rotated token is treated as theft and invalidates the affected session family.
5. The web API client performs this refresh transparently; mobile bootstraps on a splash screen while restoring the cookie and obtaining a fresh access token.

### Session and credential controls

Implemented controls include:

- List device sessions.
- Revoke one session.
- Log out the current session.
- Log out all sessions.
- Email verification and resend.
- Password-reset request and confirmation.
- Change password.
- Edit profile details.
- Optional local biometric app lock on mobile. This protects local app entry and never replaces server authentication.

Sensitive auth endpoints are Redis-rate-limited. The API is otherwise stateless and does not use a server HTTP session. CSRF is disabled because state-changing domain requests require a bearer header that a cross-site form cannot set; the refresh cookie is scoped to auth and cannot independently authorize domain operations.

### Account deletion

Account deletion requires password confirmation. The service first checks whether the user owns active shared groups. If so, deletion returns `409 OWNS_ACTIVE_GROUPS`, preventing the group's shared history from disappearing for other members. Once the blocking ownership is resolved, user-linked data follows the schema's cascade rules. Audit records deliberately retain their history and set a deleted actor reference to null.

## 5. Mobile application flow

The Flutter app is the full-featured primary client.

### Startup and routing

1. The app starts at a splash route.
2. The auth notifier restores the persisted refresh cookie and attempts refresh.
3. While auth is loading, all protected routes remain parked on the splash screen so they cannot issue premature API calls.
4. An unauthenticated user is sent to login, except for public Bagilah join/guest routes.
5. An authenticated user lands on Home.

The persistent bottom navigation contains Home, Transactions, a visually raised Bagilah action, Groups, and More. Each branch retains its own navigation stack.

Additional mobile screens include accounts, budgets, goals, settlements, recurring transactions, calendar, insights, assistant, notifications, profile, Duitlah+, help/support, and feedback.

### Mobile networking

- Repositories are thin Dio wrappers around the same API used by the web app.
- The access JWT is attached to authenticated calls.
- Refresh cookies are stored securely.
- Mutation calls can send idempotency keys.
- SSE is consumed as a streaming response and split into events on blank lines.
- Deep links route Bagilah and group invitations into the matching join screens.
- QR codes are generated locally from the backend-issued invite token; QR scanning reads the same link format.

## 6. Web application flow

The Next.js app has three roles.

### Public site

Public routes include:

- `/` landing page.
- `/privacy` and `/terms`.
- `/help` and `/faq`.
- `/status`, which polls the real API health endpoint every 30 seconds.
- Authentication pages for login, registration, password reset, and email verification.

### Authenticated companion

The `RequireAuth` guard protects the web finance application. Authenticated routes include `/dashboard`, `/accounts`, `/transactions`, `/budget`, `/goals`, `/groups`, `/bagilah`, `/settlements`, and `/profile`.

The API client attaches bearer tokens and silently refreshes expired access tokens. TanStack Query manages fetched server state. The web client submits values and renders returned calculations; it does not implement a second finance engine.

### Guest Bagilah

The web route `/bagilah/join?token=...` is the no-install invitation destination. An authenticated visitor joins as their user account. A logged-out visitor supplies a guest name and receives a 24-hour opaque guest token, then uses `/bagilah/[id]/guest`.

## 7. Personal finance logic

### Accounts

Users can create, list, view, and update accounts. Supported account types include cash, bank, e-wallet, credit card, savings, and investment.

An account balance is never a mutable stored total. It is derived from transaction history, which prevents a cached balance from drifting away from its ledger.

### Categories

The system provides default income and expense categories and permits user-defined categories. Categories form a maximum two-level tree. Transactions use leaf categories; reporting and budgets can expand a parent to include its children.

### Transactions

Users can:

- Create income or expense entries.
- List, filter, retrieve, update, and delete transactions.
- View recent transactions.
- Transfer money between owned accounts.

A transfer is represented by linked ledger rows rather than by directly editing two balances. Deleting or correcting a transfer preserves the relationship and keeps both accounts consistent. Category type is validated against transaction type.

### Dashboard

The dashboard composes account and transaction data into:

- Available balance.
- Current-month income.
- Current-month expenses.
- Recent transactions.

### Budgets

A budget is monthly and may be overall or category-specific. The service derives spent and remaining values from expense transactions. A parent-category budget includes all child-category spending.

Status is computed as:

- `OK`: below 80%.
- `WARNING`: at least 80% but below 100%.
- `EXCEEDED`: at least 100%.

Only one matching budget can exist for the same scope and month. Status is a UI signal, not a delivered push/email notification.

### Personal goals

Users can create and update savings goals for predefined purposes or a custom purpose. Progress is the sum of an append-only contribution ledger, not a stored mutable amount. Positive contributions add progress; negative contributions represent withdrawals/corrections. Individual contribution entries can be removed.

## 8. Recurring transactions, subscriptions, and analytics

### Recurring rules

A recurring rule describes an income or expense schedule, its frequency, next occurrence, and whether it represents a subscription. Users can create, list, view, update, and delete rules.

A daily in-process scheduler materializes every due occurrence into an ordinary transaction linked back to its recurring rule. Because it creates normal ledger rows, balances, budgets, and analytics need no special recurring-balance logic. The scheduler is suitable for the current single API instance; a horizontally scaled deployment would require a distributed lock or external scheduler.

### Subscription tracking

Financial subscriptions such as recurring services use recurring transaction rows with `is_subscription = true`, not a second transaction model. A summary endpoint aggregates them.

This is distinct from the Duitlah+ product subscription described in section 14.

### Insights

The analytics API provides:

- Spending by category, including parent/child roll-up.
- Six-month income, expense, and savings trend.
- Top merchants.
- Calendar entries combining posted transactions with projected recurring occurrences.
- Cash-flow forecast.

Forecast output explicitly separates deterministic scheduled income/expense from historical-average estimates and always includes a disclaimer. It is guidance rather than a guarantee.

## 9. Groups and shared-expense logic

### Group lifecycle

An authenticated user can create a group of type housemates, couple, trip, friends, family, team, or event. The creator becomes owner. The group exposes a persistent shareable invite token. Other registered users join with that token.

Members can be listed. Member removal follows permission rules, and the owner cannot simply be removed. Creating and changing groups is also subject to subscription limits where applicable.

### Shared expenses

Members log an expense with a payer and chosen participants. The amount is split equally using the shared exact-money allocator. Any indivisible remainder cents are distributed deterministically so all shares sum exactly to the expense amount.

For each member:

```text
group balance = total amount paid - total assigned share - already settled position
```

Positive means the group owes the member; negative means the member owes the group. Group expenses live in their own group ledger and are not automatically personal-account transactions.

### Group settlement generation

The owner can invoke “Settle up.” Current member net positions are passed to the settlement module, which creates simplified pairwise obligations. New group expenses can accumulate independently after that settlement snapshot.

### Special group modes

All group types share the same membership and expense foundation, with additional views/features:

- Trip: a flat group budget with derived spent/remaining amounts, a trip summary, and optional original-currency metadata on expenses. Settlement math always uses the recorded MYR amount; currency fields are display snapshots, not live FX conversion.
- Housemate: a monthly dashboard across eight fixed household categories, marking a category paid when an expense exists for it that month.
- Couple: “Mine · Yours · Ours” is composed from each partner's private personal ledger plus the Couple group's shared expenses and goals; no separate financial engine is needed.
- Shared goals: available to groups generally, with signed contributions and a per-member contribution breakdown.

Group goals follow the same derived-progress rule as personal goals.

## 10. Bagilah end-to-end flow

Bagilah's complete flow is “Scan. Claim. Settle.” A bill may be created manually or from a receipt scan.

### A. Manual bill creation

1. The owner creates a draft bill, optionally scoped to a group they belong to.
2. The owner enters receipt items with name, unit price, quantity, and optional item discount.
3. The owner adds registered participants or named guests.
4. The owner can configure tax, service charge, receipt-wide discount, allocation strategy, and the actual receipt total.
5. The draft becomes available for collaborative claims.

### B. Receipt scan creation

1. The user captures a photo or chooses one from their device.
2. The API validates size, declared type, and image magic bytes.
3. The private image is written to S3-compatible object storage; PostgreSQL stores metadata, not image bytes.
4. `ReceiptOcrService` parses it synchronously.
5. With an Anthropic key, Claude vision is forced to call a JSON-schema-defined extraction tool. Each field is still decoded defensively and malformed fields degrade independently.
6. Without a configured key, the fallback returns an empty structured scan so the user can continue with manual review.
7. The review screen shows merchant, items, quantities, prices, charges, discounts, total, and confidence hints. Every extracted value can be corrected; items can be added or removed.
8. Confirming calls the ordinary `BillService.create`, `addItem`, and `update` paths. The result is a normal draft Bagilah bill, not a parallel OCR bill type.
9. A scan cannot be confirmed twice, and users cannot access another user's scan.

### C. Invitation and identity

1. The owner generates or regenerates an invite token.
2. A client forms `{webOrigin}/bagilah/join?token=...` and may render it as a QR code.
3. The public join endpoint optionally reads a bearer JWT.
4. An authenticated user joins as themselves.
5. Otherwise, a guest supplies a name; the server creates a 24-hour opaque guest session tied to one bill participant.
6. Guest identity is resolved through the guest-session repository, never through Spring Security or a fabricated user ID.

### D. Collaborative claiming

Any participant in a draft bill—owner, registered participant, or guest—may add, change, or delete claims. This collaborative rule allows a person at the table to help enter another person's items. Only the owner may change bill structure, manage participants/charges/payments, finalize, or cancel.

Claim types are:

- Whole item.
- Quantity share.
- Percentage share.
- Custom RM amount.
- Equal split convenience action.

Draft changes emit content-free SSE signals. Connected clients receive the signal and refetch current bill data rather than relying on a complex event-payload contract. SSE emitters currently live in memory and assume one API instance; multi-instance deployment would require Redis pub/sub.

### E. Exact calculation

For every item, the engine calculates the net item amount after its item-level discount and resolves all claims to monetary shares.

The key invariant is:

```text
sum(all participant final amounts) = authoritative receipt total
```

The engine enforces it as follows:

1. Whole, quantity, percentage, and custom-amount claims are normalized into item allocations.
2. Unclaimed portions and over-allocation are surfaced as issues and block finalization.
3. `ProportionalAllocator` uses the largest-remainder method for exact-cent proportional allocation.
4. Tax and service charge are allocated proportionally to subtotal by default, or equally when configured.
5. A receipt-wide discount is allocated proportionally.
6. If the receipt's printed final total differs from computed components because of real-world rounding or Malaysian cash rounding, the difference is recorded and allocated as an explicit rounding adjustment.
7. Zero-price items and multiple payers are supported.
8. The breakdown response exposes each participant's components so the calculation is inspectable rather than a black box.

### F. Payment recording and finalization

Before finalization, the owner records how much each participant actually paid at the merchant. The balance view compares paid amount with calculated responsibility.

Finalization is allowed only when the draft is valid. It then:

1. Recalculates and validates the complete breakdown.
2. Snapshots each participant's final amount in `bill_final_amounts` so finalized history cannot change later.
3. Changes the bill state from draft to finalized.
4. Writes the appropriate audit record.
5. Converts real-user net positions into settlement obligations in the same transaction.
6. Emits the bill-change signal.

Guests are included in bill arithmetic but excluded from persistent settlement generation because they have no account dashboard on which to track an obligation.

## 11. Settlement logic

The settlement module is independent of Bagilah and Groups. Producers pass it net positions plus an opaque source type/id.

### Debt simplification

`DebtSimplifier` separates debtors and creditors and greedily matches their remaining amounts. This collapses chains such as A owing B and B owing C into fewer direct transfers while preserving the exact total owed. It produces fixed obligations between real users.

### Settlement lifecycle

Either party to a settlement can:

- View its details and payment history.
- Record a partial or full payment.
- Cancel it.
- Dispute it.

Payments are append-only history rather than an overwritten “paid amount.” The current state and outstanding balance derive from the obligation and its recorded payments/actions.

The summary endpoint aggregates counterparties across Bagilah and Groups, nets bidirectional debts, and shows outstanding totals and age. Duitlah does not hold or transfer funds. `PaymentHandoffService` currently returns manual transfer instructions; it does not pretend to provide a live DuitNow/payment-rail integration.

## 12. AI assistant and affordability

### AI chat

The assistant follows this boundary:

```text
question → fixed finance-query tools → structured user-scoped facts → language model → explanation
```

The model cannot access repositories or issue arbitrary queries. Its only data tools are named read-only operations exposed by `FinanceQueryService`, covering dashboard, category spending, trends, merchants, forecast, budgets, goals, and settlements. Every call is scoped to the authenticated user.

With an Anthropic key, `ClaudeAiChatService` runs a tool-use loop. Its system rules prohibit invented numbers, guaranteed outcomes, or claims that Duitlah can move money. Without a key, the fallback clearly reports that AI is not configured.

### Affordability

“Can I afford this?” does not rely on an LLM. `AffordabilityService` uses trusted forecast, budget, goal, and debt data, calculates the result in Java, and fills a deterministic narrative template. It remains functional even when AI chat is unavailable.

## 13. Duitlah+ entitlements

The product has `FREE` and `PLUS` tiers. The API derives entitlement from verified `user_subscriptions` records; the client cannot claim its own tier.

Current FREE limits are enforced at the actual server write points:

- Up to three actively owned groups.
- Approximately five receipt scans per month.

Joining another person's group or bill does not consume an ownership quota. The mobile Duitlah+ screen displays real tier and usage information, and limit errors open a shared upgrade dialog.

Apple, Google, and Web verification interfaces are prepared, but all currently use `UnavailableSubscriptionVerifier`; there is intentionally no fake purchase button or working store transaction without real store credentials.

## 14. Feedback, telemetry, audit, and operational behavior

### Feedback

Authenticated users can submit feedback and list their own prior feedback. Feedback records are append-only. Mobile exposes a feedback form plus Help & Support links to public documentation and email support.

### Audit logs

The append-only audit trail records sensitive actions including:

- Bill finalization.
- Transaction creation/modification.
- Payment marking.
- Participant removal.
- Receipt editing.
- Account-information changes.
- Security-setting changes.

Audit history survives account deletion by nulling the deleted actor reference.

### Telemetry

`ErrorReportingService` receives genuinely unhandled server errors. `ProductAnalyticsService` records selected lifecycle events such as registration and subscription purchase. Both default to structured logs and can optionally POST to configured webhooks. They are observability abstractions, not the user-facing finance analytics module.

### Health and API discovery

- `/actuator/health` and `/actuator/info` are public.
- OpenAPI JSON and Swagger UI are public in the current configuration.
- `/api/v1` returns version/discovery information.

## 15. API surface by domain

The detailed request/response schemas live in Swagger/OpenAPI and `docs/api.md`. The implemented endpoint groups are:

| Domain | Operations |
|---|---|
| Auth | Register, login, refresh, logout, logout-all, sessions, revoke, email verification, password reset |
| Users | Current profile, update, change password, delete account |
| Accounts/categories | Account CRUD subset, category list/create/delete |
| Transactions | CRUD, transfer, recent list |
| Dashboard/analytics | Dashboard, category spending, trends, merchants, calendar, forecast |
| Budgets/goals | Budget CRUD; goal CRUD and contribution ledger |
| Recurring | Rule CRUD and subscription summary |
| Groups | Group CRUD subset, invite/join, members, expenses, balances, settlement, budget, trip and housemate views |
| Group goals | Goal CRUD and contributions |
| Bills | Bill lifecycle, items, participants, claims, payments, breakdown, balances, invite, SSE |
| Bagilah public | Join and guest bill/claim/breakdown/SSE operations |
| Receipt scans | Upload, list, retrieve, confirm |
| Settlements | List, summary, detail, payments, cancel, dispute |
| AI | Chat and affordability |
| Duitlah+ | Current entitlement and verification |
| Feedback | Submit and list own feedback |

## 16. Data and correctness rules

The main invariants are:

- Monetary values use decimal database types and `BigDecimal`, never floating-point arithmetic for authoritative money.
- Account balances derive from transaction rows.
- Goal progress derives from contribution rows.
- Budget spend derives from transactions.
- Group balances derive from expense shares and prior settlements.
- Bagilah draft totals derive from items, claims, charges, discounts, and payments.
- Finalized Bagilah amounts are deliberately snapshotted to freeze history.
- Settlement paid state derives from append-only payment history.
- Exact allocators always reconcile distributed cents to the source amount.
- Database `CHECK` constraints backstop numeric validity, including trip currency metadata.
- User-scoped service lookups enforce ownership or membership before revealing data.

## 17. Security and hardening summary

Implemented protections include:

- BCrypt password hashing.
- Short-lived JWT access tokens.
- Opaque refresh tokens stored hashed, rotated on use, with reuse detection.
- Session listing/revocation and logout-all.
- Redis rate limiting on sensitive auth operations.
- Redis-backed 24-hour idempotency for mutating requests that supply a key.
- DTO validation plus database constraints.
- Ownership/membership checks throughout domain services.
- Private object storage with presigned receipt-image access.
- Declared MIME type and magic-byte validation for uploads.
- Default Spring `nosniff` and frame-denial headers.
- No raw/string-concatenated SQL in the application.
- Append-only audit logging for selected sensitive actions.
- Safe, structured API errors and telemetry for unhandled failures.

## 18. Current limitations and intentionally incomplete integrations

These are boundaries of the current implementation, not hidden features:

- `notifications` and `profiles` backend packages are placeholders; there is no real push/email notification delivery system. The mobile notifications screen does not imply FCM/APNs support.
- Email uses a logging fallback unless a real sender is added.
- OCR and AI chat require `ANTHROPIC_API_KEY`; their fallback behavior is usable but does not perform OCR/chat inference.
- Duitlah+ store verification is architected but not connected to Apple, Google, or Web billing credentials.
- Payment handoff is manual; Duitlah never holds money and has no live DuitNow rail.
- Receipt object storage uses MinIO locally and needs production S3-compatible configuration when deployed.
- SSE broadcasting and recurring materialization are in-process single-instance mechanisms.
- Verified iOS universal links and Android app links require a production domain/signing configuration.
- There is no self-service data export; support-assisted export is the stated path.
- Forecasts include historical estimates and are not guarantees.
- Trip foreign-currency values are snapshots for display; no live exchange-rate ledger exists.
- Phase 14 adds an authenticated dashboard p95 smoke gate and a PostgreSQL
  custom-format backup/isolated-restore verification under `scripts/`.
  Screen-reader sessions and managed-provider disaster-recovery drills remain
  manual release/operations checks.

### Settlement payment invariant (V2 Phase 14)

Recording a settlement payment locks the parent settlement row, derives the
amount already paid from the append-only payment ledger, and rejects any amount
above the remaining balance with `PAYMENT_EXCEEDS_REMAINING`. The balance is
never cached, and concurrent writers cannot both consume the same remainder.

## 19. Feature availability by client

| Feature family | Mobile | Web | API |
|---|---:|---:|---:|
| Public marketing/legal/help/status | Links/support entry | Full | Health support |
| Auth and profile | Full core flow | Full core flow | Full |
| Accounts/transactions/budgets/goals | Full | Full | Full |
| Groups/basic shared expenses | Full | Full | Full |
| Special group modes/shared goals | Full | Not added in Phase 11 | Full |
| Bagilah manual/scan/claim/finalize | Full | Full | Full |
| Guest Bagilah | Native + deep link | Full no-install flow | Full public guest API |
| Settlements | Full | Full | Full |
| Recurring/advanced insights/calendar | Full | Not added in Phase 10 | Full |
| AI assistant/affordability | Full | Not added in Phase 12 | Full/provider-dependent chat |
| Duitlah+ usage/upgrade UI | Full | Pricing presentation | Entitlement and limits |
| Feedback | Full | Public help content | Full authenticated feedback API |

## 20. Repository guide

- `README.md`: phase completion history, stack, and quick start.
- `PRODUCT.md`: users, positioning, product principles, and brand direction.
- `DESIGN.md`: design tokens, typography, accessibility, and component conventions.
- `docs/architecture.md`: module dependencies and architectural rationale.
- `docs/api.md`: API versioning and response/error conventions.
- `docs/security.md`: authentication, sessions, rate limiting, and guest identity.
- `docs/database.md`: schema and persistence rationale.
- `docs/bagilah-engine.md`: detailed splitting invariants and examples.
- `docs/deployment.md`: local and deployment configuration.
- `apps/api/src/main/java/com/duitlah/api`: authoritative domain implementations.
- `apps/mobile/lib/features`: primary-client feature modules.
- `apps/web/src/app`: public and authenticated web routes.

In short, Duitlah is a ledger-driven system: mutable source events are recorded, totals are derived wherever history should remain live, and only finalized bill allocations are snapshotted where history must be frozen. Both clients remain presentation layers over the same guarded API and exact-money engines.
