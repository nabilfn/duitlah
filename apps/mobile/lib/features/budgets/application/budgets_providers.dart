import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/providers.dart';
import '../data/budgets_repository.dart';
import '../domain/budget.dart';

final budgetsRepositoryProvider =
    Provider((ref) => BudgetsRepository(ref.watch(apiClientProvider)));

final goalsRepositoryProvider = Provider((ref) => GoalsRepository(ref.watch(apiClientProvider)));

final budgetListProvider = FutureProvider.autoDispose<List<Budget>>(
  (ref) => ref.watch(budgetsRepositoryProvider).listBudgets(),
);

final goalListProvider = FutureProvider.autoDispose<List<Goal>>(
  (ref) => ref.watch(goalsRepositoryProvider).listGoals(),
);
