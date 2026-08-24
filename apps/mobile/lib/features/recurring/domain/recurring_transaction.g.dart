// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecurringTransaction _$RecurringTransactionFromJson(
  Map<String, dynamic> json,
) => _RecurringTransaction(
  id: json['id'] as String,
  accountId: json['accountId'] as String,
  type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
  direction: $enumDecode(_$TransactionDirectionEnumMap, json['direction']),
  categoryId: json['categoryId'] as String?,
  amount: const AmountConverter().fromJson(json['amount']),
  merchant: json['merchant'] as String?,
  description: json['description'] as String?,
  notes: json['notes'] as String?,
  frequency: $enumDecode(_$RecurrenceFrequencyEnumMap, json['frequency']),
  intervalCount: (json['intervalCount'] as num).toInt(),
  startDate: json['startDate'] as String,
  endDate: json['endDate'] as String?,
  nextOccurrenceDate: json['nextOccurrenceDate'] as String,
  isSubscription: json['isSubscription'] as bool,
  active: json['active'] as bool,
);

Map<String, dynamic> _$RecurringTransactionToJson(
  _RecurringTransaction instance,
) => <String, dynamic>{
  'id': instance.id,
  'accountId': instance.accountId,
  'type': _$TransactionTypeEnumMap[instance.type]!,
  'direction': _$TransactionDirectionEnumMap[instance.direction]!,
  'categoryId': instance.categoryId,
  'amount': const AmountConverter().toJson(instance.amount),
  'merchant': instance.merchant,
  'description': instance.description,
  'notes': instance.notes,
  'frequency': _$RecurrenceFrequencyEnumMap[instance.frequency]!,
  'intervalCount': instance.intervalCount,
  'startDate': instance.startDate,
  'endDate': instance.endDate,
  'nextOccurrenceDate': instance.nextOccurrenceDate,
  'isSubscription': instance.isSubscription,
  'active': instance.active,
};

const _$TransactionTypeEnumMap = {
  TransactionType.INCOME: 'INCOME',
  TransactionType.EXPENSE: 'EXPENSE',
  TransactionType.TRANSFER: 'TRANSFER',
};

const _$TransactionDirectionEnumMap = {
  TransactionDirection.IN: 'IN',
  TransactionDirection.OUT: 'OUT',
};

const _$RecurrenceFrequencyEnumMap = {
  RecurrenceFrequency.DAILY: 'DAILY',
  RecurrenceFrequency.WEEKLY: 'WEEKLY',
  RecurrenceFrequency.MONTHLY: 'MONTHLY',
  RecurrenceFrequency.YEARLY: 'YEARLY',
};

_SubscriptionsSummary _$SubscriptionsSummaryFromJson(
  Map<String, dynamic> json,
) => _SubscriptionsSummary(
  estimatedMonthlyTotal: const AmountConverter().fromJson(
    json['estimatedMonthlyTotal'],
  ),
  subscriptions: (json['subscriptions'] as List<dynamic>)
      .map((e) => RecurringTransaction.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SubscriptionsSummaryToJson(
  _SubscriptionsSummary instance,
) => <String, dynamic>{
  'estimatedMonthlyTotal': const AmountConverter().toJson(
    instance.estimatedMonthlyTotal,
  ),
  'subscriptions': instance.subscriptions,
};
