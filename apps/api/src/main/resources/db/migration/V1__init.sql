-- Phase 0 baseline. No domain tables yet — those are added module-by-module
-- starting in Phase 2 (auth/users). This migration establishes the
-- extensions every later migration will depend on.

CREATE EXTENSION IF NOT EXISTS pgcrypto;
