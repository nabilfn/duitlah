// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expenses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Expense _$ExpenseFromJson(Map<String, dynamic> json) => _Expense(
  id: json['id'] as String,
  supplierId: json['supplierId'] as String?,
  category: json['category'] as String?,
  amount: const AmountConverter().fromJson(json['amount']),
  amountPaid: const AmountConverter().fromJson(json['amountPaid']),
  amountRemaining: const AmountConverter().fromJson(json['amountRemaining']),
  occurredOn: json['occurredOn'] as String,
  status: $enumDecode(_$ExpenseStatusEnumMap, json['status']),
  receiptId: json['receiptId'] as String?,
  chartOfAccountsId: json['chartOfAccountsId'] as String?,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$ExpenseToJson(_Expense instance) => <String, dynamic>{
  'id': instance.id,
  'supplierId': instance.supplierId,
  'category': instance.category,
  'amount': const AmountConverter().toJson(instance.amount),
  'amountPaid': const AmountConverter().toJson(instance.amountPaid),
  'amountRemaining': const AmountConverter().toJson(instance.amountRemaining),
  'occurredOn': instance.occurredOn,
  'status': _$ExpenseStatusEnumMap[instance.status]!,
  'receiptId': instance.receiptId,
  'chartOfAccountsId': instance.chartOfAccountsId,
  'notes': instance.notes,
};

const _$ExpenseStatusEnumMap = {
  ExpenseStatus.UNPAID: 'UNPAID',
  ExpenseStatus.PARTIALLY_PAID: 'PARTIALLY_PAID',
  ExpenseStatus.PAID: 'PAID',
};

_ExpensePayment _$ExpensePaymentFromJson(Map<String, dynamic> json) =>
    _ExpensePayment(
      id: json['id'] as String,
      businessAccountId: json['businessAccountId'] as String,
      amount: const AmountConverter().fromJson(json['amount']),
      paidOn: json['paidOn'] as String,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$ExpensePaymentToJson(_ExpensePayment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessAccountId': instance.businessAccountId,
      'amount': const AmountConverter().toJson(instance.amount),
      'paidOn': instance.paidOn,
      'notes': instance.notes,
    };
