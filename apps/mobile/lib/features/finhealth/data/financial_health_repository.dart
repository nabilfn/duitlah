import '../../../core/api/api_client.dart';
import '../domain/financial_health.dart';

class FinancialHealthRepository {
  FinancialHealthRepository(this._client);

  final ApiClient _client;

  Future<FinancialHealth> compute() async {
    final data = await _client.get('/api/v1/financial-health');
    return FinancialHealth.fromJson(data as Map<String, dynamic>);
  }
}
