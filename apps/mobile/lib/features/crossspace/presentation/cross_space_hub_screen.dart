import 'package:duitlah_mobile/core/utils/money.dart';
import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/dialogs.dart';
import '../application/cross_space_providers.dart';
import '../domain/cross_space.dart';
import 'cross_space_labels.dart';
import 'widgets/link_form_sheet.dart';

/// Landing screen for Phase 11 — Cross-Space Accounting ("Owner
/// Transactions" to the user), reached from the Business Dashboard's
/// "Owner Transactions" tile. Links an already-existing Personal
/// transaction to this business without ever merging the two ledgers — see
/// `widgets/link_form_sheet.dart` for what each of the four actions means.
/// Mirrors `assets_hub_screen.dart`'s single-list-plus-actions shape: four
/// action tiles up top, this business's own link history below (via
/// `GET /crossspace/links`, the space-scoped listing endpoint — more
/// natural here than the cross-business "my links" endpoint since this
/// screen is itself reached from one specific business's context).
class CrossSpaceHubScreen extends ConsumerWidget {
  const CrossSpaceHubScreen({super.key, required this.spaceId});

  final String spaceId;

  Future<void> _openLinkForm(BuildContext context, WidgetRef ref, CrossSpaceLinkType linkType) async {
    final saved = await showAppBottomSheet<bool>(
      context,
      builder: (context) => LinkFormSheet(spaceId: spaceId, linkType: linkType),
    );
    if (saved == true) {
      ref.invalidate(crossSpaceLinkListProvider(spaceId));
      if (context.mounted) showSuccessSnackBar(context, 'Link recorded.');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final links = ref.watch(crossSpaceLinkListProvider(spaceId));

    return Scaffold(
      appBar: AppBar(title: const Text('Owner Transactions')),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(crossSpaceLinkListProvider(spaceId)),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(
              "Link a Personal transaction you've already recorded to this business — the two "
              'ledgers stay separate, this just records the relationship between them.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.md),
            for (final type in CrossSpaceLinkType.values) ...[
              _ActionTile(linkType: type, onTap: () => _openLinkForm(context, ref, type)),
              const SizedBox(height: AppSpacing.xs),
            ],
            const SizedBox(height: AppSpacing.lg),
            Text('History', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            links.when(
              data: (items) => items.isEmpty
                  ? const EmptyView(icon: Icons.link_outlined, title: 'No links recorded yet')
                  : Column(children: items.map((l) => _LinkTile(link: l)).toList()),
              loading: () => const LoadingView(),
              error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(crossSpaceLinkListProvider(spaceId))),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.linkType, required this.onTap});

  final CrossSpaceLinkType linkType;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: DuitlahIcon(crossSpaceLinkTypeIcon(linkType)),
        title: Text(crossSpaceLinkTypeLabel(linkType)),
        subtitle: Text(crossSpaceLinkTypeDescription(linkType)),
        isThreeLine: true,
        trailing: const DuitlahIcon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({required this.link});

  final CrossSpaceLinkResponse link;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: DuitlahIcon(crossSpaceLinkTypeIcon(link.linkType)),
        title: Text(crossSpaceLinkTypeLabel(link.linkType)),
        subtitle: Text(link.description ?? link.createdAt),
        trailing: Text(Money.format(link.amount), style: Theme.of(context).textTheme.titleSmall),
      ),
    );
  }
}
