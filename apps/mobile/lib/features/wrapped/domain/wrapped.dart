import 'package:freezed_annotation/freezed_annotation.dart';

import 'wrapped_story_data.dart';

import '../../../core/utils/amount_converter.dart';

part 'wrapped.freezed.dart';
part 'wrapped.g.dart';

/// Drives the Home promo card (`GET /api/v1/wrapped/promo`). `year`/`month`/
/// `personaName` are only ever non-null together with `available: true`.
@freezed
abstract class WrappedPromo with _$WrappedPromo {
  const factory WrappedPromo({
    required bool available,
    int? year,
    int? month,
    String? personaName,
  }) = _WrappedPromo;

  factory WrappedPromo.fromJson(Map<String, dynamic> json) =>
      _$WrappedPromoFromJson(json);
}

/// One row of `GET /api/v1/wrapped` (history), newest-month-first.
/// `personaId`/`personaName` are null for a month with insufficient data.
@freezed
abstract class WrappedHistoryItem with _$WrappedHistoryItem {
  const factory WrappedHistoryItem({
    required int year,
    required int month,
    String? personaId,
    String? personaName,
    required bool viewed,
  }) = _WrappedHistoryItem;

  factory WrappedHistoryItem.fromJson(Map<String, dynamic> json) =>
      _$WrappedHistoryItemFromJson(json);
}

/// The month's real numbers — always populated even when [WrappedResult.sufficientData]
/// is false. `spendingChangePercentage`/`incomeChangePercentage` are null when there's no
/// prior-month figure to compare against; never render "null%"/"0%" in that case.
@freezed
abstract class WrappedOverview with _$WrappedOverview {
  const factory WrappedOverview({
    required int year,
    required int month,
    @AmountConverter() required String totalIncome,
    @AmountConverter() required String totalExpense,
    @AmountConverter() required String netAmount,
    @AmountConverter() required String totalSavingsContribution,
    required int transactionCount,
    double? spendingChangePercentage,
    double? incomeChangePercentage,
  }) = _WrappedOverview;

  factory WrappedOverview.fromJson(Map<String, dynamic> json) =>
      _$WrappedOverviewFromJson(json);
}

/// The "Money Persona" reveal. Entirely absent (see [WrappedResult.persona]) when the
/// backend judged the month's activity too thin to call out a persona — never fabricate
/// one client-side.
@freezed
abstract class WrappedPersona with _$WrappedPersona {
  const factory WrappedPersona({
    required String id,
    required String name,
    required String tagline,

    /// One of exactly 10 keys — see `presentation/widgets/persona_visuals.dart` for the
    /// colour treatment + line-art motif mapped to each.
    required String visualTheme,
    @AmountConverter() required String amount,
    required double percentage,
    required String denominatorLabel,
    required double score,
    required List<String> evidence,
  }) = _WrappedPersona;

  factory WrappedPersona.fromJson(Map<String, dynamic> json) =>
      _$WrappedPersonaFromJson(json);
}

/// One of 0-4 generic story insights. `type` is one of up to 10 backend-defined values,
/// but every insight is rendered identically from these 4 fields — never a per-type layout.
@freezed
abstract class WrappedInsight with _$WrappedInsight {
  const factory WrappedInsight({
    required String type,
    required String title,
    required String primaryValue,
    String? secondaryValue,
    String? comparison,
  }) = _WrappedInsight;

  factory WrappedInsight.fromJson(Map<String, dynamic> json) =>
      _$WrappedInsightFromJson(json);
}

/// Always present — one supportive, non-judgmental sentence for next month.
@freezed
abstract class WrappedGoal with _$WrappedGoal {
  const factory WrappedGoal({required String message}) = _WrappedGoal;

  factory WrappedGoal.fromJson(Map<String, dynamic> json) =>
      _$WrappedGoalFromJson(json);
}

/// The full `GET /api/v1/wrapped/{year}/{month}` story payload. Generated lazily on first
/// request and persisted forever after by the backend — a second call for the same month
/// always returns the identical result.
@freezed
abstract class WrappedResult with _$WrappedResult {
  const factory WrappedResult({
    required int year,
    required int month,
    required int version,
    required String generatedAt,
    required bool sufficientData,
    required WrappedOverview overview,
    WrappedPersona? persona,
    required List<WrappedInsight> insights,
    required WrappedGoal recommendedGoal,
    WrappedStoryData? story,
  }) = _WrappedResult;

  factory WrappedResult.fromJson(Map<String, dynamic> json) =>
      _$WrappedResultFromJson(json);
}
