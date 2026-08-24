// ignore_for_file: constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/amount_converter.dart';

part 'receipt_scan.freezed.dart';
part 'receipt_scan.g.dart';

enum ScanStatus { PARSED, FAILED, CONFIRMED }

@freezed
abstract class ParsedReceiptItem with _$ParsedReceiptItem {
  const factory ParsedReceiptItem({
    String? name,
    @NullableAmountConverter() String? quantity,
    @NullableAmountConverter() String? unitPrice,
    @NullableAmountConverter() String? totalPrice,
    required double confidence,
  }) = _ParsedReceiptItem;

  factory ParsedReceiptItem.fromJson(Map<String, dynamic> json) =>
      _$ParsedReceiptItemFromJson(json);
}

@freezed
abstract class ParsedReceipt with _$ParsedReceipt {
  const factory ParsedReceipt({
    String? merchant,
    required double merchantConfidence,
    String? receiptDate,
    required double receiptDateConfidence,
    required List<ParsedReceiptItem> items,
    @NullableAmountConverter() String? tax,
    required double taxConfidence,
    @NullableAmountConverter() String? serviceCharge,
    required double serviceConfidence,
    @NullableAmountConverter() String? discount,
    required double discountConfidence,
    @NullableAmountConverter() String? total,
    required double totalConfidence,
    required double overallConfidence,
  }) = _ParsedReceipt;

  factory ParsedReceipt.fromJson(Map<String, dynamic> json) => _$ParsedReceiptFromJson(json);
}

@freezed
abstract class ReceiptScan with _$ReceiptScan {
  const factory ReceiptScan({
    required String id,
    required ScanStatus status,
    required String provider,
    double? overallConfidence,
    /// Server-computed (`ParsedReceipt.needsReview()`, true when
    /// `overallConfidence < 0.7`) — the one threshold every client should use
    /// rather than guessing its own cutoff.
    @Default(false) bool needsReview,
    required ParsedReceipt parsedReceipt,
    required String imageUrl,
    String? errorMessage,
    String? billId,
  }) = _ReceiptScan;

  factory ReceiptScan.fromJson(Map<String, dynamic> json) => _$ReceiptScanFromJson(json);
}
