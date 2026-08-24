CREATE TABLE financial_spaces (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    type           VARCHAR(20) NOT NULL CHECK (type IN ('PERSONAL', 'BUSINESS')),
    name           VARCHAR(120) NOT NULL,
    owner_user_id  UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    status         VARCHAR(20) NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'ARCHIVED')),
    created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_financial_spaces_owner_user_id ON financial_spaces(owner_user_id);

-- Exactly one PERSONAL space per user -- a real invariant, not just an
-- application-layer convention (same "partial unique index" pattern already
-- used by budgets' own overall-vs-per-category uniqueness rule).
CREATE UNIQUE INDEX idx_financial_spaces_one_personal_per_owner
    ON financial_spaces(owner_user_id) WHERE type = 'PERSONAL';

CREATE TABLE space_members (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    space_id   UUID NOT NULL REFERENCES financial_spaces(id) ON DELETE CASCADE,
    user_id    UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role       VARCHAR(20) NOT NULL CHECK (role IN
                   ('OWNER', 'ADMIN', 'FINANCE', 'ACCOUNTANT', 'SALES', 'STAFF', 'VIEWER')),
    status     VARCHAR(20) NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'REMOVED')),
    joined_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (space_id, user_id)
);

CREATE INDEX idx_space_members_user_id ON space_members(user_id);

CREATE TABLE business_profiles (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    space_id              UUID NOT NULL UNIQUE REFERENCES financial_spaces(id) ON DELETE CASCADE,
    legal_name            VARCHAR(180) NOT NULL,
    trade_name            VARCHAR(180),
    registration_number   VARCHAR(50),
    tin                   VARCHAR(50),
    business_type         VARCHAR(40),
    industry              VARCHAR(80),
    sst_number            VARCHAR(50),
    financial_year_start  DATE,
    financial_year_end    DATE,
    address               TEXT,
    phone                 VARCHAR(30),
    email                 VARCHAR(255),
    currency              VARCHAR(3) NOT NULL DEFAULT 'MYR' CHECK (currency ~ '^[A-Z]{3}$'),
    created_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at            TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Existing-user migration (V2 spec section 85): every current user gets a
-- Personal space, automatically, with no data movement and no new column on
-- any other table -- see docs/v2-audit.md section 14 for why this is safe.
INSERT INTO financial_spaces (type, name, owner_user_id)
SELECT 'PERSONAL', 'Personal', id FROM users;

INSERT INTO space_members (space_id, user_id, role)
SELECT fs.id, fs.owner_user_id, 'OWNER'
FROM financial_spaces fs
WHERE fs.type = 'PERSONAL';
