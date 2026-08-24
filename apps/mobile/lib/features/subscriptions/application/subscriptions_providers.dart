import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/providers.dart';
import '../data/subscriptions_repository.dart';
import '../domain/entitlement.dart';

final subscriptionsRepositoryProvider =
    Provider((ref) => SubscriptionsRepository(ref.watch(apiClientProvider)));

final entitlementProvider = FutureProvider.autoDispose<Entitlement>(
  (ref) => ref.watch(subscriptionsRepositoryProvider).getEntitlement(),
);
