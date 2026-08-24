// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_health.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HealthComponent _$HealthComponentFromJson(Map<String, dynamic> json) =>
    _HealthComponent(
      key: json['key'] as String,
      label: json['label'] as String,
      score: const AmountConverter().fromJson(json['score']),
      weight: const AmountConverter().fromJson(json['weight']),
      explanation: json['explanation'] as String,
    );

Map<String, dynamic> _$HealthComponentToJson(_HealthComponent instance) =>
    <String, dynamic>{
      'key': instance.key,
      'label': instance.label,
      'score': const AmountConverter().toJson(instance.score),
      'weight': const AmountConverter().toJson(instance.weight),
      'explanation': instance.explanation,
    };

_FinancialHealth _$FinancialHealthFromJson(Map<String, dynamic> json) =>
    _FinancialHealth(
      score: const AmountConverter().fromJson(json['score']),
      components: (json['components'] as List<dynamic>)
          .map((e) => HealthComponent.fromJson(e as Map<String, dynamic>))
          .toList(),
      recommendations: (json['recommendations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$FinancialHealthToJson(_FinancialHealth instance) =>
    <String, dynamic>{
      'score': const AmountConverter().toJson(instance.score),
      'components': instance.components,
      'recommendations': instance.recommendations,
    };
