# Inventory & Costing

Implemented in **V2 Phase 8** (spec sections 46-49; the master prompt's
own literal Phase 8 "Implement:" bullet list: stock movements, product
inventory, weighted-average cost, COGS, ingredient costing, low-stock
alerts), continuing from
[reconciliation.md](reconciliation.md)'s V2 Phase 7 foundation.

## Computed-never-stored, again

Exactly like every other balance in this codebase, a product's quantity
on hand, Weighted Average Cost, and total inventory value are never
stored columns — they're derived on read by summing every
`inventory_movements` row for that product
(`InventoryValuationService.compute`). A movement's own `unit_cost` is
snapshotted once, at creation time, from whatever valuation existed at
that instant, and is never retroactively recalculated even if a later
purchase changes the average (spec section 48: "do not switch valuation
methods historically"). Because every historical outbound movement's
cost was already locked in correctly when it was created, a plain
order-independent `SUM(quantity)` / `SUM(quantity * unit_cost)` always
reproduces the correct current state — no chronological replay loop is
needed.

## Data model

- **`Product`** (extended) — gained `description`, `cost` (a reference/
  standard cost the user can set directly, distinct from the *actual*
  moving WAC), `taxClassification` (a classification label only — no
  SST/GST rate lookup or filing logic lives here; that's Phase 10's
  explicit scope), `trackInventory`, `reorderPoint`, and
  `lowStockNotifiedAt` (dedup bookkeeping for the alert scheduler).
- **`InventoryMovement`** — append-only. `type`
  (PURCHASE/SALE/RETURN/ADJUSTMENT/TRANSFER/OPENING_BALANCE), a signed
  `quantity` (positive = stock in, negative = stock out), a locked-in
  `unitCost`, and an optional `sourceInvoiceLineItemId` for the sales
  auto-posting integration below.
- **`ProductRecipeItem`** — a config table (product → ingredient product
  + quantity per unit), one level deep, entirely optional: a product
  with no recipe rows simply has no recipe cost to report.

## Automatic posting

Two new `AutomaticPostingService` methods reuse Phase 6's already-seeded
but previously-unused "Inventory" (`1030`) and "Cost of Goods Sold"
(`5000`) system ledger accounts — no new seed or migration needed for
them, just new named constants:

- **`postInventoryPurchase`** — debit Inventory, credit the paying
  business account's mapped ledger account, or Accounts Payable if
  bought on credit (no account specified).
- **`postCogs`** — debit Cost of Goods Sold, credit Inventory, for a
  sale's locked-in Weighted Average Cost.

Both are the same best-effort no-op-when-unmapped pattern every prior
automatic-posting method uses, so a space that hasn't set up its books
yet keeps using inventory tracking exactly as before.

## Recording a movement

A movement's *sign* — not its `type` — decides how `unitCost` is
determined: an inbound (positive-quantity) movement requires the caller
to supply the real cost paid (`400 UNIT_COST_REQUIRED` otherwise); an
outbound (negative-quantity) movement always has its cost computed
server-side from the current Weighted Average Cost, so a past sale's
locked-in cost can never be second-guessed by a client. Negative
resulting stock is not blocked — this phase has no warehouse/location
concept, and rejecting it would just push the same reconciliation
problem onto the user in a more confusing way than a report simply
showing a negative balance.

## Selling through an invoice

Issuing an invoice (`sales.InvoiceService.changeStatus`, DRAFT→SENT)
now also loops over that invoice's line items: for each one whose
product has `trackInventory = true`, it calls
`inventory.InventoryMovementService.recordSaleFromInvoice`, which
creates a SALE movement (unit cost = current WAC) and posts COGS.
`sourceInvoiceLineItemId` makes this idempotent per line item, so
re-issuing (or any retry) never double-counts the sale. This is the one
place `sales` depends on `inventory` rather than the other way around —
the producer here is `sales`, matching the established
producer-depends-on-recorder shape.

## Ingredient/recipe costing

Deliberately optional and one level deep (spec section 49), not
mandatory. An ingredient's own unit cost is its current Weighted
Average Cost if it's tracked in inventory, or its plain reference
`cost` field otherwise (e.g. a bulk-bought, non-tracked ingredient the
user estimates). `RecipeCostingService.cost` sums each ingredient
line's `quantityPerUnit × ingredientUnitCost` into a unit cost, then
compares it against the product's own selling price for gross margin
and gross margin percent.

## Low-stock alerts

`LowStockAlertScheduler` runs daily (`0 0 7 * * *`), the same thin
`@Scheduled` wrapper around a plain, independently-callable method
shape as `bills.PersonalBillScheduler`. For every BUSINESS space, for
every tracked product with a reorder point set, it compares the
computed quantity on hand against that reorder point and notifies every
member who can `MANAGE_PRODUCTS`
(`spaces.SpaceService.listActiveMemberUserIdsWithPermission`, a new
system-use-only method with no acting-user context, for exactly this
kind of scheduled job). `Product.lowStockNotifiedAt` is set on the first
dip below the reorder point and only cleared once stock rises back
above it, so a sustained dip sends exactly one alert rather than one
per scheduler run.

## Endpoints

`POST/GET /api/v1/spaces/{spaceId}/products/{productId}/movements`,
`GET .../valuation`; `POST/GET/DELETE
.../products/{productId}/recipe[/{itemId}]`, `GET .../recipe/cost`;
`GET /api/v1/spaces/{spaceId}/inventory/stock-valuation`, `GET
.../inventory/cogs?from=&to=`. All writes require `MANAGE_PRODUCTS`;
`CreateProductRequest` gained `description`, `cost`,
`taxClassification`, `trackInventory`, `reorderPoint`.

## Tests

`InventoryMovementFlowTests` (7 — a mapped purchase debiting Inventory
and crediting the bank account, a purchase on credit crediting Accounts
Payable, Weighted Average Cost recomputing correctly across two
purchases at different prices, a sale locking in the current WAC and
posting COGS, zero-quantity rejected, a missing unit cost on an inbound
movement rejected, cross-role 403), `RecipeCostingFlowTests` (3 —
recipe cost driving gross margin, a product rejected as its own
ingredient, removing an ingredient dropping it from the cost),
`LowStockAlertFlowTests` (2 — a dip notifies once and doesn't re-notify
on the next run, a healthy stock level is never alerted),
`InvoiceInventoryIntegrationFlowTests` (2 — issuing an invoice for a
tracked product posts a real SALE movement and COGS, re-issuing never
double-counts the sale), plus two new `ProductFlowTests` cases for the
extended product fields — 16 new integration tests (317 total) all
pass; full backend regression suite (every prior phase) reconfirmed
clean alongside them.
