import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/amount_text.dart';
import '../../../core/widgets/app_state_views.dart';
import '../application/insights_providers.dart';
import '../domain/insights.dart';

/// Advanced analytics beyond the home dashboard's single-month snapshot:
/// category breakdown, month-over-month trend, top merchants, and a
/// cash-flow forecast — all read-only, computed entirely server-side
/// (docs/architecture.md's Mobile section: no client-side financial math).
class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = ref.watch(selectedInsightsMonthProvider);
    final categorySpending = ref.watch(spendingByCategoryProvider);
    final trend = ref.watch(monthlyTrendProvider);
    final merchants = ref.watch(topMerchantsProvider);
    final forecast = ref.watch(forecastProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights'),
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
        onRefresh: () async {
          ref.invalidate(spendingByCategoryProvider);
          ref.invalidate(monthlyTrendProvider);
          ref.invalidate(topMerchantsProvider);
          ref.invalidate(forecastProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text('Cash-flow forecast', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            forecast.when(
              data: (f) => _ForecastCard(forecast: f),
              loading: () => const LoadingView(),
              error: (e, _) => ErrorView(error: e),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Spending by category', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            categorySpending.when(
              data: (list) => list.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                      child: EmptyView(icon: Icons.pie_chart_outline, title: 'No spending this month'),
                    )
                  : _CategoryBreakdown(items: list),
              loading: () => const LoadingView(),
              error: (e, _) => ErrorView(error: e),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('6-month trend', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            trend.when(
              data: (list) => _MonthlyTrendChart(trend: list),
              loading: () => const LoadingView(),
              error: (e, _) => ErrorView(error: e),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Top merchants', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            merchants.when(
              data: (list) => list.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                      child: EmptyView(icon: Icons.storefront_outlined, title: 'No merchants this month'),
                    )
                  : Column(
                      children: list
                          .take(10)
                          .map((m) => ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(m.merchant),
                                subtitle: Text('${m.transactionCount} transaction(s)'),
                                trailing: AmountText(m.amount, tone: AmountTone.negative),
                              ))
                          .toList(),
                    ),
              loading: () => const LoadingView(),
              error: (e, _) => ErrorView(error: e),
            ),
          ],
        ),
      ),
    );
  }
}

class _ForecastCard extends StatelessWidget {
  const _ForecastCard({required this.forecast});

  final Forecast forecast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Today', style: theme.textTheme.bodySmall),
                    AmountText(forecast.currentBalance, style: theme.textTheme.titleLarge),
                  ],
                ),
                const Icon(Icons.arrow_forward_rounded),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Projected ${forecast.targetDate}', style: theme.textTheme.bodySmall),
                    AmountText(forecast.projectedBalance, tone: AmountTone.auto, style: theme.textTheme.titleLarge),
                  ],
                ),
              ],
            ),
            const Divider(height: AppSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _MiniAmount(label: 'Scheduled in', amount: forecast.scheduledIncome, tone: AmountTone.positive),
                _MiniAmount(label: 'Scheduled out', amount: forecast.scheduledExpense, tone: AmountTone.negative),
                _MiniAmount(label: 'Predicted spend', amount: forecast.predictedVariableExpense, tone: AmountTone.negative),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              forecast.disclaimer,
              style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniAmount extends StatelessWidget {
  const _MiniAmount({required this.label, required this.amount, required this.tone});

  final String label;
  final String amount;
  final AmountTone tone;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 2),
        AmountText(amount, tone: tone, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class _CategoryBreakdown extends StatelessWidget {
  const _CategoryBreakdown({required this.items});

  final List<CategorySpending> items;

  @override
  Widget build(BuildContext context) {
    final maxAmount = items
        .map((i) => double.tryParse(i.amount) ?? 0)
        .fold<double>(0, (a, b) => a > b ? a : b);
    final theme = Theme.of(context);
    return Column(
      children: items.map((item) {
        final value = double.tryParse(item.amount) ?? 0;
        final fraction = maxAmount == 0 ? 0.0 : (value / maxAmount).clamp(0.0, 1.0);
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.categoryName, style: theme.textTheme.bodyMedium),
                  AmountText(item.amount, style: theme.textTheme.bodyMedium),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: fraction,
                  minHeight: 6,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _MonthlyTrendChart extends StatelessWidget {
  const _MonthlyTrendChart({required this.trend});

  final List<MonthlyTrend> trend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = context.semanticColors;
    final maxValue = trend
        .expand((t) => [double.tryParse(t.income) ?? 0, double.tryParse(t.expense) ?? 0])
        .fold<double>(1, (a, b) => a > b ? a : b);

    return SizedBox(
      height: 160,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: trend.map((t) {
          final income = double.tryParse(t.income) ?? 0;
          final expense = double.tryParse(t.expense) ?? 0;
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 110 * (income / maxValue).clamp(0.0, 1.0),
                    color: semantic.success,
                  ),
                  const SizedBox(width: 3),
                  Container(
                    width: 10,
                    height: 110 * (expense / maxValue).clamp(0.0, 1.0),
                    color: theme.colorScheme.error,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text('${t.month}', style: theme.textTheme.bodySmall),
            ],
          );
        }).toList(),
      ),
    );
  }
}
