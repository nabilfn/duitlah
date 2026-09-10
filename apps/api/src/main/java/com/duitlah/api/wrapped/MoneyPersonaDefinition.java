package com.duitlah.api.wrapped;

import java.util.Set;

/**
 * Structured, config-like persona metadata (spec section 12) — kept in one place ({@link
 * MoneyPersonaEngine#DEFINITIONS}) rather than scattered across UI files. {@code
 * matchLeafCategoryNames} is empty for the four personas whose signal isn't a category at all
 * (Auto-Renew Royalty: subscriptions; Tabung Titan: savings rate; Budget Ninja: budget adherence) —
 * see {@link MoneyPersonaEngine} for how each of the four scoring shapes is computed.
 */
public record MoneyPersonaDefinition(
    MoneyPersonaId id,
    String displayName,
    String tagline,
    String visualTheme,
    Set<String> matchLeafCategoryNames) {}
