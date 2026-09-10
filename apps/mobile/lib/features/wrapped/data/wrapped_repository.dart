import '../../../core/api/api_client.dart';
import '../domain/wrapped.dart';

class WrappedRepository {
  WrappedRepository(this._client);

  final ApiClient _client;

  Future<WrappedPromo> promo() async {
    final data = await _client.get('/api/v1/wrapped/promo');
    return WrappedPromo.fromJson(data as Map<String, dynamic>);
  }

  Future<List<WrappedHistoryItem>> history() async {
    final data = await _client.get('/api/v1/wrapped') as List;
    return data
        .map((e) => WrappedHistoryItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Lazily generates the story on first call and persists it forever after — a repeat call
  /// for the same month always returns the identical result, even if new transactions are
  /// later added to that month. Throws `AppException(code: 'MONTH_NOT_COMPLETED')` (via the
  /// shared [ApiClient] error mapping) if `year`/`month` is the current or a future month.
  Future<WrappedResult> result({required int year, required int month}) async {
    final data = await _client.get('/api/v1/wrapped/$year/$month');
    return WrappedResult.fromJson(data as Map<String, dynamic>);
  }

  /// Marks a month's Wrapped as viewed — removes it from the Home promo card and flags the
  /// history row as seen. No meaningful response body.
  Future<void> markViewed({required int year, required int month}) async {
    await _client.post('/api/v1/wrapped/$year/$month/viewed');
  }
}
