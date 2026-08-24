# Final Hardening

Implemented in **V2 Phase 14**, the final numbered phase of the V2 master specification.
This phase reviewed the complete V2 system rather than adding a new product domain.

## Security, permissions, and isolation

All 67 controllers (322 mapped route declarations) were reviewed against the established
authorization boundaries: personal resources resolve through caller-owned lookups; business
resources use `SpaceService` permissions; group, Bagilah, settlement, and guest resources use
their domain membership/token guards. Controllers depend on services rather than repositories,
and repository queries are parameter-bound JPQL—there is no raw SQL string construction in
application code. Existing cross-user and cross-space denial tests remain distributed beside
each domain flow, where they exercise the same fixtures as the protected operation.

The review found one financial concurrency gap: settlement payments were append-only but did
not cap the aggregate paid amount. `SettlementService.recordPayment` now locks the settlement
row, recomputes the remaining amount inside that transaction, and rejects an excess with
`409 PAYMENT_EXCEEDS_REMAINING`. The lock makes the invariant hold for concurrent requests too.

## Financial, accounting, and tax invariants

The suite now explicitly covers every invariant in specification sections 90–92:

- Bagilah allocations reconcile to the cent and finalized bills reject mutation.
- settlement payments cannot exceed the remaining amount;
- duplicate statement candidates merge without creating a second transaction;
- every journal is balanced at both service and database layers;
- sale, expense, owner contribution, owner drawing, and personal-paid business expense posting
  shapes are verified against the Trial Balance;
- credit-card repayment is a transfer and does not increase monthly spending;
- fixed YA fixtures cover brackets, relief ceilings, rebates, PCB, zakat, taxable income,
  missing rules, and a historical YA (2024) independently of the runtime year.

## Performance, migrations, and recovery

`scripts/performance-smoke.sh` performs an authenticated 25-request dashboard sample and fails
when p95 exceeds 750 ms (both configurable). This is a deterministic deployment smoke gate, not
a substitute for production capacity testing.

Every integration-test application boot validates and applies all Flyway migrations to a fresh
PostgreSQL 16 database. Phase 14 reconfirmed a clean V1→V29 migration.

`scripts/postgres-backup.sh` creates a custom-format, owner-independent dump.
`scripts/postgres-restore-smoke-test.sh` restores it into an isolated temporary database, compares
the successful Flyway version and public-table count with the source, then drops only that
temporary database. The procedure was exercised against the rebuilt Docker stack.

## Accessibility and responsive scope

Mobile remains the primary V2 client; the web app remains the documented secondary companion
for marketing, personal finance, groups, settlements, and guest Bagilah. Phase 14 does not
fabricate V2 business screens on the secondary client.

The web layout now provides a keyboard-visible “Skip to main content” link and focusable main
landmarks in both authenticated and marketing shells. Responsive source review confirmed the
existing mobile-bottom-nav/desktop-sidebar breakpoint, bounded content widths, wrapping grids,
and touch-sized shared controls. Flutter review confirmed pervasive `SafeArea`, adaptive
scrolling/layout, semantic labels/tooltips, and no client-side financial calculations. The
browser automation runtime was unavailable in this environment, so browser-device screenshots
were not used as evidence; build/type/lint checks and the live HTTP surface were used instead.

## API documentation review

The documented API was reconciled with controller mappings, including the complete Phase 13
automation surface and the Phase 14 settlement conflict. OpenAPI remains generated from the
authoritative controllers at `/v3/api-docs`; `docs/api.md` explains domain contracts and errors
rather than duplicating the entire generated schema.
