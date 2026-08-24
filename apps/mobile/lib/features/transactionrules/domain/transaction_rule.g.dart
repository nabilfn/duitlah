// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionRule _$TransactionRuleFromJson(Map<String, dynamic> json) =>
    _TransactionRule(
      id: json['id'] as String,
      matchType: $enumDecode(_$MatchTypeEnumMap, json['matchType']),
      matchValue: json['matchValue'] as String,
      categoryId: json['categoryId'] as String,
      priority: (json['priority'] as num).toInt(),
      active: json['active'] as bool,
      learned: json['learned'] as bool,
    );

Map<String, dynamic> _$TransactionRuleToJson(_TransactionRule instance) =>
    <String, dynamic>{
      'id': instance.id,
      'matchType': _$MatchTypeEnumMap[instance.matchType]!,
      'matchValue': instance.matchValue,
      'categoryId': instance.categoryId,
      'priority': instance.priority,
      'active': instance.active,
      'learned': instance.learned,
    };

const _$MatchTypeEnumMap = {
  MatchType.MERCHANT_EQUALS: 'MERCHANT_EQUALS',
  MatchType.MERCHANT_CONTAINS: 'MERCHANT_CONTAINS',
};
