// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_entries.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JournalEntryLine _$JournalEntryLineFromJson(Map<String, dynamic> json) =>
    _JournalEntryLine(
      id: json['id'] as String,
      accountId: json['accountId'] as String,
      accountCode: json['accountCode'] as String,
      accountName: json['accountName'] as String,
      direction: $enumDecode(_$LedgerDirectionEnumMap, json['direction']),
      amount: const AmountConverter().fromJson(json['amount']),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$JournalEntryLineToJson(_JournalEntryLine instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accountId': instance.accountId,
      'accountCode': instance.accountCode,
      'accountName': instance.accountName,
      'direction': _$LedgerDirectionEnumMap[instance.direction]!,
      'amount': const AmountConverter().toJson(instance.amount),
      'description': instance.description,
    };

const _$LedgerDirectionEnumMap = {
  LedgerDirection.DEBIT: 'DEBIT',
  LedgerDirection.CREDIT: 'CREDIT',
};

_JournalEntry _$JournalEntryFromJson(Map<String, dynamic> json) =>
    _JournalEntry(
      id: json['id'] as String,
      entryDate: json['entryDate'] as String,
      description: json['description'] as String,
      sourceType: $enumDecode(_$JournalSourceTypeEnumMap, json['sourceType']),
      sourceId: json['sourceId'] as String?,
      lines: (json['lines'] as List<dynamic>)
          .map((e) => JournalEntryLine.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$JournalEntryToJson(_JournalEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entryDate': instance.entryDate,
      'description': instance.description,
      'sourceType': _$JournalSourceTypeEnumMap[instance.sourceType]!,
      'sourceId': instance.sourceId,
      'lines': instance.lines,
    };

const _$JournalSourceTypeEnumMap = {
  JournalSourceType.MANUAL: 'MANUAL',
  JournalSourceType.INVOICE_ISSUED: 'INVOICE_ISSUED',
  JournalSourceType.INVOICE_PAYMENT: 'INVOICE_PAYMENT',
  JournalSourceType.EXPENSE_PAYMENT: 'EXPENSE_PAYMENT',
  JournalSourceType.CREDIT_NOTE: 'CREDIT_NOTE',
};
