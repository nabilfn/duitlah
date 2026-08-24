// ignore_for_file: constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/amount_converter.dart';

part 'personal_bill.freezed.dart';
part 'personal_bill.g.dart';

enum BillRecurrence { NONE, WEEKLY, MONTHLY, YEARLY }

enum BillStatus { UPCOMING, DUE, PAID, OVERDUE, SKIPPED }

@freezed
abstract class PersonalBill with _$PersonalBill {
  const factory PersonalBill({
    required String id,
    required String name,
    String? provider,
    required String dueDate,
    @AmountConverter() required String expectedAmount,
    required BillRecurrence recurrence,
    required BillStatus status,
    String? linkedTransactionId,
    String? receiptId,
    String? notes,
  }) = _PersonalBill;

  factory PersonalBill.fromJson(Map<String, dynamic> json) => _$PersonalBillFromJson(json);
}
