-- Phase 8: receipt scanning. A scan's parsed OCR result is ephemeral working
-- data, not permanent domain data -- permanence begins only once the user
-- confirms it into a real bill/receipt_items row (see
-- com.duitlah.api.receipts.ReceiptScanService and docs/bagilah-engine.md).
-- That's why parsed_result_json is a loosely-shaped TEXT blob (see
-- com.duitlah.api.receipts.ParsedReceiptCodec) rather than a rigid set of
-- "scanned_item" tables that would just be thrown away on confirm anyway.
CREATE TABLE receipt_scans (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_user_id       UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    bill_id             UUID REFERENCES bills(id) ON DELETE SET NULL,
    image_storage_key   VARCHAR(255) NOT NULL,
    content_type        VARCHAR(100) NOT NULL,
    status              VARCHAR(20) NOT NULL CHECK (status IN ('PARSED', 'FAILED', 'CONFIRMED')),
    provider            VARCHAR(40) NOT NULL,
    -- Not money -- a 0..1 self-reported confidence heuristic, not something
    -- that needs exact decimal precision, so DOUBLE PRECISION (matching the
    -- Java entity's `Double` field) rather than NUMERIC.
    overall_confidence  DOUBLE PRECISION,
    parsed_result_json  TEXT,
    error_message       VARCHAR(500),
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_receipt_scans_owner_user_id ON receipt_scans(owner_user_id);
