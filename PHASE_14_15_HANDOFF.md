# Duitlah V2 Upgrade — Handoff at end of Phase 13

This document is for whichever agent picks up this work next. It
summarizes what's been done, the operating discipline this session
established, and exactly what's left per the master spec.

**The master spec** lives at
`/Users/nabilfn/.claude/uploads/9c27ec03-11cc-459f-a138-34dd3c71c93e/7cbe305d-DUITLAH_V2_MASTER_UPGRADE_PROMPT.md`
— NOT inside the repo. Read it directly; don't rely on this summary for
exact wording. It defines **Phase 0 through Phase 14 only** — there is
no "V2 Phase 15" anywhere in that document (confirmed by grepping every
`# PHASE` header in the file). If you were told to do "Phase 14 and
15," Phase 14 (Final Hardening) is the last defined phase — treat
anything past it as the spec's own closing checklists (sections 101
"Definition of Done" and 102 "Final Product Principle", both summarized
below), not a numbered phase with its own bullet list.

## What's already done (V2 Phase 0 → 13, all complete)

Every phase below is implemented on the backend, tested, live-verified
against a rebuilt Docker image, documented, and (from Phase 9 onward,
after mobile became the primary client at Phase 9.5) implemented on
Flutter mobile too. Full detail for each phase lives in its own doc
under `/Users/nabilfn/Duitlah/docs/` — see the map below.

| Phase | Name | Doc |
|---|---|---|
| V2 Phase 1 | Financial Spaces | `docs/financial-spaces.md` |
| V2 Phase 2 | Personal Gap Closure I (AutoTrack, statement import, Receipt Vault) | `docs/autotrack.md` |
| V2 Phase 3 | Personal Gap Closure II (Bills, Loans/BNPL/Credit Cards, Net Worth) | `docs/personal-gap-closure-ii.md` |
| V2 Phase 4 | Personal Tax Centre | `docs/personal-tax.md` |
| V2 Phase 5 | Business Core | `docs/business-core.md` |
| V2 Phase 6 | Business Accounting Engine | `docs/accounting-engine.md` |
| V2 Phase 7 | Reconciliation | `docs/reconciliation.md` |
| V2 Phase 8 | Inventory & Costing | `docs/inventory-and-costing.md` |
| V2 Phase 9 | Fixed Assets | `docs/fixed-assets.md` |
| V2 Phase 10 | LHDN / MyInvois / SST | `docs/business-tax-and-einvoice.md` |
| V2 Phase 11 | Cross-Space Accounting | `docs/cross-space-accounting.md` |
| V2 Phase 12 | AI Financial Assistant V2 | `docs/ai-assistant-v2.md` |
| V2 Phase 13 | Advanced Automation | `docs/advanced-automation.md` |

Also read `docs/architecture.md` (module dependency graph, updated
after every phase) and `docs/database.md` (schema design decisions,
also updated every phase — has a dedicated section per phase near the
bottom) before touching anything; they explain *why* things are shaped
the way they are, which matters for Phase 14's review work.

The app also has an older set of **pre-V2 phases (1–15)** that existed
before this upgrade began and are unrelated to the V2 phase numbers
above (e.g. docs reference "Account deletion (Phase 15)" and "Feedback
(Phase 15)" — that's the *old* numbering, already fully implemented,
not a V2 phase to redo).

## Current test / build state (as of end of Phase 13)

- **Backend**: 388 tests, all passing. Latest Flyway migration:
  `V29__advanced_automation.sql`. Run from `apps/api`:
  ```
  cd apps/api && JAVA_HOME="/Users/nabilfn/.jdks/jdk-17.0.20+8/Contents/Home" ./mvnw test
  ```
- **Mobile**: 94 tests, all passing; `flutter analyze` has exactly 2
  pre-existing `info`-level lints in `lib/features/groups/presentation/group_detail_screen.dart`
  (unrelated to any V2 work, never fixed, harmless — don't be alarmed
  if you see them again).
- **Docker**: `docker compose up -d` from the repo root brings up
  `duitlah-api-1`, `duitlah-postgres-1`, `duitlah-redis-1`,
  `duitlah-minio-1`, `duitlah-web-1`. No `ANTHROPIC_API_KEY` is
  configured anywhere in this environment (dev `.env` or Docker) — the
  AI assistant (Phase 12) and receipt OCR both run in their honest
  "unavailable" fallback mode, by design, not a bug.
- **Git**: repository has **never been committed** —
  `git status` reports "No commits yet" and everything is untracked.
  This was a deliberate standing instruction throughout the whole
  session: never `git commit` unless the user explicitly asks.

## Environment gotchas learned the hard way this session

1. **`JAVA_HOME` must be set explicitly on every Maven command**:
   `/Users/nabilfn/.jdks/jdk-17.0.20+8/Contents/Home`. It is not the
   shell default.
2. **Background Bash commands can silently run in a stale working
   directory**, producing `(eval):1: no such file or directory:
   ./mvnw` (exit 127) — a false pass unless you check the real exit
   code and log content, not just a notification summary. Always
   prefix Maven commands with an explicit `cd /Users/nabilfn/Duitlah/apps/api &&`.
