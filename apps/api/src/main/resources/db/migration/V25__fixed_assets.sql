-- V2 Phase 9: Fixed Assets (spec section 50; the master prompt's own
-- literal Phase 9 bullet list: asset register, depreciation, disposal,
-- journal generation).

-- Automatic posting (accounting.AutomaticPostingService) gains three new
-- journal sources this phase -- widen the CHECK constraint again.
ALTER TABLE journal_entries DROP CONSTRAINT journal_entries_source_type_check;
ALTER TABLE journal_entries ADD CONSTRAINT journal_entries_source_type_check CHECK (source_type IN
    ('MANUAL', 'INVOICE_ISSUED', 'INVOICE_PAYMENT', 'EXPENSE_PAYMENT', 'CREDIT_NOTE', 'INVENTORY_PURCHASE', 'INVENTORY_COGS',
     'ASSET_ACQUIRED', 'ASSET_DEPRECIATION', 'ASSET_DISPOSAL'));

CREATE TABLE fixed_assets (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    space_id            UUID NOT NULL REFERENCES financial_spaces(id) ON DELETE CASCADE,
    name                VARCHAR(255) NOT NULL,
    category            VARCHAR(100),
    acquisition_date    DATE NOT NULL,
    cost                NUMERIC(14, 2) NOT NULL CHECK (cost > 0),
    salvage_value       NUMERIC(14, 2) NOT NULL DEFAULT 0 CHECK (salvage_value >= 0),
    useful_life_months  INT NOT NULL CHECK (useful_life_months > 0),
    depreciation_method VARCHAR(30) NOT NULL CHECK (depreciation_method IN
                            ('STRAIGHT_LINE', 'DOUBLE_DECLINING_BALANCE')),
    status              VARCHAR(20) NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'DISPOSED')),
    disposed_on         DATE,
    disposal_proceeds   NUMERIC(14, 2),
    created_by_user_id  UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    CHECK (salvage_value <= cost)
);
CREATE INDEX idx_fixed_assets_space_id ON fixed_assets(space_id);

-- Append-only -- see package-info. Accumulated depreciation is never a
-- stored column; it is always SUM(amount) over an asset's entries, the
-- same computed-never-stored discipline as inventory_movements/journal_lines.
CREATE TABLE asset_depreciation_entries (
    id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    asset_id           UUID NOT NULL REFERENCES fixed_assets(id) ON DELETE CASCADE,
    space_id           UUID NOT NULL REFERENCES financial_spaces(id) ON DELETE CASCADE,
    period              DATE NOT NULL,
    amount             NUMERIC(14, 2) NOT NULL CHECK (amount > 0),
    created_by_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (asset_id, period)
);
CREATE INDEX idx_asset_depreciation_entries_asset_id ON asset_depreciation_entries(asset_id);
