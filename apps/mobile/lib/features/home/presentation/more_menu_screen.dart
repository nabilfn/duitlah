import 'package:duitlah_mobile/core/theme/app_theme.dart';
import 'package:duitlah_mobile/core/widgets/app_page_body.dart';
import 'package:duitlah_mobile/core/widgets/app_search_field.dart';
import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';

/// The "More" tab — everything that doesn't fit the primary four (Home,
/// Transactions, Bagilah, Groups) without crowding the bottom nav: personal
/// finance basics (accounts/budgets/goals), settlements, and profile.
class MoreMenuScreen extends StatefulWidget {
  const MoreMenuScreen({super.key});

  @override
  State<MoreMenuScreen> createState() => _MoreMenuScreenState();
}

class _MoreMenuScreenState extends State<MoreMenuScreen> {
  String _query = "";
  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.workspaces_outlined, 'Workspaces', AppRoutes.spaces),
      (Icons.account_balance_wallet_outlined, 'Accounts', AppRoutes.accounts),
      (
        Icons.fact_check_outlined,
        'Review transactions',
        AppRoutes.autoTrackReview,
      ),
      (
        Icons.upload_file_outlined,
        'Import statement',
        AppRoutes.statementImport,
      ),
      (Icons.folder_special_outlined, 'Receipt Vault', AppRoutes.receiptVault),
      (Icons.rule_outlined, 'Transaction Rules', AppRoutes.transactionRules),
      (Icons.pie_chart_outline, 'Budgets', AppRoutes.budgets),
      (Icons.flag_outlined, 'Goals', AppRoutes.goals),
      (Icons.request_page_outlined, 'Bills', AppRoutes.bills),
      (
        Icons.account_balance_outlined,
        'Loans & Liabilities',
        AppRoutes.liabilities,
      ),
      (Icons.trending_up_outlined, 'Net Worth', AppRoutes.netWorth),
      (
        Icons.assessment_outlined,
        'Combined Net Worth',
        AppRoutes.combinedNetWorth,
      ),
      (Icons.favorite_outline, 'Financial Health', AppRoutes.financialHealth),
      (Icons.ios_share_outlined, 'Export data', AppRoutes.exports),
      (
        Icons.account_balance_outlined,
        'Personal Tax Centre',
        AppRoutes.personalTax,
      ),
      (Icons.handshake_outlined, 'Settlements', AppRoutes.settlements),
      (Icons.repeat_rounded, 'Recurring & Subscriptions', AppRoutes.recurring),
      (Icons.calendar_month_outlined, 'Calendar', AppRoutes.calendar),
      (Icons.insights_outlined, 'Insights', AppRoutes.insights),
      (Icons.smart_toy_outlined, 'Assistant', AppRoutes.assistant),
      (Icons.workspace_premium_outlined, 'Duitlah+', AppRoutes.duitlahPlus),
      (Icons.notifications_outlined, 'Notifications', AppRoutes.notifications),
      (
        Icons.tune_outlined,
        'Notification Settings',
        AppRoutes.notificationRules,
      ),
      (Icons.person_outline, 'Profile', AppRoutes.profile),
      (Icons.help_outline, 'Help & Support', AppRoutes.helpSupport),
      (Icons.groups_outlined, 'Groups', AppRoutes.groups),
      (Icons.pie_chart_outline, 'Categories', AppRoutes.categories),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: AppPageBody(
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: AppSpacing.scrollInsets(context, floatingAction: false),
          children: [
            Text(
              'Your financial toolkit',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Manage your money, plan ahead and make Duitlah yours.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            AppSearchField(
              hint: 'Search tools…',
              onChanged: (value) =>
                  setState(() => _query = value.toLowerCase().trim()),
            ),
            for (final group in <(String, List<int>)>[
              ('Everyday money', [1, 6, 7, 8, 15, 16, 17, 25, 26]),
              ('Insights & planning', [18, 10, 12, 9, 14, 19]),
              ('Records & automation', [2, 3, 4, 5, 13]),
              ('Business', [0, 11]),
              ('Your Duitlah', [23, 21, 22, 20, 24]),
            ]) ...[
              if (group.$2.any(
                (i) => items[i].$2.toLowerCase().contains(_query),
              ))
                Padding(
                  padding: const EdgeInsets.only(top: 28, bottom: 12),
                  child: Text(
                    group.$1,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              if (group.$2.any(
                (i) => items[i].$2.toLowerCase().contains(_query),
              ))
                Card(
                  child: Column(
                    children: [
                      for (final index in group.$2.where(
                        (i) => items[i].$2.toLowerCase().contains(_query),
                      )) ...[
                        if (index != group.$2.first) const Divider(indent: 56),
                        ListTile(
                          leading: DuitlahIcon(items[index].$1),
                          title: Text(items[index].$2),
                          trailing: const DuitlahIcon(
                            Icons.chevron_right,
                            size: 20,
                          ),
                          onTap: () => context.push(items[index].$3),
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
