-- Groups own an optional persistent invite token (hash-stored, like the
-- Phase 2 auth tokens) rather than per-invitation single-use tokens — a
-- shareable "join this group" link is the simplest model that satisfies
-- Phase 5's Create/Invite/Join requirement without inventing an invite-
-- tracking system Phase 7's Bagilah guest links may supersede anyway.
CREATE TABLE groups (
    id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_user_id      UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name               VARCHAR(120) NOT NULL,
    type               VARCHAR(20) NOT NULL CHECK (type IN ('GENERAL', 'HOUSEMATES', 'COUPLE', 'TRIP', 'FRIENDS', 'FAMILY', 'TEAM', 'EVENT')),
    invite_token_hash  VARCHAR(255) UNIQUE,
    archived_at        TIMESTAMPTZ,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at         TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE group_members (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    group_id   UUID NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
    user_id    UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role       VARCHAR(10) NOT NULL CHECK (role IN ('OWNER', 'MEMBER')),
    joined_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (group_id, user_id)
);

CREATE INDEX idx_group_members_user_id ON group_members(user_id);

-- A group expense is the simple "one person paid, split equally among
-- some subset of members" flavor — not Bagilah's per-item claiming
-- (receipt scanning, custom %, shared items). That's Phases 6-8; this is
-- deliberately the lighter mechanism Phase 5 actually asks for.
CREATE TABLE group_expenses (
    id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    group_id         UUID NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
    paid_by_user_id  UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_by_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    description      VARCHAR(255) NOT NULL,
    amount           NUMERIC(14, 2) NOT NULL CHECK (amount > 0),
    occurred_on      DATE NOT NULL,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_group_expenses_group_id ON group_expenses(group_id);

-- SUM(shares.amount) for a given expense must equal that expense's
-- amount exactly — see common.money.EqualSplitter, which distributes an
-- indivisible remainder cent-by-cent rather than letting division just
-- round each share independently (the same reconciliation discipline the
-- product spec requires of the Bagilah engine, applied here first since
-- Phase 5 needs it now).
CREATE TABLE group_expense_shares (
    id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    group_expense_id   UUID NOT NULL REFERENCES group_expenses(id) ON DELETE CASCADE,
    user_id            UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    amount             NUMERIC(14, 2) NOT NULL CHECK (amount >= 0),
    UNIQUE (group_expense_id, user_id)
);

CREATE INDEX idx_group_expense_shares_expense_id ON group_expense_shares(group_expense_id);
