import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/providers.dart';
import '../data/receipt_vault_repository.dart';
import '../domain/vault_receipt.dart';

final receiptVaultRepositoryProvider =
    Provider((ref) => ReceiptVaultRepository(ref.watch(apiClientProvider)));

/// Null = no merchant filter applied. Set from the vault screen's search
/// field; the list provider below watches it so submitting a search term
/// re-fetches automatically.
final receiptSearchQueryProvider = StateProvider.autoDispose<String?>((ref) => null);

final receiptVaultListProvider = FutureProvider.autoDispose<List<VaultReceipt>>(
  (ref) => ref
      .watch(receiptVaultRepositoryProvider)
      .search(merchant: ref.watch(receiptSearchQueryProvider)),
);

final receiptMatchSuggestionsProvider =
    FutureProvider.autoDispose.family<List<ReceiptMatchSuggestion>, String>(
  (ref, receiptId) => ref.watch(receiptVaultRepositoryProvider).suggestTransactionMatches(receiptId),
);
