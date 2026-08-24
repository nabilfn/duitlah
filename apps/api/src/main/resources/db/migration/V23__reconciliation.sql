-- V2 Phase 7: Reconciliation (spec section 38; the master prompt's own
-- literal Phase 7 bullet list: business statement import, matching
-- engine, reconciliation sessions, match/create/ignore/split, audit
-- trail).
--
-- The actual CSV/XLSX/PDF parsing is reused directly from the existing
-- `statements` module (Phase 2's StatementParser/ParsedStatementRow/
-- StatementProvider) -- this migration only adds the business-scoped
-- tables that track reconciliation *state*, which autotrack's one-shot
-- "become a transaction candidate" flow has no equivalent of: a
-- statement line here stays UNMATCHED/MATCHED/CREATED/IGNORED/SPLIT
-- across the whole life of a reconciliation session, not just until a
-- single accept/reject decision.
--
-- The audit trail itself reuses the existing generic `audit_logs` table
-- (V13, Phase 14) via new AuditAction values -- no separate
-- reconciliation-specific audit table.

CREATE TABLE business_statement_imports (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    space_id            UUID NOT NULL REFERENCES financial_spaces(id) ON DELETE CASCADE,
    business_account_id UUID NOT NULL REFERENCES business_accounts(id) ON DELETE CASCADE,
    provider            VARCHAR(20) NOT NULL CHECK (provider IN ('GENERIC_CSV', 'GENERIC_EXCEL', 'PDF')),
    original_filename   VARCHAR(255) NOT NULL,
    storage_key         VARCHAR(500) NOT NULL,
    status              VARCHAR(20) NOT NULL CHECK (status IN ('PARSED', 'FAILED')),
    row_count           INTEGER NOT NULL DEFAULT 0,
    error_message       TEXT,
    created_by_user_id  UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_business_statement_imports_account_id ON business_statement_imports(business_account_id);

CREATE TABLE business_statement_lines (
    id                            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    business_statement_import_id UUID NOT NULL REFERENCES business_statement_imports(id) ON DELETE CASCADE,
    occurred_on                   DATE NOT NULL,
    description                   VARCHAR(500),
    amount                        NUMERIC(14, 2) NOT NULL, -- signed: positive = money in, negative = money out
    status                        VARCHAR(20) NOT NULL DEFAULT 'UNMATCHED' CHECK (status IN
                                       ('UNMATCHED', 'MATCHED', 'CREATED', 'IGNORED', 'SPLIT')),
    created_at                    TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at                    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_business_statement_lines_import_id ON business_statement_lines(business_statement_import_id);

-- One session per import (1:1, UNIQUE below) -- the spec names "business
-- statement import" and "reconciliation sessions" as separate bullets,
-- so they stay separate tables, but this phase doesn't need many
-- sessions working the same import concurrently.
CREATE TABLE reconciliation_sessions (
    id                            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    space_id                      UUID NOT NULL REFERENCES financial_spaces(id) ON DELETE CASCADE,
    business_account_id           UUID NOT NULL REFERENCES business_accounts(id) ON DELETE CASCADE,
    business_statement_import_id UUID NOT NULL REFERENCES business_statement_imports(id) ON DELETE CASCADE,
    -- User-entered (the real bank statement shows this; our generic
    -- parsers only extract line rows, not a header/footer balance) --
    -- nullable, since a session can still match/create/ignore/split
    -- lines without ever declaring a difference to resolve.
    statement_ending_balance      NUMERIC(14, 2),
    status                        VARCHAR(20) NOT NULL DEFAULT 'IN_PROGRESS' CHECK (status IN ('IN_PROGRESS', 'COMPLETED')),
    started_at                    TIMESTAMPTZ NOT NULL DEFAULT now(),
    completed_at                  TIMESTAMPTZ,
    created_by_user_id            UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE (business_statement_import_id)
);

CREATE INDEX idx_reconciliation_sessions_account_id ON reconciliation_sessions(business_account_id);

-- Append-only. A plain Match or a Create Transaction produces exactly
-- one row; a Split produces several -- one per new ledger entry the
-- line's amount was divided into.
CREATE TABLE reconciliation_line_allocations (
    id                          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    business_statement_line_id UUID NOT NULL REFERENCES business_statement_lines(id) ON DELETE CASCADE,
    business_account_entry_id  UUID NOT NULL REFERENCES business_account_entries(id) ON DELETE CASCADE,
    amount                      NUMERIC(14, 2) NOT NULL CHECK (amount > 0),
    created_at                  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_reconciliation_allocations_line_id ON reconciliation_line_allocations(business_statement_line_id);
CREATE INDEX idx_reconciliation_allocations_entry_id ON reconciliation_line_allocations(business_account_entry_id);
