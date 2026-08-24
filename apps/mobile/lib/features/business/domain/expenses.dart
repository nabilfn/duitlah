// ignore_for_file: constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/amount_converter.dart';

part 'expenses.freezed.dart';
part 'expenses.g.dart';

/// Server-computed on every payment — never set directly by the client.
enum ExpenseStatus { UNPAID, PARTIALLY_PAID, PAID }

/// An expense with [supplierId] set IS the payable bill — there is no
/// separate purchase-order concept in this phase.
@freezed
abstract class Expense with _$Expense {
  const factory Expense({
    required String id,
    String? supplierId,
    String? category,
    @AmountConverter() required String amount,
    @AmountConverter() required String amountPaid,
    @AmountConverter() required String amountRemaining,
    required String occurredOn,
    required ExpenseStatus status,
    String? receiptId,
    /// Phase 6 — the Chart of Accounts ledger account this expense posts
    /// to automatically when a payment is recorded against it. Null means
    /// unmapped.
    String? chartOfAccountsId,
    String? notes,
  }) = _Expense;

  factory Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);
}

@freezed
abstract class ExpensePayment with _$ExpensePayment {
  const factory ExpensePayment({
    required String id,
    required String businessAccountId,
    @AmountConverter() required String amount,
    required String paidOn,
    String? notes,
  }) = _ExpensePayment;

  factory ExpensePayment.fromJson(Map<String, dynamic> json) => _$ExpensePaymentFromJson(json);
}
