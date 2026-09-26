import 'package:flutter/material.dart';

import '../../../core/widgets/dock_insets.dart';

import 'shared_money_composition.dart';
import '../../settlements/application/settlements_providers.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/duitlah_icon.dart';
import '../../../core/widgets/financial_surfaces.dart';
import '../../../core/widgets/digital_canvas.dart';
import '../application/bagilah_providers.dart';

class BillsListScreen extends ConsumerWidget {
  const BillsListScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bills = ref.watch(billListProvider);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Bagilah', style: theme.textTheme.titleLarge),
        actions: [
          IconButton(
            tooltip: 'Scan a Bagilah QR code',
            onPressed: () => context.push(AppRoutes.bagilahQrScan),
            icon: const DuitlahIcon(Icons.qr_code_scanner_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(billListProvider);
          ref.invalidate(settlementSummaryProvider);
          ref.invalidate(settlementListProvider);
          await ref.read(billListProvider.future);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            20,
            8,
            20,
            32 + DuitlahDockInsets.of(context),
          ),
          children: [
            const SharedMoneyComposition(),
            Text('Good times, shared.', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 6),
            Text(
              'Share expenses with friends, family or\nhousemates — no awkward conversations.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            bills.when(
              loading: () => const LoadingView(),
              error: (e, _) => ErrorView(
                error: e,
                onRetry: () => ref.invalidate(billListProvider),
              ),
              data: (list) {
                if (list.isEmpty) {
                  return EmptyView(
                    icon: Icons.call_split,
                    title: 'Good times, shared fairly',
                    message: 'Start a split or scan your receipt. Invite everyone when you are ready.',
                    actionLabel: 'New split',
                    onAction: () => context.push(AppRoutes.bagilahCreate),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: FilledButton(
                        onPressed: () => context.push(AppRoutes.bagilahCreate),
                        child: const Text('New split  +'),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SectionHeader(
                      'Your splits',
                      action: 'See all',
                      onAction: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const _AllSplitsScreen(),
                        ),
                      ),
                    ),
                    for (final bill in list.take(3))
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Material(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(18),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(14),
                            leading: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.secondary,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const DuitlahIcon(Icons.receipt_outlined),
                            ),
                            title: Text(
                              bill.merchant ?? 'Untitled split',
                              style: theme.textTheme.titleSmall,
                            ),
                            subtitle: Text(
                              '${bill.receiptDate}\n${bill.total != null ? Money.format(bill.total!, currency: bill.currency == 'MYR' ? 'RM' : bill.currency) : 'Draft · total not finalized'}',
                              style: theme.textTheme.bodySmall,
                            ),
                            isThreeLine: true,
                            trailing: const DuitlahIcon(
                              Icons.chevron_right,
                              size: 18,
                            ),
                            onTap: () =>
                                context.push(AppRoutes.bagilahDetail(bill.id)),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
            DuitlahEditorialLink(
              title: 'Your groups',
              subtitle: 'Housemates, trips and shared goals',

              onTap: () => context.push(AppRoutes.groups),
            ),
            const SizedBox(height: 12),
            DuitlahEditorialLink(
              title: 'Start with a receipt',
              subtitle: 'Scan the items. Share the bill.',
              onTap: () => context.push(AppRoutes.bagilahScan),
            ),
            const SizedBox(height: 12),
            DuitlahEditorialLink(
              title: 'Settle up',
              subtitle: 'See what you owe and what you are owed',
              onTap: () => context.push(AppRoutes.settlements),
            ),
          ],
        ),
      ),
    );
  }
}

/// Virtualized archive keeps a long bill history inexpensive to browse.
class _AllSplitsScreen extends ConsumerWidget {
  const _AllSplitsScreen();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bills = ref.watch(billListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('All splits')),
      body: bills.when(
        data: (list) => ListView.separated(
          padding: EdgeInsets.fromLTRB(
            20,
            8,
            20,
            32 + DuitlahDockInsets.of(context),
          ),
          itemCount: list.length,
          separatorBuilder: (_, _) => const Divider(),
          itemBuilder: (context, index) {
            final b = list[index];
            return ListTile(
              leading: const DuitlahIcon(Icons.receipt_outlined),
              title: Text(b.merchant ?? 'Untitled split'),
              subtitle: Text(
                '${b.receiptDate} · ${b.status.name.toLowerCase()}',
              ),
              trailing: const DuitlahIcon(Icons.chevron_right),
              onTap: () => context.push(AppRoutes.bagilahDetail(b.id)),
            );
          },
        ),
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(billListProvider),
        ),
      ),
    );
  }
}
