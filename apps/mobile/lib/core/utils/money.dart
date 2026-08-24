/// Display-only formatting for amounts that are ALWAYS decimal strings from
/// the API (`BigDecimal` on the backend — see docs/bagilah-engine.md). Never
/// parse these to `double` for arithmetic; only for rendering. Every
/// authoritative calculation (splits, totals, settlements) happens in
/// Spring Boot, per the Phase 9.5 one-source-of-truth rule.
class Money {
  Money._();

  /// Formats a decimal-string amount as "RM 12.34", trusting the string's
  /// own decimal placement rather than re-deriving it — `num.parse` here is
  /// solely to normalize e.g. "12" -> "12.00" for display, never to add,
  /// subtract, or otherwise recompute the value.
  static String format(String amount, {String currency = 'RM'}) {
    final value = num.tryParse(amount) ?? 0;
    return '$currency ${value.toStringAsFixed(2)}';
  }

  /// Same as [format] but without the currency prefix, for compact contexts
  /// (amount fields already labeled by a nearby currency badge).
  static String plain(String amount) {
    final value = num.tryParse(amount) ?? 0;
    return value.toStringAsFixed(2);
  }

  static bool isPositive(String amount) => (num.tryParse(amount) ?? 0) > 0;

  static bool isNegative(String amount) => (num.tryParse(amount) ?? 0) < 0;
}
