// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Bill _$BillFromJson(Map<String, dynamic> json) => _Bill(
  id: json['id'] as String,
  ownerUserId: json['ownerUserId'] as String,
  groupId: json['groupId'] as String?,
  merchant: json['merchant'] as String?,
  receiptDate: json['receiptDate'] as String,
  currency: json['currency'] as String,
  tax: const AmountConverter().fromJson(json['tax']),
  taxStrategy: $enumDecode(_$AllocationStrategyEnumMap, json['taxStrategy']),
  serviceCharge: const AmountConverter().fromJson(json['serviceCharge']),
  serviceStrategy: $enumDecode(
    _$AllocationStrategyEnumMap,
    json['serviceStrategy'],
  ),
  discount: const AmountConverter().fromJson(json['discount']),
  discountLabel: json['discountLabel'] as String?,
  declaredTotal: const NullableAmountConverter().fromJson(
    json['declaredTotal'],
  ),
  total: const NullableAmountConverter().fromJson(json['total']),
  roundingAdjustment: const NullableAmountConverter().fromJson(
    json['roundingAdjustment'],
  ),
  status: $enumDecode(_$BillStatusEnumMap, json['status']),
  finalizedAt: json['finalizedAt'] as String?,
);

Map<String, dynamic> _$BillToJson(_Bill instance) => <String, dynamic>{
  'id': instance.id,
  'ownerUserId': instance.ownerUserId,
  'groupId': instance.groupId,
  'merchant': instance.merchant,
  'receiptDate': instance.receiptDate,
  'currency': instance.currency,
  'tax': const AmountConverter().toJson(instance.tax),
  'taxStrategy': _$AllocationStrategyEnumMap[instance.taxStrategy]!,
  'serviceCharge': const AmountConverter().toJson(instance.serviceCharge),
  'serviceStrategy': _$AllocationStrategyEnumMap[instance.serviceStrategy]!,
  'discount': const AmountConverter().toJson(instance.discount),
  'discountLabel': instance.discountLabel,
  'declaredTotal': const NullableAmountConverter().toJson(
    instance.declaredTotal,
  ),
  'total': const NullableAmountConverter().toJson(instance.total),
  'roundingAdjustment': const NullableAmountConverter().toJson(
    instance.roundingAdjustment,
  ),
  'status': _$BillStatusEnumMap[instance.status]!,
  'finalizedAt': instance.finalizedAt,
};

const _$AllocationStrategyEnumMap = {
  AllocationStrategy.PROPORTIONAL: 'PROPORTIONAL',
  AllocationStrategy.EQUAL: 'EQUAL',
};

const _$BillStatusEnumMap = {
  BillStatus.DRAFT: 'DRAFT',
  BillStatus.FINALIZED: 'FINALIZED',
  BillStatus.CANCELLED: 'CANCELLED',
};

_ReceiptItem _$ReceiptItemFromJson(Map<String, dynamic> json) => _ReceiptItem(
  id: json['id'] as String,
  name: json['name'] as String,
  quantity: const AmountConverter().fromJson(json['quantity']),
  unitPrice: const AmountConverter().fromJson(json['unitPrice']),
  itemDiscount: const AmountConverter().fromJson(json['itemDiscount']),
  totalPrice: const AmountConverter().fromJson(json['totalPrice']),
);

Map<String, dynamic> _$ReceiptItemToJson(_ReceiptItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'quantity': const AmountConverter().toJson(instance.quantity),
      'unitPrice': const AmountConverter().toJson(instance.unitPrice),
      'itemDiscount': const AmountConverter().toJson(instance.itemDiscount),
      'totalPrice': const AmountConverter().toJson(instance.totalPrice),
    };

_Participant _$ParticipantFromJson(Map<String, dynamic> json) => _Participant(
  id: json['id'] as String,
  userId: json['userId'] as String?,
  displayName: json['displayName'] as String,
  guest: json['guest'] as bool,
);

Map<String, dynamic> _$ParticipantToJson(_Participant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'displayName': instance.displayName,
      'guest': instance.guest,
    };

_Claim _$ClaimFromJson(Map<String, dynamic> json) => _Claim(
  id: json['id'] as String,
  participantId: json['participantId'] as String,
  displayName: json['displayName'] as String,
  claimType: $enumDecode(_$ClaimTypeEnumMap, json['claimType']),
  value: const AmountConverter().fromJson(json['value']),
);

Map<String, dynamic> _$ClaimToJson(_Claim instance) => <String, dynamic>{
  'id': instance.id,
  'participantId': instance.participantId,
  'displayName': instance.displayName,
  'claimType': _$ClaimTypeEnumMap[instance.claimType]!,
  'value': const AmountConverter().toJson(instance.value),
};

const _$ClaimTypeEnumMap = {
  ClaimType.QUANTITY: 'QUANTITY',
  ClaimType.PERCENTAGE: 'PERCENTAGE',
  ClaimType.AMOUNT: 'AMOUNT',
};

