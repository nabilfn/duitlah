import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/duitlah_colors.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/duitlah_icon.dart';
import '../../../core/widgets/financial_surfaces.dart';
import '../../../core/widgets/participant_avatar.dart';
import '../../../core/widgets/status_chip.dart';
import '../application/bagilah_providers.dart';
import '../domain/bill.dart';
import '../domain/bagilah_enums.dart';

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
            await ref.read(billListProvider.future);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            Text(
              'Split. Settle. Simple.',
              style: theme.textTheme.headlineSmall,
            ),
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
                final featured = list.take(4).toList();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth < 290 ||
                            MediaQuery.textScalerOf(context).scale(14) > 20) {
                          return Column(
                            children: [
                              for (var i = 0; i < featured.length; i++)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: BagilahBlob(
                                    bill: featured[i],
                                    index: i,
                                  ),
                                ),
                            ],
                          );
                        }
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 11,
                              child: Column(
                                children: [
                                  for (final i in [0, 2])
                                    if (i < featured.length)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 10,
                                        ),
                                        child: BagilahBlob(
                                          bill: featured[i],
                                          index: i,
                                        ),
                                      ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 10,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Column(
                                  children: [
                                    for (final i in [1, 3])
                                      if (i < featured.length)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 10,
                                          ),
                                          child: BagilahBlob(
                                            bill: featured[i],
                                            index: i,
                                          ),
                                        ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.push(AppRoutes.bagilahCreate),
                        style: TextButton.styleFrom(
                          backgroundColor: theme.colorScheme.surfaceContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(34),
                          ),
                          padding: const EdgeInsets.all(18),
                        ),
                        child: const Column(
                          children: [
                            DuitlahIcon(Icons.add),
                            SizedBox(height: 4),
                            Text('New split'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SectionHeader(
                      'Your splits',
                      action: 'See all',
                      onAction: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const _AllSplitsScreen())),
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
            FinancialModule(title: 'Your groups', subtitle: 'Housemates, trips and shared goals', icon: Icons.groups_outlined, onTap: () => context.push(AppRoutes.groups)),
            const SizedBox(height: 12),
            FinancialModule(
              title: 'Start with a receipt',
              subtitle: 'Scan the items. Share the bill.',
              icon: Icons.camera_alt_outlined,
              onTap: () => context.push(AppRoutes.bagilahScan),
            ),
            const SizedBox(height: 12),
            FinancialModule(
              title: 'Settle up',
              subtitle: 'See what you owe and what you are owed',
              icon: Icons.handshake_outlined,
              onTap: () => context.push(AppRoutes.settlements),
            ),
          ],
        ),
      ),
    );
  }
}

class BagilahBlob extends ConsumerWidget {
  const BagilahBlob({super.key, required this.bill, required this.index});
  final Bill bill;
  final int index;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final participants = ref.watch(billParticipantsProvider(bill.id));
    final theme = Theme.of(context);
    final colors = DuitlahColors.participants;
    final foreground = context.duitlahColors.onParticipant(colors[index % 4]);
    final radius = [
      const BorderRadius.only(
        topLeft: Radius.elliptical(85, 100),
        topRight: Radius.elliptical(85, 85),
        bottomLeft: Radius.elliptical(55, 70),
        bottomRight: Radius.elliptical(70, 45),
      ),
      const BorderRadius.only(
        topLeft: Radius.elliptical(85, 55),
        topRight: Radius.elliptical(90, 100),
        bottomLeft: Radius.elliptical(60, 80),
        bottomRight: Radius.elliptical(40, 60),
      ),
      const BorderRadius.only(
        topLeft: Radius.elliptical(55, 60),
        topRight: Radius.elliptical(85, 40),
        bottomLeft: Radius.elliptical(65, 80),
        bottomRight: Radius.elliptical(95, 100),
      ),
      const BorderRadius.only(
        topLeft: Radius.elliptical(70, 65),
        topRight: Radius.elliptical(100, 75),
        bottomLeft: Radius.elliptical(40, 50),
        bottomRight: Radius.elliptical(90, 80),
      ),
    ][index % 4];
    final amount = bill.total ?? bill.declaredTotal;
    return Semantics(
      button: true,
      label: 'Open ${bill.merchant ?? 'split'}',
      child: Material(
        color: colors[index % 4],
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push(AppRoutes.bagilahDetail(bill.id)),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(minHeight: index < 2 ? 190 : 155),
            padding: EdgeInsets.fromLTRB(index == 0 ? 26 : 24, 32, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bill.merchant ?? 'Untitled split',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: foreground,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  amount == null
                      ? 'Draft'
                      : Money.format(
                          amount,
                          currency: bill.currency == 'MYR'
                              ? 'RM'
                              : bill.currency,
                        ),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: foreground,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(height: 4),
                participants.when(
                  data: (people) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${people.length} ${people.length == 1 ? 'person' : 'people'}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: foreground,
                        ),
                      ),
                      const SizedBox(height: 12),
                      AvatarStack(
                        names: people.map((p) => p.displayName).toList(),
                      ),
                    ],
                  ),
                  loading: () => Text(
                    'Loading people…',
                    style: TextStyle(fontSize: 12, color: foreground),
                  ),
                  error: (_, _) => Text(
                    'View participants',
                    style: TextStyle(fontSize: 12, color: foreground),
                  ),
                ),
                if (bill.status == BillStatus.CANCELLED) ...[
                  const SizedBox(height: 8),
                  StatusChip(label: 'Cancelled', color: foreground),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AvatarStack extends StatelessWidget {
  const AvatarStack({super.key, required this.names});
  final List<String> names;
  @override
  Widget build(BuildContext context) {
    final visible = names.take(3).toList();
    return SizedBox(
      height: 28,
      width: 110,
      child: Stack(
        children: [
          for (var i = 0; i < visible.length; i++)
            Positioned(
              left: i * 21,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: context.duitlahColors.borderSubtle, width: 1.5),
                ),
                child: ParticipantAvatar(name: visible[i], size: 25),
              ),
            ),
          if (names.length > 3)
            Positioned(
              left: 63,
              child: CircleAvatar(
                radius: 14,
                backgroundColor: context.duitlahColors.primarySoft,
                child: Text(
                  '+${names.length - 3}',
                  style: TextStyle(fontSize: 10, color: context.duitlahColors.textPrimary),
                ),
              ),
            ),
        ],
      ),
    );
  }
}


/// Virtualized archive keeps a long bill history inexpensive to browse.
class _AllSplitsScreen extends ConsumerWidget {
  const _AllSplitsScreen();
  @override Widget build(BuildContext context,WidgetRef ref) {
    final bills=ref.watch(billListProvider);
    return Scaffold(appBar:AppBar(title:const Text('All splits')),body:bills.when(
      data:(list)=>ListView.separated(padding:const EdgeInsets.fromLTRB(20,8,20,32),itemCount:list.length,separatorBuilder:(_,_)=>const Divider(),itemBuilder:(context,index){final b=list[index];return ListTile(leading:const DuitlahIcon(Icons.receipt_outlined),title:Text(b.merchant??'Untitled split'),subtitle:Text('${b.receiptDate} · ${b.status.name.toLowerCase()}'),trailing:const DuitlahIcon(Icons.chevron_right),onTap:()=>context.push(AppRoutes.bagilahDetail(b.id)));}),
      loading:()=>const LoadingView(),error:(e,_)=>ErrorView(error:e,onRetry:()=>ref.invalidate(billListProvider)),
    ));
  }
}