3. **Never edit source files while a full-suite `mvn test` run is in
   flight** — causes stale/inconsistent compiled classes and spurious
   failures in unrelated test classes. Wait for it to finish; docs/research
   work in parallel is fine.
4. **Testcontainers leak containers if a test JVM is killed abruptly**
   (e.g. background process management cutting it off) rather than
   exiting cleanly — the Ryuk reaper doesn't get to clean up. Dozens of
   orphaned `postgres:16-alpine`/`redis:7-alpine`/`minio/minio` containers
   accumulated this session and were cleaned up with:
   ```
   docker rm -f $(docker ps -a --filter "label=org.testcontainers=true" -q)
   ```
   This is safe — it only ever touches Testcontainers-labeled throwaway
   containers, never the real `duitlah-*` stack or anything else running
   on the machine. Worth doing periodically (or before Phase 14's own
   heavy test runs) so leaked containers don't confuse resource/perf
   testing.

## Operating discipline this session followed (keep following it)

- **Real, working, tested code only** — no fabricated integrations, no
  placeholder features that look real (spec section 94 explicitly bans
  this).
- **Server-enforced authorization, never client-side-only.**
- **Computed-never-stored balances** — account balances, quantities,
  valuations are always derived from summing an append-only ledger on
  read, never cached in a stored column.
- **Reuse over reinvention** — before adding a new mechanism, check
  whether an existing one (a service, a schema pattern, a Java utility
  class) already does 90% of the job. This session repeatedly found
  that "new" spec requirements were actually already half-built by an
  earlier phase.
- **Every migration/feature must be live-verified against a rebuilt
  Docker image via direct `curl`**, not just unit tests — this session
  caught several real bugs this way that unit tests alone missed (see
  `docs/cross-space-accounting.md` and `docs/business-tax-and-einvoice.md`
  for two worked examples).
- **Documentation updated after every phase**: a new phase-specific doc
  file, plus updates to `docs/architecture.md`, `docs/database.md`,
  `docs/api.md`, and a new dated paragraph appended to `README.md`.
- **Never `git commit` unless explicitly asked.**
- **Mobile work is delegated to a background `Agent` call**, then
  independently re-verified (re-run `flutter analyze`/`flutter test`
  yourself, spot-check a handful of the new files) rather than trusting
  the agent's own summary — this caught nothing wrong in Phase 12/13,
  but the discipline is there for a reason.
