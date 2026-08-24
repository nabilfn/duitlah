// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assistant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatTurn _$ChatTurnFromJson(Map<String, dynamic> json) => _ChatTurn(
  role: $enumDecode(_$ChatMessageRoleEnumMap, json['role']),
  content: json['content'] as String,
);

Map<String, dynamic> _$ChatTurnToJson(_ChatTurn instance) => <String, dynamic>{
  'role': _$ChatMessageRoleEnumMap[instance.role]!,
  'content': instance.content,
};

const _$ChatMessageRoleEnumMap = {
  ChatMessageRole.USER: 'USER',
  ChatMessageRole.ASSISTANT: 'ASSISTANT',
};

_ChatResult _$ChatResultFromJson(Map<String, dynamic> json) => _ChatResult(
  reply: json['reply'] as String,
  available: json['available'] as bool,
);

Map<String, dynamic> _$ChatResultToJson(_ChatResult instance) =>
    <String, dynamic>{'reply': instance.reply, 'available': instance.available};

_AffordabilityResult _$AffordabilityResultFromJson(Map<String, dynamic> json) =>
    _AffordabilityResult(
      amount: const AmountConverter().fromJson(json['amount']),
      currentBalance: const AmountConverter().fromJson(json['currentBalance']),
      projectedBalanceIfWaited: const AmountConverter().fromJson(
        json['projectedBalanceIfWaited'],
      ),
      projectedBalanceIfPurchased: const AmountConverter().fromJson(
        json['projectedBalanceIfPurchased'],
      ),
      totalOwedToOthers: const AmountConverter().fromJson(
        json['totalOwedToOthers'],
      ),
      canAfford: json['canAfford'] as bool,
      narrative: json['narrative'] as String,
      disclaimer: json['disclaimer'] as String,
      upcomingBillsTotal: const AmountConverter().fromJson(
        json['upcomingBillsTotal'],
      ),
      debtRepaymentsTotal: const AmountConverter().fromJson(
        json['debtRepaymentsTotal'],
      ),
      totalObligations: const AmountConverter().fromJson(
        json['totalObligations'],
      ),
      averageCreditUtilization: const NullableAmountConverter().fromJson(
        json['averageCreditUtilization'],
      ),
      totalSavingsGoalsRemaining: const AmountConverter().fromJson(
        json['totalSavingsGoalsRemaining'],
      ),
      budgetRemainingThisPeriod: const AmountConverter().fromJson(
        json['budgetRemainingThisPeriod'],
      ),
    );

Map<String, dynamic> _$AffordabilityResultToJson(
  _AffordabilityResult instance,
) => <String, dynamic>{
  'amount': const AmountConverter().toJson(instance.amount),
  'currentBalance': const AmountConverter().toJson(instance.currentBalance),
  'projectedBalanceIfWaited': const AmountConverter().toJson(
    instance.projectedBalanceIfWaited,
  ),
  'projectedBalanceIfPurchased': const AmountConverter().toJson(
    instance.projectedBalanceIfPurchased,
  ),
  'totalOwedToOthers': const AmountConverter().toJson(
    instance.totalOwedToOthers,
  ),
  'canAfford': instance.canAfford,
  'narrative': instance.narrative,
  'disclaimer': instance.disclaimer,
  'upcomingBillsTotal': const AmountConverter().toJson(
    instance.upcomingBillsTotal,
  ),
  'debtRepaymentsTotal': const AmountConverter().toJson(
    instance.debtRepaymentsTotal,
  ),
  'totalObligations': const AmountConverter().toJson(instance.totalObligations),
  'averageCreditUtilization': const NullableAmountConverter().toJson(
    instance.averageCreditUtilization,
  ),
  'totalSavingsGoalsRemaining': const AmountConverter().toJson(
    instance.totalSavingsGoalsRemaining,
  ),
  'budgetRemainingThisPeriod': const AmountConverter().toJson(
    instance.budgetRemainingThisPeriod,
  ),
};
