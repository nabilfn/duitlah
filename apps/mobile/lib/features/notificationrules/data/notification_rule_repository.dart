import '../../../core/api/api_client.dart';
import '../domain/notification_rule.dart';

/// Notification rules (Phase 13) — per-type opt in/out for the fan-out
/// `NotificationService.notify` already does. Every type always appears in
/// [list]'s response (server-synthesized defaults for any row the user
/// hasn't touched yet), so there's no separate "create" call — only
/// [update].
class NotificationRuleRepository {
  NotificationRuleRepository(this._client);

  final ApiClient _client;

  Future<List<NotificationRule>> list() async {
    final data = await _client.get('/api/v1/notification-rules') as List;
    return data.map((e) => NotificationRule.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<NotificationRule> update(
    NotificationRuleType type, {
    required bool enabled,
    String? thresholdAmount,
  }) async {
    final data = await _client.put('/api/v1/notification-rules/${type.name}', data: {
      'enabled': enabled,
      'thresholdAmount': thresholdAmount,
    });
    return NotificationRule.fromJson(data as Map<String, dynamic>);
  }
}
