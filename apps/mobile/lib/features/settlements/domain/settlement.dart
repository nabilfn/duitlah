// ignore_for_file: constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/amount_converter.dart';

part 'settlement.freezed.dart';
part 'settlement.g.dart';

enum SettlementStatus { UNPAID, PARTIALLY_PAID, PAID, CANCELLED, DISPUTED }

enum SourceType { BILL, GROUP }

@freezed
abstract class PaymentHandoffLink with _$PaymentHandoffLink {
  const factory PaymentHandoffLink({
    required String provider,
    required String instructions,
    String? url,
  }) = _PaymentHandoffLink;

  factory PaymentHandoffLink.fromJson(Map<String, dynamic> json) =>
      _$PaymentHandoffLinkFromJson(json);
}

@freezed
abstract class Settlement with _$Settlement {
  const factory Settlement({
    required String id,
    required String fromUserId,
    required String fromDisplayName,
    required String toUserId,
    required String toDisplayName,
    @AmountConverter() required String amount,
    @AmountConverter() required String amountPaid,
    @AmountConverter() required String amountRemaining,
    required SettlementStatus status,
    required SourceType sourceType,
    required String sourceId,
    required String createdAt,
    required PaymentHandoffLink handoff,
  }) = _Settlement;

  factory Settlement.fromJson(Map<String, dynamic> json) => _$SettlementFromJson(json);
}

@freezed
abstract class SettlementPayment with _$SettlementPayment {
  const factory SettlementPayment({
    required String id,
    @AmountConverter() required String amount,
    required String recordedByUserId,
    required String recordedByDisplayName,
    String? note,
    required String paidAt,
  }) = _SettlementPayment;

  factory SettlementPayment.fromJson(Map<String, dynamic> json) =>
      _$SettlementPaymentFromJson(json);
}

@freezed
abstract class CounterpartySummary with _$CounterpartySummary {
  const factory CounterpartySummary({
    required String userId,
    required String displayName,
    @AmountConverter() required String netAmount,
    required int oldestUnpaidDays,
  }) = _CounterpartySummary;

  factory CounterpartySummary.fromJson(Map<String, dynamic> json) =>
      _$CounterpartySummaryFromJson(json);
}

@freezed
abstract class SettlementSummary with _$SettlementSummary {
  const factory SettlementSummary({
    @AmountConverter() required String totalOwedToMe,
    @AmountConverter() required String totalIOwe,
    required List<CounterpartySummary> owedToMe,
    required List<CounterpartySummary> iOwe,
  }) = _SettlementSummary;

  factory SettlementSummary.fromJson(Map<String, dynamic> json) =>
      _$SettlementSummaryFromJson(json);
}
