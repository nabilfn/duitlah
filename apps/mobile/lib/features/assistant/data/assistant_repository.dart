import '../../../core/api/api_client.dart';
import '../domain/assistant.dart';

class AssistantRepository {
  AssistantRepository(this._client);

  final ApiClient _client;

  Future<ChatResult> chat(String message, List<ChatTurn> history, {String? activeSpaceId}) async {
    final data = await _client.post('/api/v1/ai/chat', data: {
      'message': message,
      'history': history.map((t) => {'role': t.role.name, 'content': t.content}).toList(),
      if (activeSpaceId != null) 'activeSpaceId': activeSpaceId,
    });
    return ChatResult.fromJson(data as Map<String, dynamic>);
  }

  Future<AffordabilityResult> checkAffordability(String amount, String? description) async {
    final data = await _client.post('/api/v1/ai/affordability', data: {
      'amount': amount,
      if (description != null && description.isNotEmpty) 'description': description,
    });
    return AffordabilityResult.fromJson(data as Map<String, dynamic>);
  }
}
