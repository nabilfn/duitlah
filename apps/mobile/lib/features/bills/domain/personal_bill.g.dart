// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_bill.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PersonalBill _$PersonalBillFromJson(Map<String, dynamic> json) =>
    _PersonalBill(
      id: json['id'] as String,
      name: json['name'] as String,
      provider: json['provider'] as String?,
      dueDate: json['dueDate'] as String,
      expectedAmount: const AmountConverter().fromJson(json['expectedAmount']),
      recurrence: $enumDecode(_$BillRecurrenceEnumMap, json['recurrence']),
      status: $enumDecode(_$BillStatusEnumMap, json['status']),
      linkedTransactionId: json['linkedTransactionId'] as String?,
      receiptId: json['receiptId'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$PersonalBillToJson(_PersonalBill instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'provider': instance.provider,
      'dueDate': instance.dueDate,
      'expectedAmount': const AmountConverter().toJson(instance.expectedAmount),
      'recurrence': _$BillRecurrenceEnumMap[instance.recurrence]!,
      'status': _$BillStatusEnumMap[instance.status]!,
      'linkedTransactionId': instance.linkedTransactionId,
      'receiptId': instance.receiptId,
      'notes': instance.notes,
    };

const _$BillRecurrenceEnumMap = {
  BillRecurrence.NONE: 'NONE',
  BillRecurrence.WEEKLY: 'WEEKLY',
  BillRecurrence.MONTHLY: 'MONTHLY',
  BillRecurrence.YEARLY: 'YEARLY',
};

const _$BillStatusEnumMap = {
  BillStatus.UPCOMING: 'UPCOMING',
  BillStatus.DUE: 'DUE',
  BillStatus.PAID: 'PAID',
  BillStatus.OVERDUE: 'OVERDUE',
  BillStatus.SKIPPED: 'SKIPPED',
};
