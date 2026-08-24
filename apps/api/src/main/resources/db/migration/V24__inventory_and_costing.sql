-- V2 Phase 8: Inventory & Costing (spec sections 46-49; the master
-- prompt's own literal Phase 8 bullet list: stock movements, product
-- inventory, weighted-average cost, COGS, ingredient costing, low-stock
-- alerts).

-- Automatic posting (accounting.AutomaticPostingService) gains two new
-- journal sources this phase -- widen Phase 6's own CHECK constraint.
ALTER TABLE journal_entries DROP CONSTRAINT journal_entries_source_type_check;
ALTER TABLE journal_entries ADD CONSTRAINT journal_entries_source_type_check CHECK (source_type IN
    ('MANUAL', 'INVOICE_ISSUED', 'INVOICE_PAYMENT', 'EXPENSE_PAYMENT', 'CREDIT_NOTE', 'INVENTORY_PURCHASE', 'INVENTORY_COGS'));

-- Section 46's own field list for Product ("cost", "tax classification",
-- "inventory tracking flag") plus this phase's own reorder-point/
-- notification-dedup fields, added to Phase 5's existing products table.
ALTER TABLE products ADD COLUMN description TEXT;
ALTER TABLE products ADD COLUMN cost NUMERIC(14, 4);
ALTER TABLE products ADD COLUMN tax_classification VARCHAR(20) NOT NULL DEFAULT 'NOT_APPLICABLE'
    CHECK (tax_classification IN ('STANDARD_RATED', 'ZERO_RATED', 'EXEMPT', 'NOT_APPLICABLE'));
ALTER TABLE products ADD COLUMN track_inventory BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE products ADD COLUMN reorder_point NUMERIC(14, 3);
-- Sends at most one low-stock notification per dip below reorder_point
-- (cleared once stock rises back above it) -- see inventory.LowStockAlertScheduler.
ALTER TABLE products ADD COLUMN low_stock_notified_at TIMESTAMPTZ;

-- Append-only (spec: "inventory quantity derives from movements... do
-- not store a manually mutable quantity as the sole source of truth").
-- quantity is signed (positive = stock in, negative = stock out) --
-- movement type alone doesn't always imply a fixed sign (a RETURN can be
-- a customer return arriving, or a return-to-supplier leaving; an
-- ADJUSTMENT can correct in either direction), the same reasoning
-- statements.ParsedStatementRow already uses for its own signed amount.
--
-- unit_cost is captured at creation time and never recalculated
-- retroactively (spec: "do not switch valuation methods historically
-- without explicit migration/accounting rules") -- for an inbound
-- movement it's the real cost paid; for an outbound movement it's the
-- Weighted Average Cost computed from history *at that moment*,
-- snapshotted so a later purchase's price never rewrites an already-
-- recorded sale's cost of goods sold.
CREATE TABLE inventory_movements (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    space_id            UUID NOT NULL REFERENCES financial_spaces(id) ON DELETE CASCADE,
    product_id          UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    type                VARCHAR(20) NOT NULL CHECK (type IN
                            ('PURCHASE', 'SALE', 'RETURN', 'ADJUSTMENT', 'TRANSFER', 'OPENING_BALANCE')),
    quantity            NUMERIC(14, 3) NOT NULL CHECK (quantity <> 0),
    unit_cost           NUMERIC(14, 4) NOT NULL,
    occurred_on         DATE NOT NULL,
    notes               VARCHAR(255),
    source_invoice_line_item_id UUID, -- set when auto-posted from an issued invoice's line item; no FK (sales owns that table)
    created_by_user_id  UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_inventory_movements_product_id ON inventory_movements(product_id);
CREATE INDEX idx_inventory_movements_space_id ON inventory_movements(space_id);

-- Ingredient/Recipe Costing (spec section 49) -- deliberately modular:
-- a product with no rows here simply has no recipe-costing data, not an
-- error. One level deep only (an ingredient's own recipe, if it has
-- one, is not recursively expanded) -- avoids graph-cycle complexity
-- for a feature the spec itself calls optional.
CREATE TABLE product_recipe_items (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id            UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    ingredient_product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    quantity_per_unit     NUMERIC(14, 4) NOT NULL CHECK (quantity_per_unit > 0),
    created_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    CHECK (product_id <> ingredient_product_id),
    UNIQUE (product_id, ingredient_product_id)
);

CREATE INDEX idx_product_recipe_items_product_id ON product_recipe_items(product_id);
