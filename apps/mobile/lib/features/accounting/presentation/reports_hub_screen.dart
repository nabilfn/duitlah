import 'package:duitlah_mobile/core/widgets/app_page_body.dart';
import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_theme.dart';

/// Landing page for the five Phase 6 reports.
class ReportsHubScreen extends StatelessWidget {
  const ReportsHubScreen({super.key, required this.spaceId});

  final String spaceId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: AppPageBody(
        child: ListView(
          padding: AppSpacing.scrollInsets(context, floatingAction: false),
          children: [
            _Tile(
              icon: Icons.menu_book_outlined,
              label: 'General Ledger',
              route: AppRoutes.accountingGeneralLedger(spaceId),
            ),
            _Tile(
              icon: Icons.balance_outlined,
              label: 'Trial Balance',
              route: AppRoutes.accountingTrialBalance(spaceId),
            ),
            _Tile(
              icon: Icons.trending_up_outlined,
              label: 'Income Statement',
              route: AppRoutes.accountingIncomeStatement(spaceId),
            ),
            _Tile(
              icon: Icons.account_balance_outlined,
              label: 'Balance Sheet',
              route: AppRoutes.accountingBalanceSheet(spaceId),
            ),
            _Tile(
              icon: Icons.water_drop_outlined,
              label: 'Cash Flow',
              route: AppRoutes.accountingCashFlow(spaceId),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.icon, required this.label, required this.route});

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
