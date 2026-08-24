// ignore_for_file: constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/amount_converter.dart';

part 'budget.freezed.dart';
part 'budget.g.dart';

enum BudgetStatus { OK, WARNING, EXCEEDED }

enum BudgetCycleType { CALENDAR_MONTH, PAYDAY, CUSTOM }

enum GoalType {
  EMERGENCY_FUND,
  TRAVEL,
  DEVICE,
  HOUSE_DEPOSIT,
  CAR,
  EDUCATION,
  WEDDING,
  CUSTOM,
}

@freezed
abstract class Budget with _$Budget {
  const factory Budget({
    required String id,
    String? categoryId,
    required String categoryName,
    required int periodYear,
    required int periodMonth,
    required BudgetCycleType cycleType,
    String? periodStartDate,
    String? periodEndDate,
    @AmountConverter() required String limit,
    @AmountConverter() required String spent,
    @AmountConverter() required String remaining,
    required BudgetStatus status,
  }) = _Budget;

  factory Budget.fromJson(Map<String, dynamic> json) => _$BudgetFromJson(json);
}

@freezed
abstract class Goal with _$Goal {
  const factory Goal({
    required String id,
    required String name,
    required GoalType type,
    @AmountConverter() required String targetAmount,
    String? targetDate,
    @AmountConverter() required String currentAmount,
    @AmountConverter() required String remaining,
    @AmountConverter() required String percentage,
    required bool archived,
  }) = _Goal;

  factory Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);
}

@freezed
abstract class GoalContribution with _$GoalContribution {
  const factory GoalContribution({
    required String id,
    @AmountConverter() required String amount,
    required String occurredOn,
    String? note,
  }) = _GoalContribution;

  factory GoalContribution.fromJson(Map<String, dynamic> json) => _$GoalContributionFromJson(json);
}
