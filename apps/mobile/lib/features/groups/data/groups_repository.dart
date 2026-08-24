import '../../../core/api/api_client.dart';
import '../domain/group.dart';

class GroupsRepository {
  GroupsRepository(this._client);

  final ApiClient _client;

  Future<List<Group>> listGroups() async {
    final data = await _client.get('/api/v1/groups') as List;
    return data.map((e) => Group.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Group> getGroup(String groupId) async {
    final data = await _client.get('/api/v1/groups/$groupId');
    return Group.fromJson(data as Map<String, dynamic>);
  }

  Future<Group> createGroup({required String name, required GroupType type}) async {
    final data = await _client.post('/api/v1/groups', data: {'name': name, 'type': type.name});
    return Group.fromJson(data as Map<String, dynamic>);
  }

  Future<Group> joinGroup(String token) async {
    final data = await _client.post('/api/v1/groups/join', data: {'token': token});
    return Group.fromJson(data as Map<String, dynamic>);
  }

  Future<String> getInviteToken(String groupId) async {
    final data = await _client.post('/api/v1/groups/$groupId/invite-token') as Map<String, dynamic>;
    return data['token'] as String? ?? data['inviteToken'] as String;
  }

  Future<List<GroupMember>> listMembers(String groupId) async {
    final data = await _client.get('/api/v1/groups/$groupId/members') as List;
    return data.map((e) => GroupMember.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<GroupExpense>> listExpenses(String groupId) async {
    final data = await _client.get('/api/v1/groups/$groupId/expenses') as List;
    return data.map((e) => GroupExpense.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<GroupExpense> addExpense(
    String groupId, {
    required String description,
    required String amount,
    required String occurredOn,
    required String paidByUserId,
    required List<String> participantUserIds,
    GroupExpenseCategory? category,
    String? originalCurrency,
    String? originalAmount,
    String? exchangeRate,
  }) async {
    final data = await _client.post('/api/v1/groups/$groupId/expenses', data: {
      'description': description,
      'amount': amount,
      'occurredOn': occurredOn,
      'paidByUserId': paidByUserId,
      'participantUserIds': participantUserIds,
      if (category != null) 'category': category.name,
      if (originalCurrency != null) 'originalCurrency': originalCurrency,
      if (originalAmount != null) 'originalAmount': originalAmount,
      if (exchangeRate != null) 'exchangeRate': exchangeRate,
    });
    return GroupExpense.fromJson(data as Map<String, dynamic>);
  }

  Future<List<GroupBalance>> getBalances(String groupId) async {
    final data = await _client.get('/api/v1/groups/$groupId/balances') as List;
    return data.map((e) => GroupBalance.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> settleGroup(String groupId, {required String idempotencyKey}) =>
      _client.post('/api/v1/groups/$groupId/settle', idempotencyKey: idempotencyKey);

  // --- Shared goals (Phase 11) ---

  Future<List<GroupGoal>> listGoals(String groupId) async {
    final data = await _client.get('/api/v1/groups/$groupId/goals') as List;
    return data.map((e) => GroupGoal.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<GroupGoal> createGoal(
    String groupId, {
    required String name,
    required String targetAmount,
    String? targetDate,
  }) async {
    final data = await _client.post('/api/v1/groups/$groupId/goals', data: {
      'name': name,
      'targetAmount': targetAmount,
      if (targetDate != null) 'targetDate': targetDate,
    });
    return GroupGoal.fromJson(data as Map<String, dynamic>);
  }

  Future<List<GroupGoalContribution>> listGoalContributions(String groupId, String goalId) async {
    final data =
        await _client.get('/api/v1/groups/$groupId/goals/$goalId/contributions') as List;
    return data.map((e) => GroupGoalContribution.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<GroupGoal> addGoalContribution(
    String groupId,
    String goalId, {
    required String amount,
    required String occurredOn,
    String? note,
    required String idempotencyKey,
  }) async {
    final data = await _client.post(
      '/api/v1/groups/$groupId/goals/$goalId/contributions',
      data: {'amount': amount, 'occurredOn': occurredOn, if (note != null) 'note': note},
      idempotencyKey: idempotencyKey,
    );
    return GroupGoal.fromJson(data as Map<String, dynamic>);
  }

  Future<void> deleteGoalContribution(String groupId, String goalId, String contributionId) =>
      _client.delete('/api/v1/groups/$groupId/goals/$goalId/contributions/$contributionId');

  // --- Trip mode (Phase 11) ---

  Future<GroupBudget> setBudget(String groupId, {required String amount}) async {
    final data = await _client.put('/api/v1/groups/$groupId/budget', data: {'amount': amount});
    return GroupBudget.fromJson(data as Map<String, dynamic>);
  }

  Future<GroupBudget> getBudget(String groupId) async {
    final data = await _client.get('/api/v1/groups/$groupId/budget');
    return GroupBudget.fromJson(data as Map<String, dynamic>);
  }

  Future<TripSummary> getTripSummary(String groupId) async {
    final data = await _client.get('/api/v1/groups/$groupId/trip-summary');
    return TripSummary.fromJson(data as Map<String, dynamic>);
  }

  // --- Housemate mode (Phase 11) ---

  Future<HousemateDashboard> getHousemateDashboard(
    String groupId, {
    required int year,
    required int month,
  }) async {
    final data = await _client.get(
      '/api/v1/groups/$groupId/housemate-dashboard',
      query: {'year': year, 'month': month},
    );
    return HousemateDashboard.fromJson(data as Map<String, dynamic>);
  }
}
