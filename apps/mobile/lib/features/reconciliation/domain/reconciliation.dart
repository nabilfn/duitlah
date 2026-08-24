// ignore_for_file: constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/amount_converter.dart';

part 'reconciliation.freezed.dart';
part 'reconciliation.g.dart';

/// Auto-detected server-side from the uploaded file's name/content-type —
/// the client never picks this, it just uploads whatever CSV/XLSX/PDF the
/// user chose.
enum StatementProvider { GENERIC_CSV, GENERIC_EXCEL, PDF }

enum BusinessStatementImportStatus { PARSED, FAILED }

enum StatementLineStatus { UNMATCHED, MATCHED, CREATED, IGNORED, SPLIT }

/// `EXACT` = same date + same amount; `PROBABLE` = amount matches within a
/// date window, or date matches within a small amount tolerance. No fuzzy
/// scoring beyond these two deterministic buckets.
enum MatchConfidence { EXACT, PROBABLE }

enum ReconciliationSessionStatus { IN_PROGRESS, COMPLETED }

/// One uploaded business bank statement. A reconciliation session is
/// auto-opened for every successful ([BusinessStatementImportStatus.PARSED])
/// import, so [reconciliationSessionId] is only ever null on a
/// [BusinessStatementImportStatus.FAILED] import.
@freezed
abstract class BusinessStatementImportResponse with _$BusinessStatementImportResponse {
  const factory BusinessStatementImportResponse({
    required String id,
    required String businessAccountId,
    required StatementProvider provider,
    required String originalFilename,
    required BusinessStatementImportStatus status,
    required int rowCount,
    String? errorMessage,
    String? reconciliationSessionId,
  }) = _BusinessStatementImportResponse;

  factory BusinessStatementImportResponse.fromJson(Map<String, dynamic> json) =>
      _$BusinessStatementImportResponseFromJson(json);
}

/// One row parsed out of a statement import. [amount] is signed: positive
/// means money in, negative means money out — unlike [EntryDirection] on
/// `business/domain/banking.dart`'s [AccountEntry], which splits direction
/// and magnitude into two fields.
@freezed
abstract class StatementLineResponse with _$StatementLineResponse {
  const factory StatementLineResponse({
    required String id,
    required String occurredOn,
    String? description,
    @AmountConverter() required String amount,
    required StatementLineStatus status,
  }) = _StatementLineResponse;

  factory StatementLineResponse.fromJson(Map<String, dynamic> json) =>
      _$StatementLineResponseFromJson(json);
}

/// A candidate existing ledger entry (from the same business account) that
/// might correspond to one still-[StatementLineStatus.UNMATCHED] line.
/// Deterministic, no fuzzy score beyond [confidence]'s two buckets.
@freezed
abstract class MatchSuggestionResponse with _$MatchSuggestionResponse {
  const factory MatchSuggestionResponse({
    required String businessAccountEntryId,
    required String occurredOn,
    String? description,
    @AmountConverter() required String signedAmount,
    required MatchConfidence confidence,
  }) = _MatchSuggestionResponse;

  factory MatchSuggestionResponse.fromJson(Map<String, dynamic> json) =>
      _$MatchSuggestionResponseFromJson(json);
}

/// One per successful statement import, auto-created. [statementEndingBalance]
/// is set (and the gap against [ledgerBalance] resolved) via
/// `POST .../resolve-difference`, which also completes the session.
@freezed
abstract class ReconciliationSessionResponse with _$ReconciliationSessionResponse {
  const factory ReconciliationSessionResponse({
    required String id,
    required String businessAccountId,
    required String businessStatementImportId,
    @NullableAmountConverter() String? statementEndingBalance,
    required ReconciliationSessionStatus status,
    required String startedAt,
    String? completedAt,
  }) = _ReconciliationSessionResponse;

  factory ReconciliationSessionResponse.fromJson(Map<String, dynamic> json) =>
      _$ReconciliationSessionResponseFromJson(json);
}

/// Per-line-status counts plus the balance comparison that "Resolve
/// Difference" acts on. [ledgerBalance] is the business account's current
/// computed balance (this phase assumes reconciling through the most recent
/// statement); [difference] is null until [statementEndingBalance] has been
/// set.
@freezed
abstract class ReconciliationSummaryResponse with _$ReconciliationSummaryResponse {
  const factory ReconciliationSummaryResponse({
    required int unmatchedCount,
    required int matchedCount,
    required int createdCount,
    required int ignoredCount,
    required int splitCount,
    @NullableAmountConverter() String? statementEndingBalance,
    @AmountConverter() required String ledgerBalance,
    @NullableAmountConverter() String? difference,
  }) = _ReconciliationSummaryResponse;

  factory ReconciliationSummaryResponse.fromJson(Map<String, dynamic> json) =>
      _$ReconciliationSummaryResponseFromJson(json);
}

/// `POST .../auto-match` result — auto-applies every `UNMATCHED` line with
/// exactly one EXACT suggestion, reusing the same `match(...)` path (and
/// audit trail) a manual match would use. A line with zero or more than one
/// EXACT candidate is left untouched; PROBABLE suggestions are never
/// auto-applied.
@freezed
abstract class AutoMatchResult with _$AutoMatchResult {
  const factory AutoMatchResult({
    required int matchedCount,
    required int skippedCount,
  }) = _AutoMatchResult;

  factory AutoMatchResult.fromJson(Map<String, dynamic> json) => _$AutoMatchResultFromJson(json);
}

/// One portion of a `POST .../lines/{lineId}/split` request — at least two
/// required, each a positive amount, all portions must sum to exactly the
/// line's absolute amount (409 `SPLIT_PORTIONS_DO_NOT_SUM_TO_LINE_AMOUNT`
/// otherwise).
class SplitPortionInput {
  SplitPortionInput({required this.description, required this.amount});

  final String? description;
  final String amount;

  Map<String, dynamic> toJson() => {
        if (description != null) 'description': description,
        'amount': amount,
      };
}
