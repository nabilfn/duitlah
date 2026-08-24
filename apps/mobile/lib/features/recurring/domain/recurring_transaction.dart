// ignore_for_file: constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/amount_converter.dart';
import '../../accounts/domain/finance.dart';

part 'recurring_transaction.freezed.dart';
part 'recurring_transaction.g.dart';

enum RecurrenceFrequency { DAILY, WEEKLY, MONTHLY, YEARLY }

@freezed
abstract class RecurringTransaction with _$RecurringTransaction {
  const factory RecurringTransaction({
    required String id,
    required String accountId,
    required TransactionType type,
    required TransactionDirection direction,
    String? categoryId,
    @AmountConverter() required String amount,
    String? merchant,
    String? description,
    String? notes,
    required RecurrenceFrequency frequency,
    required int intervalCount,
    required String startDate,
    String? endDate,
    required String nextOccurrenceDate,
    required bool isSubscription,
    required bool active,
  }) = _RecurringTransaction;

  factory RecurringTransaction.fromJson(Map<String, dynamic> json) =>
      _$RecurringTransactionFromJson(json);
}

@freezed
abstract class SubscriptionsSummary with _$SubscriptionsSummary {
  const factory SubscriptionsSummary({
    @AmountConverter() required String estimatedMonthlyTotal,
    required List<RecurringTransaction> subscriptions,
  }) = _SubscriptionsSummary;

  factory SubscriptionsSummary.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionsSummaryFromJson(json);
}
