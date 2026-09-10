package com.duitlah.api.wrapped;

import java.math.BigDecimal;
import java.util.List;

/**
 * One persona's evaluated score for a month, evidence retained per spec section 36 (explainability)
 * even though the mobile UI only ever shows a fraction of it.
 */
public record PersonaScore(
    MoneyPersonaId id,
    BigDecimal score,
    BigDecimal amount,
    BigDecimal percentage,
    String denominatorLabel,
    List<String> evidence) {}
