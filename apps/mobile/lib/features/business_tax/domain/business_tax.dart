// ignore_for_file: constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/amount_converter.dart';

part 'business_tax.freezed.dart';
part 'business_tax.g.dart';

/// Phase 10 — LHDN / MyInvois / SST. Sales tax and service tax under
/// Malaysia's SST regime — two separate taxes despite the shared "SST" name.
enum TaxType { SALES, SERVICE }

/// One row of global SST reference rate data — never editable from the
/// client, just displayed. [effectiveTo] null means this rate is still the
/// current one for its [taxType].
@freezed
abstract class SstRate with _$SstRate {
  const factory SstRate({
    required TaxType taxType,
    @AmountConverter() required String ratePercent,
    required String effectiveFrom,
    String? effectiveTo,
    String? description,
  }) = _SstRate;

  factory SstRate.fromJson(Map<String, dynamic> json) => _$SstRateFromJson(json);
}

/// Collected vs. payable SST for a date range, entirely server-computed —
/// the client never sums these itself.
@freezed
abstract class SstReport with _$SstReport {
  const factory SstReport({
    required String from,
    required String to,
    @AmountConverter() required String collectedTax,
    @AmountConverter() required String payableTax,
  }) = _SstReport;

  factory SstReport.fromJson(Map<String, dynamic> json) => _$SstReportFromJson(json);
}

/// Whether e-Invoicing (MyInvois) is currently mandatory for this business,
/// and if not yet [ready], what's missing from the business profile.
/// [missingFields] entries are raw backend field names (`"tin"`,
/// `"financialYear"`, ...) — the presentation layer maps them to plain-
/// language copy rather than showing them verbatim.
@freezed
abstract class EInvoiceReadiness with _$EInvoiceReadiness {
  const factory EInvoiceReadiness({
    required bool mandated,
    String? currentRuleEffectiveDate,
    @NullableAmountConverter() String? currentRuleThreshold,
    required List<String> missingFields,
    required bool ready,
  }) = _EInvoiceReadiness;

  factory EInvoiceReadiness.fromJson(Map<String, dynamic> json) => _$EInvoiceReadinessFromJson(json);
}
