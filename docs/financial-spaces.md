# Financial Spaces

Implemented in **V2 Phase 1** as the foundation for the Duitlah V2 upgrade
(Personal + Business + Shared finance platform — see `docs/v2-audit.md` for
the full audit and phase plan this continues from). A `FinancialSpace` is a
workspace: every future V2 module (accounting, tax, invoicing, inventory)
will be scoped to one, the same way every Phase 0-15 feature was scoped to
a `user_id` directly.

## Why this had to come first

Every table in the schema keys off `users.id` directly — there was no
existing concept of "which workspace does this belong to." Introducing
Business features (double-entry accounting, tax centres, e-invoicing)
without first introducing a space to scope them to would mean retrofitting
a workspace concept onto a dozen tables at once, later, under more risk.
`financial_spaces` is deliberately the *only* new concept this phase adds —
no accounting, no tax, no invoicing yet — so it can be verified in
isolation before anything else builds on it.

## Model

- **`FinancialSpace`** — `type` (`PERSONAL` | `BUSINESS`), `name`,
  `owner_user_id`, `status` (`ACTIVE` | `ARCHIVED`). Every existing user
  gets exactly one `PERSONAL` space, enforced by a partial unique index
  (`WHERE type = 'PERSONAL'`) rather than application logic alone — the
  same "enforce it at the database, not just in code" discipline as the
  Phase 4 budgets partial-unique-index pattern (see
  [database.md](database.md)).
- **`SpaceMember`** — `(space_id, user_id)` unique, a `role` (`OWNER`,
  `ADMIN`, `FINANCE`, `ACCOUNTANT`, `SALES`, `STAFF`, `VIEWER` — the
  Business RBAC roles the V2 spec names; a Personal space only ever has
  one member, its owner, with role `OWNER`), and `status` (`ACTIVE` |
  `REMOVED`) so a removed member's history isn't deleted, only their
  access. Membership — not space existence — is what every future
  cross-space query will check.
- **`BusinessProfile`** — one-to-one with a `BUSINESS`-typed space
  (`space_id` unique FK): legal name, trade name, registration number,
  TIN, business type, industry, SST number, financial year start/end,
  address, phone, email, currency (defaults `MYR`). Every field beyond
  `legalName` is optional — a business can be created today and have its
  full profile filled in later, once the actual settings screen exists (a
  later phase).

## Personal-space migration is additive, not a rewrite

No existing table gained a `space_id` column in this phase, and no
existing query changed. The Phase 0-15 personal-finance schema
(`accounts`, `transactions`, `budgets`, `goals`, ...) still keys off
`user_id` exactly as before; a user's Personal space exists alongside it
as a real row, not yet wired into those tables' queries. Wiring existing
personal-finance tables to `space_id` (so a user's Personal space is the
same thing their transactions/budgets/accounts already belong to, not a
parallel concept) is deliberately deferred to whichever later V2 phase
actually needs it — doing it now, before anything reads or writes through
it, would be exactly the kind of speculative structure the rest of this
codebase avoids (see `docs/database.md`'s recurring `computed, never
stored` / "don't build ahead of the phase that needs it" reasoning
throughout).

`V16__financial_spaces.sql`'s own backfill creates one `PERSONAL` space
per existing user (`INSERT ... SELECT 'PERSONAL', 'Personal', id FROM
users`) plus a matching `OWNER` `SpaceMember` row, so every user — new or
pre-existing — has exactly one Personal space from the moment this
migration runs. `SpaceFlowTests` can't directly exercise that backfill
against a fresh Testcontainers database (migrations always run before any
test user exists), so it's covered by inspection of the migration SQL
itself plus `registeringCreatesExactlyOnePersonalSpaceOwnedByTheNewUser`,
which proves the same invariant holds for every user created after this
migration via `SpaceService.createPersonalSpaceForNewUser` (wired into
`AuthService.register`, immediately after the user row is saved).

## Business spaces are opt-in and additive

Creating a Business space (`POST /api/v1/spaces/business`) never touches
or replaces a user's Personal space — a user can own one Personal space
and any number of Business spaces simultaneously, matching the V2 spec's
"Personal + Business + Shared" framing literally rather than treating
Business as a mode a user switches into.

## Authorization: 404, not 403

`SpaceService.requireMembership` is the one gate every space-scoped
read/write will go through: a non-member gets `404 SPACE_NOT_FOUND`, not
`403 FORBIDDEN` — the same "never confirm another user's data exists"
discipline the Phase 3 personal-finance tests already established for
accounts/transactions. `aUserCannotSeeOrGetASpaceTheyAreNotAMemberOf`
verifies this against a real second user's real Business space, not just
a random UUID.

## Mobile: a real workspace list, not a placeholder switcher

`apps/mobile`'s new `features/spaces` module (reachable via a
"Workspaces" entry, first in the More menu) lists a user's Personal
space and their Business spaces, and lets them create a new Business
space and view its (read-only, for this phase) profile. It deliberately
does *not* present a "switch active workspace" control — there is nothing
yet for such a switch to actually change (no space-scoped transactions,
budgets, or accounts exist as of this phase, per the section above), and
building that control now would be exactly the kind of placeholder UI the
V2 spec's own anti-placeholder instruction (section 94) rules out. It
becomes real once a later phase actually scopes a feature to the active
space.

## Endpoints

| Method | Path | Notes |
|---|---|---|
| `GET` | `/api/v1/spaces` | Every space the caller is an active member of. |
| `GET` | `/api/v1/spaces/{spaceId}` | 404 if not a member. |
| `POST` | `/api/v1/spaces/business` | Creates a `BUSINESS` space + `BusinessProfile`; caller becomes `OWNER`. |
| `GET` | `/api/v1/spaces/{spaceId}/business-profile` | 404 if not a member or no profile exists. |

Same response-envelope and error-code conventions as the rest of the API
— see [api.md](api.md).

## Tests

`SpaceFlowTests` (backend, 4 tests): registration auto-creates exactly one
Personal space; creating a Business space adds it alongside Personal and
persists its profile; a non-member gets 404 for both a space and its
profile. `financial_space_json_test.dart` (mobile, 2 tests): `fromJson`
parsing of both `FinancialSpace` and `BusinessProfile` against real
backend response shapes, including optional-field nulls.
