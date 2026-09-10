-- Duitlah Monthly Wrapped: a computed, persisted recap of one user's one
-- calendar month. The payload is a versioned, read-only computed artifact
-- (never queried by individual field, only ever fetched whole and rendered),
-- so it's stored as a single JSON blob (matching the existing
-- receipts.parsed_result_json precedent) rather than a dozen tightly-coupled
-- join tables for something this codebase never needs to query relationally.
-- persona_id is denormalized alongside the payload purely so the history list
-- (Analytics -> Monthly Stories) can render "August - Cafe Hunter" without
-- deserializing the full payload for every row.
CREATE TABLE monthly_wrapped (
    id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id          UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    year             INTEGER NOT NULL,
    month            INTEGER NOT NULL CHECK (month BETWEEN 1 AND 12),
    persona_id       VARCHAR(40),
    sufficient_data  BOOLEAN NOT NULL DEFAULT TRUE,
    payload          TEXT NOT NULL,
    wrapped_version  INTEGER NOT NULL DEFAULT 1,
    generated_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
    viewed_at        TIMESTAMPTZ,
    UNIQUE (user_id, year, month)
);
CREATE INDEX idx_monthly_wrapped_user_id ON monthly_wrapped(user_id);
