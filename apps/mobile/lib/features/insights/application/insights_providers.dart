import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/providers.dart';
import '../data/insights_repository.dart';
import '../domain/insights.dart';

final insightsRepositoryProvider = Provider((ref) => InsightsRepository(ref.watch(apiClientProvider)));

/// The month currently shown by the Insights/Calendar screens — defaults to
/// the current month, changed via the month-picker controls.
final selectedInsightsMonthProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month);
});

final spendingByCategoryProvider = FutureProvider.autoDispose<List<CategorySpending>>((ref) {
  final month = ref.watch(selectedInsightsMonthProvider);
  return ref.watch(insightsRepositoryProvider).spendingByCategory(year: month.year, month: month.month);
});

final monthlyTrendProvider = FutureProvider.autoDispose<List<MonthlyTrend>>(
  (ref) => ref.watch(insightsRepositoryProvider).monthlyTrend(),
);

final topMerchantsProvider = FutureProvider.autoDispose<List<MerchantSpending>>((ref) {
  final month = ref.watch(selectedInsightsMonthProvider);
  return ref.watch(insightsRepositoryProvider).topMerchants(year: month.year, month: month.month);
});

final calendarProvider = FutureProvider.autoDispose<List<CalendarEntry>>((ref) {
  final month = ref.watch(selectedInsightsMonthProvider);
  return ref.watch(insightsRepositoryProvider).calendar(year: month.year, month: month.month);
});

final forecastProvider = FutureProvider.autoDispose<Forecast>(
  (ref) => ref.watch(insightsRepositoryProvider).forecast(),
);
