package com.duitlah.api.spaces;

/**
 * Business RBAC foundation (V2 spec section 33). PERSONAL spaces only ever use {@link #OWNER} --
 * the remaining roles exist for BUSINESS spaces, whose actual permission enforcement per role is
 * built out module-by-module as each Business feature (invoicing, accounting, ...) arrives in later
 * phases, not all at once here.
 */
public enum SpaceRole {
  OWNER,
  ADMIN,
  FINANCE,
  ACCOUNTANT,
  SALES,
  STAFF,
  VIEWER
}
