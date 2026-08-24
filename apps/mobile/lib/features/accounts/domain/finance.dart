// ignore_for_file: constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/amount_converter.dart';

part 'finance.freezed.dart';
part 'finance.g.dart';

enum AccountType { CASH, BANK, E_WALLET, CREDIT_CARD, SAVINGS, INVESTMENT, OTHER }

enum CategoryType { INCOME, EXPENSE }

enum TransactionType { INCOME, EXPENSE, TRANSFER }

enum TransactionDirection { IN, OUT }

@freezed
abstract class Account with _$Account {
  const factory Account({
    required String id,
    required String name,
    required AccountType type,
    required String currency,
    @AmountConverter() required String openingBalance,
    @AmountConverter() required String balance,
    required bool archived,
  }) = _Account;

  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);
}

@freezed
abstract class Category with _$Category {
  const factory Category({
    required String id,
    String? parentId,
    required CategoryType type,
    required String name,
    String? icon,
    required bool custom,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
}

@freezed
abstract class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required String accountId,
    required TransactionType type,
    required TransactionDirection direction,
    String? categoryId,
    String? transferGroupId,
    String? recurringTransactionId,
    @AmountConverter() required String amount,
    String? merchant,
    String? description,
    String? notes,
    required String occurredOn,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);
}

@freezed
abstract class DashboardSummary with _$DashboardSummary {
  const factory DashboardSummary({
    @AmountConverter() required String availableBalance,
    @AmountConverter() required String monthIncome,
    @AmountConverter() required String monthExpense,
    required List<Transaction> recentTransactions,
  }) = _DashboardSummary;

  factory DashboardSummary.fromJson(Map<String, dynamic> json) => _$DashboardSummaryFromJson(json);
}

@freezed
abstract class TransactionPage with _$TransactionPage {
  const factory TransactionPage({
    required List<Transaction> content,
    required int totalElements,
    required int totalPages,
    required int number,
    required int size,
  }) = _TransactionPage;

  factory TransactionPage.fromJson(Map<String, dynamic> json) => _$TransactionPageFromJson(json);
}
