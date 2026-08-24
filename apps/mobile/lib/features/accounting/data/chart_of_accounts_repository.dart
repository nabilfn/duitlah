import '../../../core/api/api_client.dart';
import '../domain/chart_of_accounts.dart';

class ChartOfAccountsRepository {
  ChartOfAccountsRepository(this._client);

  final ApiClient _client;

  Future<List<LedgerAccount>> listAccounts(String spaceId) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/accounting/chart-of-accounts') as List;
    return data.map((e) => LedgerAccount.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<LedgerAccount> getAccount(String spaceId, String accountId) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/accounting/chart-of-accounts/$accountId');
    return LedgerAccount.fromJson(data as Map<String, dynamic>);
  }

  /// One-time bootstrap for a space that has no Chart of Accounts yet.
  /// Errors with `409 CHART_OF_ACCOUNTS_ALREADY_SEEDED` if called again.
  Future<List<LedgerAccount>> seedDefaults(String spaceId) async {
    final data = await _client.post('/api/v1/spaces/$spaceId/accounting/chart-of-accounts/seed-defaults') as List;
    return data.map((e) => LedgerAccount.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<LedgerAccount> createAccount(
    String spaceId, {
    required String code,
    required String name,
    required LedgerAccountType type,
    required bool cashEquivalent,
  }) async {
    final data = await _client.post('/api/v1/spaces/$spaceId/accounting/chart-of-accounts', data: {
      'code': code,
      'name': name,
      'type': type.name,
      'cashEquivalent': cashEquivalent,
    });
    return LedgerAccount.fromJson(data as Map<String, dynamic>);
  }

  Future<LedgerAccount> updateAccount(
    String spaceId,
    String accountId, {
    required String code,
    required String name,
    required LedgerAccountType type,
    required bool cashEquivalent,
  }) async {
    final data = await _client.put('/api/v1/spaces/$spaceId/accounting/chart-of-accounts/$accountId', data: {
      'code': code,
      'name': name,
      'type': type.name,
      'cashEquivalent': cashEquivalent,
    });
    return LedgerAccount.fromJson(data as Map<String, dynamic>);
  }

  /// Archives the account (200, empty body) — still editable/re-visible in
  /// historical reports, just excluded from active pickers going forward.
  Future<void> archiveAccount(String spaceId, String accountId) =>
      _client.delete('/api/v1/spaces/$spaceId/accounting/chart-of-accounts/$accountId');
}
