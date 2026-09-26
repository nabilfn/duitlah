import 'package:duitlah_mobile/core/widgets/app_adaptive_row.dart';
import 'package:duitlah_mobile/core/widgets/glass_account_selector.dart';
import 'package:duitlah_mobile/core/widgets/app_page_body.dart';
import 'package:duitlah_mobile/core/utils/money.dart';
import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_state_views.dart';
import '../application/cross_space_providers.dart';
import '../domain/cross_space.dart';

/// Read-only, informational combined view of the user's Personal net worth
/// plus each Business they own's computed ownership (equity) value — Phase
/// 11's "Combined Net Worth" concept. Deliberately not space-specific
/// (reached from the More menu, not a Business Dashboard tile) since it
/// aggregates across every space the user owns at once — mirroring
/// `business_tax_hub_screen.dart`'s "just show computed numbers" shape:
/// no actions here, only the server's own figures. Everything is labeled
/// "estimated" per [CombinedNetWorth.estimatedTotalNetWorth]'s own naming
/// — this is not authoritative bookkeeping, just an estimate for the
/// user's own awareness.
class CombinedNetWorthScreen extends ConsumerWidget {
  const CombinedNetWorthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final combined = ref.watch(combinedNetWorthProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Combined Net Worth'),
        actions: const [
          GlassAccountSelector(view: AccountView.both),
          SizedBox(width: 12),
        ],
      ),
      body: AppPageBody(
        child: RefreshIndicator(
          onRefresh: () async => ref.invalidate(combinedNetWorthProvider),
          child: combined.when(
            data: (nw) => ListView(
              padding: AppSpacing.scrollInsets(context, floatingAction: false),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      children: [
                        Text(
                          'Estimated net worth',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          Money.format(nw.estimatedTotalNetWorth),
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Personal net worth plus your ownership value across every business you own. '
                          'An estimate, not authoritative bookkeeping.',
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                        const Divider(height: AppSpacing.lg),
                        AppAdaptiveRow(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _Summary('Personal', nw.personalNetWorth),
                            _Summary(
                              'Business ownership',
                              nw.totalBusinessOwnershipValue,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'By business',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                if (nw.businessOwnership.isEmpty)
                  const EmptyView(
                    icon: Icons.store_outlined,
                    title: "You don't own any business spaces yet",
                  )
                else
                  ...nw.businessOwnership.map((b) => _OwnershipTile(line: b)),
              ],
            ),
            loading: () => const LoadingView(),
            error: (e, _) => ErrorView(
              error: e,
              onRetry: () => ref.invalidate(combinedNetWorthProvider),
            ),
          ),
        ),
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary(this.label, this.amount);

  final String label;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        Text(
          Money.format(amount),
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}

class _OwnershipTile extends StatelessWidget {
  const _OwnershipTile({required this.line});

  final BusinessOwnershipLine line;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppRecordTile(
        leading: const DuitlahIcon(Icons.store_outlined),
        title: Text(line.spaceName),
        trailing: Text(
          Money.format(line.equityValue),
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
    );
  }
}
