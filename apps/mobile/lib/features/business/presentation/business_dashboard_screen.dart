import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/financial_surfaces.dart';
import '../../../core/utils/money.dart';
import '../application/business_providers.dart';
import '../domain/dashboard.dart';

/// The landing screen for a business space (Phase 5) — reached by tapping a
/// business space in the Workspaces screen. Headline numbers plus
/// navigation into every business sub-feature, including a link out to the
/// existing (Phase 1) Business Profile screen rather than duplicating it.
class BusinessDashboardScreen extends ConsumerWidget {
  const BusinessDashboardScreen({super.key, required this.spaceId});

  final String spaceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(businessDashboardProvider(spaceId));
    return Scaffold(
      appBar: AppBar(title: const Text('Business')),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(businessDashboardProvider(spaceId)),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            dashboard.when(
              data: (d) => _HeadlineCard(dashboard: d),
              loading: () => const LoadingView(),
              error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(businessDashboardProvider(spaceId))),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: QuickAction(label: 'Expenses', icon: Icons.request_quote_outlined, onTap: () => context.push(AppRoutes.businessExpenses(spaceId)))),
              Expanded(child: QuickAction(label: 'Invoices', icon: Icons.receipt_outlined, onTap: () => context.push(AppRoutes.businessInvoices(spaceId)))),
              Expanded(child: QuickAction(label: 'Accounts', icon: Icons.account_balance_outlined, onTap: () => context.push(AppRoutes.businessAccounts(spaceId)))),
              Expanded(child: QuickAction(label: 'Reports', icon: Icons.insights_outlined, onTap: () => context.push(AppRoutes.accountingReports(spaceId)))),
            ]),
            const SizedBox(height: 20),
            const SectionHeader('People & business'),
            _NavTile(icon: Icons.groups_outlined, label: 'Team', route: AppRoutes.businessTeam(spaceId)),
            _NavTile(icon: Icons.badge_outlined, label: 'Business Profile', route: AppRoutes.businessProfile(spaceId)),
            const SizedBox(height: AppSpacing.md),
            _NavTile(icon: Icons.people_alt_outlined, label: 'Customers', route: AppRoutes.businessCustomers(spaceId)),
            _NavTile(icon: Icons.local_shipping_outlined, label: 'Suppliers', route: AppRoutes.businessSuppliers(spaceId)),
            _NavTile(icon: Icons.inventory_2_outlined, label: 'Products', route: AppRoutes.businessProducts(spaceId)),
            _NavTile(icon: Icons.account_balance_outlined, label: 'Business Accounts', route: AppRoutes.businessAccounts(spaceId)),
            const SizedBox(height: 20),
            const SectionHeader('Sales & payments'),
            _NavTile(icon: Icons.request_quote_outlined, label: 'Expenses', route: AppRoutes.businessExpenses(spaceId)),
            _NavTile(icon: Icons.description_outlined, label: 'Quotations', route: AppRoutes.businessQuotations(spaceId)),
            _NavTile(icon: Icons.receipt_long_outlined, label: 'Invoices', route: AppRoutes.businessInvoices(spaceId)),
            _NavTile(icon: Icons.event_repeat_outlined, label: 'Recurring Invoices', route: AppRoutes.businessRecurringInvoices(spaceId)),
            _NavTile(icon: Icons.assignment_return_outlined, label: 'Credit Notes', route: AppRoutes.businessCreditNotes(spaceId)),
            const SizedBox(height: AppSpacing.md),
            const SectionHeader('Operations & reporting'),
            _NavTile(icon: Icons.calculate_outlined, label: 'Accounting', route: AppRoutes.accountingHub(spaceId)),
            _NavTile(icon: Icons.fact_check_outlined, label: 'Reconciliation', route: AppRoutes.reconciliationHub(spaceId)),
            _NavTile(icon: Icons.warehouse_outlined, label: 'Inventory', route: AppRoutes.inventoryHub(spaceId)),
            _NavTile(icon: Icons.chair_outlined, label: 'Fixed Assets', route: AppRoutes.assetsHub(spaceId)),
            _NavTile(icon: Icons.gavel_outlined, label: 'Business Tax', route: AppRoutes.businessTaxHub(spaceId)),
            _NavTile(icon: Icons.swap_horiz_outlined, label: 'Owner Transactions', route: AppRoutes.crossSpaceHub(spaceId)),
          ],
        ),
      ),
    );
  }
}

class _HeadlineCard extends StatelessWidget {
  const _HeadlineCard({required this.dashboard});

  final BusinessDashboard dashboard;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ForestSurface(radius: 20, child: SizedBox(width: double.infinity, child: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Business cash position', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 8),
              Text(Money.format(dashboard.cashPosition), style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white)),
              const SizedBox(height: 8),
              const Text('Your business, in balance.', style: TextStyle(color: Color(0xFFDCE8E2), fontSize: 13)),
            ])))),
            const Divider(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: _Stat(label: 'Receivables', amount: dashboard.totalReceivables, count: '${dashboard.openInvoiceCount} open invoices'),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _Stat(label: 'Payables', amount: dashboard.totalPayables, count: '${dashboard.unpaidExpenseCount} unpaid expenses'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${dashboard.customerCount} customers', style: Theme.of(context).textTheme.bodySmall),
                Text('${dashboard.supplierCount} suppliers', style: Theme.of(context).textTheme.bodySmall),
                Text('${dashboard.productCount} products', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.amount, required this.count});

  final String label;
  final String amount;
  final String count;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        Text(Money.format(amount), style: Theme.of(context).textTheme.titleMedium),
        Text(count, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({required this.icon, required this.label, required this.route});

  final IconData icon;
  final String label;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: ListTile(
        leading: DuitlahIcon(icon),
        title: Text(label),
        trailing: const DuitlahIcon(Icons.chevron_right),
        onTap: () => context.push(route),
      ),
    );
  }
}
