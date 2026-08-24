import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/amount_converter.dart';
import '../../accounts/domain/finance.dart';

part 'insights.freezed.dart';
part 'insights.g.dart';

@freezed
abstract class CategorySpending with _$CategorySpending {
  const factory CategorySpending({
    required String categoryId,
    required String categoryName,
    @AmountConverter() required String amount,
  }) = _CategorySpending;

  factory CategorySpending.fromJson(Map<String, dynamic> json) => _$CategorySpendingFromJson(json);
}

@freezed
abstract class MonthlyTrend with _$MonthlyTrend {
  const factory MonthlyTrend({
    required int year,
    required int month,
    @AmountConverter() required String income,
    @AmountConverter() required String expense,
    @AmountConverter() required String savings,
  }) = _MonthlyTrend;

  factory MonthlyTrend.fromJson(Map<String, dynamic> json) => _$MonthlyTrendFromJson(json);
}

@freezed
abstract class MerchantSpending with _$MerchantSpending {
  const factory MerchantSpending({
    required String merchant,
    @AmountConverter() required String amount,
    required int transactionCount,
  }) = _MerchantSpending;

  factory MerchantSpending.fromJson(Map<String, dynamic> json) => _$MerchantSpendingFromJson(json);
}

@freezed
abstract class CalendarEntry with _$CalendarEntry {
  const factory CalendarEntry({
    required String date,
    required bool confirmed,
    required TransactionType type,
    required TransactionDirection direction,
    @AmountConverter() required String amount,
    String? merchant,
    String? description,
  }) = _CalendarEntry;

  factory CalendarEntry.fromJson(Map<String, dynamic> json) => _$CalendarEntryFromJson(json);
}

@freezed
abstract class Forecast with _$Forecast {
  const factory Forecast({
    @AmountConverter() required String currentBalance,
    required String asOfDate,
    required String targetDate,
    @AmountConverter() required String scheduledIncome,
    @AmountConverter() required String scheduledExpense,
    @AmountConverter() required String predictedVariableExpense,
    @AmountConverter() required String projectedBalance,
    required String disclaimer,
  }) = _Forecast;

  factory Forecast.fromJson(Map<String, dynamic> json) => _$ForecastFromJson(json);
}
