// ignore_for_file: constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/amount_converter.dart';

part 'fixed_assets.freezed.dart';
part 'fixed_assets.g.dart';

/// Phase 9 — Fixed Assets. `STRAIGHT_LINE` spreads (cost - salvageValue)
/// evenly over [FixedAssetResponse.usefulLifeMonths]; `DOUBLE_DECLINING_BALANCE`
/// front-loads it at twice the straight-line rate against the *declining*
/// net book value. The client never computes either — it only ever displays
/// the server's own posted [DepreciationEntryResponse.amount] figures.
enum DepreciationMethod { STRAIGHT_LINE, DOUBLE_DECLINING_BALANCE }

enum FixedAssetStatus { ACTIVE, DISPOSED }

/// One asset in the register. [accumulatedDepreciation] and [netBookValue]
/// are always server-computed from posted [DepreciationEntryResponse]s —
/// never sent by the client on create/update. Once at least one
/// depreciation entry has been posted, the server locks
/// cost/salvageValue/usefulLifeMonths/depreciationMethod/acquisitionDate
/// (409 `ASSET_FINANCIALS_LOCKED` on an update attempt) — only
/// name/category stay freely editable after that point.
@freezed
abstract class FixedAssetResponse with _$FixedAssetResponse {
  const factory FixedAssetResponse({
    required String id,
    required String name,
    String? category,
    required String acquisitionDate,
    @AmountConverter() required String cost,
    @AmountConverter() required String salvageValue,
    required int usefulLifeMonths,
    required DepreciationMethod depreciationMethod,
    required FixedAssetStatus status,
    String? disposedOn,
    @NullableAmountConverter() String? disposalProceeds,
    @AmountConverter() required String accumulatedDepreciation,
    @AmountConverter() required String netBookValue,
  }) = _FixedAssetResponse;

  factory FixedAssetResponse.fromJson(Map<String, dynamic> json) => _$FixedAssetResponseFromJson(json);
}

/// One posted depreciation entry for an asset. [period] is always
/// normalized to the 1st of its month by the server, regardless of what day
/// the manual "run" request sent.
@freezed
abstract class DepreciationEntryResponse with _$DepreciationEntryResponse {
  const factory DepreciationEntryResponse({
    required String id,
    required String assetId,
    required String period,
    @AmountConverter() required String amount,
    required String createdAt,
  }) = _DepreciationEntryResponse;

  factory DepreciationEntryResponse.fromJson(Map<String, dynamic> json) =>
      _$DepreciationEntryResponseFromJson(json);
}
