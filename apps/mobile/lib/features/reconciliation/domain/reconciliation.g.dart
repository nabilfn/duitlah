// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reconciliation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BusinessStatementImportResponse _$BusinessStatementImportResponseFromJson(
  Map<String, dynamic> json,
) => _BusinessStatementImportResponse(
  id: json['id'] as String,
  businessAccountId: json['businessAccountId'] as String,
  provider: $enumDecode(_$StatementProviderEnumMap, json['provider']),
  originalFilename: json['originalFilename'] as String,
  status: $enumDecode(_$BusinessStatementImportStatusEnumMap, json['status']),
  rowCount: (json['rowCount'] as num).toInt(),
  errorMessage: json['errorMessage'] as String?,
  reconciliationSessionId: json['reconciliationSessionId'] as String?,
);

Map<String, dynamic> _$BusinessStatementImportResponseToJson(
  _BusinessStatementImportResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'businessAccountId': instance.businessAccountId,
  'provider': _$StatementProviderEnumMap[instance.provider]!,
  'originalFilename': instance.originalFilename,
  'status': _$BusinessStatementImportStatusEnumMap[instance.status]!,
  'rowCount': instance.rowCount,
  'errorMessage': instance.errorMessage,
  'reconciliationSessionId': instance.reconciliationSessionId,
};

const _$StatementProviderEnumMap = {
  StatementProvider.GENERIC_CSV: 'GENERIC_CSV',
  StatementProvider.GENERIC_EXCEL: 'GENERIC_EXCEL',
  StatementProvider.PDF: 'PDF',
};

const _$BusinessStatementImportStatusEnumMap = {
  BusinessStatementImportStatus.PARSED: 'PARSED',
  BusinessStatementImportStatus.FAILED: 'FAILED',
};

_StatementLineResponse _$StatementLineResponseFromJson(
  Map<String, dynamic> json,
) => _StatementLineResponse(
  id: json['id'] as String,
  occurredOn: json['occurredOn'] as String,
  description: json['description'] as String?,
  amount: const AmountConverter().fromJson(json['amount']),
  status: $enumDecode(_$StatementLineStatusEnumMap, json['status']),
);

Map<String, dynamic> _$StatementLineResponseToJson(
  _StatementLineResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'occurredOn': instance.occurredOn,
  'description': instance.description,
  'amount': const AmountConverter().toJson(instance.amount),
  'status': _$StatementLineStatusEnumMap[instance.status]!,
};

const _$StatementLineStatusEnumMap = {
  StatementLineStatus.UNMATCHED: 'UNMATCHED',
  StatementLineStatus.MATCHED: 'MATCHED',
  StatementLineStatus.CREATED: 'CREATED',
  StatementLineStatus.IGNORED: 'IGNORED',
  StatementLineStatus.SPLIT: 'SPLIT',
};

_MatchSuggestionResponse _$MatchSuggestionResponseFromJson(
  Map<String, dynamic> json,
) => _MatchSuggestionResponse(
  businessAccountEntryId: json['businessAccountEntryId'] as String,
  occurredOn: json['occurredOn'] as String,
  description: json['description'] as String?,
  signedAmount: const AmountConverter().fromJson(json['signedAmount']),
  confidence: $enumDecode(_$MatchConfidenceEnumMap, json['confidence']),
);

Map<String, dynamic> _$MatchSuggestionResponseToJson(
  _MatchSuggestionResponse instance,
) => <String, dynamic>{
  'businessAccountEntryId': instance.businessAccountEntryId,
  'occurredOn': instance.occurredOn,
  'description': instance.description,
  'signedAmount': const AmountConverter().toJson(instance.signedAmount),
  'confidence': _$MatchConfidenceEnumMap[instance.confidence]!,
};

const _$MatchConfidenceEnumMap = {
  MatchConfidence.EXACT: 'EXACT',
  MatchConfidence.PROBABLE: 'PROBABLE',
};

_ReconciliationSessionResponse _$ReconciliationSessionResponseFromJson(
  Map<String, dynamic> json,
) => _ReconciliationSessionResponse(
  id: json['id'] as String,
  businessAccountId: json['businessAccountId'] as String,
  businessStatementImportId: json['businessStatementImportId'] as String,
  statementEndingBalance: const NullableAmountConverter().fromJson(
    json['statementEndingBalance'],
  ),
  status: $enumDecode(_$ReconciliationSessionStatusEnumMap, json['status']),
  startedAt: json['startedAt'] as String,
  completedAt: json['completedAt'] as String?,
);

Map<String, dynamic> _$ReconciliationSessionResponseToJson(
  _ReconciliationSessionResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'businessAccountId': instance.businessAccountId,
  'businessStatementImportId': instance.businessStatementImportId,
  'statementEndingBalance': const NullableAmountConverter().toJson(
    instance.statementEndingBalance,
  ),
  'status': _$ReconciliationSessionStatusEnumMap[instance.status]!,
  'startedAt': instance.startedAt,
  'completedAt': instance.completedAt,
};

const _$ReconciliationSessionStatusEnumMap = {
  ReconciliationSessionStatus.IN_PROGRESS: 'IN_PROGRESS',
  ReconciliationSessionStatus.COMPLETED: 'COMPLETED',
};

_ReconciliationSummaryResponse _$ReconciliationSummaryResponseFromJson(
  Map<String, dynamic> json,
) => _ReconciliationSummaryResponse(
  unmatchedCount: (json['unmatchedCount'] as num).toInt(),
  matchedCount: (json['matchedCount'] as num).toInt(),
  createdCount: (json['createdCount'] as num).toInt(),
  ignoredCount: (json['ignoredCount'] as num).toInt(),
  splitCount: (json['splitCount'] as num).toInt(),
  statementEndingBalance: const NullableAmountConverter().fromJson(
    json['statementEndingBalance'],
  ),
  ledgerBalance: const AmountConverter().fromJson(json['ledgerBalance']),
  difference: const NullableAmountConverter().fromJson(json['difference']),
);

Map<String, dynamic> _$ReconciliationSummaryResponseToJson(
  _ReconciliationSummaryResponse instance,
) => <String, dynamic>{
  'unmatchedCount': instance.unmatchedCount,
  'matchedCount': instance.matchedCount,
  'createdCount': instance.createdCount,
  'ignoredCount': instance.ignoredCount,
  'splitCount': instance.splitCount,
  'statementEndingBalance': const NullableAmountConverter().toJson(
    instance.statementEndingBalance,
  ),
  'ledgerBalance': const AmountConverter().toJson(instance.ledgerBalance),
  'difference': const NullableAmountConverter().toJson(instance.difference),
};

_AutoMatchResult _$AutoMatchResultFromJson(Map<String, dynamic> json) =>
    _AutoMatchResult(
      matchedCount: (json['matchedCount'] as num).toInt(),
      skippedCount: (json['skippedCount'] as num).toInt(),
    );

Map<String, dynamic> _$AutoMatchResultToJson(_AutoMatchResult instance) =>
    <String, dynamic>{
      'matchedCount': instance.matchedCount,
      'skippedCount': instance.skippedCount,
    };
