-- Phase 14 (Hardening): audit logs for sensitive actions (product spec
-- section 50). `actor_user_id` is ON DELETE SET NULL rather than CASCADE
-- -- the entire point of an audit trail is a historical record that must
-- outlive the account that produced it, not disappear the moment a user
-- is deleted.
CREATE TABLE audit_logs (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    actor_user_id   UUID REFERENCES users(id) ON DELETE SET NULL,
    action          VARCHAR(50) NOT NULL,
    entity_type     VARCHAR(50) NOT NULL,
    entity_id       UUID,
    metadata        TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_audit_logs_actor_user_id ON audit_logs(actor_user_id);
CREATE INDEX idx_audit_logs_entity ON audit_logs(entity_type, entity_id);
