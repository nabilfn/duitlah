/**
 * Inventory & Costing (V2 Phase 8, spec sections 46-49; the master prompt's own literal "stock
 * movements, product inventory, weighted-average cost, COGS, ingredient costing, low-stock alerts"
 * bullet list).
 *
 * <p>Stock quantity is never a stored, manually-mutable column — it's always computed by replaying
 * a product's {@link com.duitlah.api.inventory.InventoryMovement} history (append-only, the same
 * discipline as every other ledger in this codebase). Weighted Average Cost is computed the same
 * way: {@link com.duitlah.api.inventory.InventoryValuationService} replays movements in order,
 * updating a running (quantity, value) pair as each inbound movement arrives. Crucially, an
 * *outbound* movement's own {@code unit_cost} is snapshotted at the moment it's created — it is
 * never recalculated retroactively, satisfying the spec's explicit "do not switch valuation methods
 * historically" instruction: a later purchase at a different price can never rewrite an
 * already-recorded sale's cost of goods sold.
 *
 * <p>Dependency shape: this module depends on {@code catalog} (products), {@code accounting}
 * (posting Inventory/COGS journal entries — a best-effort enhancement exactly like {@code
 * bizexpenses}/{@code sales}'s own automatic posting, never a hard requirement), {@code spaces}
 * (permissions and the low-stock scheduler's notification targets), and {@code notifications}. The
 * one exception to the usual one-directional shape: {@code sales.InvoiceService} calls into this
 * module (not the reverse) when an invoice is issued, to post a {@code SALE} movement for each
 * tracked-inventory line item — the same "producer depends on recorder" relationship {@code
 * receipts} has with {@code personaltax}.
 *
 * <p>Ingredient/recipe costing ({@link com.duitlah.api.inventory.RecipeCostingService}) is
 * deliberately modular (spec: "not mandatory for every business") — a product with no recipe items
 * simply has no recipe-costing data, not an error — and one level deep only: an ingredient's own
 * recipe (if it has one) is not recursively expanded, avoiding graph-cycle complexity for a feature
 * the spec itself calls optional. It computes cost only; it does not deduct ingredient stock when
 * the finished product is sold (that would be a manufacturing/production feature the spec doesn't
 * ask for).
 */
package com.duitlah.api.inventory;
