-- V2 Phase 13: Advanced Automation (the master prompt's own literal
-- Phase 13 bullet list: recurring invoices, transaction rules,
-- automatic categorization, Smart Capture improvements,
-- statement-learning, receipt automation, intelligent reconciliation,
-- notification rules).

-- Transaction rules (also the mechanism behind "automatic
-- categorization" and "statement-learning" -- see docs/advanced-automation.md).
-- A rule is either explicitly authored by the user, or auto-learned
-- (learned = TRUE) the moment they confirm an AutoTrack candidate with a
-- category -- always visible and editable either way, never a hidden
-- model.
CREATE TABLE transaction_rules (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id       UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    match_type    VARCHAR(20) NOT NULL CHECK (match_type IN ('MERCHANT_EQUALS', 'MERCHANT_CONTAINS')),
    match_value   VARCHAR(255) NOT NULL,
    category_id   UUID NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    priority      INTEGER NOT NULL DEFAULT 0,
    active        BOOLEAN NOT NULL DEFAULT TRUE,
    learned       BOOLEAN NOT NULL DEFAULT FALSE,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_transaction_rules_user_id ON transaction_rules(user_id);
-- One learned rule per (user, exact merchant) -- reinforced (updated), never duplicated.
CREATE UNIQUE INDEX uq_transaction_rules_learned_merchant
    ON transaction_rules(user_id, match_value)
    WHERE learned = TRUE AND match_type = 'MERCHANT_EQUALS';

-- Recurring invoices -- the sales-module mirror of recurring.RecurringTransaction's
-- schedule shape, reusing recurring.RecurrenceFrequency/RecurrenceCalculator directly
-- (both already public module surface, no reason to duplicate them).
CREATE TABLE recurring_invoices (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    space_id              UUID NOT NULL REFERENCES financial_spaces(id) ON DELETE CASCADE,
    customer_id           UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
    created_by_user_id    UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    tax_percent           NUMERIC(5, 2) NOT NULL DEFAULT 0,
    notes                 VARCHAR(1000),
    payment_term_days     INTEGER NOT NULL DEFAULT 30,
    frequency             VARCHAR(10) NOT NULL CHECK (frequency IN ('DAILY', 'WEEKLY', 'MONTHLY', 'YEARLY')),
    interval_count        INTEGER NOT NULL DEFAULT 1,
    start_date            DATE NOT NULL,
    end_date              DATE,
    next_occurrence_date  DATE NOT NULL,
    active                BOOLEAN NOT NULL DEFAULT TRUE,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at            TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_recurring_invoices_space_id ON recurring_invoices(space_id);
-- Global (not space-scoped), same "one daily sweep across every rule" shape as
-- recurring_transactions.next_occurrence_date.
CREATE INDEX idx_recurring_invoices_next_occurrence_date ON recurring_invoices(next_occurrence_date)
    WHERE active = TRUE;

CREATE TABLE recurring_invoice_line_items (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    recurring_invoice_id  UUID NOT NULL REFERENCES recurring_invoices(id) ON DELETE CASCADE,
    product_id            UUID REFERENCES products(id) ON DELETE SET NULL,
    description           VARCHAR(255) NOT NULL,
    quantity              NUMERIC(14, 3) NOT NULL CHECK (quantity > 0),
    unit_price            NUMERIC(14, 2) NOT NULL CHECK (unit_price >= 0),
    sort_order            INTEGER NOT NULL DEFAULT 0
);
CREATE INDEX idx_recurring_invoice_line_items_recurring_invoice_id
    ON recurring_invoice_line_items(recurring_invoice_id);

-- Every real Invoice materialized by a recurring schedule points back at the rule that
-- produced it -- the same "source_*_id" precedent as invoices.converted_from_quotation_id.
ALTER TABLE invoices ADD COLUMN source_recurring_invoice_id UUID
    REFERENCES recurring_invoices(id) ON DELETE SET NULL;

-- Notification rules -- per-user, per-type enable/disable plus an optional threshold
-- (only meaningful for LOW_BALANCE). Absence of a row means the default for that type
-- (see NotificationRuleService) -- the same "no row means the default" precedent as
-- subscriptions.user_subscriptions and group_budgets.
CREATE TABLE notification_rules (
    id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id            UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    type               VARCHAR(20) NOT NULL CHECK (type IN
                            ('BILL_DUE_SOON', 'BILL_OVERDUE', 'LOW_STOCK_ALERT', 'BUDGET_EXCEEDED', 'LOW_BALANCE')),
    enabled            BOOLEAN NOT NULL DEFAULT TRUE,
    threshold_amount   NUMERIC(14, 2),
    last_triggered_at  TIMESTAMPTZ,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (user_id, type)
);

-- Dedup for the new BUDGET_EXCEEDED trigger -- the exact same "notified, then cleared once
-- the condition resolves" pattern as catalog.products.low_stock_notified_at.
ALTER TABLE budgets ADD COLUMN budget_exceeded_notified_at TIMESTAMPTZ;

-- Smart Capture improvement: the Receipt Vault gains the same overall_confidence column
-- receipt_scans already has, so a server-computed "needs review" signal (see
-- ReceiptResponse.needsReview) can be consistent across both OCR entry points instead of
-- each client guessing its own threshold.
ALTER TABLE receipts ADD COLUMN overall_confidence DOUBLE PRECISION;
