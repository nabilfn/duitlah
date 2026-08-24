// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cross_space.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CrossSpaceLinkResponse _$CrossSpaceLinkResponseFromJson(
  Map<String, dynamic> json,
) => _CrossSpaceLinkResponse(
  id: json['id'] as String,
  businessSpaceId: json['businessSpaceId'] as String,
  linkType: $enumDecode(_$CrossSpaceLinkTypeEnumMap, json['linkType']),
  personalTransactionId: json['personalTransactionId'] as String,
  businessJournalEntryId: json['businessJournalEntryId'] as String?,
  relatedLinkId: json['relatedLinkId'] as String?,
  amount: const AmountConverter().fromJson(json['amount']),
  description: json['description'] as String?,
  createdAt: json['createdAt'] as String,
);

Map<String, dynamic> _$CrossSpaceLinkResponseToJson(
  _CrossSpaceLinkResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'businessSpaceId': instance.businessSpaceId,
  'linkType': _$CrossSpaceLinkTypeEnumMap[instance.linkType]!,
  'personalTransactionId': instance.personalTransactionId,
  'businessJournalEntryId': instance.businessJournalEntryId,
  'relatedLinkId': instance.relatedLinkId,
  'amount': const AmountConverter().toJson(instance.amount),
  'description': instance.description,
  'createdAt': instance.createdAt,
};

const _$CrossSpaceLinkTypeEnumMap = {
  CrossSpaceLinkType.BUSINESS_ADVANCE: 'BUSINESS_ADVANCE',
  CrossSpaceLinkType.REIMBURSEMENT: 'REIMBURSEMENT',
  CrossSpaceLinkType.OWNER_CONTRIBUTION: 'OWNER_CONTRIBUTION',
  CrossSpaceLinkType.OWNER_DRAWING: 'OWNER_DRAWING',
};

_BusinessOwnershipLine _$BusinessOwnershipLineFromJson(
  Map<String, dynamic> json,
) => _BusinessOwnershipLine(
  spaceId: json['spaceId'] as String,
  spaceName: json['spaceName'] as String,
  equityValue: const AmountConverter().fromJson(json['equityValue']),
);

Map<String, dynamic> _$BusinessOwnershipLineToJson(
  _BusinessOwnershipLine instance,
) => <String, dynamic>{
  'spaceId': instance.spaceId,
  'spaceName': instance.spaceName,
  'equityValue': const AmountConverter().toJson(instance.equityValue),
};

_CombinedNetWorth _$CombinedNetWorthFromJson(Map<String, dynamic> json) =>
    _CombinedNetWorth(
      personalNetWorth: const AmountConverter().fromJson(
        json['personalNetWorth'],
      ),
      businessOwnership: (json['businessOwnership'] as List<dynamic>)
          .map((e) => BusinessOwnershipLine.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalBusinessOwnershipValue: const AmountConverter().fromJson(
        json['totalBusinessOwnershipValue'],
      ),
      estimatedTotalNetWorth: const AmountConverter().fromJson(
        json['estimatedTotalNetWorth'],
      ),
    );

Map<String, dynamic> _$CombinedNetWorthToJson(
  _CombinedNetWorth instance,
) => <String, dynamic>{
  'personalNetWorth': const AmountConverter().toJson(instance.personalNetWorth),
  'businessOwnership': instance.businessOwnership,
  'totalBusinessOwnershipValue': const AmountConverter().toJson(
    instance.totalBusinessOwnershipValue,
  ),
  'estimatedTotalNetWorth': const AmountConverter().toJson(
    instance.estimatedTotalNetWorth,
  ),
};