- **When two spec bullets turn out to be the same underlying mechanism,
  say so and build one thing** — Phase 13's "transaction rules" +
  "automatic categorization" + "statement-learning" collapsed into one
  `transactionrules` module rather than three separate half-features.
  Look for this pattern in Phase 14 too (e.g. "financial invariant
  tests" and "accounting invariant tests" likely share fixtures/setup).

## Phase 14 — Final Hardening (the actual next phase)

Master spec's own literal bullet list for this phase:

```
- security review
- permission review
- data-isolation tests
- financial invariant tests
- accounting invariant tests
- tax-rule tests
- performance tests
- migration tests
- backup/restore tests
- accessibility review
- mobile responsive review
- web responsive review
- API documentation review
```

This phase is different in character from every phase before it: it's
almost entirely **review and test-writing against the existing 13
phases**, not new features. Read spec sections 90 ("TESTING"), 91
("ACCOUNTING TESTS"), and 92 ("TAX TESTS") for concrete detail — they
give exact worked examples of what the financial/accounting/tax
invariant tests should check. Key excerpts:

**Financial invariants to test especially** (section 90):
```
Money always reconciles.
Debits = Credits.
Finalized Bagilah totals never change.
Settlement payment never exceeds allowed state.
Duplicate imports do not produce duplicate transactions.
Owner contribution is not revenue.
Owner drawing is not an expense.
Credit-card payment is not double-counted as spending.
```

**Accounting test shape** (section 91) — every one of these needs an
automated test asserting Dr==Cr:
```
Sale for RM100:              Dr Bank 100 / Cr Revenue 100
Expense:                     Dr Software Expense 50 / Cr Bank 50
Owner contribution:          Dr Bank 5000 / Cr Owner Equity 5000
Personal-paid biz expense:   Dr Software Expense 1299 / Cr Due to Owner 1299
```
Some of these already have coverage from earlier phases (owner
contribution/drawing/personal-paid-expense are covered by
`CrossSpaceFlowTests` from Phase 11) — check before writing duplicates,
per the reuse discipline above.

**Tax tests** (section 92): fixed Year-of-Assessment fixtures, testing
brackets/relief caps/rebates/PCB/zakat/taxable income/missing
rules/**historical YA** — "do not write tests based on the current
year only." `personaltax.TaxYearService` already seeds YA 2024–2026
(`V20__seed_tax_years.sql`) with an explicit honesty disclaimer about
the figures being approximations — good raw material for this.

### Suggested approach for Phase 14

1. **Re-verify the current baseline first** (full backend + mobile test
   suites, Docker rebuild) before touching anything — confirm Phase 13
   is still genuinely clean, per this session's own opening ritual
   every phase.
2. **Security review + permission review**: systematically walk every
   controller and check every mutating endpoint has an explicit
   permission/ownership check (this codebase's convention is
   `spaceService.requirePermission(...)` for business endpoints,
   `requireOwned(userId, ...)` lookups for personal ones — grep for
   endpoints missing either pattern). Check for the classic gaps: IDOR
   (can user A read/mutate user B's data by guessing an id?),
   mass-assignment, injection in any raw SQL/native queries, secrets in
   logs.
3. **Data-isolation tests**: cross-user and cross-space isolation is
   mostly already covered incidentally by existing "non-owner cannot
   see X" tests scattered across `*FlowTests` files — audit for gaps
   rather than assuming full coverage; write a consolidated test suite
   if scattered coverage turns out thin.
4. **Financial/accounting/tax invariant tests**: likely a new test
   package (e.g. `com.duitlah.api.invariants` or similar) with focused,
   fixture-driven tests per section 90–92's examples, reusing existing
   services rather than reimplementing calculations.
5. **Performance tests**: this codebase has no load-testing
   infrastructure yet — decide scope pragmatically (e.g. a handful of
   JMH or simple timed-assertion tests on the heaviest read paths:
   dashboard aggregation, General Ledger reports, reconciliation
   matching over a large statement) rather than standing up a full
   load-testing rig from scratch, unless the user wants that investment.
6. **Migration tests**: Flyway's own `DbValidate` already runs on every
   boot (confirmed clean through V29); consider a test that spins up a
   fresh database and validates all 29 migrations apply cleanly in
   order (may already be implicitly covered by `TestcontainersConfiguration`
   — check before adding a redundant one).
7. **Backup/restore tests**: no backup/restore mechanism exists in this
   codebase yet as far as this session ever touched — this may be new
   infrastructure work (e.g. a documented `pg_dump`/`pg_restore`
   procedure plus a test that restoring reproduces identical data), or
   may be explicitly out of scope for a dev-stage app — worth asking
   the user for a scope decision rather than assuming either way.
8. **Accessibility review + mobile/web responsive review**: read
   `docs/architecture.md`'s "UI DESIGN PRINCIPLES" pointer (spec
   section 93) first. **Important gap to investigate before doing web
   work**: `apps/web` exists in this repo (a Next.js app, container
   `duitlah-web-1` already running) but was **never touched by any of
   the 13 V2 phases this session completed** — its `src/types/` only
   has pre-V2-era types (`bagilah.ts`, `group.ts`, `settlement.ts`,
   `budget.ts`, `receipt-scan.ts`, `user.ts`, `finance.ts`; nothing for
   spaces/accounting/sales/tax/AI/automation) and its README is still
   the unmodified `create-next-app` boilerplate. It looks like a
   narrower pre-V2 web client (possibly scoped to Bagilah's
   guest-bill-splitting flow — see `guest-session.ts`/`guest-api-client.ts`
   in `apps/web/src/lib/`), not a full V2 web parity build. **Confirm
   its actual scope/purpose with the user before assuming "web
   responsive review" means auditing a feature-complete V2 web app** —
   it may mean reviewing this narrower existing surface only, or it may
   mean this phase needs to scope in real V2 web work first. Don't
   guess past this; it's a genuine unknown, not something this session
   verified.
9. **API documentation review**: `docs/api.md` has been updated every
   phase, but a Phase 14 pass should check it against the actual
   controllers for drift (endpoints added but undocumented, response
   shapes that changed underneath a stale doc paragraph, etc.) — a good
   candidate for a dedicated Explore-agent sweep comparing controller
   `@RequestMapping`/`@GetMapping`/etc. annotations against `api.md`'s
   prose.

### After Phase 14

Once Phase 14 itself is done and tested per this session's usual
rhythm (implement → test → full regression → Docker rebuild → live
verify → docs → mobile delegation → report), the master spec's own
closing sections (**101 "Definition of Done"**, **102 "Final Product
Principle"**) function as a final self-check for the *whole* V2
upgrade, not a phase to implement:

- **Definition of Done (101)**: a feature only counts as complete when
  it has Database + Domain Logic + Authorization + API + Validation +
  Error Handling + Tests + Mobile/Web UI (where applicable) + Audit
  (where applicable) + Documentation, all together. Worth a final sweep
  across all 13 phases checking nothing was left half-done.
- **Final Product Principle (102)**: Duitlah should feel like "one
  connected financial operating system" — everyday spending flowing up
  through personal finance → tax readiness → shared money → business
  finance → accounting → LHDN → financial intelligence, without the
  user re-entering the same information twice. Worth a final
  cross-phase review checking the connective tissue the spec describes
  (bank transaction → categorized → budget updated → forecast updated →
  tax candidate updated → net worth updated) genuinely works
  end-to-end, not just that each phase's own feature works in
  isolation.

There is no numbered phase after 14 in the master spec. If the user
wants further work past this point, it's a new scope decision for
them to make, not something to infer from the document.
