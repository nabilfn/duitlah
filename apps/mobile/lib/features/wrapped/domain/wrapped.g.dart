// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wrapped.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WrappedPromo _$WrappedPromoFromJson(Map<String, dynamic> json) =>
    _WrappedPromo(
      available: json['available'] as bool,
      year: (json['year'] as num?)?.toInt(),
      month: (json['month'] as num?)?.toInt(),
      personaName: json['personaName'] as String?,
    );

Map<String, dynamic> _$WrappedPromoToJson(_WrappedPromo instance) =>
    <String, dynamic>{
      'available': instance.available,
      'year': instance.year,
      'month': instance.month,
      'personaName': instance.personaName,
    };

_WrappedHistoryItem _$WrappedHistoryItemFromJson(Map<String, dynamic> json) =>
    _WrappedHistoryItem(
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      personaId: json['personaId'] as String?,
      personaName: json['personaName'] as String?,
      viewed: json['viewed'] as bool,
    );

Map<String, dynamic> _$WrappedHistoryItemToJson(_WrappedHistoryItem instance) =>
    <String, dynamic>{
      'year': instance.year,
      'month': instance.month,
      'personaId': instance.personaId,
      'personaName': instance.personaName,
      'viewed': instance.viewed,
    };

_WrappedOverview _$WrappedOverviewFromJson(Map<String, dynamic> json) =>
    _WrappedOverview(
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      totalIncome: const AmountConverter().fromJson(json['totalIncome']),
      totalExpense: const AmountConverter().fromJson(json['totalExpense']),
      netAmount: const AmountConverter().fromJson(json['netAmount']),
      totalSavingsContribution: const AmountConverter().fromJson(
        json['totalSavingsContribution'],
      ),
      transactionCount: (json['transactionCount'] as num).toInt(),
      spendingChangePercentage: (json['spendingChangePercentage'] as num?)
          ?.toDouble(),
      incomeChangePercentage: (json['incomeChangePercentage'] as num?)
          ?.toDouble(),
    );

Map<String, dynamic> _$WrappedOverviewToJson(_WrappedOverview instance) =>
    <String, dynamic>{
      'year': instance.year,
      'month': instance.month,
      'totalIncome': const AmountConverter().toJson(instance.totalIncome),
      'totalExpense': const AmountConverter().toJson(instance.totalExpense),
      'netAmount': const AmountConverter().toJson(instance.netAmount),
      'totalSavingsContribution': const AmountConverter().toJson(
        instance.totalSavingsContribution,
      ),
      'transactionCount': instance.transactionCount,
      'spendingChangePercentage': instance.spendingChangePercentage,
      'incomeChangePercentage': instance.incomeChangePercentage,
    };

_WrappedPersona _$WrappedPersonaFromJson(Map<String, dynamic> json) =>
    _WrappedPersona(
      id: json['id'] as String,
      name: json['name'] as String,
      tagline: json['tagline'] as String,
      visualTheme: json['visualTheme'] as String,
      amount: const AmountConverter().fromJson(json['amount']),
      percentage: (json['percentage'] as num).toDouble(),
      denominatorLabel: json['denominatorLabel'] as String,
      score: (json['score'] as num).toDouble(),
      evidence: (json['evidence'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$WrappedPersonaToJson(_WrappedPersona instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'tagline': instance.tagline,
      'visualTheme': instance.visualTheme,
      'amount': const AmountConverter().toJson(instance.amount),
      'percentage': instance.percentage,
      'denominatorLabel': instance.denominatorLabel,
      'score': instance.score,
      'evidence': instance.evidence,
    };

_WrappedInsight _$WrappedInsightFromJson(Map<String, dynamic> json) =>
    _WrappedInsight(
      type: json['type'] as String,
      title: json['title'] as String,
      primaryValue: json['primaryValue'] as String,
      secondaryValue: json['secondaryValue'] as String?,
      comparison: json['comparison'] as String?,
    );

Map<String, dynamic> _$WrappedInsightToJson(_WrappedInsight instance) =>
    <String, dynamic>{
      'type': instance.type,
      'title': instance.title,
      'primaryValue': instance.primaryValue,
      'secondaryValue': instance.secondaryValue,
      'comparison': instance.comparison,
    };

_WrappedGoal _$WrappedGoalFromJson(Map<String, dynamic> json) =>
    _WrappedGoal(message: json['message'] as String);

Map<String, dynamic> _$WrappedGoalToJson(_WrappedGoal instance) =>
    <String, dynamic>{'message': instance.message};

_WrappedResult _$WrappedResultFromJson(Map<String, dynamic> json) =>
    _WrappedResult(
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      version: (json['version'] as num).toInt(),
      generatedAt: json['generatedAt'] as String,
      sufficientData: json['sufficientData'] as bool,
      overview: WrappedOverview.fromJson(
        json['overview'] as Map<String, dynamic>,
      ),
      persona: json['persona'] == null
          ? null
          : WrappedPersona.fromJson(json['persona'] as Map<String, dynamic>),
      insights: (json['insights'] as List<dynamic>)
          .map((e) => WrappedInsight.fromJson(e as Map<String, dynamic>))
          .toList(),
      recommendedGoal: WrappedGoal.fromJson(
        json['recommendedGoal'] as Map<String, dynamic>,
      ),
      story: json['story'] == null
          ? null
          : WrappedStoryData.fromJson(json['story'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WrappedResultToJson(_WrappedResult instance) =>
    <String, dynamic>{
      'year': instance.year,
      'month': instance.month,
      'version': instance.version,
      'generatedAt': instance.generatedAt,
      'sufficientData': instance.sufficientData,
      'overview': instance.overview,
      'persona': instance.persona,
      'insights': instance.insights,
      'recommendedGoal': instance.recommendedGoal,
      'story': instance.story,
    };
