# Duitlah Monthly Wrapped

A standalone feature built after V2's numbered phases concluded (Phase 14
was "the final numbered phase of the V2 master specification"; Phase 15
was a later, separate Public Launch initiative — see
[final-hardening.md](final-hardening.md) and
[database.md](database.md)'s Public launch section), following its own
45-section product/engineering brief in the same "study the codebase,
reuse what's real, never fabricate a number" spirit as those phases: a
Spotify-Wrapped-*paced* but never Spotify-*styled* monthly financial
recap — a Money Persona reveal, ranked insights and a supportive
next-month suggestion, computed once per user per completed month and
never silently regenerated afterward.

## No LLM anywhere in this feature

Every word Monthly Wrapped shows a user — the persona name/tagline, the
insight titles, the goal message — comes from a fixed set of Java
strings selected by deterministic, testable scoring logic
(`MoneyPersonaEngine`, `MonthlyInsightEngine`, `GoalRecommendationEngine`).
Given the same transactions, the same month always produces the exact
same Wrapped, byte for byte — a hard requirement of the brief, and the
reason all three engines are covered by unit tests that assert on exact
persona ids, exact insight ordering, and exact goal messages rather than
"a plausible-looking result."

## Reuse over reinvention

`MonthlyAggregationService.summarize()` is the single entry point every
downstream engine reads from (`MonthlyFinancialSummary`, a 24-field
record). It composes already-existing services rather than
recomputing anything:

- `AnalyticsService.spendingByCategory`/`topMerchants` for category and
  merchant totals.
- `BudgetService.listForPeriod` for the month's budget performance.
- `RecurringTransactionService.subscriptionsSummary` for the
  subscription count/total the Auto-Renew Royalty persona and the
  Subscription Review goal both key off.
- A new `GoalContributionRepository.sumAmountByUserIdAndOccurredOnBetween`
  query for the month's real savings-goal contributions.

The only genuinely new aggregation logic is leaf-category stats
(`LeafCategoryStats`: name, amount, transaction count, distinct
merchants — matched against the real seeded category taxonomy from
`V3__personal_finance.sql` rather than guessing from merchant-name
keywords, to avoid a false match when a user's own custom category
happens to share a name with a global one), an essential-vs-discretionary
split (`ESSENTIAL_LEAF_NAMES`), and daily spending totals (for the
"no-spend days" and "highest spending day" insights).

## Ten personas, four scoring shapes

