// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_scan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ParsedReceiptItem _$ParsedReceiptItemFromJson(Map<String, dynamic> json) =>
    _ParsedReceiptItem(
      name: json['name'] as String?,
      quantity: const NullableAmountConverter().fromJson(json['quantity']),
      unitPrice: const NullableAmountConverter().fromJson(json['unitPrice']),
      totalPrice: const NullableAmountConverter().fromJson(json['totalPrice']),
      confidence: (json['confidence'] as num).toDouble(),
    );

Map<String, dynamic> _$ParsedReceiptItemToJson(_ParsedReceiptItem instance) =>
    <String, dynamic>{
      'name': instance.name,
      'quantity': const NullableAmountConverter().toJson(instance.quantity),
      'unitPrice': const NullableAmountConverter().toJson(instance.unitPrice),
      'totalPrice': const NullableAmountConverter().toJson(instance.totalPrice),
      'confidence': instance.confidence,
    };

_ParsedReceipt _$ParsedReceiptFromJson(Map<String, dynamic> json) =>
    _ParsedReceipt(
      merchant: json['merchant'] as String?,
      merchantConfidence: (json['merchantConfidence'] as num).toDouble(),
      receiptDate: json['receiptDate'] as String?,
      receiptDateConfidence: (json['receiptDateConfidence'] as num).toDouble(),
      items: (json['items'] as List<dynamic>)
          .map((e) => ParsedReceiptItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      tax: const NullableAmountConverter().fromJson(json['tax']),
      taxConfidence: (json['taxConfidence'] as num).toDouble(),
      serviceCharge: const NullableAmountConverter().fromJson(
        json['serviceCharge'],
      ),
      serviceConfidence: (json['serviceConfidence'] as num).toDouble(),
      discount: const NullableAmountConverter().fromJson(json['discount']),
      discountConfidence: (json['discountConfidence'] as num).toDouble(),
      total: const NullableAmountConverter().fromJson(json['total']),
      totalConfidence: (json['totalConfidence'] as num).toDouble(),
      overallConfidence: (json['overallConfidence'] as num).toDouble(),
    );

Map<String, dynamic> _$ParsedReceiptToJson(_ParsedReceipt instance) =>
    <String, dynamic>{
      'merchant': instance.merchant,
      'merchantConfidence': instance.merchantConfidence,
      'receiptDate': instance.receiptDate,
      'receiptDateConfidence': instance.receiptDateConfidence,
      'items': instance.items,
      'tax': const NullableAmountConverter().toJson(instance.tax),
      'taxConfidence': instance.taxConfidence,
      'serviceCharge': const NullableAmountConverter().toJson(
        instance.serviceCharge,
      ),
      'serviceConfidence': instance.serviceConfidence,
      'discount': const NullableAmountConverter().toJson(instance.discount),
      'discountConfidence': instance.discountConfidence,
      'total': const NullableAmountConverter().toJson(instance.total),
      'totalConfidence': instance.totalConfidence,
      'overallConfidence': instance.overallConfidence,
    };

_ReceiptScan _$ReceiptScanFromJson(Map<String, dynamic> json) => _ReceiptScan(
  id: json['id'] as String,
  status: $enumDecode(_$ScanStatusEnumMap, json['status']),
  provider: json['provider'] as String,
  overallConfidence: (json['overallConfidence'] as num?)?.toDouble(),
  needsReview: json['needsReview'] as bool? ?? false,
  parsedReceipt: ParsedReceipt.fromJson(
    json['parsedReceipt'] as Map<String, dynamic>,
  ),
  imageUrl: json['imageUrl'] as String,
  errorMessage: json['errorMessage'] as String?,
  billId: json['billId'] as String?,
);

Map<String, dynamic> _$ReceiptScanToJson(_ReceiptScan instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': _$ScanStatusEnumMap[instance.status]!,
      'provider': instance.provider,
      'overallConfidence': instance.overallConfidence,
      'needsReview': instance.needsReview,
      'parsedReceipt': instance.parsedReceipt,
      'imageUrl': instance.imageUrl,
      'errorMessage': instance.errorMessage,
      'billId': instance.billId,
    };

const _$ScanStatusEnumMap = {
  ScanStatus.PARSED: 'PARSED',
  ScanStatus.FAILED: 'FAILED',
  ScanStatus.CONFIRMED: 'CONFIRMED',
};
