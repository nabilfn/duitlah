// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_tax.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SstRate _$SstRateFromJson(Map<String, dynamic> json) => _SstRate(
  taxType: $enumDecode(_$TaxTypeEnumMap, json['taxType']),
  ratePercent: const AmountConverter().fromJson(json['ratePercent']),
  effectiveFrom: json['effectiveFrom'] as String,
  effectiveTo: json['effectiveTo'] as String?,
  description: json['description'] as String?,
);

Map<String, dynamic> _$SstRateToJson(_SstRate instance) => <String, dynamic>{
  'taxType': _$TaxTypeEnumMap[instance.taxType]!,
  'ratePercent': const AmountConverter().toJson(instance.ratePercent),
  'effectiveFrom': instance.effectiveFrom,
  'effectiveTo': instance.effectiveTo,
  'description': instance.description,
};

const _$TaxTypeEnumMap = {TaxType.SALES: 'SALES', TaxType.SERVICE: 'SERVICE'};

_SstReport _$SstReportFromJson(Map<String, dynamic> json) => _SstReport(
  from: json['from'] as String,
  to: json['to'] as String,
  collectedTax: const AmountConverter().fromJson(json['collectedTax']),
  payableTax: const AmountConverter().fromJson(json['payableTax']),
);

Map<String, dynamic> _$SstReportToJson(_SstReport instance) =>
    <String, dynamic>{
      'from': instance.from,
      'to': instance.to,
      'collectedTax': const AmountConverter().toJson(instance.collectedTax),
      'payableTax': const AmountConverter().toJson(instance.payableTax),
    };

_EInvoiceReadiness _$EInvoiceReadinessFromJson(Map<String, dynamic> json) =>
    _EInvoiceReadiness(
      mandated: json['mandated'] as bool,
      currentRuleEffectiveDate: json['currentRuleEffectiveDate'] as String?,
      currentRuleThreshold: const NullableAmountConverter().fromJson(
        json['currentRuleThreshold'],
      ),
      missingFields: (json['missingFields'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      ready: json['ready'] as bool,
    );

Map<String, dynamic> _$EInvoiceReadinessToJson(_EInvoiceReadiness instance) =>
    <String, dynamic>{
      'mandated': instance.mandated,
      'currentRuleEffectiveDate': instance.currentRuleEffectiveDate,
      'currentRuleThreshold': const NullableAmountConverter().toJson(
        instance.currentRuleThreshold,
      ),
      'missingFields': instance.missingFields,
      'ready': instance.ready,
    };
