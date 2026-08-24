import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/providers.dart';
import '../data/net_worth_repository.dart';
import '../domain/net_worth.dart';

final netWorthRepositoryProvider =
    Provider((ref) => NetWorthRepository(ref.watch(apiClientProvider)));

final netWorthProvider = FutureProvider.autoDispose<NetWorth>(
  (ref) => ref.watch(netWorthRepositoryProvider).compute(),
);

final otherAssetListProvider = FutureProvider.autoDispose<List<OtherAsset>>(
  (ref) => ref.watch(netWorthRepositoryProvider).listOtherAssets(),
);
