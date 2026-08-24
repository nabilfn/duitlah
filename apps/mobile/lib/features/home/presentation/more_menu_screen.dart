import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_theme.dart';

/// The "More" tab — everything that doesn't fit the primary four (Home,
/// Transactions, Bagilah, Groups) without crowding the bottom nav: personal
/// finance basics (accounts/budgets/goals), settlements, and profile.
class MoreMenuScreen extends StatelessWidget {
  const MoreMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.workspaces_outlined, 'Workspaces', AppRoutes.spaces),
      (Icons.account_balance_wallet_outlined, 'Accounts', AppRoutes.accounts),
      (Icons.fact_check_outlined, 'Review transactions', AppRoutes.autoTrackReview),
      (Icons.upload_file_outlined, 'Import statement', AppRoutes.statementImport),
      (Icons.folder_special_outlined, 'Receipt Vault', AppRoutes.receiptVault),
      (Icons.rule_outlined, 'Transaction Rules', AppRoutes.transactionRules),
      (Icons.pie_chart_outline, 'Budgets', AppRoutes.budgets),
      (Icons.flag_outlined, 'Goals', AppRoutes.goals),
      (Icons.request_page_outlined, 'Bills', AppRoutes.bills),
      (Icons.account_balance_outlined, 'Loans & Liabilities', AppRoutes.liabilities),
      (Icons.trending_up_outlined, 'Net Worth', AppRoutes.netWorth),
      (Icons.assessment_outlined, 'Combined Net Worth', AppRoutes.combinedNetWorth),
      (Icons.favorite_outline, 'Financial Health', AppRoutes.financialHealth),
      (Icons.ios_share_outlined, 'Export data', AppRoutes.exports),
      (Icons.account_balance_outlined, 'Personal Tax Centre', AppRoutes.personalTax),
      (Icons.handshake_outlined, 'Settlements', AppRoutes.settlements),
      (Icons.repeat_rounded, 'Recurring & Subscriptions', AppRoutes.recurring),
      (Icons.calendar_month_outlined, 'Calendar', AppRoutes.calendar),
      (Icons.insights_outlined, 'Insights', AppRoutes.insights),
      (Icons.smart_toy_outlined, 'Assistant', AppRoutes.assistant),
      (Icons.workspace_premium_outlined, 'Duitlah+', AppRoutes.duitlahPlus),
      (Icons.notifications_outlined, 'Notifications', AppRoutes.notifications),
      (Icons.tune_outlined, 'Notification Settings', AppRoutes.notificationRules),
      (Icons.person_outline, 'Profile', AppRoutes.profile),
      (Icons.help_outline, 'Help & Support', AppRoutes.helpSupport),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.xs),
        itemBuilder: (context, index) {
          final (icon, label, route) = items[index];
          return Card(
            child: ListTile(
              leading: Icon(icon),
              title: Text(label),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(route),
            ),
          );
        },
      ),
    );
  }
}
