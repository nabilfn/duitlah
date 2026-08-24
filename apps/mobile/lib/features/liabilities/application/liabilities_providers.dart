import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/providers.dart';
import '../data/liability_repository.dart';
import '../domain/liability.dart';

final liabilityRepositoryProvider =
    Provider((ref) => LiabilityRepository(ref.watch(apiClientProvider)));

final creditCardRepositoryProvider =
    Provider((ref) => CreditCardRepository(ref.watch(apiClientProvider)));

final liabilityListProvider = FutureProvider.autoDispose<List<Liability>>(
  (ref) => ref.watch(liabilityRepositoryProvider).list(),
);

final creditCardDetailsProvider =
    FutureProvider.autoDispose.family<CreditCardDetails?, String>(
  (ref, accountId) => ref.watch(creditCardRepositoryProvider).get(accountId),
);
