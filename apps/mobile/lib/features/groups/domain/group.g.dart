// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Group _$GroupFromJson(Map<String, dynamic> json) => _Group(
  id: json['id'] as String,
  name: json['name'] as String,
  type: $enumDecode(_$GroupTypeEnumMap, json['type']),
  yourRole: $enumDecode(_$GroupMemberRoleEnumMap, json['yourRole']),
  memberCount: (json['memberCount'] as num).toInt(),
  archived: json['archived'] as bool,
);

Map<String, dynamic> _$GroupToJson(_Group instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': _$GroupTypeEnumMap[instance.type]!,
  'yourRole': _$GroupMemberRoleEnumMap[instance.yourRole]!,
  'memberCount': instance.memberCount,
  'archived': instance.archived,
};

const _$GroupTypeEnumMap = {
  GroupType.GENERAL: 'GENERAL',
  GroupType.HOUSEMATES: 'HOUSEMATES',
  GroupType.COUPLE: 'COUPLE',
  GroupType.TRIP: 'TRIP',
  GroupType.FRIENDS: 'FRIENDS',
  GroupType.FAMILY: 'FAMILY',
  GroupType.TEAM: 'TEAM',
  GroupType.EVENT: 'EVENT',
};

const _$GroupMemberRoleEnumMap = {
  GroupMemberRole.OWNER: 'OWNER',
  GroupMemberRole.MEMBER: 'MEMBER',
};

_GroupMember _$GroupMemberFromJson(Map<String, dynamic> json) => _GroupMember(
  userId: json['userId'] as String,
  displayName: json['displayName'] as String,
  email: json['email'] as String,
  role: $enumDecode(_$GroupMemberRoleEnumMap, json['role']),
  joinedAt: json['joinedAt'] as String,
);

Map<String, dynamic> _$GroupMemberToJson(_GroupMember instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'displayName': instance.displayName,
      'email': instance.email,
      'role': _$GroupMemberRoleEnumMap[instance.role]!,
      'joinedAt': instance.joinedAt,
    };

_GroupExpenseShare _$GroupExpenseShareFromJson(Map<String, dynamic> json) =>
    _GroupExpenseShare(
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      amount: const AmountConverter().fromJson(json['amount']),
    );

Map<String, dynamic> _$GroupExpenseShareToJson(_GroupExpenseShare instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'displayName': instance.displayName,
      'amount': const AmountConverter().toJson(instance.amount),
    };

_GroupExpense _$GroupExpenseFromJson(Map<String, dynamic> json) =>
    _GroupExpense(
      id: json['id'] as String,
      description: json['description'] as String,
      amount: const AmountConverter().fromJson(json['amount']),
      occurredOn: json['occurredOn'] as String,
      paidByUserId: json['paidByUserId'] as String,
      paidByName: json['paidByName'] as String,
      shares: (json['shares'] as List<dynamic>)
          .map((e) => GroupExpenseShare.fromJson(e as Map<String, dynamic>))
          .toList(),
      category: $enumDecodeNullable(
        _$GroupExpenseCategoryEnumMap,
        json['category'],
      ),
      originalCurrency: json['originalCurrency'] as String?,
      originalAmount: const NullableAmountConverter().fromJson(
        json['originalAmount'],
      ),
      exchangeRate: const NullableAmountConverter().fromJson(
        json['exchangeRate'],
      ),
    );

Map<String, dynamic> _$GroupExpenseToJson(
  _GroupExpense instance,
) => <String, dynamic>{
  'id': instance.id,
  'description': instance.description,
  'amount': const AmountConverter().toJson(instance.amount),
  'occurredOn': instance.occurredOn,
  'paidByUserId': instance.paidByUserId,
  'paidByName': instance.paidByName,
  'shares': instance.shares,
  'category': _$GroupExpenseCategoryEnumMap[instance.category],
  'originalCurrency': instance.originalCurrency,
  'originalAmount': const NullableAmountConverter().toJson(
    instance.originalAmount,
  ),
  'exchangeRate': const NullableAmountConverter().toJson(instance.exchangeRate),
};

const _$GroupExpenseCategoryEnumMap = {
  GroupExpenseCategory.RENT: 'RENT',
  GroupExpenseCategory.ELECTRICITY: 'ELECTRICITY',
  GroupExpenseCategory.WATER: 'WATER',
  GroupExpenseCategory.INTERNET: 'INTERNET',
  GroupExpenseCategory.GROCERIES: 'GROCERIES',
  GroupExpenseCategory.CLEANING: 'CLEANING',
  GroupExpenseCategory.HOUSEHOLD: 'HOUSEHOLD',
  GroupExpenseCategory.STREAMING: 'STREAMING',
  GroupExpenseCategory.FLIGHTS: 'FLIGHTS',
  GroupExpenseCategory.ACCOMMODATION: 'ACCOMMODATION',
  GroupExpenseCategory.FOOD: 'FOOD',
  GroupExpenseCategory.TRANSPORT: 'TRANSPORT',
  GroupExpenseCategory.ACTIVITIES: 'ACTIVITIES',
  GroupExpenseCategory.SHOPPING: 'SHOPPING',
  GroupExpenseCategory.OTHER: 'OTHER',
};

_GroupBalance _$GroupBalanceFromJson(Map<String, dynamic> json) =>
    _GroupBalance(
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      totalPaid: const AmountConverter().fromJson(json['totalPaid']),
      totalShare: const AmountConverter().fromJson(json['totalShare']),
      net: const AmountConverter().fromJson(json['net']),
    );

