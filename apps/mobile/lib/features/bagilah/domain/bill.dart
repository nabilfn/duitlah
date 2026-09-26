import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/amount_converter.dart';
import 'bagilah_enums.dart';

part 'bill.freezed.dart';
part 'bill.g.dart';

@freezed
abstract class Bill with _$Bill {
  const factory Bill({
    required String id,
    required String ownerUserId,
    String? groupId,
    String? merchant,
    required String receiptDate,
    required String currency,
    @AmountConverter() required String tax,
    required AllocationStrategy taxStrategy,
    @AmountConverter() required String serviceCharge,
    required AllocationStrategy serviceStrategy,
    @AmountConverter() required String discount,
    String? discountLabel,
    @NullableAmountConverter() String? declaredTotal,
    @NullableAmountConverter() String? total,
    @NullableAmountConverter() String? roundingAdjustment,
    required BillStatus status,
    String? finalizedAt,
  }) = _Bill;

  factory Bill.fromJson(Map<String, dynamic> json) => _$BillFromJson(json);
}

@freezed
abstract class ReceiptItem with _$ReceiptItem {
  const factory ReceiptItem({
    required String id,
    required String name,
    @AmountConverter() required String quantity,
    @AmountConverter() required String unitPrice,
    @AmountConverter() required String itemDiscount,
    @AmountConverter() required String totalPrice,
  }) = _ReceiptItem;

  factory ReceiptItem.fromJson(Map<String, dynamic> json) =>
      _$ReceiptItemFromJson(json);
}

@freezed
abstract class Participant with _$Participant {
  const factory Participant({
    required String id,
    String? userId,
    required String displayName,
    required bool guest,
  }) = _Participant;

  factory Participant.fromJson(Map<String, dynamic> json) =>
      _$ParticipantFromJson(json);
}

@freezed
abstract class Claim with _$Claim {
  const factory Claim({
    required String id,
    required String participantId,
    required String displayName,
    required ClaimType claimType,
    @AmountConverter() required String value,
  }) = _Claim;

  factory Claim.fromJson(Map<String, dynamic> json) => _$ClaimFromJson(json);
}

@freezed
abstract class BillPayment with _$BillPayment {
  const factory BillPayment({
    required String participantId,
    required String displayName,
    @AmountConverter() required String amountPaid,
  }) = _BillPayment;

  factory BillPayment.fromJson(Map<String, dynamic> json) =>
      _$BillPaymentFromJson(json);
}

@freezed
abstract class ItemIssue with _$ItemIssue {
  const factory ItemIssue({
    required String itemId,
    required String itemName,
    required IssueType type,
  }) = _ItemIssue;

  factory ItemIssue.fromJson(Map<String, dynamic> json) =>
      _$ItemIssueFromJson(json);
}

@freezed
abstract class ParticipantBreakdown with _$ParticipantBreakdown {
  const factory ParticipantBreakdown({
    required String participantId,
    required String displayName,
    @AmountConverter() required String subtotal,
    @AmountConverter() required String taxShare,
    @AmountConverter() required String serviceShare,
    @AmountConverter() required String discountShare,
    @AmountConverter() required String roundingShare,
    @AmountConverter() required String finalAmount,
  }) = _ParticipantBreakdown;

  factory ParticipantBreakdown.fromJson(Map<String, dynamic> json) =>
      _$ParticipantBreakdownFromJson(json);
}

@freezed
abstract class Breakdown with _$Breakdown {
  const factory Breakdown({
    required bool valid,
    required List<ItemIssue> issues,
    @AmountConverter() required String subtotal,
    @AmountConverter() required String computedTotal,
    @AmountConverter() required String roundingAdjustment,
    required List<ParticipantBreakdown> participants,
  }) = _Breakdown;

  factory Breakdown.fromJson(Map<String, dynamic> json) =>
      _$BreakdownFromJson(json);
}

@freezed
abstract class BillBalance with _$BillBalance {
  const factory BillBalance({
    required String participantId,
    required String displayName,
    @AmountConverter() required String paid,
    @AmountConverter() required String owed,
    @AmountConverter() required String net,
  }) = _BillBalance;

  factory BillBalance.fromJson(Map<String, dynamic> json) =>
      _$BillBalanceFromJson(json);
}

@freezed
abstract class JoinBillResponse with _$JoinBillResponse {
  const factory JoinBillResponse({
    required String billId,
    required String participantId,
    required String displayName,
    required bool guest,
    String? guestToken,
  }) = _JoinBillResponse;

  factory JoinBillResponse.fromJson(Map<String, dynamic> json) =>
      _$JoinBillResponseFromJson(json);
}
