import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/providers.dart';
import '../data/settlements_repository.dart';
import '../domain/settlement.dart';

final settlementsRepositoryProvider =
    Provider((ref) => SettlementsRepository(ref.watch(apiClientProvider)));

final settlementListProvider = FutureProvider.autoDispose<List<Settlement>>(
  (ref) => ref.watch(settlementsRepositoryProvider).listSettlements(),
);

final settlementSummaryProvider = FutureProvider.autoDispose<SettlementSummary>(
  (ref) => ref.watch(settlementsRepositoryProvider).getSummary(),
);
