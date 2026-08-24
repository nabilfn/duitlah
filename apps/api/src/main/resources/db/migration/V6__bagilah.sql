-- Bagilah manual bill splitting (Phase 6): no OCR yet (Phase 8) and no
-- guest self-join / real-time collaboration yet (Phase 7) — the bill
-- owner enters items and assigns claims themselves in one sitting, which
-- is why bill_participants has no join_token/status columns yet; those
-- arrive with Phase 7's actual guest-join flow rather than sitting here
-- unused.
--
-- status is deliberately a smaller subset of the product spec's full
-- state machine (DRAFT/SCANNING/REVIEW/OPEN/CLAIMING/READY/FINALIZED/
-- SETTLING/SETTLED/CANCELLED): SCANNING needs OCR (Phase 8); OPEN vs
-- CLAIMING vs READY only matter once participants can claim live and
-- independently of the owner (Phase 7) and once "all items validly
-- claimed" needs to be a persisted gate rather than a check made at the
-- moment finalize() is called; SETTLING/SETTLED need payment-status
-- tracking (Phase 9). DRAFT covers all pre-finalize editing.
CREATE TABLE bills (
    id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_user_id        UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    group_id             UUID REFERENCES groups(id) ON DELETE SET NULL,
    merchant             VARCHAR(160),
    receipt_date         DATE NOT NULL,
    currency             VARCHAR(3) NOT NULL DEFAULT 'MYR',
    tax                  NUMERIC(12, 2) NOT NULL DEFAULT 0 CHECK (tax >= 0),
    tax_strategy         VARCHAR(20) NOT NULL DEFAULT 'PROPORTIONAL' CHECK (tax_strategy IN ('PROPORTIONAL', 'EQUAL')),
    service_charge       NUMERIC(12, 2) NOT NULL DEFAULT 0 CHECK (service_charge >= 0),
    service_strategy     VARCHAR(20) NOT NULL DEFAULT 'PROPORTIONAL' CHECK (service_strategy IN ('PROPORTIONAL', 'EQUAL')),
    discount             NUMERIC(12, 2) NOT NULL DEFAULT 0 CHECK (discount >= 0),
    discount_label       VARCHAR(120),
    -- The amount actually printed on the receipt, if the owner typed one in and it doesn't
    -- exactly match subtotal+tax+service-discount (Malaysian retailers commonly round the
    -- cash total to the nearest 5 sen) -- see docs/bagilah-engine.md for how this becomes the
    -- explicit, recorded rounding_adjustment rather than a silently dropped cent.
    declared_total       NUMERIC(12, 2),
    -- Frozen at finalize() time; null before that since items/claims can still change.
    total                NUMERIC(12, 2),
    rounding_adjustment  NUMERIC(12, 2),
    status               VARCHAR(20) NOT NULL DEFAULT 'DRAFT' CHECK (status IN ('DRAFT', 'FINALIZED', 'CANCELLED')),
    finalized_at         TIMESTAMPTZ,
    created_at           TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at           TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_bills_owner_user_id ON bills(owner_user_id);
CREATE INDEX idx_bills_group_id ON bills(group_id);

-- item_discount is baked into total_price (post-discount) so the calculation engine never
-- needs a separate "item-specific discount" step -- total_price is simply what that
-- participant's claims must reconcile to. quantity is NUMERIC, not INTEGER, so a claim can
-- take a fractional share of a shared unit if ever needed (e.g. half a shared platter).
CREATE TABLE receipt_items (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    bill_id        UUID NOT NULL REFERENCES bills(id) ON DELETE CASCADE,
    name           VARCHAR(160) NOT NULL,
    quantity       NUMERIC(10, 2) NOT NULL CHECK (quantity > 0),
    unit_price     NUMERIC(12, 2) NOT NULL CHECK (unit_price >= 0),
    item_discount  NUMERIC(12, 2) NOT NULL DEFAULT 0 CHECK (item_discount >= 0),
    total_price    NUMERIC(12, 2) NOT NULL CHECK (total_price >= 0),
    created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_receipt_items_bill_id ON receipt_items(bill_id);

-- Exactly one of user_id/guest_name is set. Guests here are just a name the owner typed in
-- manually on someone else's behalf (no join link, no account) -- self-serve guest joining
-- via QR/URL is Phase 7's job, not this table's.
CREATE TABLE bill_participants (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    bill_id     UUID NOT NULL REFERENCES bills(id) ON DELETE CASCADE,
    user_id     UUID REFERENCES users(id) ON DELETE CASCADE,
    guest_name  VARCHAR(120),
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    CHECK ((user_id IS NOT NULL AND guest_name IS NULL) OR (user_id IS NULL AND guest_name IS NOT NULL))
);

CREATE INDEX idx_bill_participants_bill_id ON bill_participants(bill_id);
CREATE UNIQUE INDEX idx_bill_participants_bill_user ON bill_participants(bill_id, user_id) WHERE user_id IS NOT NULL;

-- claim_type governs which single column is populated -- see the CHECK below and
-- BagilahCalculationEngine, which rejects a mix of claim types on the same item rather than
-- guessing how to reconcile them. UNIQUE(receipt_item_id, participant_id) is the duplicate-
-- claim guard: adjusting a share is an update to this one row, not a second claim.
CREATE TABLE item_claims (
    id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    receipt_item_id  UUID NOT NULL REFERENCES receipt_items(id) ON DELETE CASCADE,
    participant_id   UUID NOT NULL REFERENCES bill_participants(id) ON DELETE CASCADE,
    claim_type       VARCHAR(10) NOT NULL CHECK (claim_type IN ('QUANTITY', 'PERCENTAGE', 'AMOUNT')),
    quantity         NUMERIC(10, 2),
    percentage       NUMERIC(5, 2),
    amount           NUMERIC(12, 2),
    created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (receipt_item_id, participant_id),
    CHECK (
        (claim_type = 'QUANTITY' AND quantity IS NOT NULL AND quantity > 0 AND percentage IS NULL AND amount IS NULL)
        OR (claim_type = 'PERCENTAGE' AND percentage IS NOT NULL AND percentage > 0 AND quantity IS NULL AND amount IS NULL)
        OR (claim_type = 'AMOUNT' AND amount IS NOT NULL AND amount >= 0 AND quantity IS NULL AND percentage IS NULL)
    )
);

CREATE INDEX idx_item_claims_receipt_item_id ON item_claims(receipt_item_id);
CREATE INDEX idx_item_claims_participant_id ON item_claims(participant_id);

-- Multiple payers (section 17): one row per participant who actually paid something toward
-- the bill. SUM(amount_paid) must equal bill.total exactly by the time the bill is
-- finalized -- validated in BillService, not here, since it depends on the frozen total.
CREATE TABLE bill_payments (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    bill_id         UUID NOT NULL REFERENCES bills(id) ON DELETE CASCADE,
    participant_id  UUID NOT NULL REFERENCES bill_participants(id) ON DELETE CASCADE,
    amount_paid     NUMERIC(12, 2) NOT NULL CHECK (amount_paid > 0),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (bill_id, participant_id)
);

CREATE INDEX idx_bill_payments_bill_id ON bill_payments(bill_id);

-- A deliberate exception to this schema's usual "computed, never stored" rule (see
-- docs/database.md): everywhere else a balance is a live view over an ever-growing ledger,
-- but finalizing a bill is meant to freeze one specific calculation as history, the same way
-- a bank statement doesn't get recomputed after the fact. Written once, at finalize() time,
-- never updated afterward -- a correction is a new bill, not a rewrite of this snapshot.
CREATE TABLE bill_final_amounts (
    id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    bill_id          UUID NOT NULL REFERENCES bills(id) ON DELETE CASCADE,
    participant_id   UUID NOT NULL REFERENCES bill_participants(id) ON DELETE CASCADE,
    subtotal         NUMERIC(12, 2) NOT NULL,
    tax_share        NUMERIC(12, 2) NOT NULL,
    service_share    NUMERIC(12, 2) NOT NULL,
    discount_share   NUMERIC(12, 2) NOT NULL,
    rounding_share   NUMERIC(12, 2) NOT NULL,
    final_amount     NUMERIC(12, 2) NOT NULL,
    UNIQUE (bill_id, participant_id)
);

CREATE INDEX idx_bill_final_amounts_bill_id ON bill_final_amounts(bill_id);
