import '../../../core/api/api_client.dart';
import '../domain/app_notification.dart';

class NotificationRepository {
  NotificationRepository(this._client);

  final ApiClient _client;

  Future<List<AppNotification>> list() async {
    final data = await _client.get('/api/v1/notifications') as List;
    return data.map((e) => AppNotification.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<int> unreadCount() async {
    final data = await _client.get('/api/v1/notifications/unread-count') as Map<String, dynamic>;
    return data['count'] as int;
  }

  Future<AppNotification> markRead(String notificationId) async {
    final data = await _client.post('/api/v1/notifications/$notificationId/read');
    return AppNotification.fromJson(data as Map<String, dynamic>);
  }
}
