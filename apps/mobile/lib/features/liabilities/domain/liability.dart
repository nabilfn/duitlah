// ignore_for_file: constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/amount_converter.dart';

part 'liability.freezed.dart';
part 'liability.g.dart';

enum LiabilityType {
  PERSONAL_LOAN,
  CAR_LOAN,
  HOUSING_LOAN,
  EDUCATION_LOAN,
  PTPTN,
  BNPL,
  OTHER,
}

enum LiabilityStatus { ACTIVE, PAID_OFF, DEFAULTED }

@freezed
abstract class Liability with _$Liability {
  const factory Liability({
    required String id,
    required LiabilityType type,
    required String name,
    String? lender,
    @AmountConverter() required String originalAmount,
    @AmountConverter() required String outstandingPrincipal,
    @NullableAmountConverter() String? interestRatePercent,
    @NullableAmountConverter() String? instalmentAmount,
    String? nextDueDate,
    String? maturityDate,
    required LiabilityStatus status,
  }) = _Liability;

  factory Liability.fromJson(Map<String, dynamic> json) => _$LiabilityFromJson(json);
}

@freezed
abstract class LiabilityPayment with _$LiabilityPayment {
  const factory LiabilityPayment({
    required String id,
    @AmountConverter() required String amount,
    @AmountConverter() required String principalPortion,
    @AmountConverter() required String interestPortion,
    required String paidOn,
    String? linkedTransactionId,
  }) = _LiabilityPayment;

  factory LiabilityPayment.fromJson(Map<String, dynamic> json) => _$LiabilityPaymentFromJson(json);
}

@freezed
abstract class CreditCardDetails with _$CreditCardDetails {
  const factory CreditCardDetails({
    required String accountId,
    @AmountConverter() required String creditLimit,
    required int statementDay,
    required int paymentDueDay,
    @AmountConverter() required String minimumPaymentPercent,
    @AmountConverter() required String currentOutstanding,
    @AmountConverter() required String availableCredit,
    @AmountConverter() required String utilization,
    @AmountConverter() required String statementBalance,
    @AmountConverter() required String minimumPaymentDue,
  }) = _CreditCardDetails;

  factory CreditCardDetails.fromJson(Map<String, dynamic> json) => _$CreditCardDetailsFromJson(json);
}
