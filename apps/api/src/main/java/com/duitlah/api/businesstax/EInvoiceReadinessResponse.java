package com.duitlah.api.businesstax;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * Spec section 57's onboarding checklist, evaluated against {@code spaces.BusinessProfile} and the
 * versioned mandate threshold — never a single hardcoded rule.
 */
public record EInvoiceReadinessResponse(
    boolean mandated,
    LocalDate currentRuleEffectiveDate,
    BigDecimal currentRuleThreshold,
    List<String> missingFields,
    boolean ready) {}
