import 'package:duitlah_mobile/core/utils/money.dart';
import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/dialogs.dart';
import '../application/fixed_assets_providers.dart';
import '../domain/fixed_assets.dart';
import 'widgets/asset_form_sheet.dart';

/// Landing screen for Phase 9 — Fixed Assets, reached from the Business
/// Dashboard's "Fixed Assets" tile. The asset list here IS the asset
/// register (the backend has no separate register endpoint) — mirrors
/// `inventory_hub_screen.dart`'s single-list-plus-detail shape rather than
/// `reconciliation_hub_screen.dart`'s multi-section layout, since there's
/// only one register to show.
class AssetsHubScreen extends ConsumerWidget {
  const AssetsHubScreen({super.key, required this.spaceId});

  final String spaceId;

  Future<void> _openCreateForm(BuildContext context, WidgetRef ref) async {
    final saved = await showAppBottomSheet<bool>(
      context,
      builder: (context) => AssetFormSheet(spaceId: spaceId),
    );
    if (saved == true) ref.invalidate(assetListProvider(spaceId));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assets = ref.watch(assetListProvider(spaceId));

    return Scaffold(
      appBar: AppBar(title: const Text('Fixed Assets')),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(assetListProvider(spaceId)),
        child: assets.when(
          data: (items) => items.isEmpty
              ? ListView(
                  children: const [
                    SizedBox(height: 80),
                    EmptyView(
                      icon: Icons.chair_outlined,
                      title: 'No assets registered yet',
                      message: 'Add equipment, vehicles, or other long-term assets to track their depreciation.',
                    ),
                  ],
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: items.length,
                  itemBuilder: (context, index) => _AssetTile(spaceId: spaceId, asset: items[index]),
                ),
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(assetListProvider(spaceId))),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCreateForm(context, ref),
        icon: const DuitlahIcon(Icons.add),
        label: const Text('New Asset'),
      ),
    );
  }
}

class _AssetTile extends StatelessWidget {
  const _AssetTile({required this.spaceId, required this.asset});

  final String spaceId;
  final FixedAssetResponse asset;

  @override
  Widget build(BuildContext context) {
    final isDisposed = asset.status == FixedAssetStatus.DISPOSED;
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        title: Text(asset.name),
        subtitle: Text(asset.category ?? 'Uncategorized'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(Money.format(asset.netBookValue), style: Theme.of(context).textTheme.titleSmall),
            Chip(
              label: Text(isDisposed ? 'Disposed' : 'Active'),
              backgroundColor: isDisposed ? null : Theme.of(context).colorScheme.primaryContainer,
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
            ),
          ],
        ),
        onTap: () => context.push(AppRoutes.assetDetail(spaceId, asset.id)),
      ),
    );
  }
}
