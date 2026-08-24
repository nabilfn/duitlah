// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settlement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaymentHandoffLink _$PaymentHandoffLinkFromJson(Map<String, dynamic> json) =>
    _PaymentHandoffLink(
      provider: json['provider'] as String,
      instructions: json['instructions'] as String,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$PaymentHandoffLinkToJson(_PaymentHandoffLink instance) =>
    <String, dynamic>{
      'provider': instance.provider,
      'instructions': instance.instructions,
      'url': instance.url,
    };

_Settlement _$SettlementFromJson(Map<String, dynamic> json) => _Settlement(
  id: json['id'] as String,
  fromUserId: json['fromUserId'] as String,
  fromDisplayName: json['fromDisplayName'] as String,
  toUserId: json['toUserId'] as String,
  toDisplayName: json['toDisplayName'] as String,
  amount: const AmountConverter().fromJson(json['amount']),
  amountPaid: const AmountConverter().fromJson(json['amountPaid']),
  amountRemaining: const AmountConverter().fromJson(json['amountRemaining']),
  status: $enumDecode(_$SettlementStatusEnumMap, json['status']),
  sourceType: $enumDecode(_$SourceTypeEnumMap, json['sourceType']),
  sourceId: json['sourceId'] as String,
  createdAt: json['createdAt'] as String,
  handoff: PaymentHandoffLink.fromJson(json['handoff'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SettlementToJson(
  _Settlement instance,
) => <String, dynamic>{
  'id': instance.id,
  'fromUserId': instance.fromUserId,
  'fromDisplayName': instance.fromDisplayName,
  'toUserId': instance.toUserId,
  'toDisplayName': instance.toDisplayName,
  'amount': const AmountConverter().toJson(instance.amount),
  'amountPaid': const AmountConverter().toJson(instance.amountPaid),
  'amountRemaining': const AmountConverter().toJson(instance.amountRemaining),
  'status': _$SettlementStatusEnumMap[instance.status]!,
  'sourceType': _$SourceTypeEnumMap[instance.sourceType]!,
  'sourceId': instance.sourceId,
  'createdAt': instance.createdAt,
  'handoff': instance.handoff,
};

const _$SettlementStatusEnumMap = {
  SettlementStatus.UNPAID: 'UNPAID',
  SettlementStatus.PARTIALLY_PAID: 'PARTIALLY_PAID',
  SettlementStatus.PAID: 'PAID',
  SettlementStatus.CANCELLED: 'CANCELLED',
  SettlementStatus.DISPUTED: 'DISPUTED',
};

const _$SourceTypeEnumMap = {
  SourceType.BILL: 'BILL',
  SourceType.GROUP: 'GROUP',
};

_SettlementPayment _$SettlementPaymentFromJson(Map<String, dynamic> json) =>
    _SettlementPayment(
      id: json['id'] as String,
      amount: const AmountConverter().fromJson(json['amount']),
      recordedByUserId: json['recordedByUserId'] as String,
      recordedByDisplayName: json['recordedByDisplayName'] as String,
      note: json['note'] as String?,
      paidAt: json['paidAt'] as String,
    );

Map<String, dynamic> _$SettlementPaymentToJson(_SettlementPayment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': const AmountConverter().toJson(instance.amount),
      'recordedByUserId': instance.recordedByUserId,
      'recordedByDisplayName': instance.recordedByDisplayName,
      'note': instance.note,
      'paidAt': instance.paidAt,
    };

_CounterpartySummary _$CounterpartySummaryFromJson(Map<String, dynamic> json) =>
    _CounterpartySummary(
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      netAmount: const AmountConverter().fromJson(json['netAmount']),
      oldestUnpaidDays: (json['oldestUnpaidDays'] as num).toInt(),
    );

Map<String, dynamic> _$CounterpartySummaryToJson(
  _CounterpartySummary instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'displayName': instance.displayName,
  'netAmount': const AmountConverter().toJson(instance.netAmount),
  'oldestUnpaidDays': instance.oldestUnpaidDays,
};

_SettlementSummary _$SettlementSummaryFromJson(Map<String, dynamic> json) =>
    _SettlementSummary(
      totalOwedToMe: const AmountConverter().fromJson(json['totalOwedToMe']),
      totalIOwe: const AmountConverter().fromJson(json['totalIOwe']),
      owedToMe: (json['owedToMe'] as List<dynamic>)
          .map((e) => CounterpartySummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      iOwe: (json['iOwe'] as List<dynamic>)
          .map((e) => CounterpartySummary.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SettlementSummaryToJson(_SettlementSummary instance) =>
    <String, dynamic>{
      'totalOwedToMe': const AmountConverter().toJson(instance.totalOwedToMe),
      'totalIOwe': const AmountConverter().toJson(instance.totalIOwe),
      'owedToMe': instance.owedToMe,
      'iOwe': instance.iOwe,
    };
