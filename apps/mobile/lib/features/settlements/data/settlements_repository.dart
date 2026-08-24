import '../../../core/api/api_client.dart';
import '../domain/settlement.dart';

class SettlementsRepository {
  SettlementsRepository(this._client);

  final ApiClient _client;

  Future<List<Settlement>> listSettlements() async {
    final data = await _client.get('/api/v1/settlements') as List;
    return data.map((e) => Settlement.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<SettlementSummary> getSummary() async {
    final data = await _client.get('/api/v1/settlements/summary');
    return SettlementSummary.fromJson(data as Map<String, dynamic>);
  }

  /// Returns the updated [Settlement] itself (new `amountPaid`/`status`),
  /// not a [SettlementPayment] record — confirmed against the live API;
  /// the per-payment history entries are a separate, not-yet-exposed
  /// concept here.
  Future<Settlement> recordPayment(
    String settlementId, {
    required String amount,
    String? note,
    required String idempotencyKey,
  }) async {
    final data = await _client.post(
      '/api/v1/settlements/$settlementId/payments',
      data: {'amount': amount, if (note != null) 'note': note},
      idempotencyKey: idempotencyKey,
    );
    return Settlement.fromJson(data as Map<String, dynamic>);
  }

  Future<Settlement> cancel(String settlementId) async {
    final data = await _client.post('/api/v1/settlements/$settlementId/cancel');
    return Settlement.fromJson(data as Map<String, dynamic>);
  }

  Future<Settlement> dispute(String settlementId) async {
    final data = await _client.post('/api/v1/settlements/$settlementId/dispute');
    return Settlement.fromJson(data as Map<String, dynamic>);
  }
}
