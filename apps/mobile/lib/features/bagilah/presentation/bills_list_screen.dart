import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/status_chip.dart';
import '../application/bagilah_providers.dart';
import '../domain/bagilah_enums.dart';

class BillsListScreen extends ConsumerWidget {
  const BillsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bills = ref.watch(billListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bagilah'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_rounded),
            tooltip: 'Scan a Bagilah QR code',
            onPressed: () => context.push(AppRoutes.bagilahQrScan),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(billListProvider),
        child: bills.when(
          data: (list) => list.isEmpty
              ? ListView(
                  children: const [
                    SizedBox(height: 80),
                    EmptyView(
                      icon: Icons.receipt_long_outlined,
                      title: 'No bills yet',
                      message: 'Scan a receipt or start a bill to split with friends.',
                    ),
                  ],
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final bill = list[index];
                    return Card(
                      child: ListTile(
                        title: Text(bill.merchant ?? 'Untitled bill'),
                        subtitle: Text(bill.receiptDate),
                        trailing: StatusChip(
                          label: bill.status.name,
                          color: switch (bill.status) {
                            BillStatus.DRAFT => Theme.of(context).colorScheme.primary,
                            BillStatus.FINALIZED => context.semanticColors.success,
                            BillStatus.CANCELLED => Theme.of(context).colorScheme.error,
                          },
                        ),
                        onTap: () => context.push(AppRoutes.bagilahDetail(bill.id)),
                      ),
                    );
                  },
                ),
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(billListProvider)),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'scan_receipt',
            onPressed: () => context.push(AppRoutes.bagilahScan),
            icon: const Icon(Icons.camera_alt_outlined),
            label: const Text('Scan receipt'),
          ),
        ],
      ),
    );
  }
}
