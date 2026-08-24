# AI Assistant V2

Implemented in **V2 Phase 12** (spec sections 65-69; the master
prompt's own literal Phase 12 "Implement:" bullet list: workspace-aware
tools, Personal/Business/Shared tool contexts, widened affordability
inputs), continuing from
[cross-space-accounting.md](cross-space-accounting.md)'s V2 Phase 11
foundation.

## Extending V1, not rebuilding it

Before writing any code this phase, research turned up an entire
pre-existing `com.duitlah.api.ai` package — a genuine V1 AI assistant
from the original pre-V2 product spec's own earlier numbering (sections
40-42), still fully wired up and still passing its own tests. Its
architecture already matched V2 spec section 65's literal required
pipeline word for word: "Question -> Approved read-only tools ->
Structured financial facts -> LLM -> Explanation," with "the LLM must
not directly access repositories" enforced by a fixed, hardcoded set of
tool methods on `FinanceQueryService`. This phase is an extension of
that architecture, not a rewrite: every one of V1's original 9 tools
(`get_dashboard_summary`, `get_spending_by_category`,
`get_monthly_trend`, `get_top_merchants`, `get_forecast`, `get_budgets`,
`get_goals`, `get_settlements_summary`, `check_affordability`) stays
exactly as it was — same name, same behavior — nothing was renamed or
removed.

## "Might include" as a floor, not a ceiling

Spec section 66 introduces its Personal/Business/Shared tool lists with
"Personal tools might include: [...]" — read as a suggested minimum,
not an exhaustive spec. The concrete rule this phase followed: keep
every existing tool untouched, and add whichever tools from section
66's lists don't already exist under a similar name. That's how
`get_settlements_summary` (V1) and the new `get_settlements` (Shared,
V2) end up coexisting as near-duplicates — a deliberate choice to avoid
any regression risk from touching working code, not an oversight.

## From one hardcoded switch to pluggable providers

V1's `ClaudeAiChatService` had a single `executeTool` method: a
hardcoded `switch` over 9 tool names, all implicitly Personal. Adding
Business and Shared tool sets the same way would have meant a second and
third copy of the same dispatch logic. Instead, this phase introduced
`AiToolProvider` — matching this codebase's established pluggable
provider pattern (`EInvoiceProvider`, `NotificationProvider`):

```java
public interface AiToolProvider {
  AiToolContext context();               // PERSONAL / BUSINESS / SHARED
  List<AiToolDefinition> definitions();  // name, description, JSON schema
  Object execute(UUID userId, UUID spaceId, String toolName, JsonNode input);
}
```

`ClaudeAiChatService` auto-wires every bean of this type via
`List<AiToolProvider>`, decides which ones are *active* for the current
chat (see below), aggregates their tool definitions into the array sent
to Claude, and dispatches each `tool_use` block to whichever provider
owns that tool name. Every implementation is still the same "Finance
Query Layer" thin pass-through `FinanceQueryService` established for
V1 — `PersonalAiToolProvider`, `BusinessAiToolProvider`, and
`SharedAiToolProvider` each just call an already-existing,
already-authorized service and return its real response object,
unmodified, to be JSON-serialized as the tool result.

## `AiToolContext.SHARED` is not a `SpaceType`

The data model only has two space types, `PERSONAL` and `BUSINESS` (see
[financial-spaces.md](financial-spaces.md)) — there is no third "Shared"
space. Section 66's "Shared" tool context turned out to mean the
pre-existing Groups/Bagilah/Settlements features: a structurally
separate "money split between people" concept that was never tied to a
`FinancialSpace` to begin with. `SharedAiToolProvider` just reads those
existing modules directly; no schema change, no new space concept.

## Workspace-aware routing

Spec section 66 also asks the AI to "understand active Financial
Space." `ChatRequest` gained one new nullable field, `activeSpaceId`:

- **Omitted, or not a real Business space** — only `PERSONAL` and
  `SHARED` providers are active for the request.
- **A real `BUSINESS` space the caller belongs to** — `BUSINESS`
  providers become active too, alongside Personal and Shared.

