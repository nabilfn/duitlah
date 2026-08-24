import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/providers.dart';
import '../data/finance_repository.dart';
import '../domain/finance.dart';

final financeRepositoryProvider =
    Provider((ref) => FinanceRepository(ref.watch(apiClientProvider)));

final dashboardProvider = FutureProvider.autoDispose<DashboardSummary>(
  (ref) => ref.watch(financeRepositoryProvider).getDashboard(),
);

final accountListProvider = FutureProvider.autoDispose<List<Account>>(
  (ref) => ref.watch(financeRepositoryProvider).listAccounts(),
);

final categoryListProvider = FutureProvider.autoDispose<List<Category>>(
  (ref) => ref.watch(financeRepositoryProvider).listCategories(),
);

final transactionsProvider = FutureProvider.autoDispose<TransactionPage>(
  (ref) => ref.watch(financeRepositoryProvider).listTransactions(),
);