_BillPayment _$BillPaymentFromJson(Map<String, dynamic> json) => _BillPayment(
  participantId: json['participantId'] as String,
  displayName: json['displayName'] as String,
  amountPaid: const AmountConverter().fromJson(json['amountPaid']),
);

Map<String, dynamic> _$BillPaymentToJson(_BillPayment instance) =>
    <String, dynamic>{
      'participantId': instance.participantId,
      'displayName': instance.displayName,
      'amountPaid': const AmountConverter().toJson(instance.amountPaid),
    };

_ItemIssue _$ItemIssueFromJson(Map<String, dynamic> json) => _ItemIssue(
  itemId: json['itemId'] as String,
  itemName: json['itemName'] as String,
  type: $enumDecode(_$IssueTypeEnumMap, json['type']),
);

Map<String, dynamic> _$ItemIssueToJson(_ItemIssue instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'type': _$IssueTypeEnumMap[instance.type]!,
    };

const _$IssueTypeEnumMap = {
  IssueType.UNCLAIMED: 'UNCLAIMED',
  IssueType.OVERALLOCATED: 'OVERALLOCATED',
  IssueType.MIXED_CLAIM_TYPES: 'MIXED_CLAIM_TYPES',
};

_ParticipantBreakdown _$ParticipantBreakdownFromJson(
  Map<String, dynamic> json,
) => _ParticipantBreakdown(
  participantId: json['participantId'] as String,
  displayName: json['displayName'] as String,
  subtotal: const AmountConverter().fromJson(json['subtotal']),
  taxShare: const AmountConverter().fromJson(json['taxShare']),
  serviceShare: const AmountConverter().fromJson(json['serviceShare']),
  discountShare: const AmountConverter().fromJson(json['discountShare']),
  roundingShare: const AmountConverter().fromJson(json['roundingShare']),
  finalAmount: const AmountConverter().fromJson(json['finalAmount']),
);

Map<String, dynamic> _$ParticipantBreakdownToJson(
  _ParticipantBreakdown instance,
) => <String, dynamic>{
  'participantId': instance.participantId,
  'displayName': instance.displayName,
  'subtotal': const AmountConverter().toJson(instance.subtotal),
  'taxShare': const AmountConverter().toJson(instance.taxShare),
  'serviceShare': const AmountConverter().toJson(instance.serviceShare),
  'discountShare': const AmountConverter().toJson(instance.discountShare),
  'roundingShare': const AmountConverter().toJson(instance.roundingShare),
  'finalAmount': const AmountConverter().toJson(instance.finalAmount),
};

_Breakdown _$BreakdownFromJson(Map<String, dynamic> json) => _Breakdown(
  valid: json['valid'] as bool,
  issues: (json['issues'] as List<dynamic>)
      .map((e) => ItemIssue.fromJson(e as Map<String, dynamic>))
      .toList(),
  subtotal: const AmountConverter().fromJson(json['subtotal']),
  computedTotal: const AmountConverter().fromJson(json['computedTotal']),
  roundingAdjustment: const AmountConverter().fromJson(
    json['roundingAdjustment'],
  ),
  participants: (json['participants'] as List<dynamic>)
      .map((e) => ParticipantBreakdown.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$BreakdownToJson(_Breakdown instance) =>
    <String, dynamic>{
      'valid': instance.valid,
      'issues': instance.issues,
      'subtotal': const AmountConverter().toJson(instance.subtotal),
      'computedTotal': const AmountConverter().toJson(instance.computedTotal),
      'roundingAdjustment': const AmountConverter().toJson(
        instance.roundingAdjustment,
      ),
      'participants': instance.participants,
    };

_BillBalance _$BillBalanceFromJson(Map<String, dynamic> json) => _BillBalance(
  participantId: json['participantId'] as String,
  displayName: json['displayName'] as String,
  paid: const AmountConverter().fromJson(json['paid']),
  owed: const AmountConverter().fromJson(json['owed']),
  net: const AmountConverter().fromJson(json['net']),
);

Map<String, dynamic> _$BillBalanceToJson(_BillBalance instance) =>
    <String, dynamic>{
      'participantId': instance.participantId,
      'displayName': instance.displayName,
      'paid': const AmountConverter().toJson(instance.paid),
      'owed': const AmountConverter().toJson(instance.owed),
      'net': const AmountConverter().toJson(instance.net),
    };

_JoinBillResponse _$JoinBillResponseFromJson(Map<String, dynamic> json) =>
    _JoinBillResponse(
      billId: json['billId'] as String,
      participantId: json['participantId'] as String,
      displayName: json['displayName'] as String,
      guest: json['guest'] as bool,
      guestToken: json['guestToken'] as String?,
    );

Map<String, dynamic> _$JoinBillResponseToJson(_JoinBillResponse instance) =>
    <String, dynamic>{
      'billId': instance.billId,
      'participantId': instance.participantId,
      'displayName': instance.displayName,
      'guest': instance.guest,
      'guestToken': instance.guestToken,
    };
