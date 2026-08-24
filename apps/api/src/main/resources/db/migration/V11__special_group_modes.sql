-- Phase 11: Special Group Modes (Trip, Housemate, Couple, Shared Goals).
--
-- `category` is an optional label on a group expense, shared across every
-- group type rather than gated to "only HOUSEMATES may use RENT" -- the
-- Housemate/Trip dashboards below simply read whichever categories exist
-- for a given group; there's no real harm in a FRIENDS group tagging an
-- expense GROCERIES, so no extra validation exists to prevent it.
ALTER TABLE group_expenses ADD COLUMN category VARCHAR(20)
  CHECK (category IN (
    'RENT', 'ELECTRICITY', 'WATER', 'INTERNET', 'GROCERIES', 'CLEANING',
    'HOUSEHOLD', 'STREAMING',
    'FLIGHTS', 'ACCOMMODATION', 'FOOD', 'TRANSPORT', 'ACTIVITIES', 'SHOPPING',
    'OTHER'
  ));

-- Trip mode multi-currency (product spec section 32: "multi-currency,
-- exchange-rate snapshots"). This is an entry-time snapshot for display
-- only, never a live-converted ledger: `amount` above always remains the
-- MYR-equivalent figure every existing balance/settlement computation
-- already relies on unchanged. A client may optionally record what the
-- payer actually saw at time of entry ("Y1,800 at 0.0305") without any of
-- that flowing back into real money math.
ALTER TABLE group_expenses ADD COLUMN original_currency VARCHAR(3);
ALTER TABLE group_expenses ADD COLUMN original_amount NUMERIC(14, 2);
ALTER TABLE group_expenses ADD COLUMN exchange_rate NUMERIC(12, 6);

-- Trip mode's single overall budget (spec: "Budget RM12,000 / Spent
-- RM8,920 / Remaining RM3,080"). Deliberately not the existing `budgets`
-- table -- that's a monthly-recurring-per-category model (Phase 4); a trip
-- has no month/period, just one flat target for the group's lifetime.
-- `spent` is always SUM(group_expenses.amount) for the group, computed on
-- read like every other balance in this schema, never stored here.
CREATE TABLE group_budgets (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    group_id            UUID NOT NULL UNIQUE REFERENCES groups(id) ON DELETE CASCADE,
    amount              NUMERIC(14, 2) NOT NULL CHECK (amount > 0),
    created_by_user_id  UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Shared goals (spec section 27): a group's own goal, contributed to by
-- multiple members -- the group-scoped counterpart to Phase 4's personal
-- `goals`/`goal_contributions`, same "current amount is SUM(contributions),
-- never stored" rule, same signed-ledger shape (a negative contribution is
-- a correction/withdrawal, never an edit).
CREATE TABLE group_goals (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    group_id            UUID NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
    name                VARCHAR(120) NOT NULL,
    target_amount       NUMERIC(14, 2) NOT NULL CHECK (target_amount > 0),
    target_date         DATE,
    created_by_user_id  UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    archived_at         TIMESTAMPTZ,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_group_goals_group_id ON group_goals(group_id);

CREATE TABLE group_goal_contributions (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    group_goal_id  UUID NOT NULL REFERENCES group_goals(id) ON DELETE CASCADE,
    user_id        UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    amount         NUMERIC(14, 2) NOT NULL CHECK (amount <> 0),
    occurred_on    DATE NOT NULL,
    note           VARCHAR(255),
    created_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_group_goal_contributions_goal_id ON group_goal_contributions(group_goal_id);
