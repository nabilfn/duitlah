import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/amount_text.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/balance_card.dart';
import '../../../core/widgets/list_rows.dart';
import '../../accounts/application/finance_providers.dart';
import '../../../core/api/providers.dart';
import '../../auth/application/auth_state.dart';
import '../../insights/application/insights_providers.dart';
import '../../settlements/application/settlements_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardProvider);
    final summary = ref.watch(settlementSummaryProvider);
    final forecast = ref.watch(forecastProvider);
    final authState = ref.watch(authProvider);
    final displayName = authState.maybeWhen(
      authenticated: (user) => user.displayName.split(' ').first,
      orElse: () => '',
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(displayName.isEmpty ? 'Duitlah' : 'Hi, $displayName'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push(AppRoutes.profile),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(dashboardProvider);
          ref.invalidate(settlementSummaryProvider);
          ref.invalidate(forecastProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            dashboard.when(
              data: (data) => BalanceCard(label: 'Available balance', amount: data.availableBalance),
              loading: () => const SizedBox(height: 140, child: LoadingView()),
              error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(dashboardProvider)),
            ),
            const SizedBox(height: AppSpacing.lg),
            dashboard.maybeWhen(
              data: (data) => Row(
                children: [
                  Expanded(
                    child: _MiniStat(label: 'This month in', amount: data.monthIncome, tone: AmountTone.positive),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _MiniStat(label: 'This month out', amount: data.monthExpense, tone: AmountTone.negative),
                  ),
                ],
              ),
              orElse: () => const SizedBox.shrink(),
            ),
            const SizedBox(height: AppSpacing.xl),
            summary.maybeWhen(
              data: (s) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    children: [
                      Expanded(
                        child: _MiniStat(label: "You're owed", amount: s.totalOwedToMe, tone: AmountTone.positive),
                      ),
                      Expanded(
                        child: _MiniStat(label: 'You owe', amount: s.totalIOwe, tone: AmountTone.negative),
                      ),
                    ],
                  ),
                ),
              ),
              orElse: () => const SizedBox.shrink(),
            ),
            const SizedBox(height: AppSpacing.xl),
            forecast.maybeWhen(
              data: (f) => InkWell(
                borderRadius: BorderRadius.circular(AppRadius.md),
                onTap: () => context.push(AppRoutes.insights),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Projected ${f.targetDate}', style: Theme.of(context).textTheme.bodySmall),
                            AmountText(f.projectedBalance, tone: AmountTone.auto, style: Theme.of(context).textTheme.titleLarge),
                          ],
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),
              ),
              orElse: () => const SizedBox.shrink(),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Recent transactions', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            dashboard.when(
              data: (data) => data.recentTransactions.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                      child: EmptyView(icon: Icons.receipt_long_outlined, title: 'No transactions yet'),
                    )
                  : Column(
                      children: data.recentTransactions
                          .map((t) => MoneyRow(
                                title: t.merchant ?? t.description ?? t.type.name,
                                subtitle: t.occurredOn,
                                amount: t.amount,
                                tone: t.direction.name == 'IN' ? AmountTone.positive : AmountTone.negative,
                                leadingIcon: t.direction.name == 'IN'
                                    ? Icons.arrow_downward_rounded
                                    : Icons.arrow_upward_rounded,
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

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.amount, required this.tone});

  final String label;
  final String amount;
  final AmountTone tone;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        AmountText(amount, tone: tone, style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }
}
