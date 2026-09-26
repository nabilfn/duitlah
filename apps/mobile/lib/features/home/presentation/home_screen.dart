import 'package:flutter/material.dart';

import '../../../core/widgets/dock_insets.dart';
import '../../../core/widgets/editorial_surfaces.dart';
import '../../../core/widgets/glass_account_selector.dart';
import '../../../core/theme/glass_tokens.dart';

import '../../../core/widgets/duitlah_icon.dart';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/api/providers.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/duitlah_colors.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/digital_canvas.dart';
import '../../../core/widgets/financial_surfaces.dart';
import '../../../core/widgets/transaction_row.dart';
import '../../accounts/application/finance_providers.dart';
import '../../accounts/domain/finance.dart';
import '../../auth/application/auth_state.dart';
import '../../budgets/application/budgets_providers.dart';
import '../../insights/application/insights_providers.dart';
import '../../insights/domain/insights.dart';
import '../../settlements/application/settlements_providers.dart';
import '../../transactions/presentation/transaction_form_sheet.dart';
import '../../wrapped/presentation/widgets/wrapped_promo_card.dart';
import 'budget_trajectory.dart';

/// Home always tells the current-month story, independently of Analytics' filter.
final homeSpendingProvider = FutureProvider.autoDispose<List<CategorySpending>>(
  (ref) {
    final now = DateTime.now();
    return ref
        .watch(insightsRepositoryProvider)
        .spendingByCategory(year: now.year, month: now.month);
  },
);

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _showBalance = true;
  final _scroll = ScrollController();
  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.duitlahColors;
    final dashboard = ref.watch(dashboardProvider);
    final summary = ref.watch(settlementSummaryProvider);
    final auth = ref.watch(authProvider);
    final name = auth is AuthAuthenticated
        ? auth.user.displayName.trim().split(' ').first
        : '';
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Morning'
        : hour < 18
        ? 'Afternoon'
        : 'Evening';
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: theme.brightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(settlementSummaryProvider);
              ref.invalidate(budgetListProvider);
              ref.invalidate(homeSpendingProvider);
              ref.invalidate(dashboardProvider);
              await ref.read(dashboardProvider.future);
            },
            child: CustomScrollView(
              controller: _scroll,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    24,
                    18,
                    24,
                    32 + DuitlahDockInsets.of(context),
                  ),
                  sliver: SliverList.list(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              DateFormat('d MMMM').format(DateTime.now()),
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                          const GlassAccountSelector(),
                          IconButton(
                            tooltip: 'Notifications',
                            onPressed: () =>
                                context.push(AppRoutes.notifications),
                            icon: const DuitlahIcon(
                              Icons.notifications_outlined,
                              size: 21,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      DuitlahReveal(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name.isEmpty ? '$greeting.' : '$greeting, $name.',
                              style: theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Your money,\nat ease.',
                              style: theme.textTheme.displaySmall?.copyWith(
                                height: 1.12,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () => context.push(AppRoutes.more),
                              child: const Text('Find a tool  ↗'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      dashboard.when(
                        data: (data) => AnimatedBuilder(
                          animation: _scroll,
                          child: _FinancialCanvas(
                            data: data,
                            visible: _showBalance,
                            onVisibility: () {
                              HapticFeedback.selectionClick();
                              setState(() => _showBalance = !_showBalance);
                            },
                          ),
                          builder: (context, child) => Transform.translate(
                            offset: Offset(
                              0,
                              MediaQuery.disableAnimationsOf(context) ||
                                      !_scroll.hasClients
                                  ? 0
                                  : (_scroll.offset * .015).clamp(0, 3),
                            ),
                            child: child,
                          ),
                        ),
                        loading: () => const Padding(
                          padding: EdgeInsets.symmetric(vertical: 36),
                          child: LoadingView(),
                        ),
                        error: (e, _) => ErrorView(
                          error: e,
                          onRetry: () => ref.invalidate(dashboardProvider),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const _HomeCommands(),
                      const SizedBox(height: 44),
                      Text(
                        'THIS MONTH',
                        style: theme.textTheme.labelMedium?.copyWith(
                          letterSpacing: 1.8,
                        ),
                      ),
                      BudgetTrajectory(showAmounts: _showBalance),
                      dashboard.maybeWhen(
                        data: (data) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _showBalance
                                    ? Money.format(data.monthExpense)
                                    : '••••',
                                style: theme.textTheme.headlineMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'spent across your accounts',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        orElse: () => const SizedBox.shrink(),
                      ),
                      SectionHeader(
                        "Where it's going",
                        action: 'Analytics',
                        onAction: () => context.go(AppRoutes.insights),
                      ),
                      ref
                          .watch(homeSpendingProvider)
                          .when(
                            data: (items) => items.isEmpty
                                ? const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    child: Text('Nothing spent here yet.'),
                                  )
                                : Column(
                                    children: [
                                      for (final item in items.take(4))
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  item.categoryName,
                                                  style: theme
                                                      .textTheme
                                                      .bodyMedium,
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Flexible(
                                                child: Text(
                                                  _showBalance
                                                      ? Money.format(
                                                          item.amount,
                                                        )
                                                      : '••••',
                                                  textAlign: TextAlign.end,
                                                  style: theme
                                                      .textTheme
                                                      .titleSmall,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                            loading: () => const LoadingView(),
                            error: (_, _) => TextButton(
                              onPressed: () =>
                                  ref.invalidate(homeSpendingProvider),
                              child: const Text('Retry spending categories'),
                            ),
                          ),
                      const SizedBox(height: 24),
                      const Divider(),
                      DuitlahEditorialLink(
                        title: 'Make room for what matters.',
                        subtitle: 'Your savings goals',
                        onTap: () => context.push(AppRoutes.goals),
                      ),
                      DuitlahEditorialLink(
                        title: 'Plan a little. Breathe easier.',
                        subtitle: 'Your budgets',
                        onTap: () => context.push(AppRoutes.budgets),
                      ),
                      const Divider(),
                      const SizedBox(height: 40),
                      Text(
                        'BETTER, TOGETHER',
                        style: theme.textTheme.labelMedium?.copyWith(
                          letterSpacing: 1.8,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Good times.\nFair shares.',
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 22),
                      summary.when(
                        data: (s) => Wrap(
                          spacing: 32,
                          runSpacing: 20,
                          children: [
                            _HomeAmount(
                              label: "You're owed",
                              amount: _showBalance
                                  ? Money.format(s.totalOwedToMe)
                                  : '••••',
                            ),
                            _HomeAmount(
                              label: 'You owe',
                              amount: _showBalance
                                  ? Money.format(s.totalIOwe)
                                  : '••••',
                            ),
                          ],
                        ),
                        loading: () => const LoadingView(),
                        error: (e, _) => ErrorView(
                          error: e,
                          onRetry: () =>
                              ref.invalidate(settlementSummaryProvider),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: [
                          TextButton(
                            onPressed: () => context.go(AppRoutes.bagilah),
                            child: const Text('Open Bagilah ↗'),
                          ),
                          TextButton(
                            onPressed: () =>
                                context.push(AppRoutes.settlements),
                            child: const Text('Settle up'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      const WrappedPromoCard(),
                      SectionHeader(
                        'Recent activity',
                        action: 'See all',
                        onAction: () => context.go(AppRoutes.transactions),
                      ),
                      dashboard.when(
                        data: (data) => data.recentTransactions.isEmpty
                            ? EmptyView(
                                icon: Icons.receipt_outlined,
                                title: 'Your money story starts here',
                                message: 'Record your first transaction to see it here.',
                                actionLabel: 'Add transaction',
                                onAction: () => showTransactionForm(context),
                              )
                            : Column(
                                children: [
                                  for (final transaction
                                      in data.recentTransactions.take(5))
                                    TransactionRow(transaction: transaction),
                                ],
                              ),
                        loading: () => const LoadingView(),
                        error: (e, _) => ErrorView(
                          error: e,
                          onRetry: () => ref.invalidate(dashboardProvider),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'A little clarity. Every day.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FinancialCanvas extends StatelessWidget {
  const _FinancialCanvas({
    required this.data,
    required this.visible,
    required this.onVisibility,
  });
  final DashboardSummary data;
  final bool visible;
  final VoidCallback onVisibility;
  @override
  Widget build(BuildContext context) {
    final colors = context.duitlahColors;
    final theme = Theme.of(context);
    final income = double.tryParse(data.monthIncome) ?? 0;
    final expense = double.tryParse(data.monthExpense) ?? 0;
    final ratio = income > 0 ? expense / income : 0.0;
    return DuitlahReveal(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(48),
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(12),
        ),
        child: ColoredBox(
          color: colors.balanceBackground,
          child: DuitlahSignalField(
            onDark: true,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'AVAILABLE NOW',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colors.balanceSecondary,
                            letterSpacing: 1.4,
                          ),
                        ),
                      ),
                      Tooltip(
                        message: visible ? 'Hide balance' : 'Show balance',
                        child: DuitlahGlassButton(
                          label: visible ? 'Hide balance' : 'Show balance',
                          onPressed: onVisibility,
                          material: GlassMaterial.hero,
                          radius: 24,
                          elevated: false,
                          padding: const EdgeInsets.all(12),
                          child: AnimatedSwitcher(
                            duration: EditorialMotion.of(context),
                            child: DuitlahIcon(
                              visible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              key: ValueKey(visible),
                              color: colors.balanceSecondary,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  TweenAnimationBuilder<double>(
                    key: ValueKey(visible),
                    tween: Tween(begin: 0, end: 1),
                    duration: EditorialMotion.of(context),
                    builder: (_, value, child) =>
                        Opacity(opacity: value, child: child),
                    child: Text(
                      visible
                          ? Money.format(data.availableBalance)
                          : 'RM •••••',
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: colors.balanceText,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  DuitlahGlassSurface(
                    material: GlassMaterial.hero,
                    blur: false,
                    radius: 12,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      child: Text(
                        visible
                            ? '${Money.format(data.monthIncome)} income this month'
                            : 'Your amounts are hidden',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.balanceSecondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (visible && income > 0) ...[
                    DuitlahTrajectory(
                      progress: ratio,
                      label:
                          '${(ratio * 100).round()} percent of monthly income spent',
                      onDark: true,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(ratio * 100).round()}% of this month’s income spent',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.balanceSecondary,
                      ),
                    ),
                  ] else
                    Text(
                      visible
                          ? 'Your month, in view.'
                          : 'Tap the eye to reveal.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.balanceSecondary,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeCommands extends StatelessWidget {
  const _HomeCommands();
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      DuitlahGlassButton(
        onPressed: () => showTransactionForm(context),
        material: GlassMaterial.strong,
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            DuitlahIcon(
              Icons.add,
              size: 18,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Add expense',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            const Text('↗'),
          ],
        ),
      ),
      const SizedBox(height: 8),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            TextButton(
              onPressed: () => context.push(AppRoutes.bagilahScan),
              child: const Text('Scan receipt ↗'),
            ),
            TextButton(
              onPressed: () => showTransactionForm(
                context,
                initialType: TransactionType.INCOME,
              ),
              child: const Text('Add income'),
            ),
            TextButton(
              onPressed: () => showTransactionForm(
                context,
                initialType: TransactionType.TRANSFER,
              ),
              child: const Text('Transfer'),
            ),
            TextButton(
              onPressed: () => context.push(AppRoutes.bills),
              child: const Text('Bills'),
            ),
          ],
        ),
      ),
    ],
  );
}

class _HomeAmount extends StatelessWidget {
  const _HomeAmount({required this.label, required this.amount});
  final String label, amount;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: Theme.of(context).textTheme.bodySmall),
      const SizedBox(height: 8),
      Text(
        amount,
        style: Theme.of(context).textTheme.titleLarge
            ?.copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
      ),
    ],
  );
}
