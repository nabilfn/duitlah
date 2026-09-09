import 'package:duitlah_mobile/core/theme/duitlah_colors.dart';
import 'package:duitlah_mobile/core/widgets/duitlah_segmented_control.dart';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/amount_text.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/duitlah_icon.dart';
import '../../../core/widgets/financial_surfaces.dart';
import '../../networth/application/net_worth_providers.dart';
import '../application/insights_providers.dart';
import '../domain/insights.dart';

class InsightsScreen extends ConsumerStatefulWidget {
  const InsightsScreen({super.key});
  @override
  ConsumerState<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends ConsumerState<InsightsScreen> {
  int _tab = 0;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final month = ref.watch(selectedInsightsMonthProvider);
    final categories = ref.watch(spendingByCategoryProvider);
    final trend = ref.watch(monthlyTrendProvider);
    final merchants = ref.watch(topMerchantsProvider);
    final forecast = ref.watch(forecastProvider);
    final netWorth = ref.watch(netWorthProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(spendingByCategoryProvider);
          ref.invalidate(monthlyTrendProvider);
          ref.invalidate(topMerchantsProvider);
          ref.invalidate(netWorthProvider);
          ref.invalidate(forecastProvider);
            await ref.read(forecastProvider.future);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            DuitlahSegmentedControl<int>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(value: 0, label: Text('Expenses')),
                ButtonSegment(value: 1, label: Text('Income')),
                ButtonSegment(value: 2, label: Text('Net worth')),
              ],
              selected: {_tab},
              onSelectionChanged: (s) => setState(() => _tab = s.first),
            ),
            const SizedBox(height: 16),
            if (_tab != 2)
              Row(
                children: [
                  IconButton(
                    tooltip: 'Previous month',
                    onPressed: () =>
                        ref.read(selectedInsightsMonthProvider.notifier).state =
                            DateTime(month.year, month.month - 1),
                    icon: const DuitlahIcon(Icons.chevron_left, size: 18),
                  ),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final selected = await showDatePicker(
                          context: context,
                          initialDate: month,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(DateTime.now().year + 1),
                        );
                        if (selected != null) {
                          ref
                              .read(selectedInsightsMonthProvider.notifier)
                              .state = DateTime(
                            selected.year,
                            selected.month,
                          );
                        }
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(DateFormat('MMMM yyyy').format(month)),
                          ),
                          const DuitlahIcon(
                            Icons.calendar_month_outlined,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Next month',
                    onPressed: () =>
                        ref.read(selectedInsightsMonthProvider.notifier).state =
                            DateTime(month.year, month.month + 1),
                    icon: const DuitlahIcon(Icons.chevron_right, size: 18),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            if (_tab == 0)
              categories.when(
                data: (list) => list.isEmpty
                    ? const EmptyView(
                        icon: Icons.pie_chart_outline,
                        title: 'No spending this month',
                        message: 'Your expense categories will appear here as you record transactions.',
                      )
                    : SpendingDonut(items: list),
                loading: () => const LoadingView(),
                error: (e, _) => ErrorView(
                  error: e,
                  onRetry: () => ref.invalidate(spendingByCategoryProvider),
                ),
              ),
            if (_tab == 1)
              trend.when(
                data: (list) {
                  final selected = list
                      .where(
                        (t) => t.year == month.year && t.month == month.month,
                      )
                      .firstOrNull;
                  return selected == null
                      ? const EmptyView(
                          icon: Icons.calendar_month_outlined,
                          title: 'No income trend for this month',
                          message: 'The income trend covers the most recent six months.',
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Column(
                            children: [
                              Text(
                                'Total income',
                                style: theme.textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 8),
                              AmountText(
                                selected.income,
                                tone: AmountTone.positive,
                                style: theme.textTheme.displaySmall,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                DateFormat('MMMM yyyy').format(month),
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        );
                },
                loading: () => const LoadingView(),
                error: (e, _) => ErrorView(
                  error: e,
                  onRetry: () => ref.invalidate(monthlyTrendProvider),
                ),
              ),
            if (_tab == 2)
              netWorth.when(
                data: (nw) => Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Current net worth',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    AmountText(
                      nw.netWorth,
                      style: theme.textTheme.displaySmall,
                    ),
                    const SizedBox(height: 24),
                    FinancialModule(
                      title: 'Assets',
                      subtitle: Money.format(nw.totalAssets),
                      icon: Icons.account_balance_outlined,
                      onTap: () => context.push(AppRoutes.netWorth),
                    ),
                    const SizedBox(height: 10),
                    FinancialModule(
                      title: 'Liabilities',
                      subtitle: Money.format(nw.totalLiabilities),
                      icon: Icons.credit_card,
                      onTap: () => context.push(AppRoutes.liabilities),
                    ),
                    TextButton(
                      onPressed: () => context.push(AppRoutes.netWorth),
                      child: const Text('Manage net worth & snapshots'),
                    ),
                  ],
                ),
                loading: () => const LoadingView(),
                error: (e, _) => ErrorView(
                  error: e,
                  onRetry: () => ref.invalidate(netWorthProvider),
                ),
              ),
            const SizedBox(height: 24),
            FinancialModule(
              title: 'Make your next month count',
              subtitle: 'Set a budget that works for you.',
              icon: Icons.insights_outlined,
              onTap: () => context.push(AppRoutes.budgets),
            ),
            const SizedBox(height: 24),
            const SectionHeader('Cash-flow forecast'),
            const SizedBox(height: 12),
            forecast.when(
              data: (f) => _ForecastCard(forecast: f),
              loading: () => const LoadingView(),
              error: (e, _) => ErrorView(
                error: e,
                onRetry: () => ref.invalidate(forecastProvider),
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader('6-month trend'),
            const SizedBox(height: 8),
            const Text('Income on the left · expenses on the right'),
            const SizedBox(height: 12),
            trend.when(
              data: (list) => list.isEmpty
                  ? const EmptyView(
                      icon: Icons.insights_outlined,
                      title: 'No trend yet',
                    )
                  : _MonthlyTrendChart(trend: list),
              loading: () => const LoadingView(),
              error: (e, _) => ErrorView(
                error: e,
                onRetry: () => ref.invalidate(monthlyTrendProvider),
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader('Top merchants'),
            const SizedBox(height: 8),
            merchants.when(
              data: (list) => list.isEmpty
                  ? const EmptyView(
                      icon: Icons.storefront_outlined,
                      title: 'No merchants this month',
                    )
                  : Column(
                      children: list
                          .take(10)
                          .map(
                            (m) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(m.merchant),
                              subtitle: Text(
                                '${m.transactionCount} transactions',
                              ),
                              trailing: AmountText(
                                m.amount,
                                style: theme.textTheme.titleSmall,
                              ),
                            ),
                          )
                          .toList(),
                    ),
              loading: () => const LoadingView(),
              error: (e, _) => ErrorView(
                error: e,
                onRetry: () => ref.invalidate(topMerchantsProvider),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Display-only category proportions. Never used to create or edit a balance.
class SpendingDonut extends StatefulWidget {
  const SpendingDonut({super.key, required this.items});
  final List<CategorySpending> items;
  @override
  State<SpendingDonut> createState() => _SpendingDonutState();
}

class _SpendingDonutState extends State<SpendingDonut> {
  int? _selected;
  @override
  Widget build(BuildContext context) {
    final palette = DuitlahColors.participants;
    final amounts = widget.items
        .map(
          (i) => (double.tryParse(i.amount) ?? 0).clamp(0.0, double.infinity),
        )
        .toList();
    final total = amounts.fold<double>(0, (a, b) => a + b);
    final selected = _selected != null && _selected! < widget.items.length
        ? _selected
        : null;
    final theme = Theme.of(context);
    return Column(
      children: [
        SizedBox(
          height: 238,
          child: Center(
            child: SizedBox.square(
              dimension: 220,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _DonutPainter(amounts, palette, selected),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(45),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          Money.format(
                            selected == null
                                ? total.toStringAsFixed(2)
                                : widget.items[selected].amount,
                          ),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          selected == null
                              ? 'Total expenses'
                              : widget.items[selected].categoryName,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        for (var i = 0; i < widget.items.length; i++)
          InkWell(
            onTap: () => setState(() => _selected = _selected == i ? null : i),
            borderRadius: BorderRadius.circular(10),
            child: Semantics(
              selected: _selected == i,
              button: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 4,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: palette[i % palette.length],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 5,
                      child: Text(
                        widget.items[i].categoryName,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      total == 0
                          ? '0%'
                          : '${(amounts[i] / total * 100).round()}%',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      flex: 4,
                      child: Text(
                        Money.format(widget.items[i].amount),
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  const _DonutPainter(this.amounts, this.colors, this.selected);
  final List<double> amounts;
  final List<Color> colors;
  final int? selected;
  @override
  void paint(Canvas canvas, Size size) {
    final total = amounts.fold<double>(0, (a, b) => a + b);
    final rect = Rect.fromLTWH(16, 16, size.width - 32, size.height - 32);
    final pen = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30;
    if (total <= 0) {
      pen.color = colors.last;
      canvas.drawOval(rect, pen);
      return;
    }
    var start = -math.pi / 2;
    for (var i = 0; i < amounts.length; i++) {
      final sweep = amounts[i] / total * math.pi * 2;
      pen.color = colors[i % colors.length].withValues(
        alpha: selected == null || selected == i ? 1 : .35,
      );
      canvas.drawArc(rect, start, sweep, false, pen);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter oldDelegate) =>
      oldDelegate.amounts != amounts || oldDelegate.selected != selected;
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
            Wrap(
              spacing: 24,
              runSpacing: 16,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Today', style: theme.textTheme.bodySmall),
                    AmountText(
                      forecast.currentBalance,
                      style: theme.textTheme.titleLarge,
                    ),
                  ],
                ),
                const DuitlahIcon(Icons.arrow_forward_rounded),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Projected ${forecast.targetDate}',
                      style: theme.textTheme.bodySmall,
                    ),
                    AmountText(
                      forecast.projectedBalance,
                      tone: AmountTone.auto,
                      style: theme.textTheme.titleLarge,
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: AppSpacing.xl),
            Wrap(
              spacing: 24,
              runSpacing: 16,
              children: [
                _MiniAmount(
                  label: 'Scheduled in',
                  amount: forecast.scheduledIncome,
                  tone: AmountTone.positive,
                ),
                _MiniAmount(
                  label: 'Scheduled out',
                  amount: forecast.scheduledExpense,
                  tone: AmountTone.negative,
                ),
                _MiniAmount(
                  label: 'Predicted spend',
                  amount: forecast.predictedVariableExpense,
                  tone: AmountTone.negative,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              forecast.disclaimer,
              style: theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniAmount extends StatelessWidget {
  const _MiniAmount({
    required this.label,
    required this.amount,
    required this.tone,
  });

  final String label;
  final String amount;
  final AmountTone tone;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 2),
        AmountText(
          amount,
          tone: tone,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
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
        .expand(
          (t) => [
            double.tryParse(t.income) ?? 0,
            double.tryParse(t.expense) ?? 0,
          ],
        )
        .fold<double>(1, (a, b) => a > b ? a : b);

    return SizedBox(
      height: 160,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: trend.map((t) {
          final income = double.tryParse(t.income) ?? 0;
          final expense = double.tryParse(t.expense) ?? 0;
          return Tooltip(
            triggerMode: TooltipTriggerMode.tap,
            message: '${t.month}: Income ${t.income}, expenses ${t.expense}',
            child: Semantics(
              label: '${t.month}: Income ${t.income}, expenses ${t.expense}',
              child: Column(
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
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
