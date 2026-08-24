package com.duitlah.api.ai;

/**
 * V2 Phase 12 — the three workspace contexts spec section 66 names ("AI must understand active
 * Financial Space"). {@code SHARED} isn't a {@code spaces.SpaceType} (there is no SHARED space in
 * this codebase's model) — it means Groups/Bagilah/Settlements, the pre-existing "money split
 * between people" concept, structurally separate from a {@code FinancialSpace}.
 */
public enum AiToolContext {
  PERSONAL,
  BUSINESS,
  SHARED
}
