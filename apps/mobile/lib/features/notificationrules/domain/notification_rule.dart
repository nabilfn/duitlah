// ignore_for_file: constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/amount_converter.dart';

part 'notification_rule.freezed.dart';
part 'notification_rule.g.dart';

/// One row per `(user, type)` the user has ever changed from its default.
/// `GET /api/v1/notification-rules` always returns all five types — a
/// missing row server-side just means "still on default", so the client
/// never needs to synthesize a sixth "unset" state.
enum NotificationRuleType { BILL_DUE_SOON, BILL_OVERDUE, LOW_STOCK_ALERT, BUDGET_EXCEEDED, LOW_BALANCE }

@freezed
abstract class NotificationRule with _$NotificationRule {
  const factory NotificationRule({
    required NotificationRuleType type,
    required bool enabled,
    /// Only meaningful for [NotificationRuleType.LOW_BALANCE] — the balance
    /// below which the alert fires. Null for every other type.
    @NullableAmountConverter() String? thresholdAmount,
  }) = _NotificationRule;

  factory NotificationRule.fromJson(Map<String, dynamic> json) => _$NotificationRuleFromJson(json);
}
