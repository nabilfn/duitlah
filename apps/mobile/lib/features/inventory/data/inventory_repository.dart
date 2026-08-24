import '../../../core/api/api_client.dart';
import '../domain/inventory.dart';

/// Phase 8 — Inventory & Costing. Stock movements/valuation, recipe
/// (ingredient) costing, and the two space-wide inventory reports.
class InventoryRepository {
  InventoryRepository(this._client);

  final ApiClient _client;

  // ---- Stock movements ------------------------------------------------------

  /// [unitCost] is only meaningful for a positive [quantity] — omit it for a
  /// negative (outbound) one, since the server always computes it itself
  /// from the current Weighted Average Cost. [businessAccountId] is only
  /// meaningful for [MovementType.PURCHASE] (which bank/cash account paid);
  /// omitting it means "bought on credit".
  Future<MovementResponse> recordMovement(
    String spaceId,
    String productId, {
    required MovementType type,
    required String quantity,
    String? unitCost,
    required String occurredOn,
    String? notes,
    String? businessAccountId,
  }) async {
    final data = await _client.post(
      '/api/v1/spaces/$spaceId/products/$productId/movements',
      data: {
        'type': type.name,
        'quantity': quantity,
        if (unitCost != null) 'unitCost': unitCost,
        'occurredOn': occurredOn,
        if (notes != null) 'notes': notes,
        if (businessAccountId != null) 'businessAccountId': businessAccountId,
      },
    );
    return MovementResponse.fromJson(data as Map<String, dynamic>);
  }

  /// Newest first, per the server's contract.
  Future<List<MovementResponse>> listMovements(String spaceId, String productId) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/products/$productId/movements') as List;
    return data.map((e) => MovementResponse.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<ProductValuationResponse> getValuation(String spaceId, String productId) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/products/$productId/valuation');
    return ProductValuationResponse.fromJson(data as Map<String, dynamic>);
  }

  // ---- Recipe / ingredient costing -------------------------------------------

  Future<RecipeItemResponse> addRecipeItem(
    String spaceId,
    String productId, {
    required String ingredientProductId,
    required String quantityPerUnit,
  }) async {
    final data = await _client.post(
      '/api/v1/spaces/$spaceId/products/$productId/recipe',
      data: {'ingredientProductId': ingredientProductId, 'quantityPerUnit': quantityPerUnit},
    );
    return RecipeItemResponse.fromJson(data as Map<String, dynamic>);
  }

  Future<List<RecipeItemResponse>> listRecipeItems(String spaceId, String productId) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/products/$productId/recipe') as List;
    return data.map((e) => RecipeItemResponse.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> removeRecipeItem(String spaceId, String productId, String itemId) =>
      _client.delete('/api/v1/spaces/$spaceId/products/$productId/recipe/$itemId');

  Future<RecipeCostResponse> getRecipeCost(String spaceId, String productId) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/products/$productId/recipe/cost');
    return RecipeCostResponse.fromJson(data as Map<String, dynamic>);
  }

  // ---- Reports ----------------------------------------------------------------

  Future<List<StockValuationRow>> getStockValuation(String spaceId) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/inventory/stock-valuation') as List;
    return data.map((e) => StockValuationRow.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<CogsReport> getCogs(String spaceId, {required String from, required String to}) async {
    final data = await _client.get(
      '/api/v1/spaces/$spaceId/inventory/cogs',
      query: {'from': from, 'to': to},
    );
    return CogsReport.fromJson(data as Map<String, dynamic>);
  }
}
