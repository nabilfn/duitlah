-- Phase 7: Bagilah collaboration. A bill gets a persistent, regeneratable
-- invite token exactly like a group's (see V5__groups.sql) — same
-- shareable-link model, same hash-only storage.
ALTER TABLE bills ADD COLUMN invite_token_hash VARCHAR(255) UNIQUE;

-- A guest who joins via the invite link has no Duitlah account and no
-- refresh-token session (see V2__auth.sql's auth_sessions) to fall back
-- on, so this is a lighter, parallel concept: one row per guest device
-- that joined, holding a single opaque session token for their whole
-- 24-hour window (not rotated per request, not single-use like
-- email_verification_tokens/password_reset_tokens -- a guest keeps using
-- the same token for every request until it expires, then just re-joins
-- via the link). See com.duitlah.api.bagilah.BillGuestSession and
-- docs/bagilah-engine.md for how this is validated without ever touching
-- the real-user JWT/Spring Security path.
CREATE TABLE bill_guest_sessions (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    bill_id         UUID NOT NULL REFERENCES bills(id) ON DELETE CASCADE,
    participant_id  UUID NOT NULL REFERENCES bill_participants(id) ON DELETE CASCADE,
    token_hash      VARCHAR(255) NOT NULL UNIQUE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    expires_at      TIMESTAMPTZ NOT NULL
);

CREATE INDEX idx_bill_guest_sessions_token_hash ON bill_guest_sessions(token_hash);
CREATE INDEX idx_bill_guest_sessions_bill_id ON bill_guest_sessions(bill_id);
