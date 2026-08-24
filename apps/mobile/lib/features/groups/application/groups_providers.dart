import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/providers.dart';
import '../../../core/errors/app_exception.dart';
import '../data/groups_repository.dart';
import '../domain/group.dart';

final groupsRepositoryProvider = Provider((ref) => GroupsRepository(ref.watch(apiClientProvider)));

final groupListProvider = FutureProvider.autoDispose<List<Group>>(
  (ref) => ref.watch(groupsRepositoryProvider).listGroups(),
);

final groupDetailProvider = FutureProvider.autoDispose.family<Group, String>(
  (ref, groupId) => ref.watch(groupsRepositoryProvider).getGroup(groupId),
);

final groupMembersProvider = FutureProvider.autoDispose.family<List<GroupMember>, String>(
  (ref, groupId) => ref.watch(groupsRepositoryProvider).listMembers(groupId),
);

final groupExpensesProvider = FutureProvider.autoDispose.family<List<GroupExpense>, String>(
  (ref, groupId) => ref.watch(groupsRepositoryProvider).listExpenses(groupId),
);

final groupBalancesProvider = FutureProvider.autoDispose.family<List<GroupBalance>, String>(
  (ref, groupId) => ref.watch(groupsRepositoryProvider).getBalances(groupId),
);

final groupGoalsProvider = FutureProvider.autoDispose.family<List<GroupGoal>, String>(
  (ref, groupId) => ref.watch(groupsRepositoryProvider).listGoals(groupId),
);

typedef GroupGoalKey = ({String groupId, String goalId});

final groupGoalContributionsProvider =
    FutureProvider.autoDispose.family<List<GroupGoalContribution>, GroupGoalKey>(
  (ref, key) => ref.watch(groupsRepositoryProvider).listGoalContributions(key.groupId, key.goalId),
);

/// Null when this group has no budget set yet (backend returns 404 `BUDGET_NOT_SET`), which is a
/// normal state for a fresh Trip group — not surfaced as an error.
final groupBudgetProvider = FutureProvider.autoDispose.family<GroupBudget?, String>((ref, groupId) async {
  try {
    return await ref.watch(groupsRepositoryProvider).getBudget(groupId);
  } on AppException catch (e) {
    if (e.code == 'BUDGET_NOT_SET') return null;
    rethrow;
  }
});

final tripSummaryProvider = FutureProvider.autoDispose.family<TripSummary, String>(
  (ref, groupId) => ref.watch(groupsRepositoryProvider).getTripSummary(groupId),
);

final housemateMonthProvider = StateProvider.family<DateTime, String>(
  (ref, groupId) => DateTime(DateTime.now().year, DateTime.now().month),
);

typedef HousemateDashboardKey = ({String groupId, int year, int month});

final housemateDashboardProvider =
    FutureProvider.autoDispose.family<HousemateDashboard, HousemateDashboardKey>(
  (ref, key) => ref
      .watch(groupsRepositoryProvider)
      .getHousemateDashboard(key.groupId, year: key.year, month: key.month),
);
