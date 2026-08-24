// ignore_for_file: constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/amount_converter.dart';

part 'personal_tax.freezed.dart';
part 'personal_tax.g.dart';

enum IncomeType { EMPLOYMENT, BUSINESS, RENTAL, OTHER }

enum TaxDocumentType {
  EA,
  EC,
  PCB_EVIDENCE,
  INSURANCE_STATEMENT,
  EPF_STATEMENT,
  PRS_STATEMENT,
  ZAKAT_RECEIPT,
  MEDICAL_RECEIPT,
  EDUCATION_RECEIPT,
  DONATION_EVIDENCE,
  OTHER,
}

enum PersonalTaxReliefCategory {
  SPOUSE,
  CHILD,
  DISABLED_INDIVIDUAL,
  PARENTS_MEDICAL_CARE,
  MEDICAL_SERIOUS_ILLNESS,
  EDUCATION_FEES,
  LIFESTYLE,
  LIFESTYLE_SPORTS,
  EPF_LIFE_INSURANCE,
  PRS,
  SSPN,
  EV_CHARGING,
  OTHER,
}

enum TaxReliefCandidateStatus { POTENTIALLY_ELIGIBLE, NEEDS_REVIEW, MISSING_EVIDENCE, CONFIRMED, REJECTED }

@freezed
abstract class PersonalIncomeRecord with _$PersonalIncomeRecord {
  const factory PersonalIncomeRecord({
    required String id,
    required int yearOfAssessment,
    required IncomeType incomeType,
    @AmountConverter() required String amount,
    String? description,
  }) = _PersonalIncomeRecord;

  factory PersonalIncomeRecord.fromJson(Map<String, dynamic> json) => _$PersonalIncomeRecordFromJson(json);
}

@freezed
abstract class PcbPayment with _$PcbPayment {
  const factory PcbPayment({
    required String id,
    required int yearOfAssessment,
    required int month,
    @AmountConverter() required String amount,
    String? notes,
  }) = _PcbPayment;

  factory PcbPayment.fromJson(Map<String, dynamic> json) => _$PcbPaymentFromJson(json);
}

@freezed
abstract class ZakatPayment with _$ZakatPayment {
  const factory ZakatPayment({
    required String id,
    required int yearOfAssessment,
    @AmountConverter() required String amount,
    required String paidOn,
    String? receiptId,
    String? notes,
  }) = _ZakatPayment;

  factory ZakatPayment.fromJson(Map<String, dynamic> json) => _$ZakatPaymentFromJson(json);
}

@freezed
abstract class PersonalTaxDocument with _$PersonalTaxDocument {
  const factory PersonalTaxDocument({
    required String id,
    required int yearOfAssessment,
    required TaxDocumentType type,
    String? receiptId,
    required bool hasFile,
    String? notes,
  }) = _PersonalTaxDocument;

  factory PersonalTaxDocument.fromJson(Map<String, dynamic> json) => _$PersonalTaxDocumentFromJson(json);
}

@freezed
abstract class TaxReliefCandidate with _$TaxReliefCandidate {
  const factory TaxReliefCandidate({
    required String id,
    required int yearOfAssessment,
    PersonalTaxReliefCategory? category,
    String? sourceReceiptId,
    @AmountConverter() required String suggestedAmount,
    required TaxReliefCandidateStatus status,
    String? notes,
  }) = _TaxReliefCandidate;

  factory TaxReliefCandidate.fromJson(Map<String, dynamic> json) => _$TaxReliefCandidateFromJson(json);
}

@freezed
abstract class ConfirmedTaxRelief with _$ConfirmedTaxRelief {
  const factory ConfirmedTaxRelief({
    required String id,
    required int yearOfAssessment,
    required PersonalTaxReliefCategory category,
    @AmountConverter() required String confirmedAmount,
  }) = _ConfirmedTaxRelief;

  factory ConfirmedTaxRelief.fromJson(Map<String, dynamic> json) => _$ConfirmedTaxReliefFromJson(json);
}

@freezed
abstract class TaxReliefLine with _$TaxReliefLine {
  const factory TaxReliefLine({
    required String label,
    @AmountConverter() required String claimedAmount,
    @AmountConverter() required String maxAmount,
  }) = _TaxReliefLine;

  factory TaxReliefLine.fromJson(Map<String, dynamic> json) => _$TaxReliefLineFromJson(json);
}

@freezed
abstract class PersonalTaxCalculation with _$PersonalTaxCalculation {
  const factory PersonalTaxCalculation({
    required int yearOfAssessment,
    @AmountConverter() required String totalIncome,
    @AmountConverter() required String residentIndividualRelief,
    required List<TaxReliefLine> reliefs,
    @AmountConverter() required String totalReliefs,
    @AmountConverter() required String chargeableIncome,
    @AmountConverter() required String grossTaxPayable,
    @AmountConverter() required String rebate,
    @AmountConverter() required String zakatPaid,
    @AmountConverter() required String zakatRebate,
    @AmountConverter() required String taxAfterRebatesAndZakat,
    @AmountConverter() required String pcbPaid,
    @AmountConverter() required String estimatedPayableOrRefund,
    required String disclaimer,
  }) = _PersonalTaxCalculation;

  factory PersonalTaxCalculation.fromJson(Map<String, dynamic> json) => _$PersonalTaxCalculationFromJson(json);
}

@freezed
abstract class FilingReadinessItem with _$FilingReadinessItem {
  const factory FilingReadinessItem({
    required String key,
    required String label,
    required bool ready,
    required String explanation,
  }) = _FilingReadinessItem;

  factory FilingReadinessItem.fromJson(Map<String, dynamic> json) => _$FilingReadinessItemFromJson(json);
}

@freezed
abstract class FilingReadiness with _$FilingReadiness {
  const factory FilingReadiness({
    required int yearOfAssessment,
    @AmountConverter() required String readyPercent,
    required List<FilingReadinessItem> items,
  }) = _FilingReadiness;

  factory FilingReadiness.fromJson(Map<String, dynamic> json) => _$FilingReadinessFromJson(json);
}
