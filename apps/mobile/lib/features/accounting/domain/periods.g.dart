// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'periods.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountingPeriod _$AccountingPeriodFromJson(Map<String, dynamic> json) =>
    _AccountingPeriod(
      id: json['id'] as String,
      periodStart: json['periodStart'] as String,
      periodEnd: json['periodEnd'] as String,
      status: $enumDecode(_$AccountingPeriodStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$AccountingPeriodToJson(_AccountingPeriod instance) =>
    <String, dynamic>{
      'id': instance.id,
      'periodStart': instance.periodStart,
      'periodEnd': instance.periodEnd,
      'status': _$AccountingPeriodStatusEnumMap[instance.status]!,
    };

const _$AccountingPeriodStatusEnumMap = {
  AccountingPeriodStatus.OPEN: 'OPEN',
  AccountingPeriodStatus.CLOSED: 'CLOSED',
};
