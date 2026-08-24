// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fixed_assets.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FixedAssetResponse _$FixedAssetResponseFromJson(Map<String, dynamic> json) =>
    _FixedAssetResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String?,
      acquisitionDate: json['acquisitionDate'] as String,
      cost: const AmountConverter().fromJson(json['cost']),
      salvageValue: const AmountConverter().fromJson(json['salvageValue']),
      usefulLifeMonths: (json['usefulLifeMonths'] as num).toInt(),
      depreciationMethod: $enumDecode(
        _$DepreciationMethodEnumMap,
        json['depreciationMethod'],
      ),
      status: $enumDecode(_$FixedAssetStatusEnumMap, json['status']),
      disposedOn: json['disposedOn'] as String?,
      disposalProceeds: const NullableAmountConverter().fromJson(
        json['disposalProceeds'],
      ),
      accumulatedDepreciation: const AmountConverter().fromJson(
        json['accumulatedDepreciation'],
      ),
      netBookValue: const AmountConverter().fromJson(json['netBookValue']),
    );

Map<String, dynamic> _$FixedAssetResponseToJson(_FixedAssetResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'acquisitionDate': instance.acquisitionDate,
      'cost': const AmountConverter().toJson(instance.cost),
      'salvageValue': const AmountConverter().toJson(instance.salvageValue),
      'usefulLifeMonths': instance.usefulLifeMonths,
      'depreciationMethod':
          _$DepreciationMethodEnumMap[instance.depreciationMethod]!,
      'status': _$FixedAssetStatusEnumMap[instance.status]!,
      'disposedOn': instance.disposedOn,
      'disposalProceeds': const NullableAmountConverter().toJson(
        instance.disposalProceeds,
      ),
      'accumulatedDepreciation': const AmountConverter().toJson(
        instance.accumulatedDepreciation,
      ),
      'netBookValue': const AmountConverter().toJson(instance.netBookValue),
    };

const _$DepreciationMethodEnumMap = {
  DepreciationMethod.STRAIGHT_LINE: 'STRAIGHT_LINE',
  DepreciationMethod.DOUBLE_DECLINING_BALANCE: 'DOUBLE_DECLINING_BALANCE',
};

const _$FixedAssetStatusEnumMap = {
  FixedAssetStatus.ACTIVE: 'ACTIVE',
  FixedAssetStatus.DISPOSED: 'DISPOSED',
};

_DepreciationEntryResponse _$DepreciationEntryResponseFromJson(
  Map<String, dynamic> json,
) => _DepreciationEntryResponse(
  id: json['id'] as String,
  assetId: json['assetId'] as String,
  period: json['period'] as String,
  amount: const AmountConverter().fromJson(json['amount']),
  createdAt: json['createdAt'] as String,
);

Map<String, dynamic> _$DepreciationEntryResponseToJson(
  _DepreciationEntryResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'assetId': instance.assetId,
  'period': instance.period,
  'amount': const AmountConverter().toJson(instance.amount),
  'createdAt': instance.createdAt,
};
