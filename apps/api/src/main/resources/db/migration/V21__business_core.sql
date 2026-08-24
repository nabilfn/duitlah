-- V2 Phase 5 (Business Core): customers, suppliers, products, business bank
-- accounts (isolated from personal accounts), expenses, sales (quotations/
-- invoices/payments/credit notes), and receivables/payables. See
-- docs/business-core.md for the full design reasoning.
--
-- The double-entry accounting engine (chart_of_accounts, journal_entries,
-- journal_lines) is deliberately NOT part of this migration -- that is the
-- explicit scope of V2 Phase 6 (spec section 34), not Phase 5. Every
-- balance/outstanding figure here is computed from these tables' own
-- ledgers, the same "computed, never stored" discipline used everywhere
-- else in this schema, and will be reconciled against the real general
-- ledger once Phase 6 exists.

CREATE TABLE business_accounts (
    id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    space_id         UUID NOT NULL REFERENCES financial_spaces(id) ON DELETE CASCADE,
    name             VARCHAR(120) NOT NULL,
    type             VARCHAR(20) NOT NULL CHECK (type IN ('BANK', 'CASH', 'E_WALLET', 'CREDIT_CARD')),
    currency         VARCHAR(3) NOT NULL DEFAULT 'MYR' CHECK (currency ~ '^[A-Z]{3}$'),
    opening_balance  NUMERIC(14, 2) NOT NULL DEFAULT 0,
    archived_at      TIMESTAMPTZ,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_business_accounts_space_id ON business_accounts(space_id);

-- A business account's balance is opening_balance + SUM(signed entries) --
-- computed on read, never stored. linked_expense_payment_id/
-- linked_invoice_payment_id are set automatically when a payment is
-- recorded elsewhere; manual entries (adjustments, transfers) leave both
-- null.
CREATE TABLE business_account_entries (
    id                        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    business_account_id       UUID NOT NULL REFERENCES business_accounts(id) ON DELETE CASCADE,
    direction                 VARCHAR(10) NOT NULL CHECK (direction IN ('IN', 'OUT')),
    amount                    NUMERIC(14, 2) NOT NULL CHECK (amount > 0),
    occurred_on               DATE NOT NULL,
    description               VARCHAR(255),
    linked_expense_payment_id UUID,
    linked_invoice_payment_id UUID,
    transfer_group_id         UUID,
    created_at                TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_business_account_entries_account_id ON business_account_entries(business_account_id);

CREATE TABLE customers (
    id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    space_id             UUID NOT NULL REFERENCES financial_spaces(id) ON DELETE CASCADE,
    name                 VARCHAR(160) NOT NULL,
    contact_person       VARCHAR(120),
    phone                VARCHAR(30),
    email                VARCHAR(255),
    billing_address      TEXT,
    registration_number  VARCHAR(50),
    tin                  VARCHAR(50),
    sst_number           VARCHAR(50),
    payment_terms_days   INTEGER NOT NULL DEFAULT 30 CHECK (payment_terms_days >= 0),
    notes                TEXT,
    status               VARCHAR(20) NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'ARCHIVED')),
    created_at           TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at           TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_customers_space_id ON customers(space_id);

CREATE TABLE suppliers (
    id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    space_id             UUID NOT NULL REFERENCES financial_spaces(id) ON DELETE CASCADE,
    name                 VARCHAR(160) NOT NULL,
    contact_person       VARCHAR(120),
    phone                VARCHAR(30),
    email                VARCHAR(255),
    billing_address      TEXT,
    registration_number  VARCHAR(50),
    tin                  VARCHAR(50),
    sst_number           VARCHAR(50),
    payment_terms_days   INTEGER NOT NULL DEFAULT 30 CHECK (payment_terms_days >= 0),
    notes                TEXT,
    status               VARCHAR(20) NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'ARCHIVED')),
    created_at           TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at           TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_suppliers_space_id ON suppliers(space_id);

