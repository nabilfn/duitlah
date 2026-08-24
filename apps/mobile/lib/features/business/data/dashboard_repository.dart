import '../../../core/api/api_client.dart';
import '../domain/dashboard.dart';

class BusinessDashboardRepository {
  BusinessDashboardRepository(this._client);

  final ApiClient _client;

  Future<BusinessDashboard> getDashboard(String spaceId) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/business-dashboard');
    return BusinessDashboard.fromJson(data as Map<String, dynamic>);
  }
}
