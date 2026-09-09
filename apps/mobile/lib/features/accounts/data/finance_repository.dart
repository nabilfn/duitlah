import '../../../core/api/api_client.dart';
import '../domain/finance.dart';

class FinanceRepository {
  FinanceRepository(this._client);

  final ApiClient _client;

  Future<DashboardSummary> getDashboard() async {
    final data = await _client.get('/api/v1/dashboard');
    return DashboardSummary.fromJson(data as Map<String, dynamic>);
  }

  Future<List<Account>> listAccounts() async {
    final data = await _client.get('/api/v1/accounts') as List;
    return data.map((e) => Account.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Account> createAccount({
    required String name,
    required AccountType type,
    String currency = 'MYR',
    String openingBalance = '0',
  }) async {
    final data = await _client.post('/api/v1/accounts', data: {
      'name': name,
      'type': type.name,
      'currency': currency,
      'openingBalance': openingBalance,
    });
    return Account.fromJson(data as Map<String, dynamic>);
  }

  Future<List<Category>> listCategories() async {
    final data = await _client.get('/api/v1/categories') as List;
    return data.map((e) => Category.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<TransactionPage> listTransactions({int page = 0, int size = 20, String? accountId, TransactionType? type, String? from, String? to}) async {
    final data = await _client.get('/api/v1/transactions', query: {
      'page': page,
      'size': size,
      if (accountId != null) 'accountId': accountId,
      if (type != null) 'type': type.name,
      if (from != null) 'from': from,
      if (to != null) 'to': to,
      'sort': 'occurredOn,desc',
    });
    return TransactionPage.fromJson(data as Map<String, dynamic>);
  }

  /// [type] is INCOME or EXPENSE only — a transfer is a distinct action
  /// (see [transfer]) with its own endpoint. `direction` is never sent:
  /// the backend derives IN/OUT from `type` itself and only ever returns
  /// it, confirmed by hitting the live API directly (a request with no
  /// `direction` field still returns one).
  Future<Transaction> createTransaction({
    required String accountId,
    required TransactionType type,
    String? categoryId,
    required String amount,
    String? merchant,
    String? description,
    String? notes,
    required String occurredOn,
    required String idempotencyKey,
  }) async {
    final data = await _client.post(
      '/api/v1/transactions',
      data: {
        'accountId': accountId,
        'type': type.name,
        if (categoryId != null) 'categoryId': categoryId,
        'amount': amount,
        if (merchant != null) 'merchant': merchant,
        if (description != null) 'description': description,
        if (notes != null) 'notes': notes,
        'occurredOn': occurredOn,
      },
      idempotencyKey: idempotencyKey,
    );
    return Transaction.fromJson(data as Map<String, dynamic>);
  }

  Future<void> transfer({
    required String fromAccountId,
    required String toAccountId,
    required String amount,
    required String occurredOn,
    required String idempotencyKey,
  }) =>
      _client.post(
        '/api/v1/transactions/transfer',
        data: {
          'fromAccountId': fromAccountId,
          'toAccountId': toAccountId,
          'amount': amount,
          'occurredOn': occurredOn,
        },
        idempotencyKey: idempotencyKey,
      );
}
