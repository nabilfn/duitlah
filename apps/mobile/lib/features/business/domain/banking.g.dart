// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BusinessAccount _$BusinessAccountFromJson(Map<String, dynamic> json) =>
    _BusinessAccount(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$BusinessAccountTypeEnumMap, json['type']),
      currency: json['currency'] as String,
      openingBalance: const AmountConverter().fromJson(json['openingBalance']),
      balance: const AmountConverter().fromJson(json['balance']),
      chartOfAccountsId: json['chartOfAccountsId'] as String?,
      archived: json['archived'] as bool,
    );

Map<String, dynamic> _$BusinessAccountToJson(_BusinessAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$BusinessAccountTypeEnumMap[instance.type]!,
      'currency': instance.currency,
      'openingBalance': const AmountConverter().toJson(instance.openingBalance),
      'balance': const AmountConverter().toJson(instance.balance),
      'chartOfAccountsId': instance.chartOfAccountsId,
      'archived': instance.archived,
    };

const _$BusinessAccountTypeEnumMap = {
  BusinessAccountType.BANK: 'BANK',
  BusinessAccountType.CASH: 'CASH',
  BusinessAccountType.E_WALLET: 'E_WALLET',
  BusinessAccountType.CREDIT_CARD: 'CREDIT_CARD',
};

_AccountEntry _$AccountEntryFromJson(Map<String, dynamic> json) =>
    _AccountEntry(
      id: json['id'] as String,
      direction: $enumDecode(_$EntryDirectionEnumMap, json['direction']),
      amount: const AmountConverter().fromJson(json['amount']),
      occurredOn: json['occurredOn'] as String,
      description: json['description'] as String?,
      transferGroupId: json['transferGroupId'] as String?,
    );

Map<String, dynamic> _$AccountEntryToJson(_AccountEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'direction': _$EntryDirectionEnumMap[instance.direction]!,
      'amount': const AmountConverter().toJson(instance.amount),
      'occurredOn': instance.occurredOn,
      'description': instance.description,
      'transferGroupId': instance.transferGroupId,
    };

const _$EntryDirectionEnumMap = {
  EntryDirection.IN: 'IN',
  EntryDirection.OUT: 'OUT',
};
