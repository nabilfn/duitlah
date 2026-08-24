import '../../../core/api/api_client.dart';
import '../domain/user_feedback.dart';

class FeedbackRepository {
  FeedbackRepository(this._client);

  final ApiClient _client;

  Future<UserFeedback> submit({
    required FeedbackCategory category,
    required String message,
    required String idempotencyKey,
  }) async {
    final data = await _client.post(
      '/api/v1/feedback',
      data: {'category': category.name, 'message': message},
      idempotencyKey: idempotencyKey,
    );
    return UserFeedback.fromJson(data as Map<String, dynamic>);
  }
}
