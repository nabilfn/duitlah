import 'package:duitlah_mobile/core/widgets/app_page_body.dart';
import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../application/accounting_providers.dart';

/// Entry point for Phase 6's accounting module — reached from the Business
/// Dashboard's "Accounting" tile. Surfaces a "set up first" banner when the
/// space hasn't seeded a Chart of Accounts yet (the one prerequisite every
/// other accounting feature depends on), otherwise a flat hub into the four
/// sub-features.
class AccountingHubScreen extends ConsumerWidget {
  const AccountingHubScreen({super.key, required this.spaceId});

  final String spaceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(chartOfAccountsListProvider(spaceId));
    final needsSetup = accounts.valueOrNull?.isEmpty ?? false;

    return Scaffold(
      appBar: AppBar(title: const Text('Accounting')),
      body: AppPageBody(
        child: ListView(
          padding: AppSpacing.scrollInsets(context, floatingAction: false),
          children: [
            if (needsSetup) ...[
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: ListTile(
                  leading: const DuitlahIcon(Icons.rocket_launch_outlined),
                  title: const Text('Set up your Chart of Accounts'),
                  subtitle: const Text(
                    'Required before you can post journal entries or run reports.',
                  ),
                  trailing: const DuitlahIcon(Icons.chevron_right),
                  onTap: () => context.push(
                    AppRoutes.accountingChartOfAccounts(spaceId),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            _Tile(
              icon: Icons.account_tree_outlined,
              label: 'Chart of Accounts',
              route: AppRoutes.accountingChartOfAccounts(spaceId),
            ),
            _Tile(
              icon: Icons.event_note_outlined,
              label: 'Accounting Periods',
              route: AppRoutes.accountingPeriods(spaceId),
            ),
            _Tile(
              icon: Icons.book_outlined,
              label: 'Journal Entries',
              route: AppRoutes.accountingJournalEntries(spaceId),
            ),
            _Tile(
              icon: Icons.assessment_outlined,
              label: 'Reports',
              route: AppRoutes.accountingReports(spaceId),
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
