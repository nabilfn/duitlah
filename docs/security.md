# Security

## Authentication (Phase 2)

The API is stateless and bearer-token based — see the `auth` module
(`apps/api/src/main/java/com/duitlah/api/auth/`):

- **Access token**: a short-lived JWT (HS256, default 15 minutes —
  `duitlah.auth.access-token-ttl-minutes`), returned in the response body
  and held by the frontend in memory only (`apps/web/src/stores/auth-store.ts`
  — never localStorage/sessionStorage). Validated per-request by
  `JwtAuthenticationFilter`; carries no revocation state, so its short TTL
  is the only thing bounding a compromised token's lifetime.
- **Refresh token**: a long-lived (default 30 days) opaque random token,
  set as an `httpOnly`, `Secure`-configurable cookie scoped to
  `/api/v1/auth` (`RefreshCookieService`) — invisible to JavaScript, so an
  XSS bug can't exfiltrate it. Only ever persisted as a SHA-256 hash
  (`common/security/SecureTokens.java`); the raw value exists only in the
  Set-Cookie header.
- **Rotation + reuse detection**: every `/auth/refresh` call revokes the
  presented token and issues a new one (`SessionService.rotate`). If a
  revoked token is presented again — a signal it was stolen and used by
  two parties — every session for that user is revoked
  (`SessionRevoker`, run in `REQUIRES_NEW` specifically so this survives
  the same request's 401 rolling back its own transaction; this is a real
  gotcha, see the class Javadoc).
- **Password storage**: `BCryptPasswordEncoder`. Plaintext passwords are
  never stored or logged.
- **Rate limiting / account-risk mitigation**: Redis fixed-window
  counters (`auth/RateLimiter.java`) on register, login (per-IP and
  per-email), password-reset-request, and verification-email resend.
  This is the deliberate choice instead of a hard account lockout: a
  lockout that a stranger can trigger just by repeatedly failing someone
  else's password is itself a denial-of-service vector against the
  legitimate user, and current guidance (NIST 800-63B) favors throttling
  over lockout for exactly that reason. Per-email throttling still bounds
  credential-stuffing/brute-force against one account without handing an
  attacker a free way to lock a real user out.
- **Sessions**: `GET /api/v1/auth/sessions` lists active sessions (device,
  last used), `DELETE /api/v1/auth/sessions/{id}` revokes one,
  `POST /api/v1/auth/logout-all` revokes all. Changing your password
  revokes every other session but keeps the current one active; resetting
  a forgotten password via emailed link revokes every session, including
  the current one — the two flows have different trust assumptions about
  whether "the current device" is really you.

## Baseline decisions

- CSRF is disabled — safe here because the API is bearer-token
  authenticated, not cookie-session authenticated. The refresh cookie
  alone can't authorize any request outside `/api/v1/auth/refresh` and
  `/logout` (both intentionally side-effect-limited even if triggered
  cross-site), and every other endpoint requires the `Authorization`
  header, which a cross-site form can't set.
- CORS (`config/CorsConfig.java`) is locked to an explicit allow-list via
  `duitlah.cors.allowed-origins` (`CORS_ALLOWED_ORIGINS` env var). Never
  set this to `*` in production, and never set it to `*` with credentials
  enabled regardless (the browser rejects that combination anyway).
  `SecurityConfig` explicitly `permitAll()`s every `OPTIONS` request
  (Phase 15) — a CORS preflight has no `Authorization` header by design,
  so without this, `.anyRequest().authenticated()` rejected the preflight
  itself with 401 on every protected endpoint, which the browser reports
  as a CORS failure rather than a plain 401, silently blocking the real
  request from ever being sent. Found live via Phase 15's own browser
  console verification of the new public pages (an unauthenticated
  `GET /api/v1/dashboard` fetch from `apps/web` failed this way). This
  doesn't weaken anything: `CorsFilter` still enforces the real
  allowed-origin check on every request, and the actual GET/POST/etc.
  request behind the preflight is still authenticated normally.
- Actuator exposes only `health` and `info`
  (`management.endpoints.web.exposure.include`), gated behind
  `when-authorized`.
- `JWT_SECRET` ships with an insecure, clearly-labeled dev-only default
  (`application.yml`) — every real environment MUST override it
  (`openssl rand -base64 48` or equivalent). Same for `REFRESH_COOKIE_SECURE`
  (must be `true` wherever the site is served over HTTPS) and
  `REFRESH_COOKIE_SAME_SITE` (`Lax` works when frontend/backend share a
  registrable domain; cross-domain deployments need `None` + `Secure=true`).

