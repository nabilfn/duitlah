import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/providers.dart';
import '../data/wrapped_repository.dart';
import '../domain/wrapped.dart';

final wrappedRepositoryProvider = Provider(
  (ref) => WrappedRepository(ref.watch(apiClientProvider)),
);

/// Cheap to call on every Home load — the backend never generates anything as a side effect
/// of this endpoint.
final wrappedPromoProvider = FutureProvider.autoDispose<WrappedPromo>(
  (ref) => ref.watch(wrappedRepositoryProvider).promo(),
);

/// Backs the Analytics → "Monthly Stories" list — newest-month-first per the backend contract.
final wrappedHistoryProvider =
    FutureProvider.autoDispose<List<WrappedHistoryItem>>(
      (ref) => ref.watch(wrappedRepositoryProvider).history(),
    );

/// Family key for [wrappedResultProvider] — a plain value type so Riverpod can key the cache
/// by year+month without pulling in a full freezed model for something this small.
class WrappedMonthKey {
  const WrappedMonthKey(this.year, this.month);

  final int year;
  final int month;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WrappedMonthKey && other.year == year && other.month == month);

  @override
  int get hashCode => Object.hash(year, month);

  @override
  String toString() => 'WrappedMonthKey($year-$month)';
}

/// The full story payload for one specific month. `.autoDispose` is deliberate: this can be a
/// large, month-specific payload the user only ever opens a couple of times, not something to
/// keep warm indefinitely across the whole app session.
final wrappedResultProvider = FutureProvider.autoDispose
    .family<WrappedResult, WrappedMonthKey>(
      (ref, key) => ref
          .watch(wrappedRepositoryProvider)
          .result(year: key.year, month: key.month),
    );
