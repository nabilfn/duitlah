import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/providers.dart';
import '../data/recurring_transactions_repository.dart';
import '../domain/recurring_transaction.dart';

final recurringTransactionsRepositoryProvider =
    Provider((ref) => RecurringTransactionsRepository(ref.watch(apiClientProvider)));

final recurringTransactionListProvider = FutureProvider.autoDispose<List<RecurringTransaction>>(
  (ref) => ref.watch(recurringTransactionsRepositoryProvider).list(),
);

final subscriptionsSummaryProvider = FutureProvider.autoDispose<SubscriptionsSummary>(
  (ref) => ref.watch(recurringTransactionsRepositoryProvider).subscriptionsSummary(),
);