`MoneyPersonaId` is a fixed 10-value enum — Cafe Hunter, Checkout
Champion, Jalan-Jalan CEO, Auto-Renew Royalty, Tabung Titan, Budget
Ninja, Memory Collector, Life Admin Legend, Makan Mission Specialist,
Digital Loot Goblin — each with a `MoneyPersonaDefinition` (display
name, tagline, `visualTheme` key for the mobile side's line-art motif).
Rather than forcing every persona into one formula, `MoneyPersonaEngine`
maps them onto four distinct scoring shapes: category-share-based (7 of
the 10 — e.g. Cafe Hunter scores on the "Cafe & Beverages" leaf
category's share of total spend), subscription-count-based
(`scoreAutoRenewRoyalty`), savings-rate-based (`scoreTabungTitan`), and
budget-adherence-based (`scoreBudgetNinja`). `choosePrimary()` picks the
single highest-scoring persona above a materiality floor, or returns
empty — Monthly Wrapped never fabricates a persona from too little
signal (`sufficientData: false` months always have `persona: null`,
both in the API response and in `MonthlyWrapped.persona_id`).

## Nine ranked insight types, capped at four

`MonthlyInsightEngine.rank()` runs up to nine independent candidate
producers (`FAVOURITE_MERCHANT`, `TOP_CATEGORY`, `HIGHEST_SPEND_MERCHANT`,
`HIGHEST_SPENDING_DAY`, `NO_SPEND_DAYS`, `LARGEST_TRANSACTION`,
`RECURRING_PAYMENTS`, `SPENDING_CHANGE`, `SAVINGS_IMPROVEMENT`,
`BUDGET_PERFORMANCE`), each returning `Optional.empty()` when its own
precondition isn't met (e.g. `SPENDING_CHANGE` needs a real prior-month
figure to compare against — never a fabricated "0% change"), then
ranks and truncates to `MAX_INSIGHTS` (4). Every insight is rendered by
the same generic 4-field shape (`type`, `title`, `primaryValue`,
`secondaryValue`, `comparison`) on both backend and mobile — there is
no per-type layout anywhere, so a tenth insight type could be added
without a mobile release.

## Goal recommendation: first matching rule wins

`GoalRecommendationEngine.recommend()` chains six rules via
`Optional.or()`, ordered from most specific/actionable to generic and
always-safe: a persona-specific category spending-limit suggestion (only
when this month's spend in that persona's category materially exceeds
the historical average — both an absolute RM300 and a relative 20%
floor, so a small month-to-month wobble never triggers it), a
subscription review (3+ active subscriptions), a low-savings-rate nudge
(below 10%), a "finished under budget" congratulation (every budget on
track with money left over), a savings-momentum callout (rate improved
vs. last month), and a generic fallback ("Keep tracking your spending —
small, consistent habits add up over time.") that always applies. Every
message is worded supportively — spec section 20 explicitly bans a
shame message for high essential spending, low income, or a genuinely
hard month, and none of the six rules ever produces one.

## Generate once, never silently regenerate

`monthly_wrapped` (`V30__monthly_wrapped.sql`) stores the full
`WrappedResult` as a JSON blob in a `payload TEXT` column — the same
"hand the whole computed artifact to a JSON column" precedent as
`receipts.parsed_result_json` — plus a denormalized `persona_id` so the
history list can render "August — Cafe Hunter" without deserializing
every row's full payload. `UNIQUE(user_id, year, month)` is the real
backstop against a duplicate: `WrappedGenerationService.generateAndPersist`
does an in-transaction existence check as the fast path, then catches
`DataIntegrityViolationException` as a race-loss fallback rather than a
real error, re-reading the row the other concurrent request just wrote.
Once persisted, a Wrapped is never rewritten — a later edit to an old
transaction does not retroactively change an already-issued month's
story, matching the brief's "this is a keepsake, not a live dashboard"
framing.

## Generation: scheduled ahead of time, lazy as a safety net

`MonthlyWrappedScheduler` runs `0 30 1 1 * *` (01:30 on the 1st of every
month) and calls `getOrGenerate` for every user's just-completed month,
so the Home promo card and history are already populated the moment the
month turns over rather than generating on first tap — the same "thin
`@Scheduled` wrapper around a plain, independently-testable method"
shape as `RecurringTransactionScheduler`/`PersonalBillScheduler`. A
per-user failure is logged and skipped rather than aborting the whole
run. `getOrGenerate` (the same method the controller calls on-demand)
remains the safety net for anyone the scheduled run misses — a user who
registers after it runs, a job that fails partway through — so a Wrapped
is never permanently missing just because the nightly job had a bad
run. `requireCompletedMonth` (current or future month → `400
MONTH_NOT_COMPLETED`) applies only to the controller-facing call; the
scheduler always requests *last* month, which is by definition always
already complete, so it never needs — or hits — that guard.

## Privacy-safe sharing

A dedicated 9:16 card is available in four variants: Money Persona, Monthly Summary,
Top Category and Biggest Insight (where their source data exists). RM amounts are
hidden until explicitly enabled. Account details, merchant notes, IDs and transaction
histories are never included. The mobile share service renders a 1080 × 1920 PNG,
provides an iPad share anchor and removes temporary files after success or failure.

## Endpoints

`GET /api/v1/wrapped/promo` — the Home promo card's data source; only
ever reads what the scheduler (or a prior on-demand call) already
produced, and never generates a Wrapped as a side effect of a screen
that just wants to know whether to show a teaser. Returns
`{available: false}` once the user has already viewed last month's
story, or if it judged that month's data insufficient. `GET
/api/v1/wrapped` — every one of the caller's Wrapped months,
newest-first, `personaId`/`personaName` null for an insufficient-data
month. `GET /api/v1/wrapped/{year}/{month}` — the full story payload;
generates lazily on first request if the scheduler hasn't already,
`400 MONTH_NOT_COMPLETED` for the current or a future month. `POST
/api/v1/wrapped/{year}/{month}/viewed` — marks a month viewed, removing
it from the promo card and flagging its history row as seen.

## Mobile: eight editorial chapters

The approved September 10 visual reference is implemented as an immersive story:
intro, overview, comparison, category composition, persona clues, persona reveal,
records and next month. The fixed cream/plum/gold art direction does not invert with
the surrounding app theme. Plus Jakarta Sans remains unchanged across the app;
SIL-licensed Bodoni Moda is bundled specifically for Wrapped headlines.

`WrappedStoryController` owns navigation, reveal stages, selected categories and
expanded records. Right taps and swipes complete meaningful reveals before advancing;
the introduction and persona build-up have explicit CTAs. Animations respect reduced
motion. There is no automatic chapter advance or final-page loop.

The existing Home and Analytics entry points remain. Unseen stories do not expose
the persona early. Only Done marks a month viewed; closing, system back and reaching
the last page do not. Failed completion remains retryable. Replay starts from the
introduction, and unfinished stories remain unviewed.

## Structured version-2 snapshot details

`WrappedStoryData` adds previous expenses, the exact decimal spending difference,
category amounts/shares/counts, persona supporting metrics, merchant records and
available expansion details. It reuses `MonthlyFinancialSummary`; category counts
roll recorded expenses into their top-level category. Unassigned spending remains
visible. Suggestions use 10% of positive recorded income with decimal rounding.
No income means no income-based savings CTA.

These details are persisted with newly generated snapshots. Version-1 snapshots
remain unchanged and decode with absent optional story data. The client omits
unsupported chapters and expansions rather than reconstructing historical numbers
from rounded percentages or combining old snapshots with live data.

The savings CTA opens the existing goal editor with the suggested target, Monthly
frequency guidance and Wrapped attribution. The user can edit or cancel before
creating the goal. The existing workflow creates a manual savings target; it does
not schedule recurring transfers or move funds.

## Tests and visual review

425 backend tests and 165 mobile tests pass. Backend integration covers real
transactions, version-2 details, category roll-up counts and immutable replay;
legacy payload compatibility and decimal calculations have unit coverage. Mobile
checks cover every chapter at 375/390/393/430px, safe areas, reduced motion, sparse
data, large values, long names, goal confirmation, completion retries and actual
1080 × 1920 export/cleanup. Flutter analysis and Wrapped Java formatting are clean.

See [reviewed previews and behaviour](wrapped/README.md). No physical-device
frame-rate measurement or third-party social-app delivery is claimed by these tests.

## A pre-existing bug found and fixed along the way

Two unrelated backend tests
(`PersonalFinanceFlowTests.dashboardSummarizesBalanceAndMonthTotals`,
`CreditCardFlowTests.repayingTheCardIsATransferNotASecondExpense`) had
hardcoded `"2026-08-01"`-style date literals asserting against
`/api/v1/dashboard`'s *current-month* totals — a latent bug that only
surfaces once the real calendar rolls past the hardcoded month, which it
did mid-session. Both were fixed to use `LocalDate.now()`-derived dates
instead; unrelated to Monthly Wrapped itself, but caught by the first
full-suite run after this feature's own tests were added.
