import '../../../core/api/api_client.dart';
import '../domain/fixed_assets.dart';

/// Phase 9 — Fixed Assets. The asset register (create/list/get/update),
/// depreciation (manual "run" for backfilling or running ahead of the
/// server's own monthly scheduler, plus the posted-entries history), and
/// disposal — all writes require the server-enforced `MANAGE_BOOKS`
/// permission (a real 403 `INSUFFICIENT_PERMISSION`, never guessed
/// client-side), same as every other write in `accounting`/`reconciliation`.
class FixedAssetsRepository {
  FixedAssetsRepository(this._client);

  final ApiClient _client;

  // ---- Asset register ----------------------------------------------------

  /// The asset list IS the register — there's no separate register
  /// endpoint per the backend contract.
  Future<List<FixedAssetResponse>> listAssets(String spaceId) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/assets') as List;
    return data.map((e) => FixedAssetResponse.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<FixedAssetResponse> getAsset(String spaceId, String assetId) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/assets/$assetId');
    return FixedAssetResponse.fromJson(data as Map<String, dynamic>);
  }

  /// [businessAccountId] is create-only (which bank/cash account paid for
  /// the asset); omitting it means "bought on credit". [salvageValue]
  /// defaults to 0 server-side when omitted.
  Future<FixedAssetResponse> createAsset(
    String spaceId, {
    required String name,
    String? category,
    required String acquisitionDate,
    required String cost,
    String? salvageValue,
    required int usefulLifeMonths,
    required DepreciationMethod depreciationMethod,
    String? businessAccountId,
  }) async {
    final data = await _client.post(
      '/api/v1/spaces/$spaceId/assets',
      data: {
        'name': name,
        if (category != null) 'category': category,
        'acquisitionDate': acquisitionDate,
        'cost': cost,
        if (salvageValue != null) 'salvageValue': salvageValue,
        'usefulLifeMonths': usefulLifeMonths,
        'depreciationMethod': depreciationMethod.name,
        if (businessAccountId != null) 'businessAccountId': businessAccountId,
      },
    );
    return FixedAssetResponse.fromJson(data as Map<String, dynamic>);
  }

  /// Throws 409 `ASSET_FINANCIALS_LOCKED` if cost/salvageValue/
  /// usefulLifeMonths/depreciationMethod/acquisitionDate are changed on an
  /// asset that already has at least one depreciation entry posted — the
  /// caller (the edit form) should disable those fields once
  /// [FixedAssetResponse.accumulatedDepreciation] is nonzero rather than
  /// relying solely on this. Throws 409 `ASSET_ALREADY_DISPOSED` if the
  /// asset has been disposed.
  Future<FixedAssetResponse> updateAsset(
    String spaceId,
    String assetId, {
    required String name,
    String? category,
    required String acquisitionDate,
    required String cost,
    String? salvageValue,
    required int usefulLifeMonths,
    required DepreciationMethod depreciationMethod,
  }) async {
    final data = await _client.put(
      '/api/v1/spaces/$spaceId/assets/$assetId',
      data: {
        'name': name,
        if (category != null) 'category': category,
        'acquisitionDate': acquisitionDate,
        'cost': cost,
        if (salvageValue != null) 'salvageValue': salvageValue,
        'usefulLifeMonths': usefulLifeMonths,
        'depreciationMethod': depreciationMethod.name,
      },
    );
    return FixedAssetResponse.fromJson(data as Map<String, dynamic>);
  }

  // ---- Depreciation --------------------------------------------------------

  /// [period] may be any date within the target month — the server
  /// normalizes it to the 1st. Throws 409 `PERIOD_ALREADY_DEPRECIATED`,
  /// 409 `ASSET_FULLY_DEPRECIATED`, or 409 `ASSET_ALREADY_DISPOSED`.
  Future<DepreciationEntryResponse> runDepreciation(String spaceId, String assetId, {required String period}) async {
    final data = await _client.post(
      '/api/v1/spaces/$spaceId/assets/$assetId/depreciation/run',
      data: {'period': period},
    );
    return DepreciationEntryResponse.fromJson(data as Map<String, dynamic>);
  }

  /// Newest period first, per the server's contract.
  Future<List<DepreciationEntryResponse>> listDepreciationEntries(String spaceId, String assetId) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/assets/$assetId/depreciation-entries') as List;
    return data.map((e) => DepreciationEntryResponse.fromJson(e as Map<String, dynamic>)).toList();
  }

  // ---- Disposal -------------------------------------------------------------

  /// [businessAccountId] is required only when [proceeds] > 0 (400
  /// `PROCEEDS_ACCOUNT_REQUIRED` otherwise) — which account received the
  /// sale proceeds. Irreversible from the UI's perspective: once disposed,
  /// an asset can no longer be depreciated or disposed again (409
  /// `ASSET_ALREADY_DISPOSED`).
  Future<FixedAssetResponse> disposeAsset(
    String spaceId,
    String assetId, {
    required String disposedOn,
    required String proceeds,
    String? businessAccountId,
  }) async {
    final data = await _client.post(
      '/api/v1/spaces/$spaceId/assets/$assetId/dispose',
      data: {
        'disposedOn': disposedOn,
        'proceeds': proceeds,
        if (businessAccountId != null) 'businessAccountId': businessAccountId,
      },
    );
    return FixedAssetResponse.fromJson(data as Map<String, dynamic>);
  }
}
