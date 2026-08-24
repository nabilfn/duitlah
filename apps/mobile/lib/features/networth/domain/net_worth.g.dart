// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'net_worth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BreakdownLine _$BreakdownLineFromJson(Map<String, dynamic> json) =>
    _BreakdownLine(
      label: json['label'] as String,
      amount: const AmountConverter().fromJson(json['amount']),
    );

Map<String, dynamic> _$BreakdownLineToJson(_BreakdownLine instance) =>
    <String, dynamic>{
      'label': instance.label,
      'amount': const AmountConverter().toJson(instance.amount),
    };

_NetWorth _$NetWorthFromJson(Map<String, dynamic> json) => _NetWorth(
  totalAssets: const AmountConverter().fromJson(json['totalAssets']),
  totalLiabilities: const AmountConverter().fromJson(json['totalLiabilities']),
  netWorth: const AmountConverter().fromJson(json['netWorth']),
  assetsBreakdown: (json['assetsBreakdown'] as List<dynamic>)
      .map((e) => BreakdownLine.fromJson(e as Map<String, dynamic>))
      .toList(),
  liabilitiesBreakdown: (json['liabilitiesBreakdown'] as List<dynamic>)
      .map((e) => BreakdownLine.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$NetWorthToJson(_NetWorth instance) => <String, dynamic>{
  'totalAssets': const AmountConverter().toJson(instance.totalAssets),
  'totalLiabilities': const AmountConverter().toJson(instance.totalLiabilities),
  'netWorth': const AmountConverter().toJson(instance.netWorth),
  'assetsBreakdown': instance.assetsBreakdown,
  'liabilitiesBreakdown': instance.liabilitiesBreakdown,
};

_OtherAsset _$OtherAssetFromJson(Map<String, dynamic> json) => _OtherAsset(
  id: json['id'] as String,
  type: $enumDecode(_$AssetTypeEnumMap, json['type']),
  name: json['name'] as String,
  estimatedValue: const AmountConverter().fromJson(json['estimatedValue']),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$OtherAssetToJson(_OtherAsset instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$AssetTypeEnumMap[instance.type]!,
      'name': instance.name,
      'estimatedValue': const AmountConverter().toJson(instance.estimatedValue),
      'notes': instance.notes,
    };

const _$AssetTypeEnumMap = {
  AssetType.PROPERTY: 'PROPERTY',
  AssetType.VEHICLE: 'VEHICLE',
  AssetType.OTHER: 'OTHER',
};

_NetWorthSnapshot _$NetWorthSnapshotFromJson(Map<String, dynamic> json) =>
    _NetWorthSnapshot(
      id: json['id'] as String,
      totalAssets: const AmountConverter().fromJson(json['totalAssets']),
      totalLiabilities: const AmountConverter().fromJson(
        json['totalLiabilities'],
      ),
      netWorth: const AmountConverter().fromJson(json['netWorth']),
      snapshotDate: json['snapshotDate'] as String,
    );

Map<String, dynamic> _$NetWorthSnapshotToJson(
  _NetWorthSnapshot instance,
) => <String, dynamic>{
  'id': instance.id,
  'totalAssets': const AmountConverter().toJson(instance.totalAssets),
  'totalLiabilities': const AmountConverter().toJson(instance.totalLiabilities),
  'netWorth': const AmountConverter().toJson(instance.netWorth),
  'snapshotDate': instance.snapshotDate,
};