## Authorization (Phase 2 baseline; expands per-module from Phase 5 onward)

Authorization is enforced server-side only — never trust a frontend-only
check. `@AuthenticationPrincipal UUID userId`, populated by
`JwtAuthenticationFilter`, is the source of truth for "who is making this
request" in every controller. A user may access a group/bill only if
they own it or belong to it (404, not 403, for anyone else — see
[api.md](api.md)); a bill owner has additional privileges (managing
items/participants/charges, payments, finalize/cancel) that ordinary
participants don't. As of Phase 7, claiming itself is participant-gated
rather than per-claim-owner-gated — any participant of a draft bill can
adjust *any* claim on it, not only their own; see
[bagilah-engine.md](bagilah-engine.md) for why.

## Guest access (Phase 7)

A Bagilah guest (no Duitlah account) is authenticated by an entirely
separate mechanism from everything above — not a JWT, not
`JwtAuthenticationFilter`, not Spring Security's `Authentication` at all:

- Joining (`POST /api/v1/bagilah/join`, public) issues an opaque,
  SHA-256-hash-stored session token (`bill_guest_sessions` — same
  hashing idiom as refresh tokens, `common/security/SecureTokens.java`),
  valid 24 hours, tied to one `bill_id`/`participant_id` pair.
- `BagilahGuestController` (`/api/v1/bagilah/guest/{guestToken}/...`) is a
  narrower, parallel controller to the owner/participant one
  (`BillController`) — view the bill and claim, nothing else — rather
  than the same routes accepting two credential types. `BillService`
  resolves the token with a direct repository lookup; there's no code
  path where a guest session could be mistaken for (or silently coerced
  into) a real user id.
- These routes are `permitAll()` in `SecurityConfig` specifically because
  a guest has no token Spring Security would accept in the first place —
  authorization for them happens entirely inside `BillService`, not the
  filter chain.

## Settlements (Phase 9)

A `Settlement` is visible/actionable by exactly its two named parties —
`from_user_id` (the ower) or `to_user_id` (the one owed) — resolved via
`SettlementRepository.findByIdInvolvingUser`, the same 404-not-403
pattern as everywhere else. Either party can record a payment (mark
paid), cancel, or dispute: this is deliberately symmetric rather than
"only the debtor can pay, only the creditor can confirm," since a
self-reported ledger with no real money movement behind it (section 19:
"do not hold funds") has no way to independently verify who initiated a
real-world transfer anyway — trusting either party to report it
honestly is the actual security model here, not a gap in one. Settlement
*generation* is asymmetric, though: only a bill's own `finalize()` (owner
action) or a group's owner-only `settle` action produces new
`Settlement` rows — an individual can't fabricate one naming themselves
as owed money by someone else.

## Mobile (Phase 9.5)

`apps/mobile` deliberately reuses every mechanism above rather than
inventing a parallel mobile-specific auth model:

- **Access token**: held in memory only, inside `ApiClient`
  (`core/api/api_client.dart`) — never written to disk, matching
  `auth-store.ts`'s own "in memory only" rule above.
- **Refresh token**: the same httpOnly-style cookie, persisted across app
  restarts via a `cookie_jar` `PersistCookieJar` whose storage backend
  (`core/storage/secure_cookie_storage.dart`) is `flutter_secure_storage`
  (Keychain on iOS, `EncryptedSharedPreferences` on Android) — encrypted
  at rest, never a plaintext file, never SharedPreferences directly.
- **401 handling**: identical rotate-and-retry behavior to
  `api-client.ts`, including the shared in-flight-refresh guard against
  concurrent requests racing to rotate the same cookie.
- **Guest access**: the mobile guest flow (`GuestBagilahRepository`) talks
  to the exact same `BagilahGuestController` endpoints over plain HTTP
  calls from a native screen — no JWT, no `Authentication`, same 24-hour
  opaque token model as the web guest flow. The guest token itself is
  cached locally (`GuestSessionStore`) in `flutter_secure_storage`, not
  because it's uniquely sensitive but because it functions as a
  bearer credential for 24 hours and shouldn't sit in a less-protected
  store.
