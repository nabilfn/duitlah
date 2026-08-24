# Personal Tax Centre

Implemented in **V2 Phase 4** (spec sections 25-30), continuing from
[personal-gap-closure-ii.md](personal-gap-closure-ii.md)'s V2 Phase 3
foundation. A Malaysian personal-tax **preparation and estimation**
system — explicitly not an LHDN filing integration (spec: "must not claim
to replace official LHDN filing unless a legitimate official integration
exists," which this repository does not have).

## Honesty note (read this before trusting a number)

`V20__seed_tax_years.sql` seeds YA2024-YA2026 with a good-faith
approximation of the resident-individual tax structure published by LHDN
since the Budget 2023 revision — brackets, relief ceilings, and the
individual rebate. **These figures come from the assistant's own general
knowledge, not a live LHDN feed or an official dataset shipped with this
repository.** Malaysian tax rules are revised almost every Budget cycle.
Every calculation this module produces carries an explicit disclaimer
saying so, and this is deliberate, not boilerplate — verify every seeded
value against the current official LHDN circular before relying on this
for real filing.

This is exactly why spec section 26 demands YA-versioned rules in the
first place: correcting a rate is a data change (a new `tax_years` row,
or an `UPDATE` with a citation), never a code change — and it never
silently invalidates an already-computed prior year's result, since that
year's own `tax_years`/`tax_brackets`/`tax_relief_rules` rows are
untouched.

## Structure

`com.duitlah.api.personaltax` mirrors the spec's own Tax Centre tabs
(section 25): Income, PCB, Tax Reliefs, Zakat, Documents, plus the
Calculation and Filing Readiness views. "Receipt Vault" isn't a separate
tab here — it's the existing Phase 2 `receipts` module, reused rather
than duplicated (see below).

## Year-of-Assessment versioning (section 26)

`TaxYear` (one per YA, holding the automatic self relief) has three child
rule tables: `TaxBracket` (progressive rate bands), `TaxReliefRule` (a
claim ceiling per `PersonalTaxReliefCategory` — a representative, not
exhaustive, set of 13 real LHDN categories), and `TaxRebateRule` (a flat
rebate below a chargeable-income threshold). There's no generic "TaxRule"
table — brackets/relief-rules/rebate-rules already are the concrete forms
that name implies, and adding an umbrella table over them would be
structure with no distinct behavior of its own, the same reasoning this
codebase already applies elsewhere (e.g. `bills` not splitting into a
separate rule-vs-occurrence model). `TaxYearService.requireYear` 404s
with `TAX_YEAR_NOT_CONFIGURED` for any YA that hasn't been seeded —
calculating for an unconfigured year fails loudly, never silently
falling back to a wrong year's rules.

## Tax relief tracking (section 27)

The pipeline is implemented literally: **Transaction/Receipt/Document →
Tax Relief Candidate → Eligibility Review → Confirmed Relief.**

- **Real, not fabricated, suggestion**: `receipts.ReceiptVaultService.upload`
  already tags a receipt `TAX_EVIDENCE` (Phase 2). When OCR reads a real
  total off that upload, it now also calls
  `TaxReliefCandidateService.createFromReceipt` — a genuine existing
  signal (the user explicitly tagged this receipt as tax evidence), never
  a merchant-category guess dressed up as intelligence. A candidate from
  this path starts with no category — the user assigns one when
  confirming.
- **Never a silent claim**: `TaxReliefCandidate.status` only ever leaves
  `NEEDS_REVIEW`/`POTENTIALLY_ELIGIBLE` via an explicit `confirm` or
  `reject` call. `confirm` clamps the claimed amount to that YA's
  `TaxReliefRule` ceiling for the chosen category — a user can't
  accidentally over-claim past the legal limit through this app.
- **`ConfirmedTaxRelief`** (one row per user/YA/category, upserted on
  re-confirm) is the ledger of truth `PersonalTaxCalculationService`
  reads — never the candidates themselves, which are workflow state, not
  the source of truth.

## Tax documents (section 28)

`PersonalTaxDocument` either links an existing Receipt Vault entry
(`receiptId` — reusing its OCR/storage rather than a second OCR pass) or
stores its own file directly (`storageKey`, via the same
`common.storage.ObjectStorage` every other upload in this app uses) for
document types that aren't naturally receipts — an EA form, an EPF
statement PDF. Linking validates the receipt is actually owned by the
caller (a real ownership check, not just an opaque ID reference).

## Tax calculation (section 29)

`PersonalTaxCalculationService.calculate` — deterministic, no model call
anywhere in it, the same discipline as `finhealth.FinancialHealthService`/
`ai.AffordabilityService` — implements the exact pipeline the spec
diagrams:

```text
Income
+ (total of personal_income_records for the YA)
- Eligible reliefs
  (self relief + SUM(confirmed reliefs, each re-clamped to its
   category's current ceiling at calculation time, not just at
   confirmation time)
= Chargeable income (floored at 0)

→ Tax brackets (progressive — each band's rate applies only to its own slice)
→ Tax payable (gross)
→ Applicable rebates (chargeable-income-threshold rebate, capped at gross tax)
→ Zakat (a rebate against tax payable, capped at what's left — zakat can
   reduce tax to zero but never produce a negative "rebate")
→ PCB already paid (subtracted last)
= Estimated payable / (refund if negative)
```

Every intermediate figure is returned, not just the final number, and the
disclaimer is never omitted.

## Filing readiness (section 30)

`FilingReadinessService` — an explainable checklist, not a guess about
need. `INCOME`/`EA`/`PCB` are ready only when real data exists. `ZAKAT` is
marked ready by default (documented, not a guess — this app has no way to
know a user's zakat obligation, so treating its absence as "blocking"
would be worse than assuming it isn't owed). `LIFESTYLE`/`MEDICAL`/
`INSURANCE` reflect a real, actionable signal: whether a relief candidate
in that category is still sitting unreviewed — not whether the user
"should" have one, which this app can't know either.

`TaxPreparationSummaryService` generates the spec's own "MyTax preparation
summary" (a reference document for the taxpayer's own use, explicitly
never a submission — spec: "do not simulate successful LHDN submission")
by reusing `exports.PdfExportWriter` rather than a second PDF-writing code
path.

## Endpoints

`GET/POST/DELETE /api/v1/personal-tax/income`; `GET/POST
/api/v1/personal-tax/pcb` (upsert per YA+month); `GET/POST
/api/v1/personal-tax/zakat`; `POST /api/v1/personal-tax/documents` (link a
receipt) and `.../documents/upload` (direct file); `GET/POST
/api/v1/personal-tax/relief-candidates`, `.../confirm`, `.../reject`;
`GET/DELETE /api/v1/personal-tax/confirmed-reliefs`; `GET
/api/v1/personal-tax/calculation`; `GET
/api/v1/personal-tax/filing-readiness`; `GET
/api/v1/personal-tax/preparation-summary` (a PDF download).

## Mobile

One feature module (`personaltax`) with a YA-selectable overview screen
(calculation summary + filing readiness + a "download preparation
summary" share action) and five sub-screens (Income, PCB, Zakat, Tax
Reliefs, Documents), reachable from the More menu. Multi-currency-style
"add a relief manually without going through the receipt pipeline" is
supported directly in the Tax Reliefs screen, matching the backend's own
manual-creation path.

## Tests

Backend: `PersonalTaxCalculationFlowTests` (7 — including hand-computed
progressive-bracket and zakat-clamping math against the seeded YA2026
rules), `TaxReliefCandidateFlowTests` (5, including the real
Receipt-Vault-to-candidate wiring), `FilingReadinessFlowTests` (3),
`PersonalTaxDocumentFlowTests` (3, including a real cross-user 404 on
linking someone else's receipt) — 18 new integration tests (233 total).
Mobile: 4 new JSON round-trip tests (47 total). `flutter analyze` clean.
