import '../../../core/api/api_client.dart';
import '../domain/expenses.dart';

class ExpensesRepository {
  ExpensesRepository(this._client);

  final ApiClient _client;

  Future<List<Expense>> listExpenses(String spaceId) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/expenses') as List;
    return data.map((e) => Expense.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Expense> getExpense(String spaceId, String expenseId) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/expenses/$expenseId');
    return Expense.fromJson(data as Map<String, dynamic>);
  }

  Future<Expense> createExpense(
    String spaceId, {
    String? supplierId,
    String? category,
    required String amount,
    required String occurredOn,
    String? receiptId,
    String? notes,
  }) async {
    final data = await _client.post('/api/v1/spaces/$spaceId/expenses', data: {
      if (supplierId != null) 'supplierId': supplierId,
      if (category != null) 'category': category,
      'amount': amount,
      'occurredOn': occurredOn,
      if (receiptId != null) 'receiptId': receiptId,
      if (notes != null) 'notes': notes,
    });
    return Expense.fromJson(data as Map<String, dynamic>);
  }

  /// Phase 6 — maps (or clears, when [chartOfAccountsId] is null) this
  /// expense's Chart of Accounts ledger account, so recording a payment
  /// against it starts producing a real double-entry journal automatically.
  Future<Expense> updateChartOfAccountsMapping(
    String spaceId,
    String expenseId, {
    required String? chartOfAccountsId,
  }) async {
    final data = await _client.patch(
      '/api/v1/spaces/$spaceId/expenses/$expenseId/chart-of-accounts-mapping',
      data: {'chartOfAccountsId': chartOfAccountsId},
    );
    return Expense.fromJson(data as Map<String, dynamic>);
  }

  Future<List<ExpensePayment>> listPayments(String spaceId, String expenseId) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/expenses/$expenseId/payments') as List;
    return data.map((e) => ExpensePayment.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<ExpensePayment> recordPayment(
    String spaceId,
    String expenseId, {
    required String businessAccountId,
    required String amount,
    required String paidOn,
    String? notes,
  }) async {
    final data = await _client.post('/api/v1/spaces/$spaceId/expenses/$expenseId/payments', data: {
      'businessAccountId': businessAccountId,
      'amount': amount,
      'paidOn': paidOn,
      if (notes != null) 'notes': notes,
    });
    return ExpensePayment.fromJson(data as Map<String, dynamic>);
  }
}
