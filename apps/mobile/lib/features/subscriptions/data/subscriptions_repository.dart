import '../../../core/api/api_client.dart';
import '../domain/entitlement.dart';

class SubscriptionsRepository {
  SubscriptionsRepository(this._client);

  final ApiClient _client;

  Future<Entitlement> getEntitlement() async {
    final data = await _client.get('/api/v1/subscriptions/me');
    return Entitlement.fromJson(data as Map<String, dynamic>);
  }
}
