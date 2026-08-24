// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: json['id'] as String,
  name: json['name'] as String,
  sku: json['sku'] as String?,
  type: $enumDecode(_$ProductTypeEnumMap, json['type']),
  unit: json['unit'] as String?,
  unitPrice: const AmountConverter().fromJson(json['unitPrice']),
  active: json['active'] as bool,
  description: json['description'] as String?,
  cost: const NullableAmountConverter().fromJson(json['cost']),
  taxClassification: $enumDecode(
    _$TaxClassificationEnumMap,
    json['taxClassification'],
  ),
  trackInventory: json['trackInventory'] as bool,
  reorderPoint: const NullableAmountConverter().fromJson(json['reorderPoint']),
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'sku': instance.sku,
  'type': _$ProductTypeEnumMap[instance.type]!,
  'unit': instance.unit,
  'unitPrice': const AmountConverter().toJson(instance.unitPrice),
  'active': instance.active,
  'description': instance.description,
  'cost': const NullableAmountConverter().toJson(instance.cost),
  'taxClassification': _$TaxClassificationEnumMap[instance.taxClassification]!,
  'trackInventory': instance.trackInventory,
  'reorderPoint': const NullableAmountConverter().toJson(instance.reorderPoint),
};

const _$ProductTypeEnumMap = {
  ProductType.GOODS: 'GOODS',
  ProductType.SERVICE: 'SERVICE',
};

const _$TaxClassificationEnumMap = {
  TaxClassification.STANDARD_RATED: 'STANDARD_RATED',
  TaxClassification.ZERO_RATED: 'ZERO_RATED',
  TaxClassification.EXEMPT: 'EXEMPT',
  TaxClassification.NOT_APPLICABLE: 'NOT_APPLICABLE',
};
