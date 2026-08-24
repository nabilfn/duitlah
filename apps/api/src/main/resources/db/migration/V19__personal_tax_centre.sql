-- V2 Phase 4 (Personal Tax Centre): a Malaysian personal-tax estimation
-- system, versioned by Year of Assessment (spec section 26: "never
-- hardcode a single permanent tax rule"). See docs/personal-tax.md for
-- the full design reasoning and an explicit honesty note about where the
-- seeded rates/reliefs in V19__seed_tax_years.sql come from.

CREATE TABLE tax_years (
    id                       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    year_of_assessment       INTEGER NOT NULL UNIQUE,
    resident_individual_relief NUMERIC(12, 2) NOT NULL,
    notes                    TEXT,
    created_at               TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Progressive chargeable-income bands for one YA. `rate_percent` applies
-- only to the slice of chargeable income within
-- [lower_bound, upper_bound] -- the calculation service walks these in
-- order, never a flat "highest bracket applies to everything" mistake.
CREATE TABLE tax_brackets (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tax_year_id    UUID NOT NULL REFERENCES tax_years(id) ON DELETE CASCADE,
    lower_bound    NUMERIC(14, 2) NOT NULL,
    upper_bound    NUMERIC(14, 2),
    rate_percent   NUMERIC(5, 2) NOT NULL CHECK (rate_percent >= 0),
    CHECK (upper_bound IS NULL OR upper_bound > lower_bound)
);

CREATE INDEX idx_tax_brackets_tax_year_id ON tax_brackets(tax_year_id);

-- The maximum claimable amount for one relief category in one YA --
-- category identity is a stable enum (see PersonalTaxReliefCategory),
-- the *limit* is what changes year to year.
CREATE TABLE tax_relief_rules (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tax_year_id    UUID NOT NULL REFERENCES tax_years(id) ON DELETE CASCADE,
    category       VARCHAR(40) NOT NULL,
    max_amount     NUMERIC(12, 2) NOT NULL CHECK (max_amount >= 0),
    description    TEXT,
    UNIQUE (tax_year_id, category)
);

-- A chargeable-income-threshold rebate (e.g. Malaysia's individual
-- rebate for lower-income taxpayers) -- a flat amount subtracted from
-- gross tax payable, not a relief against chargeable income itself.
CREATE TABLE tax_rebate_rules (
    id                          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tax_year_id                 UUID NOT NULL REFERENCES tax_years(id) ON DELETE CASCADE,
    chargeable_income_threshold NUMERIC(14, 2) NOT NULL,
    rebate_amount                NUMERIC(12, 2) NOT NULL CHECK (rebate_amount >= 0),
    description                 TEXT
);

CREATE TABLE personal_income_records (
    id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id           UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    space_id          UUID NOT NULL REFERENCES financial_spaces(id) ON DELETE CASCADE,
    year_of_assessment INTEGER NOT NULL,
    income_type       VARCHAR(20) NOT NULL CHECK (income_type IN
                          ('EMPLOYMENT', 'BUSINESS', 'RENTAL', 'OTHER')),
    amount            NUMERIC(14, 2) NOT NULL CHECK (amount >= 0),
    description       VARCHAR(160),
    created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_personal_income_records_user_id_ya ON personal_income_records(user_id, year_of_assessment);

CREATE TABLE pcb_payments (
    id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id            UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    year_of_assessment INTEGER NOT NULL,
    month              SMALLINT NOT NULL CHECK (month BETWEEN 1 AND 12),
    amount             NUMERIC(12, 2) NOT NULL CHECK (amount >= 0),
    notes              TEXT,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (user_id, year_of_assessment, month)
);

CREATE TABLE zakat_payments (
    id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id            UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    year_of_assessment INTEGER NOT NULL,
    amount             NUMERIC(12, 2) NOT NULL CHECK (amount > 0),
    paid_on            DATE NOT NULL,
    receipt_id         UUID REFERENCES receipts(id) ON DELETE SET NULL,
    notes              TEXT,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_zakat_payments_user_id_ya ON zakat_payments(user_id, year_of_assessment);

CREATE TABLE personal_tax_documents (
    id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id            UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    space_id           UUID NOT NULL REFERENCES financial_spaces(id) ON DELETE CASCADE,
    year_of_assessment INTEGER NOT NULL,
    type               VARCHAR(30) NOT NULL CHECK (type IN
                           ('EA', 'EC', 'PCB_EVIDENCE', 'INSURANCE_STATEMENT', 'EPF_STATEMENT',
                            'PRS_STATEMENT', 'ZAKAT_RECEIPT', 'MEDICAL_RECEIPT',
                            'EDUCATION_RECEIPT', 'DONATION_EVIDENCE', 'OTHER')),
    receipt_id         UUID REFERENCES receipts(id) ON DELETE SET NULL,
    storage_key        VARCHAR(500),
    notes              TEXT,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at         TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_personal_tax_documents_user_id_ya ON personal_tax_documents(user_id, year_of_assessment);

-- The pipeline's own suggestion step (spec section 27). A candidate never
-- silently becomes a confirmed relief -- see confirmed_tax_reliefs below.
CREATE TABLE tax_relief_candidates (
    id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id            UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    year_of_assessment INTEGER NOT NULL,
    category           VARCHAR(40),
    source_receipt_id  UUID REFERENCES receipts(id) ON DELETE CASCADE,
    suggested_amount   NUMERIC(12, 2) NOT NULL CHECK (suggested_amount > 0),
    status             VARCHAR(20) NOT NULL DEFAULT 'NEEDS_REVIEW' CHECK (status IN
                           ('POTENTIALLY_ELIGIBLE', 'NEEDS_REVIEW', 'MISSING_EVIDENCE',
                            'CONFIRMED', 'REJECTED')),
    notes              TEXT,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at         TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_tax_relief_candidates_user_id_ya ON tax_relief_candidates(user_id, year_of_assessment);

-- The ledger of truth PersonalTaxCalculationService actually reads --
-- one confirmed amount per category per YA, the pipeline's terminal
-- state. A category can be re-confirmed (e.g. amount corrected), never
-- duplicated.
CREATE TABLE confirmed_tax_reliefs (
    id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id            UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    year_of_assessment INTEGER NOT NULL,
    category           VARCHAR(40) NOT NULL,
    confirmed_amount   NUMERIC(12, 2) NOT NULL CHECK (confirmed_amount >= 0),
    source_candidate_id UUID REFERENCES tax_relief_candidates(id) ON DELETE SET NULL,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (user_id, year_of_assessment, category)
);
