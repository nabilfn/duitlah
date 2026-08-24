import '../../../core/api/api_client.dart';
import '../domain/periods.dart';

class AccountingPeriodsRepository {
  AccountingPeriodsRepository(this._client);

  final ApiClient _client;

  Future<List<AccountingPeriod>> list(String spaceId) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/accounting/periods') as List;
    return data.map((e) => AccountingPeriod.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Errors with `409 ACCOUNTING_PERIOD_OVERLAPS` if the range overlaps an
  /// existing period.
  Future<AccountingPeriod> create(String spaceId, {required String periodStart, required String periodEnd}) async {
    final data = await _client.post('/api/v1/spaces/$spaceId/accounting/periods', data: {
      'periodStart': periodStart,
      'periodEnd': periodEnd,
    });
    return AccountingPeriod.fromJson(data as Map<String, dynamic>);
  }

  /// One-directional — there is no reopen endpoint.
  Future<AccountingPeriod> close(String spaceId, String periodId) async {
    final data = await _client.post('/api/v1/spaces/$spaceId/accounting/periods/$periodId/close');
    return AccountingPeriod.fromJson(data as Map<String, dynamic>);
  }
}
