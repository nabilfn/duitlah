import '../../../core/api/api_client.dart';
import '../domain/transaction_rule.dart';

/// New in Phase 13 — consulted automatically by the backend's category
/// suggestion logic (`TransactionRuleService.suggestCategory`), so there's no
/// "apply" action here, just CRUD: the server does the matching on its own
/// whenever an AutoTrack candidate is produced.
class TransactionRuleRepository {
  TransactionRuleRepository(this._client);

  final ApiClient _client;

  Future<List<TransactionRule>> list() async {
    final data = await _client.get('/api/v1/transaction-rules') as List;
    return data.map((e) => TransactionRule.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<TransactionRule> create({
    required MatchType matchType,
    required String matchValue,
    required String categoryId,
    int? priority,
  }) async {
    final data = await _client.post('/api/v1/transaction-rules', data: {
      'matchType': matchType.name,
      'matchValue': matchValue,
      'categoryId': categoryId,
      if (priority != null) 'priority': priority,
    });
    return TransactionRule.fromJson(data as Map<String, dynamic>);
  }

  Future<TransactionRule> update(
    String ruleId, {
    required MatchType matchType,
    required String matchValue,
    required String categoryId,
    required int priority,
    required bool active,
  }) async {
    final data = await _client.put('/api/v1/transaction-rules/$ruleId', data: {
      'matchType': matchType.name,
      'matchValue': matchValue,
      'categoryId': categoryId,
      'priority': priority,
      'active': active,
    });
    return TransactionRule.fromJson(data as Map<String, dynamic>);
  }

  Future<void> delete(String ruleId) => _client.delete('/api/v1/transaction-rules/$ruleId');
}
