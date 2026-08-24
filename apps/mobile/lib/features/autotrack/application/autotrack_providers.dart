import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/providers.dart';
import '../data/autotrack_repository.dart';
import '../domain/transaction_candidate.dart';

final autoTrackRepositoryProvider =
    Provider((ref) => AutoTrackRepository(ref.watch(apiClientProvider)));

final pendingCandidatesProvider = FutureProvider.autoDispose<List<TransactionCandidate>>(
  (ref) => ref.watch(autoTrackRepositoryProvider).listCandidates(status: CandidateStatus.PENDING),
);

final statementImportsProvider = FutureProvider.autoDispose<List<StatementImport>>(
  (ref) => ref.watch(autoTrackRepositoryProvider).listStatementImports(),
);
