// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insights.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CategorySpending _$CategorySpendingFromJson(Map<String, dynamic> json) =>
    _CategorySpending(
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      amount: const AmountConverter().fromJson(json['amount']),
    );

Map<String, dynamic> _$CategorySpendingToJson(_CategorySpending instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'amount': const AmountConverter().toJson(instance.amount),
    };

_MonthlyTrend _$MonthlyTrendFromJson(Map<String, dynamic> json) =>
    _MonthlyTrend(
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      income: const AmountConverter().fromJson(json['income']),
      expense: const AmountConverter().fromJson(json['expense']),
      savings: const AmountConverter().fromJson(json['savings']),
    );

Map<String, dynamic> _$MonthlyTrendToJson(_MonthlyTrend instance) =>
    <String, dynamic>{
      'year': instance.year,
      'month': instance.month,
      'income': const AmountConverter().toJson(instance.income),
      'expense': const AmountConverter().toJson(instance.expense),
      'savings': const AmountConverter().toJson(instance.savings),
    };

_MerchantSpending _$MerchantSpendingFromJson(Map<String, dynamic> json) =>
    _MerchantSpending(
      merchant: json['merchant'] as String,
      amount: const AmountConverter().fromJson(json['amount']),
      transactionCount: (json['transactionCount'] as num).toInt(),
    );

Map<String, dynamic> _$MerchantSpendingToJson(_MerchantSpending instance) =>
    <String, dynamic>{
      'merchant': instance.merchant,
      'amount': const AmountConverter().toJson(instance.amount),
      'transactionCount': instance.transactionCount,
    };

_CalendarEntry _$CalendarEntryFromJson(Map<String, dynamic> json) =>
    _CalendarEntry(
      date: json['date'] as String,
      confirmed: json['confirmed'] as bool,
      type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
      direction: $enumDecode(_$TransactionDirectionEnumMap, json['direction']),
      amount: const AmountConverter().fromJson(json['amount']),
      merchant: json['merchant'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$CalendarEntryToJson(_CalendarEntry instance) =>
    <String, dynamic>{
      'date': instance.date,
      'confirmed': instance.confirmed,
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'direction': _$TransactionDirectionEnumMap[instance.direction]!,
      'amount': const AmountConverter().toJson(instance.amount),
      'merchant': instance.merchant,
      'description': instance.description,
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

_Forecast _$ForecastFromJson(Map<String, dynamic> json) => _Forecast(
  currentBalance: const AmountConverter().fromJson(json['currentBalance']),
  asOfDate: json['asOfDate'] as String,
  targetDate: json['targetDate'] as String,
  scheduledIncome: const AmountConverter().fromJson(json['scheduledIncome']),
  scheduledExpense: const AmountConverter().fromJson(json['scheduledExpense']),
  predictedVariableExpense: const AmountConverter().fromJson(
    json['predictedVariableExpense'],
  ),
  projectedBalance: const AmountConverter().fromJson(json['projectedBalance']),
  disclaimer: json['disclaimer'] as String,
);

Map<String, dynamic> _$ForecastToJson(_Forecast instance) => <String, dynamic>{
  'currentBalance': const AmountConverter().toJson(instance.currentBalance),
  'asOfDate': instance.asOfDate,
  'targetDate': instance.targetDate,
  'scheduledIncome': const AmountConverter().toJson(instance.scheduledIncome),
  'scheduledExpense': const AmountConverter().toJson(instance.scheduledExpense),
  'predictedVariableExpense': const AmountConverter().toJson(
    instance.predictedVariableExpense,
  ),
  'projectedBalance': const AmountConverter().toJson(instance.projectedBalance),
  'disclaimer': instance.disclaimer,
};
