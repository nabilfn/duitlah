-- V2 Phase 10: LHDN / MyInvois / SST (spec sections 53-57; the master
-- prompt's own literal Phase 10 bullet list: business tax infrastructure,
-- SST, MyInvois adapter, TIN handling, document submission, status
-- tracking, validated document handling, cancellation/rejection,
-- readiness rules).

-- Section 57's own e-Invoice readiness checklist ("Business registration,
-- TIN, Business type, Annual revenue range, Industry, SST status,
-- Financial year") is almost entirely already covered by Phase 5's
-- business_profiles (tin, registration_number, business_type, industry,
-- sst_number, financial_year_start/end) -- the only genuinely missing
-- piece is annual revenue, which the versioned mandate-threshold rule
-- below needs to determine e-Invoice eligibility.
ALTER TABLE business_profiles ADD COLUMN annual_revenue NUMERIC(16, 2);

-- Section 57: "Do not hardcode one permanent e-Invoice threshold. Use
-- versioned rules/effective dates." -- the real threshold changed from
-- RM500,000 to RM1,000,000 in December 2025, which is exactly the
-- scenario this table exists to survive without a code change.
CREATE TABLE einvoice_mandate_rules (
    id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    effective_date     DATE NOT NULL UNIQUE,
    revenue_threshold  NUMERIC(16, 2) NOT NULL,
    description        VARCHAR(255) NOT NULL,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Section 54: SST is genuinely multi-rate (Sales Tax 5%/10%, Service Tax
-- 6%/8%, and the rates/thresholds have changed within the last year) --
-- the same "never a hardcoded constant" discipline as personaltax's
-- tax_brackets/tax_years.
CREATE TABLE sst_rates (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tax_type       VARCHAR(10) NOT NULL CHECK (tax_type IN ('SALES', 'SERVICE')),
    rate_percent   NUMERIC(5, 2) NOT NULL,
    effective_from DATE NOT NULL,
    effective_to   DATE,
    description    VARCHAR(255) NOT NULL,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Section 56's workflow: Invoice -> Eligibility/Required Fields ->
-- Customer TIN validation -> Generate payload -> Submit -> Pending ->
-- Validated/Invalid -> Persist UID/status -> QR/validated document, plus
-- provider-allowed cancellation/rejection. One row per invoice that has
-- ever entered this workflow; UNIQUE(invoice_id) since only one active
-- e-Invoice document exists per invoice at a time.
CREATE TABLE einvoice_documents (
    id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    space_id             UUID NOT NULL REFERENCES financial_spaces(id) ON DELETE CASCADE,
    invoice_id           UUID NOT NULL UNIQUE REFERENCES invoices(id) ON DELETE CASCADE,
    status               VARCHAR(20) NOT NULL DEFAULT 'READY' CHECK (status IN
                             ('READY', 'SUBMITTED', 'VALID', 'INVALID', 'CANCELLED', 'REJECTED')),
    submission_uid       VARCHAR(64),
    document_uuid        VARCHAR(64),
    long_id              VARCHAR(64),
    validated_at         TIMESTAMPTZ,
    invalid_reason       TEXT,
    cancelled_at         TIMESTAMPTZ,
    cancellation_reason  VARCHAR(300),
    rejected_at          TIMESTAMPTZ,
    rejection_reason     VARCHAR(300),
    created_by_user_id   UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at           TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at           TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_einvoice_documents_space_id ON einvoice_documents(space_id);

-- Section 56: "All provider interactions must be auditable" -- every
-- submit/status-check/cancel/reject call is recorded here, independent of
-- the einvoice_documents row's own current-state columns above, so a full
-- interaction history survives even across state transitions.
CREATE TABLE einvoice_provider_logs (
    id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    einvoice_document_id UUID NOT NULL REFERENCES einvoice_documents(id) ON DELETE CASCADE,
    operation         VARCHAR(20) NOT NULL CHECK (operation IN
                          ('SUBMIT', 'STATUS_CHECK', 'CANCEL', 'REJECT')),
    provider_name     VARCHAR(50) NOT NULL,
    success           BOOLEAN NOT NULL,
    detail            TEXT,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_einvoice_provider_logs_document_id ON einvoice_provider_logs(einvoice_document_id);
