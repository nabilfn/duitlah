-- Phase 9: settlement. A Settlement is a fixed, independent debt obligation
-- between two real users -- generated once (at a bill's finalize() time, or
-- whenever a group is explicitly "settled up"), then tracked to payment
-- through its own history, entirely decoupled from whatever new expenses a
-- group accumulates afterward. See com.duitlah.api.settlements.DebtSimplifier
-- for how a bill/group's net positions become these pairwise transfers, and
-- docs/database.md for why status is *not* a stored column.
--
-- Guests are deliberately excluded: a Settlement is meant to be visible from
-- its own owner's "who owes me" dashboard, which requires a real account to
-- log into in the first place. A guest's net position in a bill remains
-- visible on that bill's own balances (see V6__bagilah.sql) -- it just
-- doesn't get promoted into a durable, cross-bill Settlement record.
CREATE TABLE settlements (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    from_user_id   UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    to_user_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    amount         NUMERIC(12, 2) NOT NULL CHECK (amount > 0),
    source_type    VARCHAR(20) NOT NULL CHECK (source_type IN ('BILL', 'GROUP')),
    -- Polymorphic reference (a bills.id or groups.id) -- deliberately not a
    -- foreign key, since it can point at either table; source_type says which.
    source_id      UUID NOT NULL,
    cancelled_at   TIMESTAMPTZ,
    disputed_at    TIMESTAMPTZ,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
    CHECK (from_user_id <> to_user_id)
);

CREATE INDEX idx_settlements_from_user_id ON settlements(from_user_id);
CREATE INDEX idx_settlements_to_user_id ON settlements(to_user_id);
CREATE INDEX idx_settlements_source ON settlements(source_type, source_id);

-- Append-only: a payment, once recorded, is never edited -- a correction is a
-- new (possibly negative-sense, i.e. reversing) note-explained entry, not a
-- rewrite of history. amount_paid/status are always computed from this table
-- (SUM(settlement_payments.amount) vs settlements.amount), never stored.
CREATE TABLE settlement_payments (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    settlement_id         UUID NOT NULL REFERENCES settlements(id) ON DELETE CASCADE,
    amount                NUMERIC(12, 2) NOT NULL CHECK (amount > 0),
    recorded_by_user_id   UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    note                  VARCHAR(255),
    paid_at               TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_at            TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_settlement_payments_settlement_id ON settlement_payments(settlement_id);
