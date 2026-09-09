import 'package:duitlah_mobile/core/theme/duitlah_colors.dart';
import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_state_views.dart';
import '../application/spaces_providers.dart';
import '../domain/financial_space.dart';

/// Duitlah V2 Phase 1: one Duitlah identity, multiple financial spaces. This
/// screen shows every space you belong to and lets you create a real
/// Business space. As of Phase 5 (Business Core), tapping a business space
/// now switches into it — it opens that space's Business Dashboard, the
/// real landing screen with live business data (team, customers, suppliers,
/// products, accounts, expenses, quotations, invoices, credit notes) behind
/// it, rather than the placeholder-free no-op this screen deliberately kept
/// until that data existed server-side.
class SpacesScreen extends ConsumerWidget {
  const SpacesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spaces = ref.watch(spaceListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Workspaces')),
      body: spaces.when(
        data: (list) {
          final personal = list.where((s) => s.type == SpaceType.PERSONAL).toList();
          final businesses = list.where((s) => s.type == SpaceType.BUSINESS).toList();
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(spaceListProvider),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                Text('Personal', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: AppSpacing.sm),
                for (final space in personal) _SpaceCard(space: space),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Businesses', style: Theme.of(context).textTheme.titleSmall),
                    TextButton.icon(
                      onPressed: () => context.push(AppRoutes.createBusinessSpace),
                      icon: const DuitlahIcon(Icons.add, size: 18),
                      label: const Text('Add Business'),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                if (businesses.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                    child: Text(
                      'No business workspaces yet.',
                      style: TextStyle(color: context.duitlahColors.textTertiary),
                    ),
                  ),
                for (final space in businesses)
                  _SpaceCard(
                    space: space,
                    onTap: () => context.push(AppRoutes.businessDashboard(space.id)),
                  ),
              ],
            ),
          );
        },
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(spaceListProvider)),
      ),
    );
  }
}

class _SpaceCard extends StatelessWidget {
  const _SpaceCard({required this.space, this.onTap});

  final FinancialSpace space;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: DuitlahIcon(
          space.type == SpaceType.PERSONAL ? Icons.person_outline : Icons.business_outlined,
        ),
        title: Text(space.name),
        subtitle: Text(space.yourRole.name),
        trailing: onTap != null ? const DuitlahIcon(Icons.chevron_right) : null,
        onTap: onTap,
      ),
    );
  }
}