Resolution goes through `spaces.SpaceService.getSpace(userId,
activeSpaceId)` — the exact same membership-enforcing chokepoint every
other module in this codebase uses (404-not-403 on a space the caller
doesn't belong to). An invalid or foreign space id doesn't fail the
whole chat request; it just falls back to the Personal+Shared context,
the same "degrade gracefully rather than break" posture
`CrossSpaceReportService` used for an inaccessible business space in
Phase 11. `BusinessAiToolProvider`'s own methods don't duplicate any
permission check themselves — every downstream service call
(`IncomeStatementService.generate`, `BalanceSheetService.generate`,
etc.) already independently enforces its own `VIEW_REPORTS`/membership
check, the same defense-in-depth every report endpoint in this codebase
already has.

## The tools added this phase

**Personal** (`PersonalAiToolProvider`, 5 new on top of V1's 9):
`get_net_worth`, `get_loans`, `get_bills`, `get_tax_summary`,
`get_tax_reliefs`. The last one reuses `personaltax.
TaxReliefCandidateService` and its existing `TaxReliefCandidateStatus`
enum (`POTENTIALLY_ELIGIBLE`/`NEEDS_REVIEW`/`MISSING_EVIDENCE`/
`CONFIRMED`/`REJECTED`) — a match this phase discovered rather than
built: that enum's own values are exactly the language spec section 70
requires ("Return: Potentially eligible / Needs review when
appropriate"), so exposing it as a tool with the right system-prompt
instruction was the whole job.

**Business** (`BusinessAiToolProvider`, 10 new, all requiring an active
Business space): `get_business_dashboard`, `get_profit_and_loss`,
`get_balance_sheet`, `get_cash_flow`, `get_receivables`, `get_payables`,
`get_overdue_invoices`, `get_inventory`, `get_tax_summary`,
`get_reconciliation_status`. `get_receivables`/`get_payables`/
`get_overdue_invoices` are client-side filters over `InvoiceService.
list`/`BusinessExpenseService.list` — neither service has a dedicated
query for "still outstanding," and a stream filter over the existing
list call was simpler than adding one.

**Shared** (`SharedAiToolProvider`, 3 new, always active):
`get_group_balances` (omit `groupId` to get every group the user
belongs to), `get_settlements`, `get_bagilah_summary`.

## Affordability inputs, widened (spec section 68)

`AffordabilityService` still has no LLM involvement anywhere — see
[database.md](database.md)'s AI assistant design decisions for why that
split is deliberate. This phase widened its real inputs:

- **Folded into the deterministic `canAfford` check**, alongside the
  existing `totalOwedToOthers`: `upcomingBillsTotal` (personal bills due
  by the forecast target date, excluding `PAID`/`SKIPPED`) and
  `debtRepaymentsTotal` (instalments due by then on `ACTIVE`
  liabilities). `totalObligations` is their sum — the actual value
  `canAfford` checks the projected post-purchase balance against.
- **Informational only**, surfaced alongside the verdict but not mixed
  into it: `averageCreditUtilization` (a 0-1 ratio via
  `liabilities.CreditCardService.averageUtilizationForUser`, `null`
  with no credit cards), `totalSavingsGoalsRemaining`, and
  `budgetRemainingThisPeriod`. These describe the user's broader
  financial posture rather than a due obligation — folding them into
  the pass/fail math would make an already-simple, auditable rule
  harder to reason about for no real benefit.

## Endpoints

`POST /api/v1/ai/chat` (now accepts an optional `activeSpaceId`),
`POST /api/v1/ai/affordability` (now returns the widened response
above) — see [api.md](api.md) for the full field list.

## Tests

`AiFlowTests` (5 — the original 4 V1 tests, still passing unmodified,
plus one new test folding an upcoming bill into obligations and
`canAfford`), `AiToolProviderFlowTests` (6 — direct dispatch coverage
for the new Personal/Business/Shared tools against real Spring-managed
provider beans, including an unknown-tool-name rejection per provider),
`AiWorkspaceContextFlowTests` (3 — no active space activates only
Personal+Shared, a real Business space activates Business tools
alongside them, a foreign/invalid space id falls back to Personal+
Shared) — 10 new integration tests, all pass; full backend regression
suite (367 tests total, every prior phase) reconfirmed clean.

No ANTHROPIC_API_KEY is configured in the test environment or this
repository's local Docker setup, so `ClaudeAiChatService`'s own routing
logic (`resolveActiveContext`) is exercised directly in
`AiWorkspaceContextFlowTests` — constructed with real, Spring-managed
providers and a real `SpaceService`, but never making the outbound
Anthropic HTTP call — the same "never mock what the real service can
answer" posture as every other test in this codebase, just entered
through the provider layer instead of a live tool-use loop.
Live-verified against a rebuilt Docker image: the chat endpoint's
honest `UnavailableAiChatService` fallback (no key configured, matching
every prior environment), and the upgraded affordability endpoint
end-to-end against a real account, a real income transaction, and a
real upcoming bill — the live response matched the test's predicted
`totalObligations`/`canAfford` exactly.
