// ignore_for_file: constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/amount_converter.dart';

part 'net_worth.freezed.dart';
part 'net_worth.g.dart';

enum AssetType { PROPERTY, VEHICLE, OTHER }

@freezed
abstract class BreakdownLine with _$BreakdownLine {
  const factory BreakdownLine({required String label, @AmountConverter() required String amount}) =
      _BreakdownLine;

  factory BreakdownLine.fromJson(Map<String, dynamic> json) => _$BreakdownLineFromJson(json);
}

@freezed
abstract class NetWorth with _$NetWorth {
  const factory NetWorth({
    @AmountConverter() required String totalAssets,
    @AmountConverter() required String totalLiabilities,
    @AmountConverter() required String netWorth,
    required List<BreakdownLine> assetsBreakdown,
    required List<BreakdownLine> liabilitiesBreakdown,
  }) = _NetWorth;

  factory NetWorth.fromJson(Map<String, dynamic> json) => _$NetWorthFromJson(json);
}

@freezed
abstract class OtherAsset with _$OtherAsset {
  const factory OtherAsset({
    required String id,
    required AssetType type,
    required String name,
    @AmountConverter() required String estimatedValue,
    String? notes,
  }) = _OtherAsset;

  factory OtherAsset.fromJson(Map<String, dynamic> json) => _$OtherAssetFromJson(json);
}

@freezed
abstract class NetWorthSnapshot with _$NetWorthSnapshot {
  const factory NetWorthSnapshot({
    required String id,
    @AmountConverter() required String totalAssets,
    @AmountConverter() required String totalLiabilities,
    @AmountConverter() required String netWorth,
    required String snapshotDate,
  }) = _NetWorthSnapshot;

  factory NetWorthSnapshot.fromJson(Map<String, dynamic> json) => _$NetWorthSnapshotFromJson(json);
}
