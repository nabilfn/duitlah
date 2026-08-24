import '../../../core/api/api_client.dart';
import '../domain/reconciliation.dart';

/// Phase 7 — Reconciliation. Matches a business bank statement (uploaded
/// here) against the account's existing ledger entries line by line.
class ReconciliationRepository {
  ReconciliationRepository(this._client);

  final ApiClient _client;

  // ---- Statement imports --------------------------------------------------

  Future<BusinessStatementImportResponse> uploadStatement(
    String spaceId, {
    required String businessAccountId,
    required String filePath,
  }) async {
    final data = await _client.uploadFiles(
      '/api/v1/spaces/$spaceId/reconciliation/statement-imports',
      fieldName: 'file',
      filePaths: [filePath],
      query: {'businessAccountId': businessAccountId},
    );
    return BusinessStatementImportResponse.fromJson(data as Map<String, dynamic>);
  }

  Future<List<BusinessStatementImportResponse>> listStatementImports(String spaceId) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/reconciliation/statement-imports') as List;
    return data.map((e) => BusinessStatementImportResponse.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<StatementLineResponse>> listStatementLines(String spaceId, String importId) async {
    final data = await _client.get(
      '/api/v1/spaces/$spaceId/reconciliation/statement-imports/$importId/lines',
    ) as List;
    return data.map((e) => StatementLineResponse.fromJson(e as Map<String, dynamic>)).toList();
  }

  // ---- Matching engine ------------------------------------------------------

  Future<List<MatchSuggestionResponse>> getSuggestions(
    String spaceId,
    String importId,
    String lineId,
  ) async {
    final data = await _client.get(
      '/api/v1/spaces/$spaceId/reconciliation/statement-imports/$importId/lines/$lineId/suggestions',
    ) as List;
    return data.map((e) => MatchSuggestionResponse.fromJson(e as Map<String, dynamic>)).toList();
  }

  // ---- Line-level actions (each only valid while UNMATCHED) ----------------

  Future<StatementLineResponse> matchLine(
    String spaceId,
    String importId,
    String lineId, {
    required String businessAccountEntryId,
  }) async {
    final data = await _client.post(
      '/api/v1/spaces/$spaceId/reconciliation/statement-imports/$importId/lines/$lineId/match',
      data: {'businessAccountEntryId': businessAccountEntryId},
    );
    return StatementLineResponse.fromJson(data as Map<String, dynamic>);
  }

  /// Posts a brand-new ledger entry for exactly this line's date/amount/
  /// description — use when the transaction was never recorded in the books
  /// at all, so nothing exists to [matchLine] against.
  Future<StatementLineResponse> createTransactionForLine(
    String spaceId,
    String importId,
    String lineId,
  ) async {
    final data = await _client.post(
      '/api/v1/spaces/$spaceId/reconciliation/statement-imports/$importId/lines/$lineId/create-transaction',
    );
    return StatementLineResponse.fromJson(data as Map<String, dynamic>);
  }

  /// For a statement line that isn't a real business transaction (a bank's
  /// own marker/note row).
  Future<StatementLineResponse> ignoreLine(
    String spaceId,
    String importId,
    String lineId,
  ) async {
    final data = await _client.post(
      '/api/v1/spaces/$spaceId/reconciliation/statement-imports/$importId/lines/$lineId/ignore',
    );
    return StatementLineResponse.fromJson(data as Map<String, dynamic>);
  }

  /// Divides one lump-sum statement line into several new ledger entries.
  /// [portions] must have at least two entries whose amounts sum to exactly
  /// the line's absolute amount (409 `SPLIT_PORTIONS_DO_NOT_SUM_TO_LINE_AMOUNT`
  /// otherwise) — build the caller's form with a live running total so the
  /// user sees a mismatch before submitting.
  Future<StatementLineResponse> splitLine(
    String spaceId,
    String importId,
    String lineId, {
    required List<SplitPortionInput> portions,
  }) async {
    final data = await _client.post(
      '/api/v1/spaces/$spaceId/reconciliation/statement-imports/$importId/lines/$lineId/split',
      data: {'portions': portions.map((p) => p.toJson()).toList()},
    );
    return StatementLineResponse.fromJson(data as Map<String, dynamic>);
  }

  /// Auto-applies every unambiguous exact match in the import — one button,
  /// same as every other reconciliation action, nothing runs silently in
  /// the background.
  Future<AutoMatchResult> autoMatch(String spaceId, String importId) async {
    final data = await _client.post(
      '/api/v1/spaces/$spaceId/reconciliation/statement-imports/$importId/auto-match',
    );
    return AutoMatchResult.fromJson(data as Map<String, dynamic>);
  }

  // ---- Reconciliation sessions ----------------------------------------------

  Future<List<ReconciliationSessionResponse>> listSessions(String spaceId) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/reconciliation/sessions') as List;
    return data.map((e) => ReconciliationSessionResponse.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<ReconciliationSessionResponse> getSession(String spaceId, String sessionId) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/reconciliation/sessions/$sessionId');
    return ReconciliationSessionResponse.fromJson(data as Map<String, dynamic>);
  }

  Future<ReconciliationSummaryResponse> getSessionSummary(String spaceId, String sessionId) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/reconciliation/sessions/$sessionId/summary');
    return ReconciliationSummaryResponse.fromJson(data as Map<String, dynamic>);
  }

  /// Session-level, not per-line: if there's a non-zero gap between the
  /// (possibly newly-set) statement ending balance and the current ledger
  /// balance, the server posts one adjustment ledger entry for exactly that
  /// gap before completing the session. Omit [statementEndingBalance] to
  /// just re-use whatever was set before.
  Future<ReconciliationSessionResponse> resolveDifference(
    String spaceId,
    String sessionId, {
    String? statementEndingBalance,
    String? description,
  }) async {
    final data = await _client.post(
      '/api/v1/spaces/$spaceId/reconciliation/sessions/$sessionId/resolve-difference',
      data: {
        if (statementEndingBalance != null) 'statementEndingBalance': statementEndingBalance,
        if (description != null) 'description': description,
      },
    );
    return ReconciliationSessionResponse.fromJson(data as Map<String, dynamic>);
  }
}
