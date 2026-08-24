// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_of_accounts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LedgerAccount _$LedgerAccountFromJson(Map<String, dynamic> json) =>
    _LedgerAccount(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$LedgerAccountTypeEnumMap, json['type']),
      systemDefault: json['systemDefault'] as bool,
      cashEquivalent: json['cashEquivalent'] as bool,
      archived: json['archived'] as bool,
    );

Map<String, dynamic> _$LedgerAccountToJson(_LedgerAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'type': _$LedgerAccountTypeEnumMap[instance.type]!,
      'systemDefault': instance.systemDefault,
      'cashEquivalent': instance.cashEquivalent,
      'archived': instance.archived,
    };

const _$LedgerAccountTypeEnumMap = {
  LedgerAccountType.ASSET: 'ASSET',
  LedgerAccountType.LIABILITY: 'LIABILITY',
  LedgerAccountType.EQUITY: 'EQUITY',
  LedgerAccountType.REVENUE: 'REVENUE',
  LedgerAccountType.EXPENSE: 'EXPENSE',
};
