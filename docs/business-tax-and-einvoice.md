# Business Tax & e-Invoice (LHDN / MyInvois / SST)

Implemented in **V2 Phase 10** (spec sections 53-57; the master prompt's
own literal Phase 10 "Implement:" bullet list: business tax
infrastructure, SST, MyInvois adapter, TIN handling, document
submission, status tracking, validated document handling,
cancellation/rejection, readiness rules), continuing from
[fixed-assets.md](fixed-assets.md)'s V2 Phase 9 foundation.

## What was researched, and why that matters here

Spec section 57 says outright: "Do not hardcode one permanent
e-Invoice threshold. Use versioned rules/effective dates." Section 56
adds: "Use current official LHDN specifications at implementation
time. Do not rely on outdated hardcoded assumptions." Both were taken
literally: the real API surface, endpoint paths, and current SST/
e-Invoice rules below came from a live web search and fetch against
the official MyInvois SDK site (`sdk.myinvois.hasil.gov.my`) and
public regulatory-tracking sources performed at implementation time
(August 2026), not from general training knowledge. That research
immediately validated the warning — the real e-Invoice exemption
threshold changed from RM500,000 to RM1,000,000 between when this
project was scoped and when this phase was implemented. Every figure
below still carries the same honesty posture as `personaltax`'s tax
brackets: verify against the current official source before relying on
it for a real filing or submission — see the seed migration's own
header comment for the exact sources consulted.

## Two modules

- **`businesstax`** — business tax infrastructure, SST, and e-Invoice
  readiness rules (sections 53-54, 57). Almost entirely built on top of
  `spaces.BusinessProfile` (Phase 5), which already carried `tin`,
  `registrationNumber`, `sstNumber`, `businessType`, `industry`, and
  `financialYearStart`/`End` — section 57's onboarding checklist was
  already satisfied except for one field, `annualRevenue`, added this
  phase. `BusinessProfile` also gained its first update endpoint (`PUT
  /business-profile`) — Phase 5 only ever let it be set once, at
  space-creation time.
- **`einvoice`** — the MyInvois provider abstraction and submission
  workflow (sections 55-56).

## Reuse over reinvention

- **SST reporting** (collected/payable tax for a period) reuses
  `accounting`'s existing "SST/GST Payable" (code `2020`) ledger
  account and General Ledger report rather than a second tax-tracking
  mechanism: a period's collected tax is simply that account's
  credits, and payable tax is its net balance.
- **Business identity** (TIN, registration number, SST number) is read
  from `spaces.BusinessProfile` and `crm.Customer` — both already had
  every field this phase needed; nothing was duplicated onto a second
  "business tax profile" entity.
- **Contra-account and loss representation** needed no schema changes
  in Phase 9's accounting engine and needs none here either — the same
  applies to how a credited/debited standard account type already
  produces the right signed number for anything unusual.

## SST (spec section 54)

`SstRate` is a global, versioned reference table — the same discipline
`personaltax`'s tax_brackets/tax_years already established. Only the
two headline/standard rates are seeded (Sales Tax 10%, Service Tax
8%); Malaysia's SST also has documented reduced-rate categories (5%
sales tax for certain goods; 6% service tax for food & beverage,
telecommunications, logistics, parking, construction, healthcare, and
education) that this phase deliberately does not attempt to classify
automatically — the same "label, not a computed rate lookup" scope
boundary `catalog.TaxClassification` drew for itself in Phase 8. Spec
section 54 also says explicitly: "Do not assume every business is SST
registered" — `sstNumber` being unset is a valid, unflagged state, not
a readiness gap.

## e-Invoice readiness (spec section 57)

`EInvoiceReadinessService` evaluates a space's `BusinessProfile`
against section 57's own checklist (business registration, TIN,
business type, annual revenue, industry, financial year) and the
versioned `EInvoiceMandateRule` table — the real phased LHDN rollout,
each row being the minimum annual revenue, as of its effective date,
above which e-Invoicing is mandatory. `mandated` and the list of
`missingFields` are both computed fresh on every call, never cached.

## The MyInvois provider abstraction (spec section 55)

Section 55 names the exact shape this follows:

```text
EInvoiceProvider
  MyInvoisProvider
  UnavailableEInvoiceProvider
  MockEInvoiceProvider // development/tests only
```

"Production must never return fake success." `UnavailableEInvoiceProvider`
is the default bean in every environment (including this one) until a
space configures real LHDN-issued credentials
(`duitlah.myinvois.enabled=true` plus a real `client-id`/`client-secret`)
— every one of its methods throws a clear `503
EINVOICE_PROVIDER_UNAVAILABLE` rather than fabricating a submission, a
valid status, or a successful cancellation. `MyInvoisProvider` is a
real HTTP client against the documented endpoints (confirmed via the
research above):

- `POST {identityUrl}/connect/token` — OAuth2 client-credentials login,
  form-encoded, `grant_type=client_credentials`, token cached for its
  documented one-hour validity.
