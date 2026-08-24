/**
 * V2 Phase 10 (part 1) — business tax infrastructure, SST, and e-Invoice readiness rules (spec
 * sections 53-54, 57; the master prompt's own literal Phase 10 bullet list: "business tax
 * infrastructure", "SST", "readiness rules").
 *
 * <p>Section 57's own e-Invoice readiness checklist ("Business registration, TIN, Business type,
 * Annual revenue range, Industry, SST status, Financial year") is almost entirely already covered
 * by {@code spaces.BusinessProfile} (Phase 5) — this module adds the one missing field
 * (`annualRevenue`) plus the actual readiness/mandate computation, rather than duplicating a second
 * "business tax profile" entity alongside an existing one.
 *
 * <p>SST rates ({@link SstRate}) are a global, versioned reference table — the same "never a
 * hardcoded constant" discipline {@code personaltax}'s tax_brackets/tax_years already established —
 * reused directly rather than reinvented. The SST reporting bullet (collected/payable tax for a
 * period) reuses {@code accounting}'s already-existing "SST/GST Payable" (code {@code 2020}) ledger
 * account and General Ledger report rather than a second tax-tracking mechanism: a period's
 * collected tax is simply that account's credits, and payable tax is its net balance.
 *
 * <p>The e-Invoice mandate threshold ({@link EInvoiceMandateRule}) is likewise versioned by
 * effective date — spec section 57's own explicit warning ("Do not hardcode one permanent e-Invoice
 * threshold. Use versioned rules/effective dates") turned out to be immediately relevant: the real
 * exemption threshold changed from RM500,000 to RM1,000,000 between when this phase was scoped and
 * when it was implemented.
 *
 * <p>Depends on {@code spaces} (BusinessProfile) and {@code accounting} (General Ledger for SST
 * reporting). {@code einvoice} depends on this module for readiness/TIN checks — nothing here
 * depends back on {@code einvoice}.
 */
package com.duitlah.api.businesstax;
