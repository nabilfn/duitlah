import '../../../core/api/api_client.dart';
import '../../accounts/domain/finance.dart' show TransactionType;
import '../domain/transaction_candidate.dart';

/// Duitlah AutoTrack (V2 Phase 2): review, confirm, reject, or resolve-as-
/// duplicate the suggestions statement import and the Receipt Vault
/// produce. Confirming never re-sends what the candidate already detected —
/// same "the review form's current values are independent of the original
/// parse" discipline as `ReceiptScanRepository.confirm`.
class AutoTrackRepository {
  AutoTrackRepository(this._client);

  final ApiClient _client;

  Future<List<TransactionCandidate>> listCandidates({CandidateStatus? status}) async {
    final data = await _client.get(
      '/api/v1/autotrack/candidates',
      query: {if (status != null) 'status': status.name},
    ) as List;
    return data.map((e) => TransactionCandidate.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<TransactionCandidate> getCandidate(String candidateId) async {
    final data = await _client.get('/api/v1/autotrack/candidates/$candidateId');
    return TransactionCandidate.fromJson(data as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> confirmCandidate(
    String candidateId, {
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
      '/api/v1/autotrack/candidates/$candidateId/confirm',
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
    return data as Map<String, dynamic>;
  }

  Future<void> rejectCandidate(String candidateId) =>
      _client.post('/api/v1/autotrack/candidates/$candidateId/reject');

  /// "This is already the same transaction" — the spec's own "Merge" action
  /// for a flagged possible duplicate.
  Future<void> mergeCandidate(String candidateId) =>
      _client.post('/api/v1/autotrack/candidates/$candidateId/merge');

  Future<StatementImport> uploadStatement({
    required String accountId,
    required String filePath,
  }) async {
    final data = await _client.uploadFiles(
      '/api/v1/statement-imports',
      fieldName: 'file',
      filePaths: [filePath],
      query: {'accountId': accountId},
    );
    return StatementImport.fromJson(data as Map<String, dynamic>);
  }

  Future<List<StatementImport>> listStatementImports() async {
    final data = await _client.get('/api/v1/statement-imports') as List;
    return data.map((e) => StatementImport.fromJson(e as Map<String, dynamic>)).toList();
  }
}
