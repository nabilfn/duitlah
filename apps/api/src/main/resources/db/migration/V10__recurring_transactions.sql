-- Phase 10: recurring transactions -- and, via the is_subscription flag, the
-- "Subscriptions" tracking view from the master spec (section 37). A
-- subscription is just a recurring transaction the user has flagged as one
-- (Netflix, Spotify, ...), not a separate entity or table: the amount,
-- schedule, and category machinery are identical either way, and a second
-- table would just be the same columns with a different name.
--
-- Unrelated to the `com.duitlah.api.subscriptions` Java package, which is
-- reserved for Duitlah+ premium-plan entitlements (see that package's
-- package-info.java) -- a naming collision in English, not in domain.
CREATE TABLE recurring_transactions (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id               UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    account_id            UUID NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
    type                  VARCHAR(10) NOT NULL CHECK (type IN ('INCOME', 'EXPENSE')),
    direction             VARCHAR(3) NOT NULL CHECK (direction IN ('IN', 'OUT')),
    category_id           UUID REFERENCES categories(id) ON DELETE SET NULL,
    amount                NUMERIC(14, 2) NOT NULL CHECK (amount > 0),
    merchant              VARCHAR(120),
    description           VARCHAR(255),
    notes                 TEXT,
    frequency             VARCHAR(10) NOT NULL CHECK (frequency IN ('DAILY', 'WEEKLY', 'MONTHLY', 'YEARLY')),
    interval_count        INTEGER NOT NULL DEFAULT 1 CHECK (interval_count > 0),
    start_date            DATE NOT NULL,
    end_date              DATE,
    next_occurrence_date  DATE NOT NULL,
    is_subscription       BOOLEAN NOT NULL DEFAULT false,
    active                BOOLEAN NOT NULL DEFAULT true,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    CHECK (end_date IS NULL OR end_date >= start_date)
);

CREATE INDEX idx_recurring_transactions_user_id ON recurring_transactions(user_id);
-- Partial index: only active rules are ever scanned by the daily
-- materialization job (see RecurringTransactionService#materializeAllDue).
CREATE INDEX idx_recurring_transactions_next_occurrence ON recurring_transactions(next_occurrence_date) WHERE active = true;

-- Traces a materialized transaction back to the rule that created it. This
-- is what lets the calendar/forecast views tell "already happened" (a real
-- transactions row) apart from "projected" (computed on the fly from the
-- rule, never persisted) without a second parallel data model, and lets
-- cash-flow forecasting exclude recurring-linked spend when averaging
-- "typical variable spending" so a rent payment isn't double-counted as
-- both a scheduled and a predicted expense.
ALTER TABLE transactions ADD COLUMN recurring_transaction_id UUID REFERENCES recurring_transactions(id) ON DELETE SET NULL;
CREATE INDEX idx_transactions_recurring_transaction_id ON transactions(recurring_transaction_id);
