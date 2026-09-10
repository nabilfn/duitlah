package com.duitlah.api.wrapped;

import java.math.BigDecimal;
import java.util.Set;

/**
 * One leaf category's expense activity for a month — richer than {@code
 * analytics.CategorySpendingResponse} (which only ever needs an amount) because {@link
 * MoneyPersonaEngine}'s scoring formula also needs transaction frequency and merchant variety per
 * category. Grouped by category name rather than id, so a global category and a same-named custom
 * one never need to be told apart for Wrapped's purposes — the amount is what matters.
 */
public record LeafCategoryStats(
    String categoryName, BigDecimal amount, int transactionCount, Set<String> merchants) {}
