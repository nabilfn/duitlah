// ignore_for_file: constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_rule.freezed.dart';
part 'transaction_rule.g.dart';

/// `MERCHANT_EQUALS` beats `MERCHANT_CONTAINS` at the same [TransactionRule.priority] — the
/// highest-priority active rule wins; `TransactionRuleService.suggestCategory` is consulted
/// before the fallback "last time you logged at this exact merchant" heuristic.
enum MatchType { MERCHANT_EQUALS, MERCHANT_CONTAINS }

@freezed
abstract class TransactionRule with _$TransactionRule {
  const factory TransactionRule({
    required String id,
    required MatchType matchType,
    required String matchValue,
    required String categoryId,
    required int priority,
    required bool active,
    /// True when the backend auto-created this rule itself
    /// (`TransactionRuleService.learnFromConfirmation`, upserted every time a candidate at this
    /// merchant is confirmed with a category) rather than the user authoring it directly — still
    /// exactly as editable/deletable as a hand-written rule, just labeled differently in the UI.
    required bool learned,
  }) = _TransactionRule;

  factory TransactionRule.fromJson(Map<String, dynamic> json) => _$TransactionRuleFromJson(json);
}