Map<String, dynamic> _$GroupBalanceToJson(_GroupBalance instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'displayName': instance.displayName,
      'totalPaid': const AmountConverter().toJson(instance.totalPaid),
      'totalShare': const AmountConverter().toJson(instance.totalShare),
      'net': const AmountConverter().toJson(instance.net),
    };

_GroupGoalMemberContribution _$GroupGoalMemberContributionFromJson(
  Map<String, dynamic> json,
) => _GroupGoalMemberContribution(
  userId: json['userId'] as String,
  displayName: json['displayName'] as String,
  totalContributed: const AmountConverter().fromJson(json['totalContributed']),
);

Map<String, dynamic> _$GroupGoalMemberContributionToJson(
  _GroupGoalMemberContribution instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'displayName': instance.displayName,
  'totalContributed': const AmountConverter().toJson(instance.totalContributed),
};

_GroupGoal _$GroupGoalFromJson(Map<String, dynamic> json) => _GroupGoal(
  id: json['id'] as String,
  name: json['name'] as String,
  targetAmount: const AmountConverter().fromJson(json['targetAmount']),
  targetDate: json['targetDate'] as String?,
  currentAmount: const AmountConverter().fromJson(json['currentAmount']),
  remaining: const AmountConverter().fromJson(json['remaining']),
  percentage: const AmountConverter().fromJson(json['percentage']),
  archived: json['archived'] as bool,
  byMember: (json['byMember'] as List<dynamic>)
      .map(
        (e) => GroupGoalMemberContribution.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$GroupGoalToJson(_GroupGoal instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'targetAmount': const AmountConverter().toJson(instance.targetAmount),
      'targetDate': instance.targetDate,
      'currentAmount': const AmountConverter().toJson(instance.currentAmount),
      'remaining': const AmountConverter().toJson(instance.remaining),
      'percentage': const AmountConverter().toJson(instance.percentage),
      'archived': instance.archived,
      'byMember': instance.byMember,
    };

_GroupGoalContribution _$GroupGoalContributionFromJson(
  Map<String, dynamic> json,
) => _GroupGoalContribution(
  id: json['id'] as String,
  userId: json['userId'] as String,
  userDisplayName: json['userDisplayName'] as String,
  amount: const AmountConverter().fromJson(json['amount']),
  occurredOn: json['occurredOn'] as String,
  note: json['note'] as String?,
);

Map<String, dynamic> _$GroupGoalContributionToJson(
  _GroupGoalContribution instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'userDisplayName': instance.userDisplayName,
  'amount': const AmountConverter().toJson(instance.amount),
  'occurredOn': instance.occurredOn,
  'note': instance.note,
};

_GroupBudget _$GroupBudgetFromJson(Map<String, dynamic> json) => _GroupBudget(
  amount: const AmountConverter().fromJson(json['amount']),
  spent: const AmountConverter().fromJson(json['spent']),
  remaining: const AmountConverter().fromJson(json['remaining']),
);

Map<String, dynamic> _$GroupBudgetToJson(_GroupBudget instance) =>
    <String, dynamic>{
      'amount': const AmountConverter().toJson(instance.amount),
      'spent': const AmountConverter().toJson(instance.spent),
      'remaining': const AmountConverter().toJson(instance.remaining),
    };

_TripCategorySpending _$TripCategorySpendingFromJson(
  Map<String, dynamic> json,
) => _TripCategorySpending(
  category: $enumDecode(_$GroupExpenseCategoryEnumMap, json['category']),
  amount: const AmountConverter().fromJson(json['amount']),
);

Map<String, dynamic> _$TripCategorySpendingToJson(
  _TripCategorySpending instance,
) => <String, dynamic>{
  'category': _$GroupExpenseCategoryEnumMap[instance.category]!,
  'amount': const AmountConverter().toJson(instance.amount),
};

_TripSummary _$TripSummaryFromJson(Map<String, dynamic> json) => _TripSummary(
  budgetAmount: const NullableAmountConverter().fromJson(json['budgetAmount']),
  spent: const AmountConverter().fromJson(json['spent']),
  remaining: const NullableAmountConverter().fromJson(json['remaining']),
  spendingByCategory: (json['spendingByCategory'] as List<dynamic>)
      .map((e) => TripCategorySpending.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TripSummaryToJson(
  _TripSummary instance,
) => <String, dynamic>{
  'budgetAmount': const NullableAmountConverter().toJson(instance.budgetAmount),
  'spent': const AmountConverter().toJson(instance.spent),
  'remaining': const NullableAmountConverter().toJson(instance.remaining),
  'spendingByCategory': instance.spendingByCategory,
};

_HousemateCategoryStatus _$HousemateCategoryStatusFromJson(
  Map<String, dynamic> json,
) => _HousemateCategoryStatus(
  category: $enumDecode(_$GroupExpenseCategoryEnumMap, json['category']),
  paid: json['paid'] as bool,
);

Map<String, dynamic> _$HousemateCategoryStatusToJson(
  _HousemateCategoryStatus instance,
) => <String, dynamic>{
  'category': _$GroupExpenseCategoryEnumMap[instance.category]!,
  'paid': instance.paid,
};

_HousemateDashboard _$HousemateDashboardFromJson(Map<String, dynamic> json) =>
    _HousemateDashboard(
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      categories: (json['categories'] as List<dynamic>)
          .map(
            (e) => HousemateCategoryStatus.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$HousemateDashboardToJson(_HousemateDashboard instance) =>
    <String, dynamic>{
      'year': instance.year,
      'month': instance.month,
      'categories': instance.categories,
    };
