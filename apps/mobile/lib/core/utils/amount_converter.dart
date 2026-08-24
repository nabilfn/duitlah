import 'package:json_annotation/json_annotation.dart';

/// Every "amount" field in the backend is a Java `BigDecimal`, but Jackson
/// serializes `BigDecimal` as a bare JSON number by default — e.g.
/// `"tax":0.00`, not `"tax":"0.00"` — confirmed by hitting the real API
/// directly. The web app's TypeScript types claim `string` for these
/// fields, but that's never actually enforced at runtime by JavaScript, so
/// the mismatch was invisible there. Dart's `json_serializable` DOES
/// enforce types, so a bare `as String` cast on a JSON number throws.
///
/// This converter accepts either shape (defensively, in case a future
/// backend change adds `@JsonFormat(shape = STRING)`) and normalizes to a
/// Dart `String` — which is what the rest of this app expects, since every
/// amount here is display-only and never used for arithmetic
/// (docs/bagilah-engine.md's calculation engine owns all real math).
class AmountConverter implements JsonConverter<String, Object?> {
  const AmountConverter();

  @override
  String fromJson(Object? json) {
    if (json == null) return '0';
    if (json is String) return json;
    return json.toString();
  }

  @override
  Object? toJson(String object) => object;
}

/// Same as [AmountConverter] but for optional amount fields.
class NullableAmountConverter implements JsonConverter<String?, Object?> {
  const NullableAmountConverter();

  @override
  String? fromJson(Object? json) {
    if (json == null) return null;
    if (json is String) return json;
    return json.toString();
  }

  @override
  Object? toJson(String? object) => object;
}
