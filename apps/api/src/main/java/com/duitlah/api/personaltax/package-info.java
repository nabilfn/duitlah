/**
 * The Malaysian Personal Tax Centre (V2 Phase 4, spec sections 25-30) — a tax-preparation and
 * estimation system, not an LHDN filing integration. Every calculation is deterministic ({@link
 * com.duitlah.api.personaltax.PersonalTaxCalculationService} — no model call anywhere in it, the
 * same discipline as {@code finhealth.FinancialHealthService}/{@code ai.AffordabilityService}) and
 * versioned by Year of Assessment ({@link com.duitlah.api.personaltax.TaxYear}/{@link
 * com.duitlah.api.personaltax.TaxBracket}/{@link com.duitlah.api.personaltax.TaxReliefRule}/{@link
 * com.duitlah.api.personaltax.TaxRebateRule}) — a stale or wrong rate is a data correction (a
 * new/updated {@code tax_years} row), never a code change, and never something that silently
 * invalidates an already-computed prior year's result.
 *
 * <p><b>Honesty note</b> (see {@code V20__seed_tax_years.sql}'s own header): the seeded YA2024-
 * YA2026 brackets/relief ceilings reflect the assistant's general knowledge of the published LHDN
 * structure, not a live feed or an official dataset. Every response from this module carries an
 * explicit disclaimer that it is an estimate and that official LHDN filing remains the taxpayer's
 * responsibility (spec section 29) — this module must never claim to replace it.
 *
 * <p>{@link com.duitlah.api.personaltax.TaxReliefCandidate} implements the spec's own pipeline
 * (section 27): a Receipt Vault upload tagged {@code TAX_EVIDENCE} with a real parsed total becomes
 * a candidate automatically ({@code receipts.ReceiptVaultService} depends on this module for that
 * one call, the same "producer depends on recorder" shape {@code autotrack} already established) —
 * never a fabricated merchant-category guess. A candidate never becomes a confirmed relief on its
 * own; {@link com.duitlah.api.personaltax.TaxReliefCandidateService#confirm} always requires an
 * explicit user action.
 */
package com.duitlah.api.personaltax;
