// ignore_for_file: constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/amount_converter.dart';
import '../../accounts/domain/finance.dart' show TransactionDirection;

part 'transaction_candidate.freezed.dart';
part 'transaction_candidate.g.dart';

enum CandidateSourceType { RECEIPT_OCR, STATEMENT_CSV, STATEMENT_XLSX, STATEMENT_PDF }

enum CandidateStatus { PENDING, CONFIRMED, REJECTED, DUPLICATE, FAILED }

@freezed
abstract class TransactionCandidate with _$TransactionCandidate {
  const factory TransactionCandidate({
    required String id,
    required CandidateSourceType sourceType,
    @AmountConverter() required String detectedAmount,
    required String detectedCurrency,
    String? detectedMerchant,
    required String detectedDate,
    required TransactionDirection detectedDirection,
    String? suggestedAccountId,
    String? suggestedCategoryId,
    @AmountConverter() required String confidence,
    required CandidateStatus status,
    String? duplicateOfTransactionId,
    @NullableAmountConverter() String? duplicateConfidence,
    String? resultingTransactionId,
  }) = _TransactionCandidate;

  factory TransactionCandidate.fromJson(Map<String, dynamic> json) =>
      _$TransactionCandidateFromJson(json);
}

enum StatementProvider { GENERIC_CSV, GENERIC_EXCEL, PDF }

enum StatementImportStatus { UPLOADED, PARSED, FAILED }

@freezed
abstract class StatementImport with _$StatementImport {
  const factory StatementImport({
    required String id,
    required String accountId,
    required StatementProvider provider,
    required String originalFilename,
    required StatementImportStatus status,
    required int rowCount,
    String? errorMessage,
  }) = _StatementImport;

  factory StatementImport.fromJson(Map<String, dynamic> json) => _$StatementImportFromJson(json);
}
