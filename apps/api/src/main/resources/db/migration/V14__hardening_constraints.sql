-- Phase 14 (Hardening): a database constraint review found that Trip
-- mode's currency snapshot columns (V11) had no CHECK constraints, even
-- though they're client-supplied and the API layer's own
-- @DecimalMin/@Size validation was the only thing preventing a garbage
-- value from ever reaching the database. NULL is still allowed for all
-- three (the snapshot is optional -- see V11's own comment); a CHECK only
-- ever constrains the non-null case in Postgres, so this doesn't change
-- who is even allowed to omit them.
ALTER TABLE group_expenses ADD CONSTRAINT chk_original_amount_positive
    CHECK (original_amount IS NULL OR original_amount > 0);
ALTER TABLE group_expenses ADD CONSTRAINT chk_exchange_rate_positive
    CHECK (exchange_rate IS NULL OR exchange_rate > 0);
ALTER TABLE group_expenses ADD CONSTRAINT chk_original_currency_format
    CHECK (original_currency IS NULL OR original_currency ~ '^[A-Z]{3}$');
