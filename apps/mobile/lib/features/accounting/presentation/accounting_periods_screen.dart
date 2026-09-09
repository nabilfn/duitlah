import 'package:duitlah_mobile/core/theme/duitlah_colors.dart';
import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/dialogs.dart';
import '../application/accounting_providers.dart';
import '../domain/periods.dart';

String _fmtDate(DateTime d) => d.toIso8601String().substring(0, 10);

/// Accounting periods — an open-ended list of date ranges, each either OPEN
/// or CLOSED. Closing is a one-directional confirm (no reopen endpoint
/// exists on the backend); once closed, posting a journal entry dated
/// inside the period is rejected with `409 ACCOUNTING_PERIOD_CLOSED`.
class AccountingPeriodsScreen extends ConsumerWidget {
  const AccountingPeriodsScreen({super.key, required this.spaceId});

  final String spaceId;

  Future<void> _create(BuildContext context, WidgetRef ref) async {
    final now = DateTime.now();
    var start = DateTime(now.year, now.month, 1);
    var end = DateTime(now.year, now.month + 1, 0);

    final saved = await showAppBottomSheet<bool>(
      context,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => SingleChildScrollView(child: Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.lg,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('New period', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Start'),
                subtitle: Text(_fmtDate(start)),
                trailing: const DuitlahIcon(Icons.calendar_month_outlined),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: start,
                    firstDate: DateTime(now.year - 5),
                    lastDate: DateTime(now.year + 5),
                  );
                  if (picked != null) setSheetState(() => start = picked);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('End'),
                subtitle: Text(_fmtDate(end)),
                trailing: const DuitlahIcon(Icons.calendar_month_outlined),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: end,
                    firstDate: DateTime(now.year - 5),
                    lastDate: DateTime(now.year + 5),
                  );
                  if (picked != null) setSheetState(() => end = picked);
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: 'Create period',
                onPressed: () async {
                  try {
                    await ref.read(accountingPeriodsRepositoryProvider).create(
                          spaceId,
                          periodStart: _fmtDate(start),
                          periodEnd: _fmtDate(end),
                        );
                    if (context.mounted) Navigator.of(context).pop(true);
                  } catch (e) {
                    if (context.mounted) {
                      showErrorSnackBar(context, e is AppException ? e.message : 'Something went wrong.');
                    }
                  }
                },
              ),
            ],
          ),
        )),
      ),
    );
    if (saved == true) ref.invalidate(accountingPeriodListProvider(spaceId));
  }

  Future<void> _close(BuildContext context, WidgetRef ref, AccountingPeriod period) async {
    if (period.status == AccountingPeriodStatus.CLOSED) return;
    final confirmed = await showConfirmDialog(
      context,
      title: 'Close this period?',
      message: 'Closing is one-directional — there is no way to reopen a closed period. '
          'Journal entries dated inside it will be rejected afterwards.',
      confirmLabel: 'Close period',
      destructive: true,
    );
    if (!confirmed) return;
    try {
      await ref.read(accountingPeriodsRepositoryProvider).close(spaceId, period.id);
      ref.invalidate(accountingPeriodListProvider(spaceId));
    } catch (e) {
      if (context.mounted) showErrorSnackBar(context, e is AppException ? e.message : 'Something went wrong.');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final periods = ref.watch(accountingPeriodListProvider(spaceId));
    return Scaffold(
      appBar: AppBar(title: const Text('Accounting Periods')),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(accountingPeriodListProvider(spaceId)),
        child: periods.when(
          data: (items) => items.isEmpty
              ? ListView(
                  children: const [
                    SizedBox(height: 80),
                    EmptyView(icon: Icons.event_note_outlined, title: 'No accounting periods yet'),
                  ],
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final p = items[index];
                    final closed = p.status == AccountingPeriodStatus.CLOSED;
                    return Card(
                      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: ListTile(
                        title: Text('${p.periodStart} — ${p.periodEnd}'),
                        subtitle: closed ? null : const Text('Tap to close this period'),
                        trailing: Chip(
                          label: Text(p.status.name),
                          backgroundColor: (closed ? context.duitlahColors.textTertiary : context.duitlahColors.positive).withValues(alpha: 0.15),
                        ),
                        onTap: closed ? null : () => _close(context, ref, p),
                      ),
                    );
                  },
                ),
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(accountingPeriodListProvider(spaceId))),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => _create(context, ref), child: const DuitlahIcon(Icons.add)),
    );
  }
}
