// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationRule _$NotificationRuleFromJson(Map<String, dynamic> json) =>
    _NotificationRule(
      type: $enumDecode(_$NotificationRuleTypeEnumMap, json['type']),
      enabled: json['enabled'] as bool,
      thresholdAmount: const NullableAmountConverter().fromJson(
        json['thresholdAmount'],
      ),
    );

Map<String, dynamic> _$NotificationRuleToJson(_NotificationRule instance) =>
    <String, dynamic>{
      'type': _$NotificationRuleTypeEnumMap[instance.type]!,
      'enabled': instance.enabled,
      'thresholdAmount': const NullableAmountConverter().toJson(
        instance.thresholdAmount,
      ),
    };

const _$NotificationRuleTypeEnumMap = {
  NotificationRuleType.BILL_DUE_SOON: 'BILL_DUE_SOON',
  NotificationRuleType.BILL_OVERDUE: 'BILL_OVERDUE',
  NotificationRuleType.LOW_STOCK_ALERT: 'LOW_STOCK_ALERT',
  NotificationRuleType.BUDGET_EXCEEDED: 'BUDGET_EXCEEDED',
  NotificationRuleType.LOW_BALANCE: 'LOW_BALANCE',
};
