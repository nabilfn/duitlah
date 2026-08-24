import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/providers.dart';
import '../data/fixed_assets_repository.dart';
import '../domain/fixed_assets.dart';

/// A resource scoped to a space plus an asset id — mirrors
/// `inventory_providers.dart`'s `SpaceProductKey` and
/// `business_providers.dart`'s `SpaceResourceKey`.
typedef SpaceAssetKey = ({String spaceId, String assetId});

// ---- Repository -------------------------------------------------------------

final fixedAssetsRepositoryProvider =
    Provider((ref) => FixedAssetsRepository(ref.watch(apiClientProvider)));

// ---- Asset register -----------------------------------------------------------

final assetListProvider = FutureProvider.autoDispose.family<List<FixedAssetResponse>, String>(
  (ref, spaceId) => ref.watch(fixedAssetsRepositoryProvider).listAssets(spaceId),
);

final assetDetailProvider = FutureProvider.autoDispose.family<FixedAssetResponse, SpaceAssetKey>(
  (ref, key) => ref.watch(fixedAssetsRepositoryProvider).getAsset(key.spaceId, key.assetId),
);

// ---- Depreciation ---------------------------------------------------------------

final depreciationEntryListProvider =
    FutureProvider.autoDispose.family<List<DepreciationEntryResponse>, SpaceAssetKey>(
  (ref, key) => ref.watch(fixedAssetsRepositoryProvider).listDepreciationEntries(key.spaceId, key.assetId),
);
