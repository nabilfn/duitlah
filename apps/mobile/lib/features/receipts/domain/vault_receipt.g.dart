// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vault_receipt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VaultReceipt _$VaultReceiptFromJson(Map<String, dynamic> json) =>
    _VaultReceipt(
      id: json['id'] as String,
      purpose: $enumDecode(_$ReceiptPurposeEnumMap, json['purpose']),
      ocrStatus: $enumDecode(_$VaultOcrStatusEnumMap, json['ocrStatus']),
      merchant: json['merchant'] as String?,
      receiptDate: json['receiptDate'] as String?,
      totalAmount: const NullableAmountConverter().fromJson(
        json['totalAmount'],
      ),
      folder: json['folder'] as String?,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      linkedTransactionId: json['linkedTransactionId'] as String?,
      linkedBillId: json['linkedBillId'] as String?,
      imageUrl: json['imageUrl'] as String,
      needsReview: json['needsReview'] as bool? ?? false,
    );

Map<String, dynamic> _$VaultReceiptToJson(
  _VaultReceipt instance,
) => <String, dynamic>{
  'id': instance.id,
  'purpose': _$ReceiptPurposeEnumMap[instance.purpose]!,
  'ocrStatus': _$VaultOcrStatusEnumMap[instance.ocrStatus]!,
  'merchant': instance.merchant,
  'receiptDate': instance.receiptDate,
  'totalAmount': const NullableAmountConverter().toJson(instance.totalAmount),
  'folder': instance.folder,
  'tags': instance.tags,
  'linkedTransactionId': instance.linkedTransactionId,
  'linkedBillId': instance.linkedBillId,
  'imageUrl': instance.imageUrl,
  'needsReview': instance.needsReview,
};

const _$ReceiptPurposeEnumMap = {
  ReceiptPurpose.PERSONAL_EXPENSE: 'PERSONAL_EXPENSE',
  ReceiptPurpose.BUSINESS_EXPENSE: 'BUSINESS_EXPENSE',
  ReceiptPurpose.TAX_EVIDENCE: 'TAX_EVIDENCE',
  ReceiptPurpose.BAGILAH: 'BAGILAH',
  ReceiptPurpose.UNSPECIFIED: 'UNSPECIFIED',
};

const _$VaultOcrStatusEnumMap = {
  VaultOcrStatus.UNPROCESSED: 'UNPROCESSED',
  VaultOcrStatus.PARSED: 'PARSED',
  VaultOcrStatus.FAILED: 'FAILED',
};

_ReceiptMatchSuggestion _$ReceiptMatchSuggestionFromJson(
  Map<String, dynamic> json,
) => _ReceiptMatchSuggestion(
  transactionId: json['transactionId'] as String,
  occurredOn: json['occurredOn'] as String,
  merchant: json['merchant'] as String?,
  amount: const AmountConverter().fromJson(json['amount']),
  confidence: $enumDecode(_$ReceiptMatchConfidenceEnumMap, json['confidence']),
);

Map<String, dynamic> _$ReceiptMatchSuggestionToJson(
  _ReceiptMatchSuggestion instance,
) => <String, dynamic>{
  'transactionId': instance.transactionId,
  'occurredOn': instance.occurredOn,
  'merchant': instance.merchant,
  'amount': const AmountConverter().toJson(instance.amount),
  'confidence': _$ReceiptMatchConfidenceEnumMap[instance.confidence]!,
};

const _$ReceiptMatchConfidenceEnumMap = {
  ReceiptMatchConfidence.EXACT: 'EXACT',
  ReceiptMatchConfidence.PROBABLE: 'PROBABLE',
};
