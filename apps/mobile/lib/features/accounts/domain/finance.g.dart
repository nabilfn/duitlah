// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Account _$AccountFromJson(Map<String, dynamic> json) => _Account(
  id: json['id'] as String,
  name: json['name'] as String,
  type: $enumDecode(_$AccountTypeEnumMap, json['type']),
  currency: json['currency'] as String,
  openingBalance: const AmountConverter().fromJson(json['openingBalance']),
  balance: const AmountConverter().fromJson(json['balance']),
  archived: json['archived'] as bool,
);

Map<String, dynamic> _$AccountToJson(_Account instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': _$AccountTypeEnumMap[instance.type]!,
  'currency': instance.currency,
  'openingBalance': const AmountConverter().toJson(instance.openingBalance),
  'balance': const AmountConverter().toJson(instance.balance),
  'archived': instance.archived,
};

const _$AccountTypeEnumMap = {
  AccountType.CASH: 'CASH',
  AccountType.BANK: 'BANK',
  AccountType.E_WALLET: 'E_WALLET',
  AccountType.CREDIT_CARD: 'CREDIT_CARD',
  AccountType.SAVINGS: 'SAVINGS',
  AccountType.INVESTMENT: 'INVESTMENT',
  AccountType.OTHER: 'OTHER',
};

_Category _$CategoryFromJson(Map<String, dynamic> json) => _Category(
  id: json['id'] as String,
  parentId: json['parentId'] as String?,
  type: $enumDecode(_$CategoryTypeEnumMap, json['type']),
  name: json['name'] as String,
  icon: json['icon'] as String?,
  custom: json['custom'] as bool,
);

Map<String, dynamic> _$CategoryToJson(_Category instance) => <String, dynamic>{
  'id': instance.id,
  'parentId': instance.parentId,
  'type': _$CategoryTypeEnumMap[instance.type]!,
  'name': instance.name,
  'icon': instance.icon,
  'custom': instance.custom,
};

const _$CategoryTypeEnumMap = {
  CategoryType.INCOME: 'INCOME',
  CategoryType.EXPENSE: 'EXPENSE',
};

_Transaction _$TransactionFromJson(Map<String, dynamic> json) => _Transaction(
  id: json['id'] as String,
  accountId: json['accountId'] as String,
  type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
  direction: $enumDecode(_$TransactionDirectionEnumMap, json['direction']),
  categoryId: json['categoryId'] as String?,
  transferGroupId: json['transferGroupId'] as String?,
  recurringTransactionId: json['recurringTransactionId'] as String?,
  amount: const AmountConverter().fromJson(json['amount']),
  merchant: json['merchant'] as String?,
  description: json['description'] as String?,
  notes: json['notes'] as String?,
  occurredOn: json['occurredOn'] as String,
);

Map<String, dynamic> _$TransactionToJson(_Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accountId': instance.accountId,
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'direction': _$TransactionDirectionEnumMap[instance.direction]!,
      'categoryId': instance.categoryId,
      'transferGroupId': instance.transferGroupId,
      'recurringTransactionId': instance.recurringTransactionId,
      'amount': const AmountConverter().toJson(instance.amount),
      'merchant': instance.merchant,
      'description': instance.description,
      'notes': instance.notes,
      'occurredOn': instance.occurredOn,
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

_DashboardSummary _$DashboardSummaryFromJson(Map<String, dynamic> json) =>
    _DashboardSummary(
      availableBalance: const AmountConverter().fromJson(
        json['availableBalance'],
      ),
      monthIncome: const AmountConverter().fromJson(json['monthIncome']),
      monthExpense: const AmountConverter().fromJson(json['monthExpense']),
      recentTransactions: (json['recentTransactions'] as List<dynamic>)
          .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DashboardSummaryToJson(
  _DashboardSummary instance,
) => <String, dynamic>{
  'availableBalance': const AmountConverter().toJson(instance.availableBalance),
  'monthIncome': const AmountConverter().toJson(instance.monthIncome),
  'monthExpense': const AmountConverter().toJson(instance.monthExpense),
  'recentTransactions': instance.recentTransactions,
};

_TransactionPage _$TransactionPageFromJson(Map<String, dynamic> json) =>
    _TransactionPage(
      content: (json['content'] as List<dynamic>)
          .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalElements: (json['totalElements'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      number: (json['number'] as num).toInt(),
      size: (json['size'] as num).toInt(),
    );

Map<String, dynamic> _$TransactionPageToJson(_TransactionPage instance) =>
    <String, dynamic>{
      'content': instance.content,
      'totalElements': instance.totalElements,
      'totalPages': instance.totalPages,
      'number': instance.number,
      'size': instance.size,
    };
