# Business Core

Implemented in **V2 Phase 5** (spec sections 31-33, 37-39; the master
prompt's own literal Phase 5 "Implement:" bullet list), continuing from
[personal-tax.md](personal-tax.md)'s V2 Phase 4 foundation. This is the
first phase where a Business space (created back in Phase 1) becomes a
real working workspace instead of a name and a profile record.

## Scope boundary (read this before assuming something is missing)

Sections 34-36 describe a full double-entry accounting engine (Chart of
Accounts, journal entries, General Ledger, Trial Balance, P&L, Balance
Sheet, Cash Flow) in prose *before* section 39 in the spec document, but
Phase 5's own bullet list does not include it — Phase 6's does. So this
phase deliberately has **no Chart of Accounts, no journals, no ledger
postings** anywhere. Every number a business user sees this phase
(account balances, expense/invoice status, the dashboard rollup) is
computed directly from this phase's own tables, not from a general
ledger that doesn't exist yet.

Phase 5's bullet list also has no separate "Purchases"/supplier-bill
module (unlike the broader section-31 module list). A `BusinessExpense`
with a `supplierId` set **is** the payable bill — its own
`expense_payments` ledger is the payables mechanism. A distinct
purchase-order concept is deferred.

## Real, server-enforced RBAC (section 33)

`SpaceRole` (OWNER/ADMIN/FINANCE/ACCOUNTANT/SALES/STAFF/VIEWER) has
existed since Phase 1 but was never enforced beyond membership. This
phase adds `BusinessPermission` (MANAGE_TEAM, MANAGE_CUSTOMERS,
MANAGE_SUPPLIERS, MANAGE_PRODUCTS, RECORD_EXPENSES,
MANAGE_SALES_DOCUMENTS, RECORD_PAYMENTS, MANAGE_BANKING, VIEW_REPORTS)
and a `BusinessPermissions` role→permission matrix, and
`SpaceService.requirePermission` throws a genuine `403
INSUFFICIENT_PERMISSION` — distinct from the existing 404
`requireMembership` check — when an active member's role doesn't cover
the action. This is the spec's own explicit "do not rely on hiding
buttons for authorization" demand (section 33); the mobile client hides
nothing by role, it just surfaces a 403 as an error message.

OWNER gets every permission; ADMIN gets everything except MANAGE_TEAM;
FINANCE gets suppliers/expenses/payments/banking/reports; ACCOUNTANT
gets reports only (books/tax/reconciliation permissions arrive with the
Phase 6/7 modules they gate); SALES gets customers/products/sales
documents; STAFF can record expenses; VIEWER gets nothing beyond read
access (which every active member has regardless of role). A business
space can never end up with zero owners — demoting or removing the sole
remaining OWNER is rejected with `409 LAST_OWNER`.

Team management: `GET/POST /api/v1/spaces/{spaceId}/members`,
`PATCH/DELETE /api/v1/spaces/{spaceId}/members/{memberId}`. Adding a
member is deliberately by-email-of-an-existing-account only (`404
USER_NOT_FOUND` otherwise) — there is no invite-a-stranger flow yet.

## Customers & Suppliers (`crm`)

Two separate entities/tables with an identical shape (name, contact
person, phone, email, billing address, registration number, TIN, SST
number, payment terms in days — defaults to 30, notes, ACTIVE/ARCHIVED
status) — kept structurally distinct rather than one polymorphic
"Contact" table, since a real accounting engine (Phase 6) will need to
treat receivables-from and payables-to very differently even though
today's fields happen to match. `CustomerService`/`SupplierService` each
expose a public `requireOwned` specifically so `sales`/`bizexpenses` can
validate a customer/supplier reference belongs to the same space without
a second query path.

## Products & Services (`catalog`)

Deliberately minimal — a priced catalog entry (name, SKU, GOODS/SERVICE,
unit, unit price, active flag) a quotation/invoice line item can
reference. No stock-on-hand tracking or costing; that's Phase 8's
explicit scope ("Inventory & Costing").

## Business accounts (`bizbanking`)

A business's own bank/cash/e-wallet/credit-card accounts, structurally
isolated from personal `finance.Account` (spec section 37's explicit
requirement) even though the type enum overlaps. Balance is the same
discipline as every other account in this codebase: **computed on read
as `openingBalance + SUM(signed entries)`, never stored.**
`business_account_entries` is append-only; a manual entry (adjustment)
leaves `linked_expense_payment_id`/`linked_invoice_payment_id` both
null, while a real expense/invoice payment sets exactly one of them so
the entry's origin is always traceable. A transfer between two of a
space's own accounts posts a matched OUT/IN pair sharing a
`transfer_group_id`.

## Business expenses & payables (`bizexpenses`)

`BusinessExpense.status` (UNPAID/PARTIALLY_PAID/PAID) is one of the few
status fields in this codebase that's genuinely **stored**, not
computed on read — it only ever transitions inside the same transaction
that records an `ExpensePayment`, and the migration's own CHECK
constraint enumerates the exact three states. Recording a payment also
posts a `BusinessAccountEntry` (OUT) against the chosen business
account, linked back via `linked_expense_payment_id`.

## Sales: quotations, invoices, credit notes (`sales`)

`Quotation.status` (DRAFT/SENT/ACCEPTED/DECLINED/EXPIRED) is a full
explicit workflow. `Invoice.status` is deliberately narrower —
**DRAFT/SENT/VOID only**, the three explicit actions a user takes — and
mirrors `settlements.Settlement`'s own precedent: PARTIALLY_PAID/PAID/
OVERDUE are never stored, always computed fresh in
`InvoiceService.toResponse` from `total` vs. the append-only
`invoice_payments` ledger (minus any ISSUED credit notes against that
invoice) vs. `dueDate`. The response field to actually show a user is
`effectiveStatus`, not `status`.

An ACCEPTED quotation can be converted to a brand-new DRAFT invoice
(`POST .../quotations/{id}/convert-to-invoice`, `409
QUOTATION_NOT_ACCEPTED` otherwise) — customer, tax rate, and every line
item copy over, and the invoice keeps a `convertedFromQuotationId` back
pointer. Quote/invoice/credit-note numbers are server-generated and
sequential per space (`Q-00001`, `INV-00001`, `CN-00001`), not
client-supplied, so there's no collision risk across concurrent
creators. A credit note against an invoice reduces that invoice's
computed `amountOutstanding`; voiding the credit note un-does that
without touching the invoice itself. A VOID invoice rejects new
payments outright (`409 INVOICE_VOID`).

## Business dashboard (`bizdashboard`)

A read-only rollup — cash position (sum of non-archived MYR business
account balances, same currency-scoping discipline as
`finance.AccountService.totalAvailableBalance`), total receivables (sum
of `amountOutstanding` across invoices whose `effectiveStatus` is
SENT/PARTIALLY_PAID/OVERDUE), total payables (sum of `amountRemaining`
across non-PAID expenses), and entity counts. Nothing here is stored;
every number is recomputed from the owning module's own service on each
request — there is no separate "dashboard cache" table to keep in sync.

## Endpoints

`GET/POST /api/v1/spaces/{spaceId}/members`,
`PATCH/DELETE .../members/{memberId}`; `POST/GET/PUT/DELETE
.../customers[/{id}]` and identical routes under `.../suppliers`;
`POST/GET/PUT/DELETE .../products[/{id}]`; `POST/GET/PATCH
.../business-accounts[/{id}]`, `GET/POST .../business-accounts/{id}/entries`,
`POST .../business-accounts/{id}/transfer`; `POST/GET .../expenses[/{id}]`,
`GET/POST .../expenses/{id}/payments`; `POST/GET/PATCH
.../quotations[/{id}][/status]`, `POST .../quotations/{id}/convert-to-invoice`;
`POST/GET/PATCH .../invoices[/{id}][/status]`, `GET/POST
.../invoices/{id}/payments`; `POST/GET .../credit-notes[/{id}]`,
`POST .../credit-notes/{id}/void`; `GET .../business-dashboard`.

## Mobile

A new `business` feature module (customers, suppliers, products,
business accounts + entries + transfers, expenses + payments,
quotations + convert-to-invoice, invoices + payments + credit notes,
and the dashboard hub), plus team management added to the existing
`spaces` feature. The Workspaces screen's business-space card now opens
the Business Dashboard directly (previously it opened only the Business
Profile screen, since there was no real business data behind a
dashboard until this phase). No client-side permission hiding — a 403
from the server surfaces as a plain error message, per section 33.

## Tests

Backend: `BusinessTeamFlowTests` (5, including a real cross-role 403 and
the LAST_OWNER guard), `CustomerFlowTests` (5), `SupplierFlowTests` (3),
`ProductFlowTests` (3), `BusinessAccountFlowTests` (5, including a real
computed-balance-after-transfer check), `BusinessExpenseFlowTests` (5,
including the UNPAID→PARTIALLY_PAID→PAID transition and the ledger
entry it posts), `QuotationFlowTests` (4, including the
QUOTATION_NOT_ACCEPTED conversion guard), `InvoiceFlowTests` (6,
including a hand-verified OVERDUE computation and the INVOICE_VOID
payment guard), `CreditNoteFlowTests` (3), `BusinessDashboardFlowTests`
(2) — 41 new integration tests. Mobile: JSON round-trip tests for the
new domain models. `flutter analyze` clean.