- `POST {baseUrl}/api/v1.0/documentsubmissions/` — submit.
- `GET {baseUrl}/api/v1.0/documents/{uuid}/details` — status.
- `PUT {baseUrl}/api/v1.0/documents/state/{uuid}/state` — cancel/reject
  (`{"status": "cancelled"|"rejected", "reason": "..."}`).

`baseUrl`/`identityUrl` default to the real documented sandbox hosts
(`preprod-api.myinvois.hasil.gov.my` / `preprod-identity.myinvois.hasil.gov.my`)
so a space only needs real credentials to go live against the sandbox;
pointing both at the production hosts goes live for real.

**Scope boundary, stated plainly (matches this codebase's honesty
discipline, not a shortcut hidden from view):** LHDN requires every
submitted document to carry a digital signature over its canonical
content, produced with the business's own LHDN-issued certificate.
That certificate-based signing step is not implemented —
`MyInvoisProvider` computes a real SHA-256 `documentHash` (the field
the API genuinely expects) but submits the plain, unsigned JSON as the
`document` field. A real go-live submission against LHDN would be
rejected for a missing signature until a business supplies their real
certificate and that signing step is added (typically
`java.security.Signature`/`KeyStore` over a PKCS#12 file). Every other
piece — authentication, and every endpoint's request/response shape
and error handling — is real and matches the documented API surface.

`MockEInvoiceProvider` lives only in `src/test/java` (never shipped
under `src/main`), imported via a `@TestConfiguration`
(`MockEInvoiceConfiguration`) the same explicit-`@Import` idiom
`TestcontainersConfiguration` already uses — only the test classes that
need the full submit-to-VALID happy path import it; every other test
exercises the real default `UnavailableEInvoiceProvider`.

## The workflow (spec section 56)

Split into two explicit user actions rather than one continuous
pipeline, since submission is a legally significant, hard-to-reverse
action a business should be able to review before committing to:

1. **Prepare** (`POST .../einvoice/prepare`) — eligibility (invoice
   must be issued/`SENT`) and TIN validation (`400
   EINVOICE_SELLER_TIN_MISSING`/`EINVOICE_BUYER_TIN_MISSING`), no
   external call. Creates the `EInvoiceDocument` row at `READY`.
2. **Submit** (`POST .../einvoice/submit`) — generates the payload and
   calls the provider; `SUBMITTED` with `submissionUid`/`documentUuid`
   on success.
3. **Sync status** (`POST .../einvoice/sync-status`) — pulls the real
   current status; `VALID` (with `longId`) or `INVALID` (with a
   reason). Pull-based, matching how `statements`/`reconciliation`
   import is also pull- rather than webhook-driven.
4. **Cancel/Reject** (`POST .../einvoice/cancel` /`.../reject`) — only
   from `VALID`, and only within the real documented 72-hour window
   from validation (`409 EINVOICE_WINDOW_EXPIRED` after that — issue a
   credit note instead, reusing Phase 5's existing `sales.CreditNoteService`).

"All provider interactions must be auditable": every call — successful
or not — is recorded in `einvoice_provider_logs`, independent of the
document's own current-state columns, plus every real state transition
is recorded through the existing generic `audit.AuditLogService`
(five new `AuditAction` values) rather than a second audit mechanism.

## Endpoints

`GET /api/v1/spaces/{spaceId}/business-tax/{sst-rates,sst-report,einvoice-readiness}`;
`GET/PUT /api/v1/spaces/{spaceId}/business-profile`; `POST
/api/v1/spaces/{spaceId}/invoices/{invoiceId}/einvoice/{prepare,submit,sync-status,cancel,reject}`,
`GET .../einvoice[/logs]`. e-Invoice writes require `MANAGE_SALES_DOCUMENTS`
(the same permission Phase 5 already gates invoice actions with);
business-tax/profile writes require `MANAGE_BOOKS`.

## Tests

`EInvoiceReadinessFlowTests` (6 — a fresh profile missing every field,
completing every field making it ready and correctly mandated against
the real threshold, below-threshold revenue not mandated, seeded SST
rates, a zero SST report with no chart of accounts, and a real issued
invoice's tax showing up in the report), `EInvoiceWorkflowFlowTests`
(4, against `MockEInvoiceProvider` — the full prepare→submit→sync→
VALID→cancel happy path with provider-log verification, an INVALID
status persisting its reason, cancelling after the 72-hour window
rejected, rejecting a not-yet-valid document rejected),
`EInvoiceUnavailableFlowTests` (4, against the real default
`UnavailableEInvoiceProvider` — submission fails honestly rather than
faking success, a draft invoice can't be prepared, a customer without
a TIN blocks preparation, a business without a TIN blocks preparation)
— 14 new integration tests, all pass; full backend regression suite
(every prior phase) reconfirmed clean alongside them.
