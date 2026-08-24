package com.duitlah.api.budgets;

import java.math.BigDecimal;
import java.math.RoundingMode;

/**
 * A computed signal for the frontend to render (color, icon, copy) — never a
 * notification/email/push alert. That infrastructure doesn't exist yet (see docs/security.md's
 * EmailSender note) and "Basic Budgets" doesn't require it; this is the "Alerts" from the product
 * spec's Phase 4 scope for now. Keep language non-shaming either way — see PRODUCT.md.
 */
public enum BudgetStatus {
  OK,
  WARNING,
  EXCEEDED;

  private static final BigDecimal WARNING_THRESHOLD = new BigDecimal("0.80");

  public static BudgetStatus of(BigDecimal spent, BigDecimal limit) {
    if (limit.signum() <= 0) {
      return OK;
    }
    BigDecimal ratio = spent.divide(limit, 4, RoundingMode.HALF_UP);
    if (ratio.compareTo(BigDecimal.ONE) >= 0) {
      return EXCEEDED;
    }
    if (ratio.compareTo(WARNING_THRESHOLD) >= 0) {
      return WARNING;
    }
    return OK;
  }
}
