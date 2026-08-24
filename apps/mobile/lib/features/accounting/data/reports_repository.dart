import '../../../core/api/api_client.dart';
import '../domain/reports.dart';

class AccountingReportsRepository {
  AccountingReportsRepository(this._client);

  final ApiClient _client;

  Future<GeneralLedgerReport> generalLedger(
    String spaceId, {
    required String accountId,
    required String from,
    required String to,
  }) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/accounting/reports/general-ledger', query: {
      'accountId': accountId,
      'from': from,
      'to': to,
    });
    return GeneralLedgerReport.fromJson(data as Map<String, dynamic>);
  }

  Future<TrialBalanceReport> trialBalance(String spaceId, {required String asOf}) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/accounting/reports/trial-balance', query: {'asOf': asOf});
    return TrialBalanceReport.fromJson(data as Map<String, dynamic>);
  }

  Future<IncomeStatementReport> incomeStatement(String spaceId, {required String from, required String to}) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/accounting/reports/income-statement', query: {
      'from': from,
      'to': to,
    });
    return IncomeStatementReport.fromJson(data as Map<String, dynamic>);
  }

  Future<BalanceSheetReport> balanceSheet(String spaceId, {required String asOf}) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/accounting/reports/balance-sheet', query: {'asOf': asOf});
    return BalanceSheetReport.fromJson(data as Map<String, dynamic>);
  }

  Future<CashFlowReport> cashFlow(String spaceId, {required String from, required String to}) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/accounting/reports/cash-flow', query: {
      'from': from,
      'to': to,
    });
    return CashFlowReport.fromJson(data as Map<String, dynamic>);
  }
}
