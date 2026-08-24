import '../../../core/api/api_client.dart';
import '../domain/journal_entries.dart';

class JournalEntriesRepository {
  JournalEntriesRepository(this._client);

  final ApiClient _client;

  Future<List<JournalEntry>> list(String spaceId, {required String from, required String to}) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/accounting/journal-entries', query: {
      'from': from,
      'to': to,
    }) as List;
    return data.map((e) => JournalEntry.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<JournalEntry> getEntry(String spaceId, String entryId) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/accounting/journal-entries/$entryId');
    return JournalEntry.fromJson(data as Map<String, dynamic>);
  }

  /// Errors with `409 JOURNAL_ENTRY_NOT_BALANCED` (total debits != total
  /// credits), `409 ACCOUNTING_PERIOD_CLOSED`, or `409 LEDGER_ACCOUNT_ARCHIVED`.
  Future<JournalEntry> create(
    String spaceId, {
    required String entryDate,
    required String description,
    required List<JournalEntryLineInput> lines,
  }) async {
    final data = await _client.post('/api/v1/spaces/$spaceId/accounting/journal-entries', data: {
      'entryDate': entryDate,
      'description': description,
      'lines': lines.map((l) => l.toJson()).toList(),
    });
    return JournalEntry.fromJson(data as Map<String, dynamic>);
  }
}
