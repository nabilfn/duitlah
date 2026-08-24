import '../../../core/api/api_client.dart';
import '../domain/insights.dart';

class InsightsRepository {
  InsightsRepository(this._client);

  final ApiClient _client;

  Future<List<CategorySpending>> spendingByCategory({required int year, required int month}) async {
    final data = await _client.get('/api/v1/analytics/spending-by-category', query: {
      'year': year,
      'month': month,
    }) as List;
    return data.map((e) => CategorySpending.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<MonthlyTrend>> monthlyTrend({int months = 6}) async {
    final data = await _client.get('/api/v1/analytics/monthly-trend', query: {'months': months}) as List;
    return data.map((e) => MonthlyTrend.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<MerchantSpending>> topMerchants({required int year, required int month}) async {
    final data = await _client.get('/api/v1/analytics/merchants', query: {
      'year': year,
      'month': month,
    }) as List;
    return data.map((e) => MerchantSpending.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<CalendarEntry>> calendar({required int year, required int month}) async {
    final data = await _client.get('/api/v1/analytics/calendar', query: {
      'year': year,
      'month': month,
    }) as List;
    return data.map((e) => CalendarEntry.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Forecast> forecast() async {
    final data = await _client.get('/api/v1/analytics/forecast');
    return Forecast.fromJson(data as Map<String, dynamic>);
  }
}
