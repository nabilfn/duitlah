import '../../../core/api/api_client.dart';
import '../domain/budget.dart';

class BudgetsRepository {
  BudgetsRepository(this._client);

  final ApiClient _client;

  Future<List<Budget>> listBudgets({int? year, int? month}) async {
    final data = await _client.get('/api/v1/budgets', query: {
      if (year != null) 'year': year,
      if (month != null) 'month': month,
    }) as List;
    return data.map((e) => Budget.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// The create request body field is `amountLimit` — a genuine asymmetry
  /// with the response DTO, which reports the same value back as `limit`
  /// (confirmed by hitting the live API directly; sending `limit` on
  /// create is silently rejected with a validation error).
  /// [cycleType] defaults to CALENDAR_MONTH — the exact pre-Phase-3 behavior — in which case
  /// [periodYear]/[periodMonth] are required. PAYDAY/CUSTOM instead require [periodStartDate]/
  /// [periodEndDate] (spec section 21) and periodYear/periodMonth are ignored.
  Future<Budget> createBudget({
    String? categoryId,
    int? periodYear,
    int? periodMonth,
    required String limit,
    BudgetCycleType cycleType = BudgetCycleType.CALENDAR_MONTH,
    String? periodStartDate,
    String? periodEndDate,
  }) async {
    final data = await _client.post('/api/v1/budgets', data: {
      if (categoryId != null) 'categoryId': categoryId,
      if (periodYear != null) 'periodYear': periodYear,
      if (periodMonth != null) 'periodMonth': periodMonth,
      'amountLimit': limit,
      'cycleType': cycleType.name,
      if (periodStartDate != null) 'periodStartDate': periodStartDate,
      if (periodEndDate != null) 'periodEndDate': periodEndDate,
    });
    return Budget.fromJson(data as Map<String, dynamic>);
  }

  Future<void> deleteBudget(String budgetId) => _client.delete('/api/v1/budgets/$budgetId');
}

class GoalsRepository {
  GoalsRepository(this._client);

  final ApiClient _client;

  Future<List<Goal>> listGoals() async {
    final data = await _client.get('/api/v1/goals') as List;
    return data.map((e) => Goal.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Goal> createGoal({
    required String name,
    required GoalType type,
    required String targetAmount,
    String? targetDate,
  }) async {
    final data = await _client.post('/api/v1/goals', data: {
      'name': name,
      'type': type.name,
      'targetAmount': targetAmount,
      if (targetDate != null) 'targetDate': targetDate,
    });
    return Goal.fromJson(data as Map<String, dynamic>);
  }

  Future<GoalContribution> addContribution(
    String goalId, {
    required String amount,
    required String occurredOn,
    String? note,
    required String idempotencyKey,
  }) async {
    final data = await _client.post(
      '/api/v1/goals/$goalId/contributions',
      data: {'amount': amount, 'occurredOn': occurredOn, if (note != null) 'note': note},
      idempotencyKey: idempotencyKey,
    );
    return GoalContribution.fromJson(data as Map<String, dynamic>);
  }
}
