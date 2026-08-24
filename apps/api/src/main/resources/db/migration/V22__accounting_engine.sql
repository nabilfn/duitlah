-- V2 Phase 6: Business Accounting Engine (spec sections 34-36).
--
-- Double-entry is non-negotiable (section 34): every journal_entries row
-- must have journal_lines whose DEBITs equal their CREDITs. That invariant
-- is enforced twice, deliberately — once here at the database level (a
-- deferred constraint trigger, since "the debits for this whole entry sum
-- to its credits" is a cross-row check no plain CHECK constraint can
-- express), and again in JournalEntryService before anything is even
-- attempted, so a caller gets a clean validation error rather than a raw
-- Postgres exception in the common case.
--
-- journal_entries/journal_lines are append-only, exactly like every other
-- ledger table in this codebase (goal_contributions, liability_payments,
-- business_account_entries, expense_payments, invoice_payments) — there is
-- no UPDATE/DELETE path for a posted line, so no trigger is needed for
-- those operations.

CREATE TABLE chart_of_accounts (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    space_id        UUID NOT NULL REFERENCES financial_spaces(id) ON DELETE CASCADE,
    code            VARCHAR(20) NOT NULL,
    name            VARCHAR(120) NOT NULL,
    type            VARCHAR(20) NOT NULL CHECK (type IN ('ASSET', 'LIABILITY', 'EQUITY', 'REVENUE', 'EXPENSE')),
    system_default  BOOLEAN NOT NULL DEFAULT false,
    -- Flags an ASSET account as cash/bank-equivalent for the Cash Flow report (accounting.
    -- CashFlowService) — kept as a plain flag here rather than a query against
    -- bizbanking.business_accounts.chart_of_accounts_id, so this module stays self-contained
    -- (bizbanking already depends on accounting for posting; the reverse would cycle).
    cash_equivalent BOOLEAN NOT NULL DEFAULT false,
    archived_at     TIMESTAMPTZ,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (space_id, code)
);

CREATE INDEX idx_chart_of_accounts_space_id ON chart_of_accounts(space_id);

CREATE TABLE accounting_periods (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    space_id      UUID NOT NULL REFERENCES financial_spaces(id) ON DELETE CASCADE,
    period_start  DATE NOT NULL,
    period_end    DATE NOT NULL CHECK (period_end >= period_start),
    status        VARCHAR(10) NOT NULL DEFAULT 'OPEN' CHECK (status IN ('OPEN', 'CLOSED')),
    closed_at     TIMESTAMPTZ,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (space_id, period_start)
);

CREATE INDEX idx_accounting_periods_space_id ON accounting_periods(space_id);

-- source_type/source_id trace a journal entry back to the business action
-- that produced it (an invoice, an expense payment, ...). No FK on
-- source_id — it can point at rows in several different tables depending
-- on source_type, and it's purely informational (every real invariant this
-- system needs lives on journal_lines, not on the source pointer).
CREATE TABLE journal_entries (
    id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    space_id           UUID NOT NULL REFERENCES financial_spaces(id) ON DELETE CASCADE,
    entry_date         DATE NOT NULL,
    description        VARCHAR(255),
    source_type        VARCHAR(30) NOT NULL DEFAULT 'MANUAL' CHECK (source_type IN
                           ('MANUAL', 'INVOICE_ISSUED', 'INVOICE_PAYMENT', 'EXPENSE_PAYMENT', 'CREDIT_NOTE')),
    source_id          UUID,
    created_by_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_journal_entries_space_id_entry_date ON journal_entries(space_id, entry_date);
CREATE INDEX idx_journal_entries_source ON journal_entries(source_type, source_id);

CREATE TABLE journal_lines (
    id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    journal_entry_id  UUID NOT NULL REFERENCES journal_entries(id) ON DELETE CASCADE,
    account_id        UUID NOT NULL REFERENCES chart_of_accounts(id),
    direction         VARCHAR(10) NOT NULL CHECK (direction IN ('DEBIT', 'CREDIT')),
    amount            NUMERIC(14, 2) NOT NULL CHECK (amount > 0),
    description       VARCHAR(255),
    sort_order        INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX idx_journal_lines_journal_entry_id ON journal_lines(journal_entry_id);
CREATE INDEX idx_journal_lines_account_id ON journal_lines(account_id);

-- The double-entry invariant, enforced at the database level. Deferred so
-- it checks at COMMIT, after every line of a multi-line entry has been
-- inserted (Hibernate issues one INSERT per row, not a single multi-row
-- statement) — an immediate trigger would reject the very first line of
-- any entry before its balancing line ever arrives.
CREATE FUNCTION check_journal_entry_balance() RETURNS TRIGGER AS $$
DECLARE
    imbalance NUMERIC;
BEGIN
    SELECT COALESCE(SUM(CASE WHEN direction = 'DEBIT' THEN amount ELSE -amount END), 0)
    INTO imbalance
    FROM journal_lines
    WHERE journal_entry_id = NEW.journal_entry_id;

    IF imbalance <> 0 THEN
        RAISE EXCEPTION 'journal_entry % is not balanced (debit minus credit = %)', NEW.journal_entry_id, imbalance;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER trg_journal_lines_balance
    AFTER INSERT ON journal_lines
    DEFERRABLE INITIALLY DEFERRED
    FOR EACH ROW
    EXECUTE FUNCTION check_journal_entry_balance();

-- Optional per-record links into the chart of accounts, so automatic
-- posting (section 36) knows which GL account to move — nullable, since a
-- space that hasn't set up its books yet must keep working exactly as
-- Phase 5 shipped it (posting is silently skipped wherever a mapping is
-- absent; see accounting.AutomaticPostingService).
ALTER TABLE business_accounts ADD COLUMN chart_of_accounts_id UUID REFERENCES chart_of_accounts(id) ON DELETE SET NULL;
ALTER TABLE business_expenses ADD COLUMN chart_of_accounts_id UUID REFERENCES chart_of_accounts(id) ON DELETE SET NULL;