- **Biometric lock** (`core/auth/biometric_lock_service.dart`, `local_auth`):
  an optional, user-disableable device-level gate on an *already*
  authenticated session — Face ID/Touch ID/Android biometrics unlock the
  app's UI, not the API; every request still carries the real access
  token/refresh cookie regardless of whether the biometric gate is
  enabled. Biometrics never replace server-side auth.
- **Transport**: `Env.apiBaseUrl` defaults to plain HTTP only for local
  dev (`http://localhost:8080` / `http://10.0.2.2:8080` for the Android
  emulator's loopback alias); a real deployment must set `API_BASE_URL`
  to an HTTPS origin and (Android) drop the dev-only
  `usesCleartextTraffic="true"` manifest flag — see
  [deployment.md](deployment.md).
- **No secrets in the client**: no DB credentials, JWT signing secret,
  OCR provider key, or service-account key is ever bundled into the
  Flutter app — `apps/mobile` only ever holds a base URL and, transiently,
  the same access token/refresh cookie the web app holds.
- **Deep links**: `BagilahJoinScreen` treats an incoming
  `/bagilah/join?token=...` link exactly like the web app's
  `/bagilah/join` page — the token is opaque and single-purpose
  (resolved server-side by `BagilahJoinController`/`BillService`); the
  client does no local trust decision beyond "does this look like our own
  invite path."

## Idempotency (Phase 14)

Every request carrying an `Idempotency-Key` header is deduplicated
server-side by `IdempotencyFilter` (`common/idempotency/`), added to the
filter chain right after `JwtAuthenticationFilter`:

- The key is scoped per-user (`userId` + the raw header value) so one
  user can never collide with — or replay into — another user's request.
- The first request atomically claims the key in Redis (`SETNX`-style
  `setIfAbsent`, 24-hour TTL) before it reaches the controller. A second
  request presenting the same key while the first is still in flight gets
  `409 DUPLICATE_REQUEST_IN_PROGRESS` immediately, without re-running any
  business logic.
- Once the first request completes, its exact HTTP status/body is cached
  (via `ContentCachingResponseWrapper`) and replayed verbatim to any later
  request with the same key — the caller sees the original response, not
  a second write.
- A 5xx response releases the claim instead of caching it, so a genuine
  transient failure can be retried with the same key rather than being
  permanently stuck replaying an error.

This was previously documented across several phases as "not yet
implemented server-side" (see [api.md](api.md)); Phase 14 closes that gap
and it's now verified under real concurrent load (`IdempotencyFlowTests`
races 5 threads on one key and asserts exactly one transaction results).

## Audit logging (Phase 14)

`audit_logs` (V13 migration) is an append-only table —
`actor_user_id` uses `ON DELETE SET NULL` specifically so the trail
outlives a deleted account rather than cascading away with it.
`AuditLogService.record(...)` is called inline, in the same transaction
as the action it's recording (not `REQUIRES_NEW`), for the 8 actions the
product spec calls out: bill finalized, transaction created/modified,
payment marked, group participant removed, receipt edited, account info
changed, security settings changed. It deliberately swallows its own
exceptions (logging a warning instead) — a broken audit write must never
break the real business operation it's attached to. There is no
browsing/export endpoint yet; the current requirement is only that the
data is captured (verified directly via `AuditLogRepository` in
`AuditLogFlowTests`), not that it's exposed anywhere.

## Response headers / CSP (Phase 14)

Verified live (`curl -D -`) against every response, including the one
HTML page this API serves (`/swagger-ui/index.html`):
`X-Content-Type-Options: nosniff` and `X-Frame-Options: DENY` are already
present on every response. These come from Spring Security's default
header writers, which are active automatically because `SecurityConfig`
never disables `.headers()` — no code change was needed, only this
confirmation that the defaults are actually in effect rather than assumed.

A `Content-Security-Policy` header was deliberately **not** added. CSP is
a browser-rendering directive: it constrains what a *page* is allowed to
load/execute. This API returns JSON almost everywhere and never renders
any client-supplied content as HTML, so there is no reflected/stored-XSS
surface for a CSP to defend. The one page that is real HTML —
Swagger UI — is generated entirely from springdoc's own bundled
scripts/styles (not from any user input) and relies on inline
script/style tags to boot; a CSP strict enough to matter would break it
for no corresponding security gain, since it's internal API-documentation
tooling, not a surface real users interact with. If a genuine
user-facing HTML surface is ever added directly to `apps/api` (none
exists today — `apps/web` and `apps/mobile` are separate deployments and
own their own CSP posture), a real per-route CSP should be added at that
point, not before.

