// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entitlement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Entitlement _$EntitlementFromJson(Map<String, dynamic> json) => _Entitlement(
  tier: $enumDecode(_$SubscriptionTierEnumMap, json['tier']),
  status: $enumDecodeNullable(_$SubscriptionStatusEnumMap, json['status']),
  expiresAt: json['expiresAt'] as String?,
  maxActiveGroups: (json['maxActiveGroups'] as num?)?.toInt(),
  activeGroupCount: (json['activeGroupCount'] as num).toInt(),
  maxReceiptScansPerMonth: (json['maxReceiptScansPerMonth'] as num?)?.toInt(),
  receiptScansThisMonth: (json['receiptScansThisMonth'] as num).toInt(),
);

Map<String, dynamic> _$EntitlementToJson(_Entitlement instance) =>
    <String, dynamic>{
      'tier': _$SubscriptionTierEnumMap[instance.tier]!,
      'status': _$SubscriptionStatusEnumMap[instance.status],
      'expiresAt': instance.expiresAt,
      'maxActiveGroups': instance.maxActiveGroups,
      'activeGroupCount': instance.activeGroupCount,
      'maxReceiptScansPerMonth': instance.maxReceiptScansPerMonth,
      'receiptScansThisMonth': instance.receiptScansThisMonth,
    };

const _$SubscriptionTierEnumMap = {
  SubscriptionTier.FREE: 'FREE',
  SubscriptionTier.PLUS: 'PLUS',
};

const _$SubscriptionStatusEnumMap = {
  SubscriptionStatus.ACTIVE: 'ACTIVE',
  SubscriptionStatus.EXPIRED: 'EXPIRED',
  SubscriptionStatus.CANCELED: 'CANCELED',
  SubscriptionStatus.GRACE_PERIOD: 'GRACE_PERIOD',
};
