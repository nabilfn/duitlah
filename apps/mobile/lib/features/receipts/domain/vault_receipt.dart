// ignore_for_file: constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/amount_converter.dart';

part 'vault_receipt.freezed.dart';
part 'vault_receipt.g.dart';

enum ReceiptPurpose { PERSONAL_EXPENSE, BUSINESS_EXPENSE, TAX_EVIDENCE, BAGILAH, UNSPECIFIED }

enum VaultOcrStatus { UNPROCESSED, PARSED, FAILED }

@freezed
abstract class VaultReceipt with _$VaultReceipt {
  const factory VaultReceipt({
    required String id,
    required ReceiptPurpose purpose,
    required VaultOcrStatus ocrStatus,
    String? merchant,
    String? receiptDate,
    @NullableAmountConverter() String? totalAmount,
    String? folder,
    required List<String> tags,
    String? linkedTransactionId,
    String? linkedBillId,
    required String imageUrl,
    /// Server-computed, same threshold as the Bagilah scan flow's
    /// `ReceiptScan.needsReview` — true when OCR confidence on this receipt
    /// is genuinely low.
    @Default(false) bool needsReview,
  }) = _VaultReceipt;

  factory VaultReceipt.fromJson(Map<String, dynamic> json) => _$VaultReceiptFromJson(json);
}

/// Same deterministic EXACT/PROBABLE two-tier shape as
/// `reconciliation.MatchingService` — no fuzzy text matching. Advisory only:
/// picking one still goes through the existing
/// `ReceiptVaultRepository.attachToTransaction` call.
enum ReceiptMatchConfidence { EXACT, PROBABLE }

@freezed
abstract class ReceiptMatchSuggestion with _$ReceiptMatchSuggestion {
  const factory ReceiptMatchSuggestion({
    required String transactionId,
    required String occurredOn,
    String? merchant,
    @AmountConverter() required String amount,
    required ReceiptMatchConfidence confidence,
  }) = _ReceiptMatchSuggestion;

  factory ReceiptMatchSuggestion.fromJson(Map<String, dynamic> json) =>
      _$ReceiptMatchSuggestionFromJson(json);
}