## Database constraints (Phase 14)

A full review of every `NUMERIC`/amount column across all 14 migrations
found one real gap: Trip mode's currency-snapshot columns on
`group_expenses` (`original_amount`, `exchange_rate`, `original_currency`
— added in V11) had no `CHECK` constraint, relying entirely on
application-layer `@DecimalMin`/`@Size` validation. V14 adds
`chk_original_amount_positive`, `chk_exchange_rate_positive`, and
`chk_original_currency_format` (all `NULL`-permissive, since the
snapshot itself is optional). `GroupService.createExpense` was also
tightened to normalize `originalCurrency` to uppercase and reject
anything not matching `[A-Z]{3}` with `400 INVALID_CURRENCY_CODE` before
it ever reaches the database — this checks shape, not the real ISO 4217
list, which was a deliberate scope decision. No other numeric column
across the schema was missing its constraint.

## SQL injection (Phase 14)

Checked every repository/query in the backend: there is no native/raw
SQL anywhere and no string-concatenated `@Query`. Every query is either
a Spring Data derived method or a parameterized JPQL `@Query` — the ORM
layer itself is the injection defense, not a convention that has to be
remembered per-query.

## File upload validation (Phase 14)

Receipt photo uploads (`ReceiptScanService.upload`) were already
allowlist-and-size-gated (JPEG/PNG/WEBP/HEIC only, 10MB cap) from an
earlier phase, but only checked the client-*declared* `Content-Type`
header — which proves nothing about the actual bytes. Phase 14 adds a
real magic-byte signature check (`matchesDeclaredFormat`) so a file
can no longer ride in under a spoofed image content-type label, get
stored, and later be served back with that same attacker-chosen
Content-Type via the presigned GET URL. Storage keys were already
server-generated (`receipts/{userId}/{randomUUID}.{ext}` — the
extension itself comes from the *validated* content type, never the
client-supplied filename), so path traversal via filename was never
possible either.

## Permission review (Phase 14)

A full pass across every controller confirmed the 404-not-403,
ownership/membership-scoped lookup pattern (see "Authorization" above)
has zero gaps: every unscoped `findById` call site in every service was
checked by hand, and every controller's request-mapping count was
cross-checked against its principal-scoping count. No IDOR was found.

## Account deletion (Phase 15)

`DELETE /api/v1/users/me` requires the current password in the request
body — the same "prove you're still you" bar as changing a password —
before anything is deleted. It's blocked (`409 OWNS_ACTIVE_GROUPS`)
while the account owns any active group, since `groups.owner_user_id`
cascades on user deletion (see [database.md](database.md)); without
this guard, deleting your own account would silently delete an entire
shared group's history out from under every other member in it, not
just your own data. A successful deletion clears the caller's refresh
cookie, the same as logout — there is no lingering session to worry
about afterward.

## Telemetry (Phase 15)

Error monitoring and product analytics (`telemetry` package) both
default to structured server logs (`Logging*` implementations) and
optionally post to a configured webhook URL
(`duitlah.telemetry.error-webhook-url`/`analytics-webhook-url`) when
one is set — see [architecture.md](architecture.md) for the full
"optional provider" shape. Neither payload includes anything beyond an
error's own message/type/context or an event name plus the properties
the calling code explicitly passed (`user_registered`,
`subscription_purchased`, each with a small, deliberately-chosen
property set) — no request bodies, headers, or raw financial figures
are ever forwarded wholesale.

## Phase 14 final hardening status

- Secrets live in environment variables (see each app's `.env.example`),
  never committed, never exposed to the frontend bundle.
- An authenticated dashboard p95 smoke gate and PostgreSQL custom-format
  backup/isolated-restore check are executable under `scripts/` and were
  run against the rebuilt Docker stack. Web keyboard landmarks and
  responsive source/build checks were completed; a real screen-reader
  session and browser-device screenshots remain manual release checks.
- Self-service data export (product spec section 52) isn't built yet —
  the Privacy Policy (`apps/web`'s `/privacy`) is explicit that a
  request to `support@duitlah.app` is the only way to get a copy of
  your data today. Account deletion (also section 52) is real and
  self-service as of Phase 15 — see above.
