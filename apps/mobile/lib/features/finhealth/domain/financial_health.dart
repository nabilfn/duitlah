import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/amount_converter.dart';

part 'financial_health.freezed.dart';
part 'financial_health.g.dart';

@freezed
abstract class HealthComponent with _$HealthComponent {
  const factory HealthComponent({
    required String key,
    required String label,
    @AmountConverter() required String score,
    @AmountConverter() required String weight,
    required String explanation,
  }) = _HealthComponent;

  factory HealthComponent.fromJson(Map<String, dynamic> json) => _$HealthComponentFromJson(json);
}

@freezed
abstract class FinancialHealth with _$FinancialHealth {
  const factory FinancialHealth({
    @AmountConverter() required String score,
    required List<HealthComponent> components,
    required List<String> recommendations,
  }) = _FinancialHealth;

  factory FinancialHealth.fromJson(Map<String, dynamic> json) => _$FinancialHealthFromJson(json);
}
