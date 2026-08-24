-- V2 Phase 11: Cross-Space Accounting (spec sections 58-61; the master
-- prompt's own literal Phase 11 bullet list: personal-paid business
-- expense, reimbursement, owner contribution, owner drawing, due
-- to/from owner, cross-space references, consolidated personal
-- reporting).

ALTER TABLE journal_entries DROP CONSTRAINT journal_entries_source_type_check;
ALTER TABLE journal_entries ADD CONSTRAINT journal_entries_source_type_check CHECK (source_type IN
    ('MANUAL', 'INVOICE_ISSUED', 'INVOICE_PAYMENT', 'EXPENSE_PAYMENT', 'CREDIT_NOTE', 'INVENTORY_PURCHASE', 'INVENTORY_COGS',
     'ASSET_ACQUIRED', 'ASSET_DEPRECIATION', 'ASSET_DISPOSAL',
     'BUSINESS_ADVANCE', 'REIMBURSEMENT', 'OWNER_CONTRIBUTION', 'OWNER_DRAWING'));

-- Section 58's "cross-space references" -- links an existing Personal
-- transaction to the real Business journal entry it produced, without
-- ever merging the two ledgers. Every row is append-only: a link is
-- never edited, only ever created (and, for a reimbursement, related
-- back to the advance it settles via related_link_id).
CREATE TABLE cross_space_links (
    id                         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    personal_user_id          UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    business_space_id         UUID NOT NULL REFERENCES financial_spaces(id) ON DELETE CASCADE,
    link_type                 VARCHAR(20) NOT NULL CHECK (link_type IN
                                  ('BUSINESS_ADVANCE', 'REIMBURSEMENT', 'OWNER_CONTRIBUTION', 'OWNER_DRAWING')),
    personal_transaction_id   UUID NOT NULL REFERENCES transactions(id) ON DELETE CASCADE,
    business_journal_entry_id UUID REFERENCES journal_entries(id) ON DELETE SET NULL,
    related_link_id           UUID REFERENCES cross_space_links(id) ON DELETE SET NULL,
    amount                    NUMERIC(14, 2) NOT NULL CHECK (amount > 0),
    description                VARCHAR(255),
    created_by_user_id        UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at                 TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_cross_space_links_personal_user_id ON cross_space_links(personal_user_id);
CREATE INDEX idx_cross_space_links_business_space_id ON cross_space_links(business_space_id);
CREATE INDEX idx_cross_space_links_personal_transaction_id ON cross_space_links(personal_transaction_id);
