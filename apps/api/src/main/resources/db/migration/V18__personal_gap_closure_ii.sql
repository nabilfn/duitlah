-- V2 Phase 3 (Personal Gap Closure II): Bills, Loans/BNPL/Credit Card
-- liabilities, Net Worth, Financial Health Score, custom budget cycles,
-- multi-currency transactions, and in-app notifications. See
-- docs/personal-gap-closure-ii.md for the full design reasoning.
--
-- Table named `personal_bills` (not `bills`) -- `bills` already belongs to
-- Bagilah's own split-receipt feature since V6, an entirely different
-- domain. Naming collision avoided deliberately, not by accident.

CREATE TABLE personal_bills (
    id                       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id                  UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    space_id                 UUID NOT NULL REFERENCES financial_spaces(id) ON DELETE CASCADE,
    name                     VARCHAR(120) NOT NULL,
    provider                 VARCHAR(120),
    due_date                 DATE NOT NULL,
    expected_amount          NUMERIC(14, 2) NOT NULL CHECK (expected_amount > 0),
    recurrence               VARCHAR(20) NOT NULL DEFAULT 'NONE'
                                 CHECK (recurrence IN ('NONE', 'WEEKLY', 'MONTHLY', 'YEARLY')),
    recurring_transaction_id UUID REFERENCES recurring_transactions(id) ON DELETE SET NULL,
    status                   VARCHAR(20) NOT NULL DEFAULT 'UPCOMING'
                                 CHECK (status IN ('UPCOMING', 'DUE', 'PAID', 'OVERDUE', 'SKIPPED')),
    linked_transaction_id    UUID REFERENCES transactions(id) ON DELETE SET NULL,
    receipt_id               UUID REFERENCES receipts(id) ON DELETE SET NULL,
    notes                    TEXT,
    created_at               TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at               TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_personal_bills_user_id_status ON personal_bills(user_id, status);
CREATE INDEX idx_personal_bills_user_id_due_date ON personal_bills(user_id, due_date);

CREATE TABLE credit_card_details (
    id                       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    account_id               UUID NOT NULL UNIQUE REFERENCES accounts(id) ON DELETE CASCADE,
    credit_limit             NUMERIC(14, 2) NOT NULL CHECK (credit_limit > 0),
    statement_day            SMALLINT NOT NULL CHECK (statement_day BETWEEN 1 AND 28),
    payment_due_day          SMALLINT NOT NULL CHECK (payment_due_day BETWEEN 1 AND 28),
    minimum_payment_percent  NUMERIC(4, 2) NOT NULL DEFAULT 5.00 CHECK (minimum_payment_percent > 0),
    created_at               TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at               TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE liabilities (
    id                     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id                UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    space_id               UUID NOT NULL REFERENCES financial_spaces(id) ON DELETE CASCADE,
    type                   VARCHAR(20) NOT NULL CHECK (type IN
                               ('PERSONAL_LOAN', 'CAR_LOAN', 'HOUSING_LOAN', 'EDUCATION_LOAN',
                                'PTPTN', 'BNPL', 'OTHER')),
    name                   VARCHAR(120) NOT NULL,
    lender                 VARCHAR(120),
    original_amount        NUMERIC(14, 2) NOT NULL CHECK (original_amount > 0),
    interest_rate_percent  NUMERIC(5, 2),
    instalment_amount      NUMERIC(14, 2),
    next_due_date          DATE,
    maturity_date          DATE,
    status                 VARCHAR(20) NOT NULL DEFAULT 'ACTIVE'
                               CHECK (status IN ('ACTIVE', 'PAID_OFF', 'DEFAULTED')),
    created_at             TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at             TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_liabilities_user_id ON liabilities(user_id);

-- Append-only, same discipline as goal_contributions/settlement_payments.
-- Outstanding principal is computed (original_amount minus the sum of
-- principal_portion here), never stored -- the same "computed, never
-- stored" rule as account balance and goal progress.
CREATE TABLE liability_payments (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    liability_id          UUID NOT NULL REFERENCES liabilities(id) ON DELETE CASCADE,
    amount                NUMERIC(14, 2) NOT NULL CHECK (amount > 0),
    principal_portion     NUMERIC(14, 2) NOT NULL CHECK (principal_portion >= 0),
    interest_portion      NUMERIC(14, 2) NOT NULL DEFAULT 0 CHECK (interest_portion >= 0),
    paid_on               DATE NOT NULL,
    linked_transaction_id UUID REFERENCES transactions(id) ON DELETE SET NULL,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_liability_payments_liability_id ON liability_payments(liability_id);

-- Manually-entered assets Net Worth needs but `accounts` doesn't cover
-- (property, vehicles) -- accounts already covers cash/bank/e-wallet/
-- investment/savings.
CREATE TABLE other_assets (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    space_id        UUID NOT NULL REFERENCES financial_spaces(id) ON DELETE CASCADE,
    type            VARCHAR(20) NOT NULL CHECK (type IN ('PROPERTY', 'VEHICLE', 'OTHER')),
    name            VARCHAR(120) NOT NULL,
    estimated_value NUMERIC(14, 2) NOT NULL CHECK (estimated_value >= 0),
    notes           TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_other_assets_user_id ON other_assets(user_id);

-- Optional historical trend (spec: "may be generated") -- written only
-- when a user explicitly asks for a snapshot, never on a background
-- schedule; one row per user per day.
CREATE TABLE net_worth_snapshots (
    id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id           UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    space_id          UUID NOT NULL REFERENCES financial_spaces(id) ON DELETE CASCADE,
    total_assets      NUMERIC(16, 2) NOT NULL,
    total_liabilities NUMERIC(16, 2) NOT NULL,
    net_worth         NUMERIC(16, 2) NOT NULL,
    snapshot_date     DATE NOT NULL,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (user_id, snapshot_date)
);

-- The real notification architecture (spec section 24) replacing the
-- Phase 9.5 placeholder screen. In-app only for now -- see
-- docs/personal-gap-closure-ii.md for why Push isn't wired up here.
CREATE TABLE notification_records (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id    UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    type       VARCHAR(40) NOT NULL,
    title      VARCHAR(160) NOT NULL,
    body       TEXT NOT NULL,
    read_at    TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_notification_records_user_id ON notification_records(user_id);

-- Custom budget cycles (spec section 21). Existing calendar-month budgets
-- are untouched: cycle_type defaults to CALENDAR_MONTH and
-- period_start_date/period_end_date stay NULL for them, so period_year/
-- period_month remain fully authoritative for every budget created before
-- this migration and every calendar-month budget created after it.
ALTER TABLE budgets ADD COLUMN cycle_type VARCHAR(20) NOT NULL DEFAULT 'CALENDAR_MONTH'
    CHECK (cycle_type IN ('CALENDAR_MONTH', 'PAYDAY', 'CUSTOM'));
ALTER TABLE budgets ADD COLUMN period_start_date DATE;
ALTER TABLE budgets ADD COLUMN period_end_date DATE;

-- Multi-currency (spec section 22): a display snapshot generalized from
-- Trip mode's group_expenses columns (V11) to personal transactions
-- directly. `amount`/`transactions.currency-via-account` remain the real
-- figure every balance/report computation uses -- these four columns are
-- metadata captured once at creation time and never recomputed, so a
-- historical report never silently changes when exchange rates move.
ALTER TABLE transactions ADD COLUMN original_currency VARCHAR(3) CHECK (original_currency ~ '^[A-Z]{3}$');
ALTER TABLE transactions ADD COLUMN original_amount NUMERIC(14, 2) CHECK (original_amount IS NULL OR original_amount > 0);
ALTER TABLE transactions ADD COLUMN exchange_rate NUMERIC(14, 6) CHECK (exchange_rate IS NULL OR exchange_rate > 0);
ALTER TABLE transactions ADD COLUMN converted_at TIMESTAMPTZ;
