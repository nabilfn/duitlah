import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/providers.dart';
import '../data/reconciliation_repository.dart';
import '../domain/reconciliation.dart';

/// A resource scoped to a space plus a session id (getting/summarizing one
/// reconciliation session, or resolving its difference).
typedef SpaceSessionKey = ({String spaceId, String sessionId});

/// A resource scoped to a space plus a statement import id (listing that
/// import's lines).
typedef SpaceImportKey = ({String spaceId, String importId});

/// A single statement line within one import — the key every line-level
/// action (match/create-transaction/ignore/split) and its suggestions list
/// is addressed by.
typedef SpaceImportLineKey = ({String spaceId, String importId, String lineId});

// ---- Repository -------------------------------------------------------------

final reconciliationRepositoryProvider =
    Provider((ref) => ReconciliationRepository(ref.watch(apiClientProvider)));

// ---- Statement imports -------------------------------------------------------

final statementImportListProvider =
    FutureProvider.autoDispose.family<List<BusinessStatementImportResponse>, String>(
  (ref, spaceId) => ref.watch(reconciliationRepositoryProvider).listStatementImports(spaceId),
);

final statementLinesProvider = FutureProvider.autoDispose.family<List<StatementLineResponse>, SpaceImportKey>(
  (ref, key) => ref.watch(reconciliationRepositoryProvider).listStatementLines(key.spaceId, key.importId),
);

// ---- Matching engine ----------------------------------------------------------

final matchSuggestionsProvider =
    FutureProvider.autoDispose.family<List<MatchSuggestionResponse>, SpaceImportLineKey>(
  (ref, key) =>
      ref.watch(reconciliationRepositoryProvider).getSuggestions(key.spaceId, key.importId, key.lineId),
);

// ---- Reconciliation sessions --------------------------------------------------

final reconciliationSessionListProvider =
    FutureProvider.autoDispose.family<List<ReconciliationSessionResponse>, String>(
  (ref, spaceId) => ref.watch(reconciliationRepositoryProvider).listSessions(spaceId),
);

final reconciliationSessionProvider =
    FutureProvider.autoDispose.family<ReconciliationSessionResponse, SpaceSessionKey>(
  (ref, key) => ref.watch(reconciliationRepositoryProvider).getSession(key.spaceId, key.sessionId),
);

final reconciliationSummaryProvider =
    FutureProvider.autoDispose.family<ReconciliationSummaryResponse, SpaceSessionKey>(
  (ref, key) => ref.watch(reconciliationRepositoryProvider).getSessionSummary(key.spaceId, key.sessionId),
);
