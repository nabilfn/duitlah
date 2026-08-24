import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/providers.dart';
import '../data/inventory_repository.dart';
import '../domain/inventory.dart';

/// A resource scoped to a space plus a product id — every per-product
/// inventory resource (valuation, movements, recipe) is addressed by this.
typedef SpaceProductKey = ({String spaceId, String productId});

/// The resolved (never-null) date range the COGS report is filtered by —
/// the hub screen defaults this to the current month before it ever reads
/// the provider, mirroring `accounting_providers.dart`'s `DateRangeFilter`.
typedef CogsFilter = ({String spaceId, String from, String to});

// ---- Repository -------------------------------------------------------------

final inventoryRepositoryProvider = Provider((ref) => InventoryRepository(ref.watch(apiClientProvider)));

// ---- Stock movements & valuation ---------------------------------------------

final productValuationProvider = FutureProvider.autoDispose.family<ProductValuationResponse, SpaceProductKey>(
  (ref, key) => ref.watch(inventoryRepositoryProvider).getValuation(key.spaceId, key.productId),
);

final movementListProvider = FutureProvider.autoDispose.family<List<MovementResponse>, SpaceProductKey>(
  (ref, key) => ref.watch(inventoryRepositoryProvider).listMovements(key.spaceId, key.productId),
);

// ---- Recipe / ingredient costing ---------------------------------------------

final recipeItemsProvider = FutureProvider.autoDispose.family<List<RecipeItemResponse>, SpaceProductKey>(
  (ref, key) => ref.watch(inventoryRepositoryProvider).listRecipeItems(key.spaceId, key.productId),
);

final recipeCostProvider = FutureProvider.autoDispose.family<RecipeCostResponse, SpaceProductKey>(
  (ref, key) => ref.watch(inventoryRepositoryProvider).getRecipeCost(key.spaceId, key.productId),
);

// ---- Reports ------------------------------------------------------------------

final stockValuationListProvider = FutureProvider.autoDispose.family<List<StockValuationRow>, String>(
  (ref, spaceId) => ref.watch(inventoryRepositoryProvider).getStockValuation(spaceId),
);

final cogsReportProvider = FutureProvider.autoDispose.family<CogsReport, CogsFilter>(
  (ref, f) => ref.watch(inventoryRepositoryProvider).getCogs(f.spaceId, from: f.from, to: f.to),
);
