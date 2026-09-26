import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/providers.dart';
import '../data/bagilah_repository.dart';
import '../data/guest_bagilah_repository.dart';
import '../data/guest_session_store.dart';
import '../domain/bill.dart';

final bagilahRepositoryProvider =
    Provider((ref) => BagilahRepository(ref.watch(apiClientProvider)));

final guestBagilahRepositoryProvider = Provider((ref) => GuestBagilahRepository());

final guestSessionStoreProvider =
    Provider((ref) => GuestSessionStore(ref.watch(secureStorageProvider)));

final billListProvider = FutureProvider.autoDispose<List<Bill>>(
  (ref) => ref.watch(bagilahRepositoryProvider).listBills(),
);

final billDetailProvider = FutureProvider.autoDispose.family<Bill, String>(
  (ref, billId) => ref.watch(bagilahRepositoryProvider).getBill(billId),
);

final billItemsProvider = FutureProvider.autoDispose.family<List<ReceiptItem>, String>(
  (ref, billId) => ref.watch(bagilahRepositoryProvider).getItems(billId),
);

final billParticipantsProvider = FutureProvider.autoDispose.family<List<Participant>, String>(
  (ref, billId) => ref.watch(bagilahRepositoryProvider).getParticipants(billId),
);

/// Keyed by "billId:itemId" — a claims list belongs to one specific item.
final billItemClaimsProvider =
    FutureProvider.autoDispose.family<List<Claim>, (String billId, String itemId)>(
  (ref, key) => ref.watch(bagilahRepositoryProvider).getClaims(key.$1, key.$2),
);

final billBreakdownProvider = FutureProvider.autoDispose.family<Breakdown, String>(
  (ref, billId) => ref.watch(bagilahRepositoryProvider).getBreakdown(billId),
);

final billBalancesProvider = FutureProvider.autoDispose.family<List<BillBalance>, String>(
  (ref, billId) => ref.watch(bagilahRepositoryProvider).getBalances(billId),
);

/// Who actually paid the merchant, as recorded so far. `finalizeBill` rejects
/// a bill with no payments (`NO_PAYMENTS_RECORDED`) or with payments that
/// don't add up to the total (`PAYMENTS_DONT_MATCH_TOTAL`), so this has to be
/// captured before a draft can be closed.
final billPaymentsProvider = FutureProvider.autoDispose.family<List<BillPayment>, String>(
  (ref, billId) => ref.watch(bagilahRepositoryProvider).getPayments(billId),
);

final guestBillDetailProvider = FutureProvider.autoDispose.family<Bill, String>(
  (ref, guestToken) => ref.watch(guestBagilahRepositoryProvider).getBill(guestToken),
);

final guestBillItemsProvider = FutureProvider.autoDispose.family<List<ReceiptItem>, String>(
  (ref, guestToken) => ref.watch(guestBagilahRepositoryProvider).getItems(guestToken),
);

final guestBillParticipantsProvider = FutureProvider.autoDispose.family<List<Participant>, String>(
  (ref, guestToken) => ref.watch(guestBagilahRepositoryProvider).getParticipants(guestToken),
);

final guestBillItemClaimsProvider =
    FutureProvider.autoDispose.family<List<Claim>, (String guestToken, String itemId)>(
  (ref, key) => ref.watch(guestBagilahRepositoryProvider).getClaims(key.$1, key.$2),
);

final guestBreakdownProvider = FutureProvider.autoDispose.family<Breakdown, String>(
  (ref, guestToken) => ref.watch(guestBagilahRepositoryProvider).getBreakdown(guestToken),
);
