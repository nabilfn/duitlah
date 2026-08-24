// ignore_for_file: constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/amount_converter.dart';

part 'group.freezed.dart';
part 'group.g.dart';

enum GroupType { GENERAL, HOUSEMATES, COUPLE, TRIP, FRIENDS, FAMILY, TEAM, EVENT }

enum GroupMemberRole { OWNER, MEMBER }

enum GroupExpenseCategory {
  RENT,
  ELECTRICITY,
  WATER,
  INTERNET,
  GROCERIES,
  CLEANING,
  HOUSEHOLD,
  STREAMING,
  FLIGHTS,
  ACCOMMODATION,
  FOOD,
  TRANSPORT,
  ACTIVITIES,
  SHOPPING,
  OTHER,
}

@freezed
abstract class Group with _$Group {
  const factory Group({
    required String id,
    required String name,
    required GroupType type,
    required GroupMemberRole yourRole,
    required int memberCount,
    required bool archived,
  }) = _Group;

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}

@freezed
abstract class GroupMember with _$GroupMember {
  const factory GroupMember({
    required String userId,
    required String displayName,
    required String email,
    required GroupMemberRole role,
    required String joinedAt,
  }) = _GroupMember;

  factory GroupMember.fromJson(Map<String, dynamic> json) => _$GroupMemberFromJson(json);
}

@freezed
abstract class GroupExpenseShare with _$GroupExpenseShare {
  const factory GroupExpenseShare({
    required String userId,
    required String displayName,
    @AmountConverter() required String amount,
  }) = _GroupExpenseShare;

  factory GroupExpenseShare.fromJson(Map<String, dynamic> json) =>
      _$GroupExpenseShareFromJson(json);
}

@freezed
abstract class GroupExpense with _$GroupExpense {
  const factory GroupExpense({
    required String id,
    required String description,
    @AmountConverter() required String amount,
    required String occurredOn,
    required String paidByUserId,
    required String paidByName,
    required List<GroupExpenseShare> shares,
    GroupExpenseCategory? category,
    String? originalCurrency,
    @NullableAmountConverter() String? originalAmount,
    @NullableAmountConverter() String? exchangeRate,
  }) = _GroupExpense;

  factory GroupExpense.fromJson(Map<String, dynamic> json) => _$GroupExpenseFromJson(json);
}

@freezed
abstract class GroupBalance with _$GroupBalance {
  const factory GroupBalance({
    required String userId,
    required String displayName,
    @AmountConverter() required String totalPaid,
    @AmountConverter() required String totalShare,
    @AmountConverter() required String net,
  }) = _GroupBalance;

  factory GroupBalance.fromJson(Map<String, dynamic> json) => _$GroupBalanceFromJson(json);
}

/// Shared goals (product spec section 27) — the group-scoped counterpart to the personal `Goal`.
@freezed
abstract class GroupGoalMemberContribution with _$GroupGoalMemberContribution {
  const factory GroupGoalMemberContribution({
    required String userId,
    required String displayName,
    @AmountConverter() required String totalContributed,
  }) = _GroupGoalMemberContribution;

  factory GroupGoalMemberContribution.fromJson(Map<String, dynamic> json) =>
      _$GroupGoalMemberContributionFromJson(json);
}

@freezed
abstract class GroupGoal with _$GroupGoal {
  const factory GroupGoal({
    required String id,
    required String name,
    @AmountConverter() required String targetAmount,
    String? targetDate,
    @AmountConverter() required String currentAmount,
    @AmountConverter() required String remaining,
    @AmountConverter() required String percentage,
    required bool archived,
    required List<GroupGoalMemberContribution> byMember,
  }) = _GroupGoal;

  factory GroupGoal.fromJson(Map<String, dynamic> json) => _$GroupGoalFromJson(json);
}

@freezed
abstract class GroupGoalContribution with _$GroupGoalContribution {
  const factory GroupGoalContribution({
    required String id,
    required String userId,
    required String userDisplayName,
    @AmountConverter() required String amount,
    required String occurredOn,
    String? note,
  }) = _GroupGoalContribution;

  factory GroupGoalContribution.fromJson(Map<String, dynamic> json) =>
      _$GroupGoalContributionFromJson(json);
}

/// Trip mode's overall budget (product spec section 32).
@freezed
abstract class GroupBudget with _$GroupBudget {
  const factory GroupBudget({
    @AmountConverter() required String amount,
    @AmountConverter() required String spent,
    @AmountConverter() required String remaining,
  }) = _GroupBudget;

  factory GroupBudget.fromJson(Map<String, dynamic> json) => _$GroupBudgetFromJson(json);
}

@freezed
abstract class TripCategorySpending with _$TripCategorySpending {
  const factory TripCategorySpending({
    required GroupExpenseCategory category,
    @AmountConverter() required String amount,
  }) = _TripCategorySpending;

  factory TripCategorySpending.fromJson(Map<String, dynamic> json) =>
      _$TripCategorySpendingFromJson(json);
}

@freezed
abstract class TripSummary with _$TripSummary {
  const factory TripSummary({
    @NullableAmountConverter() String? budgetAmount,
    @AmountConverter() required String spent,
    @NullableAmountConverter() String? remaining,
    required List<TripCategorySpending> spendingByCategory,
  }) = _TripSummary;

  factory TripSummary.fromJson(Map<String, dynamic> json) => _$TripSummaryFromJson(json);
}

/// Housemate mode's dashboard (product spec section 30).
@freezed
abstract class HousemateCategoryStatus with _$HousemateCategoryStatus {
  const factory HousemateCategoryStatus({
    required GroupExpenseCategory category,
    required bool paid,
  }) = _HousemateCategoryStatus;

  factory HousemateCategoryStatus.fromJson(Map<String, dynamic> json) =>
      _$HousemateCategoryStatusFromJson(json);
}

@freezed
abstract class HousemateDashboard with _$HousemateDashboard {
  const factory HousemateDashboard({
    required int year,
    required int month,
    required List<HousemateCategoryStatus> categories,
  }) = _HousemateDashboard;

  factory HousemateDashboard.fromJson(Map<String, dynamic> json) =>
      _$HousemateDashboardFromJson(json);
}
