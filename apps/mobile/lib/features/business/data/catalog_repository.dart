import '../../../core/api/api_client.dart';
import '../domain/catalog.dart';

class CatalogRepository {
  CatalogRepository(this._client);

  final ApiClient _client;

  Future<List<Product>> listProducts(String spaceId) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/products') as List;
    return data.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Product> getProduct(String spaceId, String id) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/products/$id');
    return Product.fromJson(data as Map<String, dynamic>);
  }

  Future<Product> createProduct(
    String spaceId, {
    required String name,
    String? sku,
    required ProductType type,
    String? unit,
    required String unitPrice,
    String? description,
    String? cost,
    TaxClassification taxClassification = TaxClassification.NOT_APPLICABLE,
    bool trackInventory = false,
    String? reorderPoint,
  }) async {
    final data = await _client.post('/api/v1/spaces/$spaceId/products', data: {
      'name': name,
      if (sku != null) 'sku': sku,
      'type': type.name,
      if (unit != null) 'unit': unit,
      'unitPrice': unitPrice,
      if (description != null) 'description': description,
      if (cost != null) 'cost': cost,
      'taxClassification': taxClassification.name,
      'trackInventory': trackInventory,
      if (reorderPoint != null) 'reorderPoint': reorderPoint,
    });
    return Product.fromJson(data as Map<String, dynamic>);
  }

  Future<Product> updateProduct(
    String spaceId,
    String id, {
    required String name,
    String? sku,
    required ProductType type,
    String? unit,
    required String unitPrice,
    String? description,
    String? cost,
    TaxClassification taxClassification = TaxClassification.NOT_APPLICABLE,
    bool trackInventory = false,
    String? reorderPoint,
  }) async {
    final data = await _client.put('/api/v1/spaces/$spaceId/products/$id', data: {
      'name': name,
      if (sku != null) 'sku': sku,
      'type': type.name,
      if (unit != null) 'unit': unit,
      'unitPrice': unitPrice,
      if (description != null) 'description': description,
      if (cost != null) 'cost': cost,
      'taxClassification': taxClassification.name,
      'trackInventory': trackInventory,
      if (reorderPoint != null) 'reorderPoint': reorderPoint,
    });
    return Product.fromJson(data as Map<String, dynamic>);
  }

  Future<void> archiveProduct(String spaceId, String id) => _client.delete('/api/v1/spaces/$spaceId/products/$id');
}
