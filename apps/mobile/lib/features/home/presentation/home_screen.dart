import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/duitlah_icon.dart';
import '../../../core/widgets/financial_surfaces.dart';
import '../../../core/widgets/transaction_row.dart';
import '../../accounts/application/finance_providers.dart';
import '../../accounts/domain/finance.dart';
import '../../settlements/application/settlements_providers.dart';
import '../../transactions/presentation/transaction_form_sheet.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _showBalance = true;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dashboard = ref.watch(dashboardProvider);
    final summary = ref.watch(settlementSummaryProvider);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.forest,
        body: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(settlementSummaryProvider);
            ref.invalidate(dashboardProvider);
            await ref.read(dashboardProvider.future);
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: ForestSurface(
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              TextButton(
                                onPressed: () => context.push(AppRoutes.spaces),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.black.withValues(
                                    alpha: .14,
                                  ),
                                ),
                                child: const Text('Personal'),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Material(
                                  color: Colors.white.withValues(alpha: .86),
                                  borderRadius: BorderRadius.circular(28),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(28),
                                    onTap: () => context.push(AppRoutes.more),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 12,
                                      ),
                                      child: Row(
                                        children: [
                                          DuitlahIcon(
                                            Icons.search,
                                            size: 18,
                                            color: AppColors.forest,
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              'Find a tool…',
                                              style: TextStyle(
                                                color: AppColors
                                                    .lightMutedForeground,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                tooltip: 'Notifications',
                                onPressed: () =>
                                    context.push(AppRoutes.notifications),
                                icon: const DuitlahIcon(
                                  Icons.notifications_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Text(
                                'Available balance',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: IconButton(
                                  tooltip: _showBalance
                                      ? 'Hide balance'
                                      : 'Show balance',
                                  onPressed: () => setState(
                                    () => _showBalance = !_showBalance,
                                  ),
                                  icon: DuitlahIcon(
                                    _showBalance
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: dashboard.when(
                                  data: (d) => Text(
                                    _showBalance
                                        ? Money.format(d.availableBalance)
                                        : 'RM •••••',
                                    style: theme.textTheme.headlineMedium
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontFeatures: const [
                                            FontFeature.tabularFigures(),
                                          ],
                                        ),
                                  ),
                                  loading: () => const SizedBox(
                                    height: 34,
                                    child: LinearProgressIndicator(),
                                  ),
                                  error: (e, _) => TextButton(
                                    onPressed: () =>
                                        ref.invalidate(dashboardProvider),
                                    child: const Text(
                                      'Retry balance',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              FilledButton.icon(
                                onPressed: () => showTransactionForm(
                                  context,
                                  initialType: TransactionType.INCOME,
                                ),
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColors.forest,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                ),
                                icon: const DuitlahIcon(Icons.add, size: 16),
                                label: const Text(
                                  'Add income',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: QuickAction(
                              label: 'Scan receipt',
                              icon: Icons.qr_code_scanner_rounded,
                              onTap: () => context.push(AppRoutes.bagilahScan),
                            ),
                          ),
                          Expanded(
                            child: QuickAction(
                              label: 'Add income',
                              icon: Icons.add_circle_outline,
                              color: AppColors.coral,
                              onTap: () => showTransactionForm(
                                context,
                                initialType: TransactionType.INCOME,
                              ),
                            ),
                          ),
                          Expanded(
                            child: QuickAction(
                              label: 'Transfer',
                              icon: Icons.swap_horiz_outlined,
                              color: AppColors.blue,
                              onTap: () => showTransactionForm(
                                context,
                                initialType: TransactionType.TRANSFER,
                              ),
                            ),
                          ),
                          Expanded(
                            child: QuickAction(
                              label: 'Bills',
                              icon: Icons.request_page_outlined,
                              color: const Color(0xFFE5E9DC),
                              onTap: () => context.push(AppRoutes.bills),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      FinancialModule(
                        title: 'Grow your savings',
                        subtitle: 'Make room for what matters',
                        icon: Icons.favorite_outline,
                        onTap: () => context.push(AppRoutes.goals),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: FinancialModule(
                              title: 'Your budgets',
                              subtitle: 'A little planning goes a long way',
                              icon: Icons.pie_chart_outline,
                              compact: true,
                              color: AppColors.sage,
                              onTap: () => context.push(AppRoutes.budgets),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FinancialModule(
                              title: 'Daily spending',
                              subtitle: dashboard.maybeWhen(
                                data: (d) => _showBalance
                                    ? '${Money.format(d.monthExpense)} this month'
                                    : 'Explore your activity',
                                orElse: () => 'See where your money goes',
                              ),
                              icon: Icons.insights_outlined,
                              compact: true,
                              onTap: () => context.go(AppRoutes.insights),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ForestSurface(
                        radius: 18,
                        child: InkWell(
                          onTap: () => context.go(AppRoutes.bagilah),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Split. Settle. Simple.',
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(color: Colors.white),
                                      ),
                                      const SizedBox(height: 6),
                                      const Text(
                                        'Shared moments. Fair shares.\nBring everyone together with Bagilah.',
                                        style: TextStyle(
                                          color: Color(0xFFDCE8E2),
                                          fontSize: 13,
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const DuitlahIcon(
                                  Icons.chevron_right,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SectionHeader(
                        'Your month',
                        action: 'Analytics',
                        onAction: () => context.go(AppRoutes.insights),
                      ),
                      dashboard.maybeWhen(
                        data: (d) => Row(
                          children: [
                            Expanded(
                              child: _HomeAmount(
                                label: 'Income',
                                amount: _showBalance
                                    ? Money.format(d.monthIncome)
                                    : '••••',
                                positive: true,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _HomeAmount(
                                label: 'Expenses',
                                amount: _showBalance
                                    ? Money.format(d.monthExpense)
                                    : '••••',
                              ),
                            ),
                          ],
                        ),
                        orElse: () => const SizedBox.shrink(),
                      ),
                      const SizedBox(height: 20),
                      SectionHeader(
                        'Shared money',
                        action: 'Settle up',
                        onAction: () => context.push(AppRoutes.settlements),
                      ),
                      summary.when(
                        data: (s) => Row(
                          children: [
                            Expanded(
                              child: _HomeAmount(
                                label: "You're owed",
                                amount: _showBalance
                                    ? Money.format(s.totalOwedToMe)
                                    : '••••',
                                positive: true,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _HomeAmount(
                                label: 'You owe',
                                amount: _showBalance
                                    ? Money.format(s.totalIOwe)
                                    : '••••',
                              ),
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
                      const SizedBox(height: 20),
                      SectionHeader(
                        'Recent transactions',
                        action: 'See all',
                        onAction: () => context.go(AppRoutes.transactions),
                      ),
                      dashboard.when(
                        data: (d) => d.recentTransactions.isEmpty
                            ? EmptyView(
                                icon: Icons.receipt_outlined,
                                title: 'Your money story starts here',
                                message: 'Record your first transaction to see it here.',
                                actionLabel: 'Add transaction',
                                onAction: () => showTransactionForm(context),
                              )
                            : Column(
                                children: d.recentTransactions
                                    .take(5)
                                    .map((t) => TransactionRow(transaction: t))
                                    .toList(),
                              ),
                        loading: () => const LoadingView(),
                        error: (e, _) => ErrorView(
                          error: e,
                          onRetry: () => ref.invalidate(dashboardProvider),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: ColoredBox(color: theme.scaffoldBackgroundColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeAmount extends StatelessWidget {
  const _HomeAmount({
    required this.label,
    required this.amount,
    this.positive = false,
  });
  final String label, amount;
  final bool positive;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: Theme.of(context).textTheme.bodySmall),
      const SizedBox(height: 6),
      Text(
        amount,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: positive ? Theme.of(context).colorScheme.primary : null,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    ],
  );
}
