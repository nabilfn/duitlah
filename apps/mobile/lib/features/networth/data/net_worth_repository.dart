import '../../../core/api/api_client.dart';
import '../domain/net_worth.dart';

class NetWorthRepository {
  NetWorthRepository(this._client);

  final ApiClient _client;

  Future<NetWorth> compute() async {
    final data = await _client.get('/api/v1/net-worth');
    return NetWorth.fromJson(data as Map<String, dynamic>);
  }

  Future<NetWorthSnapshot> takeSnapshot() async {
    final data = await _client.post('/api/v1/net-worth/snapshots');
    return NetWorthSnapshot.fromJson(data as Map<String, dynamic>);
  }

  Future<List<NetWorthSnapshot>> history() async {
    final data = await _client.get('/api/v1/net-worth/snapshots') as List;
    return data.map((e) => NetWorthSnapshot.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<OtherAsset>> listOtherAssets() async {
    final data = await _client.get('/api/v1/net-worth/other-assets') as List;
    return data.map((e) => OtherAsset.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<OtherAsset> addOtherAsset({
    required AssetType type,
    required String name,
    required String estimatedValue,
  }) async {
    final data = await _client.post('/api/v1/net-worth/other-assets', data: {
      'type': type.name,
      'name': name,
      'estimatedValue': estimatedValue,
    });
    return OtherAsset.fromJson(data as Map<String, dynamic>);
  }

  Future<void> deleteOtherAsset(String assetId) =>
      _client.delete('/api/v1/net-worth/other-assets/$assetId');
}
