// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Budget _$BudgetFromJson(Map<String, dynamic> json) => _Budget(
  id: json['id'] as String,
  categoryId: json['categoryId'] as String?,
  categoryName: json['categoryName'] as String,
  periodYear: (json['periodYear'] as num).toInt(),
  periodMonth: (json['periodMonth'] as num).toInt(),
  cycleType: $enumDecode(_$BudgetCycleTypeEnumMap, json['cycleType']),
  periodStartDate: json['periodStartDate'] as String?,
  periodEndDate: json['periodEndDate'] as String?,
  limit: const AmountConverter().fromJson(json['limit']),
  spent: const AmountConverter().fromJson(json['spent']),
  remaining: const AmountConverter().fromJson(json['remaining']),
  status: $enumDecode(_$BudgetStatusEnumMap, json['status']),
);

Map<String, dynamic> _$BudgetToJson(_Budget instance) => <String, dynamic>{
  'id': instance.id,
  'categoryId': instance.categoryId,
  'categoryName': instance.categoryName,
  'periodYear': instance.periodYear,
  'periodMonth': instance.periodMonth,
  'cycleType': _$BudgetCycleTypeEnumMap[instance.cycleType]!,
  'periodStartDate': instance.periodStartDate,
  'periodEndDate': instance.periodEndDate,
  'limit': const AmountConverter().toJson(instance.limit),
  'spent': const AmountConverter().toJson(instance.spent),
  'remaining': const AmountConverter().toJson(instance.remaining),
  'status': _$BudgetStatusEnumMap[instance.status]!,
};

const _$BudgetCycleTypeEnumMap = {
  BudgetCycleType.CALENDAR_MONTH: 'CALENDAR_MONTH',
  BudgetCycleType.PAYDAY: 'PAYDAY',
  BudgetCycleType.CUSTOM: 'CUSTOM',
};

const _$BudgetStatusEnumMap = {
  BudgetStatus.OK: 'OK',
  BudgetStatus.WARNING: 'WARNING',
  BudgetStatus.EXCEEDED: 'EXCEEDED',
};

_Goal _$GoalFromJson(Map<String, dynamic> json) => _Goal(
  id: json['id'] as String,
  name: json['name'] as String,
  type: $enumDecode(_$GoalTypeEnumMap, json['type']),
  targetAmount: const AmountConverter().fromJson(json['targetAmount']),
  targetDate: json['targetDate'] as String?,
  currentAmount: const AmountConverter().fromJson(json['currentAmount']),
  remaining: const AmountConverter().fromJson(json['remaining']),
  percentage: const AmountConverter().fromJson(json['percentage']),
  archived: json['archived'] as bool,
);

Map<String, dynamic> _$GoalToJson(_Goal instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': _$GoalTypeEnumMap[instance.type]!,
  'targetAmount': const AmountConverter().toJson(instance.targetAmount),
  'targetDate': instance.targetDate,
  'currentAmount': const AmountConverter().toJson(instance.currentAmount),
  'remaining': const AmountConverter().toJson(instance.remaining),
  'percentage': const AmountConverter().toJson(instance.percentage),
  'archived': instance.archived,
};

const _$GoalTypeEnumMap = {
  GoalType.EMERGENCY_FUND: 'EMERGENCY_FUND',
  GoalType.TRAVEL: 'TRAVEL',
  GoalType.DEVICE: 'DEVICE',
  GoalType.HOUSE_DEPOSIT: 'HOUSE_DEPOSIT',
  GoalType.CAR: 'CAR',
  GoalType.EDUCATION: 'EDUCATION',
  GoalType.WEDDING: 'WEDDING',
  GoalType.CUSTOM: 'CUSTOM',
};

_GoalContribution _$GoalContributionFromJson(Map<String, dynamic> json) =>
    _GoalContribution(
      id: json['id'] as String,
      amount: const AmountConverter().fromJson(json['amount']),
      occurredOn: json['occurredOn'] as String,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$GoalContributionToJson(_GoalContribution instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': const AmountConverter().toJson(instance.amount),
      'occurredOn': instance.occurredOn,
      'note': instance.note,
    };
