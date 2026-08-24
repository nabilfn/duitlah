-- Phase 13: Premium Subscriptions (product spec sections 53-56). Duitlah's
-- own verified entitlement state, deliberately not a mirror of Apple/
-- Google/Stripe's own subscription object -- see SubscriptionVerifier for
-- why the provider never becomes the app's permission model.
--
-- No row at all means FREE: a user only gets a row here once they
-- actually verify a real purchase, rather than every user needing one
-- created at registration for a tier that's already the default.
CREATE TABLE user_subscriptions (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id             UUID NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    tier                VARCHAR(10) NOT NULL CHECK (tier IN ('FREE', 'PLUS')),
    source              VARCHAR(10) NOT NULL CHECK (source IN ('APPLE', 'GOOGLE', 'WEB')),
    external_reference  VARCHAR(255) NOT NULL,
    status              VARCHAR(20) NOT NULL
                        CHECK (status IN ('ACTIVE', 'EXPIRED', 'CANCELED', 'GRACE_PERIOD')),
    started_at          TIMESTAMPTZ NOT NULL,
    expires_at          TIMESTAMPTZ,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);
