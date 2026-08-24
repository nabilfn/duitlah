import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/amount_text.dart';
import '../../../core/widgets/app_state_views.dart';
import '../application/insights_providers.dart';
import '../domain/insights.dart';

/// A financial calendar (master spec section 38): confirmed transactions and
/// projected recurring occurrences for the selected month, grouped by day.
/// Deliberately a day-by-day list rather than a full month grid — with
/// multiple entries possible per day, a list reads better on a phone width
/// than cramming amounts into small grid cells.
class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = ref.watch(selectedInsightsMonthProvider);
    final entries = ref.watch(calendarProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => ref.read(selectedInsightsMonthProvider.notifier).state =
                DateTime(month.year, month.month - 1),
          ),
          Center(child: Text('${month.year}-${month.month.toString().padLeft(2, '0')}')),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => ref.read(selectedInsightsMonthProvider.notifier).state =
                DateTime(month.year, month.month + 1),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(calendarProvider),
        child: entries.when(
          data: (list) {
            if (list.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(height: 80),
                  EmptyView(icon: Icons.calendar_today_outlined, title: 'Nothing scheduled this month'),
                ],
              );
            }
            final byDay = <String, List<CalendarEntry>>{};
            for (final entry in list) {
              byDay.putIfAbsent(entry.date, () => []).add(entry);
            }
            final days = byDay.keys.toList()..sort();
            return ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: days.length,
              itemBuilder: (context, index) {
                final date = days[index];
                final dayEntries = byDay[date]!;
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(date, style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(height: 4),
                      ...dayEntries.map((e) => _CalendarEntryTile(entry: e)),
                    ],
                  ),
                );
              },
            );
          },
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(calendarProvider)),
        ),
      ),
    );
  }
}

class _CalendarEntryTile extends StatelessWidget {
  const _CalendarEntryTile({required this.entry});

  final CalendarEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIncome = entry.direction.name == 'IN';
    return Card(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        dense: true,
        leading: Icon(
          entry.confirmed ? Icons.check_circle_outline : Icons.schedule_outlined,
          size: 20,
          color: entry.confirmed ? theme.colorScheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.4),
        ),
        title: Text(entry.merchant ?? entry.description ?? entry.type.name),
        subtitle: Text(entry.confirmed ? 'Posted' : 'Upcoming'),
        trailing: AmountText(entry.amount, tone: isIncome ? AmountTone.positive : AmountTone.negative),
      ),
    );
  }
}
