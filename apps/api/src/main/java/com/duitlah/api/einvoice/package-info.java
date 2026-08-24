/**
 * V2 Phase 10 (part 2) — the MyInvois provider abstraction and submission workflow (spec sections
 * 55-56; the master prompt's own literal Phase 10 bullet list: "MyInvois adapter", "TIN handling",
 * "document submission", "status tracking", "validated document handling",
 * "cancellation/rejection").
 *
 * <p>Section 55 names the exact shape this module follows:
 *
 * <pre>
 * EInvoiceProvider
 *   MyInvoisProvider
 *   UnavailableEInvoiceProvider
 *   MockEInvoiceProvider // development/tests only
 * </pre>
 *
 * <p>"Production must never return fake success." {@link EInvoiceProvider} is a plain interface;
 * {@link MyInvoisProvider} is a real HTTP client against the documented MyInvois SDK endpoints
 * (OAuth2 client-credentials login, {@code POST /api/v1.0/documentsubmissions/}, {@code GET
 * /api/v1.0/documents/{uuid}/details}, {@code PUT /api/v1.0/documents/state/{uuid}/state}),
 * inactive by default until a space configures real LHDN-issued sandbox or production credentials.
 * {@link UnavailableEInvoiceProvider} is the default bean in every environment until then, and
 * always reports itself unavailable rather than fabricating a result — this is the load-bearing
 * honesty guarantee the spec's own words demand. A mock provider exists only in the test sources
 * (not shipped in {@code main}), exactly matching the "development/tests only" comment.
 *
 * <p>Section 56's workflow (Invoice → Eligibility/Required Fields → Customer TIN validation →
 * Generate payload → Submit → Pending → Validated/Invalid → Persist UID/status → QR/validated
 * document, plus cancellation/rejection) is implemented as two explicit user actions rather than
 * one — {@code prepare} (eligibility + payload readiness, reversible, no external call) and {@code
 * submit} (the actual, consequential call to LHDN) — since submission is a legally significant,
 * hard-to-reverse action a real business should be able to review before committing to. "All
 * provider interactions must be auditable": every call to a provider, successful or not, is
 * recorded in {@code einvoice_provider_logs} independent of the document's own current-state
 * columns, and every state transition is additionally recorded through the existing generic {@code
 * audit.AuditLogService} rather than a second audit mechanism.
 *
 * <p>Depends on {@code sales} (reads the {@code Invoice} being submitted — the one exception to
 * "producer depends on recorder": here {@code einvoice} depends on {@code sales}, not the reverse,
 * since submission is a distinct user-initiated action rather than an automatic side effect of
 * issuing an invoice), {@code businesstax} (the seller's TIN/SST info), {@code crm} (the buyer's
 * TIN), and {@code audit}.
 */
package com.duitlah.api.einvoice;
