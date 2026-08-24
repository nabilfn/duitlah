// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_candidate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionCandidate _$TransactionCandidateFromJson(
  Map<String, dynamic> json,
) => _TransactionCandidate(
  id: json['id'] as String,
  sourceType: $enumDecode(_$CandidateSourceTypeEnumMap, json['sourceType']),
  detectedAmount: const AmountConverter().fromJson(json['detectedAmount']),
  detectedCurrency: json['detectedCurrency'] as String,
  detectedMerchant: json['detectedMerchant'] as String?,
  detectedDate: json['detectedDate'] as String,
  detectedDirection: $enumDecode(
    _$TransactionDirectionEnumMap,
    json['detectedDirection'],
  ),
  suggestedAccountId: json['suggestedAccountId'] as String?,
  suggestedCategoryId: json['suggestedCategoryId'] as String?,
  confidence: const AmountConverter().fromJson(json['confidence']),
  status: $enumDecode(_$CandidateStatusEnumMap, json['status']),
  duplicateOfTransactionId: json['duplicateOfTransactionId'] as String?,
  duplicateConfidence: const NullableAmountConverter().fromJson(
    json['duplicateConfidence'],
  ),
  resultingTransactionId: json['resultingTransactionId'] as String?,
);

Map<String, dynamic> _$TransactionCandidateToJson(
  _TransactionCandidate instance,
) => <String, dynamic>{
  'id': instance.id,
  'sourceType': _$CandidateSourceTypeEnumMap[instance.sourceType]!,
  'detectedAmount': const AmountConverter().toJson(instance.detectedAmount),
  'detectedCurrency': instance.detectedCurrency,
  'detectedMerchant': instance.detectedMerchant,
  'detectedDate': instance.detectedDate,
  'detectedDirection':
      _$TransactionDirectionEnumMap[instance.detectedDirection]!,
  'suggestedAccountId': instance.suggestedAccountId,
  'suggestedCategoryId': instance.suggestedCategoryId,
  'confidence': const AmountConverter().toJson(instance.confidence),
  'status': _$CandidateStatusEnumMap[instance.status]!,
  'duplicateOfTransactionId': instance.duplicateOfTransactionId,
  'duplicateConfidence': const NullableAmountConverter().toJson(
    instance.duplicateConfidence,
  ),
  'resultingTransactionId': instance.resultingTransactionId,
};

const _$CandidateSourceTypeEnumMap = {
  CandidateSourceType.RECEIPT_OCR: 'RECEIPT_OCR',
  CandidateSourceType.STATEMENT_CSV: 'STATEMENT_CSV',
  CandidateSourceType.STATEMENT_XLSX: 'STATEMENT_XLSX',
  CandidateSourceType.STATEMENT_PDF: 'STATEMENT_PDF',
};

const _$TransactionDirectionEnumMap = {
  TransactionDirection.IN: 'IN',
  TransactionDirection.OUT: 'OUT',
};

const _$CandidateStatusEnumMap = {
  CandidateStatus.PENDING: 'PENDING',
  CandidateStatus.CONFIRMED: 'CONFIRMED',
  CandidateStatus.REJECTED: 'REJECTED',
  CandidateStatus.DUPLICATE: 'DUPLICATE',
  CandidateStatus.FAILED: 'FAILED',
};

_StatementImport _$StatementImportFromJson(Map<String, dynamic> json) =>
    _StatementImport(
      id: json['id'] as String,
      accountId: json['accountId'] as String,
      provider: $enumDecode(_$StatementProviderEnumMap, json['provider']),
      originalFilename: json['originalFilename'] as String,
      status: $enumDecode(_$StatementImportStatusEnumMap, json['status']),
      rowCount: (json['rowCount'] as num).toInt(),
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$StatementImportToJson(_StatementImport instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accountId': instance.accountId,
      'provider': _$StatementProviderEnumMap[instance.provider]!,
      'originalFilename': instance.originalFilename,
      'status': _$StatementImportStatusEnumMap[instance.status]!,
      'rowCount': instance.rowCount,
      'errorMessage': instance.errorMessage,
    };

const _$StatementProviderEnumMap = {
  StatementProvider.GENERIC_CSV: 'GENERIC_CSV',
  StatementProvider.GENERIC_EXCEL: 'GENERIC_EXCEL',
  StatementProvider.PDF: 'PDF',
};

const _$StatementImportStatusEnumMap = {
  StatementImportStatus.UPLOADED: 'UPLOADED',
  StatementImportStatus.PARSED: 'PARSED',
  StatementImportStatus.FAILED: 'FAILED',
};
