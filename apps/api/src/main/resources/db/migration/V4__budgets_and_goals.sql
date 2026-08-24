-- Budgets: category_id NULL means "overall monthly budget" rather than a
-- per-category one. A plain UNIQUE(user_id, category_id, period_year,
-- period_month) would NOT stop two overall budgets for the same month —
-- SQL treats every NULL as distinct from every other NULL, so the
-- category_id IS NULL rows would never collide. Two partial unique
-- indexes (one per case) close that gap.
CREATE TABLE budgets (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id       UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    category_id   UUID REFERENCES categories(id) ON DELETE CASCADE,
    period_year   SMALLINT NOT NULL,
    period_month  SMALLINT NOT NULL CHECK (period_month BETWEEN 1 AND 12),
    amount_limit  NUMERIC(14, 2) NOT NULL CHECK (amount_limit > 0),
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX uq_budgets_overall ON budgets(user_id, period_year, period_month) WHERE category_id IS NULL;
CREATE UNIQUE INDEX uq_budgets_category ON budgets(user_id, category_id, period_year, period_month) WHERE category_id IS NOT NULL;

-- Goals follow the same "computed, never stored" balance pattern as
-- accounts (see docs/database.md): currentAmount is SUM(goal_contributions.amount)
-- for the goal, not a column on `goals` — a contribution can be negative
-- (a correction or a withdrawal), so this is a signed ledger, not a
-- one-way counter.
CREATE TABLE goals (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id        UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name           VARCHAR(120) NOT NULL,
    type           VARCHAR(20) NOT NULL CHECK (type IN ('EMERGENCY_FUND', 'TRAVEL', 'DEVICE', 'HOUSE_DEPOSIT', 'CAR', 'EDUCATION', 'WEDDING', 'CUSTOM')),
    target_amount  NUMERIC(14, 2) NOT NULL CHECK (target_amount > 0),
    target_date    DATE,
    archived_at    TIMESTAMPTZ,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_goals_user_id ON goals(user_id);

CREATE TABLE goal_contributions (
    id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    goal_id      UUID NOT NULL REFERENCES goals(id) ON DELETE CASCADE,
    user_id      UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    amount       NUMERIC(14, 2) NOT NULL CHECK (amount <> 0),
    occurred_on  DATE NOT NULL,
    note         VARCHAR(255),
    created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_goal_contributions_goal_id ON goal_contributions(goal_id);