CREATE TABLE products (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    space_id    UUID NOT NULL REFERENCES financial_spaces(id) ON DELETE CASCADE,
    name        VARCHAR(160) NOT NULL,
    sku         VARCHAR(60),
    type        VARCHAR(10) NOT NULL CHECK (type IN ('GOODS', 'SERVICE')),
    unit        VARCHAR(30) NOT NULL DEFAULT 'unit',
    unit_price  NUMERIC(14, 2) NOT NULL CHECK (unit_price >= 0),
    is_active   BOOLEAN NOT NULL DEFAULT true,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_products_space_id ON products(space_id);

-- Payables come from here, not a separate "Purchases" module -- Phase 5's
-- own scope names expenses/payables but not a distinct purchase-order
-- concept (see docs/business-core.md).
CREATE TABLE business_expenses (
    id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    space_id     UUID NOT NULL REFERENCES financial_spaces(id) ON DELETE CASCADE,
    supplier_id  UUID REFERENCES suppliers(id) ON DELETE SET NULL,
    category     VARCHAR(80),
    amount       NUMERIC(14, 2) NOT NULL CHECK (amount > 0),
    occurred_on  DATE NOT NULL,
    status       VARCHAR(20) NOT NULL DEFAULT 'UNPAID' CHECK (status IN ('UNPAID', 'PARTIALLY_PAID', 'PAID')),
    receipt_id   UUID REFERENCES receipts(id) ON DELETE SET NULL,
    notes        TEXT,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_business_expenses_space_id ON business_expenses(space_id);
CREATE INDEX idx_business_expenses_supplier_id ON business_expenses(supplier_id);

-- Append-only, same discipline as liability_payments/goal_contributions.
CREATE TABLE expense_payments (
    id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    business_expense_id  UUID NOT NULL REFERENCES business_expenses(id) ON DELETE CASCADE,
    business_account_id  UUID NOT NULL REFERENCES business_accounts(id) ON DELETE CASCADE,
    amount               NUMERIC(14, 2) NOT NULL CHECK (amount > 0),
    paid_on              DATE NOT NULL,
    notes                TEXT,
    created_at           TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_expense_payments_expense_id ON expense_payments(business_expense_id);

CREATE TABLE quotations (
    id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    space_id     UUID NOT NULL REFERENCES financial_spaces(id) ON DELETE CASCADE,
    customer_id  UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
    quote_number VARCHAR(40) NOT NULL,
    issue_date   DATE NOT NULL,
    expiry_date  DATE,
    status       VARCHAR(20) NOT NULL DEFAULT 'DRAFT' CHECK (status IN
                     ('DRAFT', 'SENT', 'ACCEPTED', 'DECLINED', 'EXPIRED')),
    tax_percent  NUMERIC(5, 2) NOT NULL DEFAULT 0,
    subtotal     NUMERIC(14, 2) NOT NULL DEFAULT 0,
    tax_amount   NUMERIC(14, 2) NOT NULL DEFAULT 0,
    total        NUMERIC(14, 2) NOT NULL DEFAULT 0,
    notes        TEXT,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (space_id, quote_number)
);

CREATE INDEX idx_quotations_space_id ON quotations(space_id);
CREATE INDEX idx_quotations_customer_id ON quotations(customer_id);

CREATE TABLE quotation_line_items (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    quotation_id  UUID NOT NULL REFERENCES quotations(id) ON DELETE CASCADE,
    product_id    UUID REFERENCES products(id) ON DELETE SET NULL,
    description   VARCHAR(255) NOT NULL,
    quantity      NUMERIC(12, 2) NOT NULL CHECK (quantity > 0),
    unit_price    NUMERIC(14, 2) NOT NULL CHECK (unit_price >= 0),
    line_total    NUMERIC(14, 2) NOT NULL,
    sort_order    INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX idx_quotation_line_items_quotation_id ON quotation_line_items(quotation_id);

CREATE TABLE invoices (
    id                        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    space_id                  UUID NOT NULL REFERENCES financial_spaces(id) ON DELETE CASCADE,
    customer_id               UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
    invoice_number            VARCHAR(40) NOT NULL,
    issue_date                DATE NOT NULL,
    due_date                  DATE NOT NULL,
    status                    VARCHAR(20) NOT NULL DEFAULT 'DRAFT' CHECK (status IN ('DRAFT', 'SENT', 'VOID')),
    tax_percent               NUMERIC(5, 2) NOT NULL DEFAULT 0,
    subtotal                  NUMERIC(14, 2) NOT NULL DEFAULT 0,
    tax_amount                NUMERIC(14, 2) NOT NULL DEFAULT 0,
    total                     NUMERIC(14, 2) NOT NULL DEFAULT 0,
    converted_from_quotation_id UUID REFERENCES quotations(id) ON DELETE SET NULL,
    notes                     TEXT,
    created_at                TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at                TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (space_id, invoice_number)
);

CREATE INDEX idx_invoices_space_id ON invoices(space_id);
CREATE INDEX idx_invoices_customer_id ON invoices(customer_id);

CREATE TABLE invoice_line_items (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    invoice_id    UUID NOT NULL REFERENCES invoices(id) ON DELETE CASCADE,
    product_id    UUID REFERENCES products(id) ON DELETE SET NULL,
    description   VARCHAR(255) NOT NULL,
    quantity      NUMERIC(12, 2) NOT NULL CHECK (quantity > 0),
    unit_price    NUMERIC(14, 2) NOT NULL CHECK (unit_price >= 0),
    line_total    NUMERIC(14, 2) NOT NULL,
    sort_order    INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX idx_invoice_line_items_invoice_id ON invoice_line_items(invoice_id);

-- Append-only. Invoice outstanding = total - SUM(payments) - SUM(applied credit notes).
CREATE TABLE invoice_payments (
    id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    invoice_id           UUID NOT NULL REFERENCES invoices(id) ON DELETE CASCADE,
    business_account_id  UUID NOT NULL REFERENCES business_accounts(id) ON DELETE CASCADE,
    amount               NUMERIC(14, 2) NOT NULL CHECK (amount > 0),
    paid_on              DATE NOT NULL,
    notes                TEXT,
    created_at           TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_invoice_payments_invoice_id ON invoice_payments(invoice_id);

CREATE TABLE credit_notes (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    space_id            UUID NOT NULL REFERENCES financial_spaces(id) ON DELETE CASCADE,
    customer_id         UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
    invoice_id          UUID REFERENCES invoices(id) ON DELETE SET NULL,
    credit_note_number  VARCHAR(40) NOT NULL,
    issue_date          DATE NOT NULL,
    amount              NUMERIC(14, 2) NOT NULL CHECK (amount > 0),
    reason              TEXT,
    status              VARCHAR(20) NOT NULL DEFAULT 'ISSUED' CHECK (status IN ('ISSUED', 'VOID')),
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (space_id, credit_note_number)
);

CREATE INDEX idx_credit_notes_space_id ON credit_notes(space_id);
CREATE INDEX idx_credit_notes_invoice_id ON credit_notes(invoice_id);
