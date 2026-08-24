-- V2 Phase 2 (Personal Gap Closure I): the generalized transaction-ingestion
-- pipeline (Duitlah AutoTrack), bank statement import, and the Receipt Vault.
-- See docs/autotrack.md for the full design reasoning.

CREATE TABLE receipts (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id               UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    space_id              UUID NOT NULL REFERENCES financial_spaces(id) ON DELETE CASCADE,
    storage_key           VARCHAR(500) NOT NULL,
    content_type          VARCHAR(60) NOT NULL,
    purpose               VARCHAR(20) NOT NULL CHECK (purpose IN
                              ('PERSONAL_EXPENSE', 'BUSINESS_EXPENSE', 'TAX_EVIDENCE', 'BAGILAH', 'UNSPECIFIED')),
    ocr_status            VARCHAR(20) NOT NULL DEFAULT 'UNPROCESSED' CHECK (ocr_status IN
                              ('UNPROCESSED', 'PARSED', 'FAILED')),
    merchant              VARCHAR(120),
    receipt_date          DATE,
    total_amount          NUMERIC(14, 2),
    folder                VARCHAR(80),
    tags                  TEXT[] NOT NULL DEFAULT '{}',
    linked_transaction_id UUID REFERENCES transactions(id) ON DELETE SET NULL,
    linked_bill_id        UUID REFERENCES bills(id) ON DELETE SET NULL,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at            TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_receipts_user_id ON receipts(user_id);
CREATE INDEX idx_receipts_space_id ON receipts(space_id);
CREATE INDEX idx_receipts_merchant ON receipts(merchant);

CREATE TABLE statement_imports (
    id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id           UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    space_id          UUID NOT NULL REFERENCES financial_spaces(id) ON DELETE CASCADE,
    account_id        UUID NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
    provider          VARCHAR(20) NOT NULL CHECK (provider IN ('GENERIC_CSV', 'GENERIC_EXCEL', 'PDF')),
    original_filename VARCHAR(255) NOT NULL,
    storage_key       VARCHAR(500) NOT NULL,
    status            VARCHAR(20) NOT NULL DEFAULT 'UPLOADED' CHECK (status IN
                          ('UPLOADED', 'PARSED', 'FAILED')),
    row_count         INTEGER NOT NULL DEFAULT 0,
    error_message     TEXT,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_statement_imports_user_id ON statement_imports(user_id);

CREATE TABLE transaction_candidates (
    id                           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id                      UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    space_id                     UUID NOT NULL REFERENCES financial_spaces(id) ON DELETE CASCADE,
    source_type                  VARCHAR(20) NOT NULL CHECK (source_type IN
                                     ('RECEIPT_OCR', 'STATEMENT_CSV', 'STATEMENT_XLSX', 'STATEMENT_PDF')),
    receipt_id                   UUID REFERENCES receipts(id) ON DELETE CASCADE,
    statement_import_id          UUID REFERENCES statement_imports(id) ON DELETE CASCADE,
    detected_amount              NUMERIC(14, 2) NOT NULL CHECK (detected_amount > 0),
    detected_currency            VARCHAR(3) NOT NULL DEFAULT 'MYR' CHECK (detected_currency ~ '^[A-Z]{3}$'),
    detected_merchant            VARCHAR(120),
    detected_date                DATE NOT NULL,
    detected_direction           VARCHAR(10) NOT NULL CHECK (detected_direction IN ('IN', 'OUT')),
    suggested_account_id         UUID REFERENCES accounts(id) ON DELETE SET NULL,
    suggested_category_id        UUID REFERENCES categories(id) ON DELETE SET NULL,
    confidence                   NUMERIC(3, 2) NOT NULL CHECK (confidence BETWEEN 0 AND 1),
    status                       VARCHAR(20) NOT NULL DEFAULT 'PENDING' CHECK (status IN
                                     ('PENDING', 'CONFIRMED', 'REJECTED', 'DUPLICATE', 'FAILED')),
    duplicate_of_transaction_id  UUID REFERENCES transactions(id) ON DELETE SET NULL,
    duplicate_confidence         NUMERIC(3, 2) CHECK (duplicate_confidence IS NULL OR duplicate_confidence BETWEEN 0 AND 1),
    resulting_transaction_id     UUID REFERENCES transactions(id) ON DELETE SET NULL,
    created_at                   TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at                   TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_transaction_candidates_user_id_status ON transaction_candidates(user_id, status);
