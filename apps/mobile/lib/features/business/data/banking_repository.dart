import '../../../core/api/api_client.dart';
import '../domain/banking.dart';

class BankingRepository {
  BankingRepository(this._client);

  final ApiClient _client;

  Future<List<BusinessAccount>> listAccounts(String spaceId) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/business-accounts') as List;
    return data.map((e) => BusinessAccount.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<BusinessAccount> getAccount(String spaceId, String accountId) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/business-accounts/$accountId');
    return BusinessAccount.fromJson(data as Map<String, dynamic>);
  }

  Future<BusinessAccount> createAccount(
    String spaceId, {
    required String name,
    required BusinessAccountType type,
    String? currency,
    String? openingBalance,
  }) async {
    final data = await _client.post('/api/v1/spaces/$spaceId/business-accounts', data: {
      'name': name,
      'type': type.name,
      if (currency != null) 'currency': currency,
      if (openingBalance != null) 'openingBalance': openingBalance,
    });
    return BusinessAccount.fromJson(data as Map<String, dynamic>);
  }

  Future<BusinessAccount> updateAccount(
    String spaceId,
    String accountId, {
    required String name,
    required BusinessAccountType type,
    required String openingBalance,
    required bool archived,
  }) async {
    final data = await _client.patch('/api/v1/spaces/$spaceId/business-accounts/$accountId', data: {
      'name': name,
      'type': type.name,
      'openingBalance': openingBalance,
      'archived': archived,
    });
    return BusinessAccount.fromJson(data as Map<String, dynamic>);
  }

  Future<List<AccountEntry>> listEntries(String spaceId, String accountId) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/business-accounts/$accountId/entries') as List;
    return data.map((e) => AccountEntry.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<AccountEntry> createEntry(
    String spaceId,
    String accountId, {
    required EntryDirection direction,
    required String amount,
    required String occurredOn,
    String? description,
  }) async {
    final data = await _client.post('/api/v1/spaces/$spaceId/business-accounts/$accountId/entries', data: {
      'direction': direction.name,
      'amount': amount,
      'occurredOn': occurredOn,
      if (description != null) 'description': description,
    });
    return AccountEntry.fromJson(data as Map<String, dynamic>);
  }

  /// Phase 6 — maps (or clears, when [chartOfAccountsId] is null) this
  /// business account's Chart of Accounts ledger account, so Phase 5's
  /// "record expense payment" / "receive invoice payment" actions on it
  /// start producing real double-entry journals automatically.
  Future<BusinessAccount> updateChartOfAccountsMapping(
    String spaceId,
    String accountId, {
    required String? chartOfAccountsId,
  }) async {
    final data = await _client.patch(
      '/api/v1/spaces/$spaceId/business-accounts/$accountId/chart-of-accounts-mapping',
      data: {'chartOfAccountsId': chartOfAccountsId},
    );
    return BusinessAccount.fromJson(data as Map<String, dynamic>);
  }

  Future<void> transfer(
    String spaceId,
    String accountId, {
    required String toBusinessAccountId,
    required String amount,
    required String occurredOn,
    String? description,
  }) =>
      _client.post('/api/v1/spaces/$spaceId/business-accounts/$accountId/transfer', data: {
        'toBusinessAccountId': toBusinessAccountId,
        'amount': amount,
        'occurredOn': occurredOn,
        if (description != null) 'description': description,
      });
}
