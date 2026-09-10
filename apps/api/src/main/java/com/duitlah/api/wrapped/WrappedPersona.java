package com.duitlah.api.wrapped;

import java.math.BigDecimal;
import java.util.List;

/**
 * Screen 03's persona reveal (spec section 16) — every number here traces back to a real {@link
 * PersonaScore}, never invented for the reveal.
 */
public record WrappedPersona(
    String id,
    String name,
    String tagline,
    String visualTheme,
    BigDecimal amount,
    BigDecimal percentage,
    String denominatorLabel,
    BigDecimal score,
    List<String> evidence) {

  static WrappedPersona from(MoneyPersonaDefinition definition, PersonaScore score) {
    return new WrappedPersona(
        definition.id().name(),
        definition.displayName(),
        definition.tagline(),
        definition.visualTheme(),
        score.amount(),
        score.percentage(),
        score.denominatorLabel(),
        score.score(),
        score.evidence());
  }
}
