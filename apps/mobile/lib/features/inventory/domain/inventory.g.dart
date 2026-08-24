// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MovementResponse _$MovementResponseFromJson(Map<String, dynamic> json) =>
    _MovementResponse(
      id: json['id'] as String,
      productId: json['productId'] as String,
      type: $enumDecode(_$MovementTypeEnumMap, json['type']),
      quantity: const AmountConverter().fromJson(json['quantity']),
      unitCost: const AmountConverter().fromJson(json['unitCost']),
      value: const AmountConverter().fromJson(json['value']),
      occurredOn: json['occurredOn'] as String,
      notes: json['notes'] as String?,
      sourceInvoiceLineItemId: json['sourceInvoiceLineItemId'] as String?,
      createdByUserId: json['createdByUserId'] as String,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$MovementResponseToJson(_MovementResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'type': _$MovementTypeEnumMap[instance.type]!,
      'quantity': const AmountConverter().toJson(instance.quantity),
      'unitCost': const AmountConverter().toJson(instance.unitCost),
      'value': const AmountConverter().toJson(instance.value),
      'occurredOn': instance.occurredOn,
      'notes': instance.notes,
      'sourceInvoiceLineItemId': instance.sourceInvoiceLineItemId,
      'createdByUserId': instance.createdByUserId,
      'createdAt': instance.createdAt,
    };

const _$MovementTypeEnumMap = {
  MovementType.PURCHASE: 'PURCHASE',
  MovementType.SALE: 'SALE',
  MovementType.RETURN: 'RETURN',
  MovementType.ADJUSTMENT: 'ADJUSTMENT',
  MovementType.TRANSFER: 'TRANSFER',
  MovementType.OPENING_BALANCE: 'OPENING_BALANCE',
};

_ProductValuationResponse _$ProductValuationResponseFromJson(
  Map<String, dynamic> json,
) => _ProductValuationResponse(
  productId: json['productId'] as String,
  quantityOnHand: const AmountConverter().fromJson(json['quantityOnHand']),
  weightedAverageCost: const AmountConverter().fromJson(
    json['weightedAverageCost'],
  ),
  totalValue: const AmountConverter().fromJson(json['totalValue']),
);

Map<String, dynamic> _$ProductValuationResponseToJson(
  _ProductValuationResponse instance,
) => <String, dynamic>{
  'productId': instance.productId,
  'quantityOnHand': const AmountConverter().toJson(instance.quantityOnHand),
  'weightedAverageCost': const AmountConverter().toJson(
    instance.weightedAverageCost,
  ),
  'totalValue': const AmountConverter().toJson(instance.totalValue),
};

_RecipeItemResponse _$RecipeItemResponseFromJson(Map<String, dynamic> json) =>
    _RecipeItemResponse(
      id: json['id'] as String,
      ingredientProductId: json['ingredientProductId'] as String,
      ingredientName: json['ingredientName'] as String,
      quantityPerUnit: const AmountConverter().fromJson(
        json['quantityPerUnit'],
      ),
      ingredientUnitCost: const AmountConverter().fromJson(
        json['ingredientUnitCost'],
      ),
      lineCost: const AmountConverter().fromJson(json['lineCost']),
    );

Map<String, dynamic> _$RecipeItemResponseToJson(
  _RecipeItemResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'ingredientProductId': instance.ingredientProductId,
  'ingredientName': instance.ingredientName,
  'quantityPerUnit': const AmountConverter().toJson(instance.quantityPerUnit),
  'ingredientUnitCost': const AmountConverter().toJson(
    instance.ingredientUnitCost,
  ),
  'lineCost': const AmountConverter().toJson(instance.lineCost),
};

_RecipeCostResponse _$RecipeCostResponseFromJson(Map<String, dynamic> json) =>
    _RecipeCostResponse(
      productId: json['productId'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => RecipeItemResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      unitCost: const AmountConverter().fromJson(json['unitCost']),
      sellingPrice: const AmountConverter().fromJson(json['sellingPrice']),
      grossMargin: const AmountConverter().fromJson(json['grossMargin']),
      grossMarginPercent: const AmountConverter().fromJson(
        json['grossMarginPercent'],
      ),
    );

Map<String, dynamic> _$RecipeCostResponseToJson(_RecipeCostResponse instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'items': instance.items,
      'unitCost': const AmountConverter().toJson(instance.unitCost),
      'sellingPrice': const AmountConverter().toJson(instance.sellingPrice),
      'grossMargin': const AmountConverter().toJson(instance.grossMargin),
      'grossMarginPercent': const AmountConverter().toJson(
        instance.grossMarginPercent,
      ),
    };

_StockValuationRow _$StockValuationRowFromJson(Map<String, dynamic> json) =>
    _StockValuationRow(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      sku: json['sku'] as String?,
      quantityOnHand: const AmountConverter().fromJson(json['quantityOnHand']),
      weightedAverageCost: const AmountConverter().fromJson(
        json['weightedAverageCost'],
      ),
      totalValue: const AmountConverter().fromJson(json['totalValue']),
    );

Map<String, dynamic> _$StockValuationRowToJson(_StockValuationRow instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productName': instance.productName,
      'sku': instance.sku,
      'quantityOnHand': const AmountConverter().toJson(instance.quantityOnHand),
      'weightedAverageCost': const AmountConverter().toJson(
        instance.weightedAverageCost,
      ),
      'totalValue': const AmountConverter().toJson(instance.totalValue),
    };

_CogsReport _$CogsReportFromJson(Map<String, dynamic> json) => _CogsReport(
  from: json['from'] as String,
  to: json['to'] as String,
  totalCogs: const AmountConverter().fromJson(json['totalCogs']),
);

Map<String, dynamic> _$CogsReportToJson(_CogsReport instance) =>
    <String, dynamic>{
      'from': instance.from,
      'to': instance.to,
      'totalCogs': const AmountConverter().toJson(instance.totalCogs),
    };
