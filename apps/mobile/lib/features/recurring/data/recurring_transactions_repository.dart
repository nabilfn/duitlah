import '../../../core/api/api_client.dart';
import '../../accounts/domain/finance.dart';
import '../domain/recurring_transaction.dart';

class RecurringTransactionsRepository {
  RecurringTransactionsRepository(this._client);

  final ApiClient _client;

  Future<List<RecurringTransaction>> list() async {
    final data = await _client.get('/api/v1/recurring-transactions') as List;
    return data.map((e) => RecurringTransaction.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<SubscriptionsSummary> subscriptionsSummary() async {
    final data = await _client.get('/api/v1/recurring-transactions/subscriptions/summary');
    return SubscriptionsSummary.fromJson(data as Map<String, dynamic>);
  }

  Future<RecurringTransaction> create({
    required String accountId,
    required TransactionType type,
    String? categoryId,
    required String amount,
    String? merchant,
    String? description,
    String? notes,
    required RecurrenceFrequency frequency,
    int intervalCount = 1,
    required String startDate,
    String? endDate,
    required bool isSubscription,
  }) async {
    final data = await _client.post('/api/v1/recurring-transactions', data: {
      'accountId': accountId,
      'type': type.name,
      if (categoryId != null) 'categoryId': categoryId,
      'amount': amount,
      if (merchant != null) 'merchant': merchant,
      if (description != null) 'description': description,
      if (notes != null) 'notes': notes,
      'frequency': frequency.name,
      'intervalCount': intervalCount,
      'startDate': startDate,
      if (endDate != null) 'endDate': endDate,
      'isSubscription': isSubscription,
    });
    return RecurringTransaction.fromJson(data as Map<String, dynamic>);
  }

  Future<RecurringTransaction> update(
    String id, {
    String? categoryId,
    required String amount,
    String? merchant,
    String? description,
    String? notes,
    required RecurrenceFrequency frequency,
    int intervalCount = 1,
    String? endDate,
    required bool isSubscription,
    required bool active,
  }) async {
    final data = await _client.patch('/api/v1/recurring-transactions/$id', data: {
      if (categoryId != null) 'categoryId': categoryId,
      'amount': amount,
      if (merchant != null) 'merchant': merchant,
      if (description != null) 'description': description,
      if (notes != null) 'notes': notes,
      'frequency': frequency.name,
      'intervalCount': intervalCount,
      if (endDate != null) 'endDate': endDate,
      'isSubscription': isSubscription,
      'active': active,
    });
    return RecurringTransaction.fromJson(data as Map<String, dynamic>);
  }

  Future<void> delete(String id) => _client.delete('/api/v1/recurring-transactions/$id');
}
