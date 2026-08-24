import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/dialogs.dart';
import '../../accounting/application/accounting_providers.dart';
import '../../accounting/domain/chart_of_accounts.dart';
import '../application/business_providers.dart';
import '../domain/banking.dart';
import '../domain/expenses.dart';
import 'expenses_screen.dart' show expenseStatusColor;

/// Distinguishes "sheet dismissed without a choice" (returns null — no
/// change) from "user explicitly chose to clear the mapping" (returns a
/// record with a null [chartOfAccountsId] inside it).
typedef _MappingChoice = ({String? chartOfAccountsId});

class ExpenseDetailScreen extends ConsumerWidget {
  const ExpenseDetailScreen({super.key, required this.spaceId, required this.expenseId});

  final String spaceId;
  final String expenseId;

  SpaceResourceKey get _key => (spaceId: spaceId, resourceId: expenseId);

  Future<void> _recordPayment(BuildContext context, WidgetRef ref) async {
    final accounts = await ref.read(bankingRepositoryProvider).listAccounts(spaceId);
    final active = accounts.where((a) => !a.archived).toList();
    if (!context.mounted) return;
    if (active.isEmpty) {
      showErrorSnackBar(context, 'Add a business account first.');
      return;
    }

    final amountController = TextEditingController();
    final dateController = TextEditingController(text: DateTime.now().toIso8601String().substring(0, 10));
    final notesController = TextEditingController();
    var account = active.first;

    final saved = await showAppBottomSheet<bool>(
      context,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
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
              Text('Record payment', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<BusinessAccount>(
                initialValue: account,
                decoration: const InputDecoration(labelText: 'Paid from'),
                items: active.map((a) => DropdownMenuItem(value: a, child: Text(a.name))).toList(),
                onChanged: (v) => setSheetState(() => account = v ?? account),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Amount', controller: amountController, keyboardType: TextInputType.number),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Paid on (YYYY-MM-DD)', controller: dateController),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Notes (optional)', controller: notesController),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: 'Record payment',
                onPressed: () async {
                  final amount = amountController.text.trim();
                  if (amount.isEmpty) return;
                  try {
                    await ref.read(expensesRepositoryProvider).recordPayment(
                          spaceId,
                          expenseId,
                          businessAccountId: account.id,
                          amount: amount,
                          paidOn: dateController.text.trim(),
                          notes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
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
        ),
      ),
    );
    if (saved == true) {
      ref.invalidate(expenseDetailProvider(_key));
      ref.invalidate(expensePaymentsProvider(_key));
      ref.invalidate(expenseListProvider(spaceId));
    }
  }

  Future<void> _mapLedgerAccount(BuildContext context, WidgetRef ref, Expense expense) async {
    final ledgerAccounts = await ref.read(chartOfAccountsRepositoryProvider).listAccounts(spaceId);
    if (!context.mounted) return;
    if (ledgerAccounts.isEmpty) {
      context.push(AppRoutes.accountingChartOfAccounts(spaceId));
      return;
    }

    final candidates = ledgerAccounts.where((a) => a.type == LedgerAccountType.EXPENSE && !a.archived).toList();
    final selected = await showAppBottomSheet<_MappingChoice>(
      context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text('Map to ledger account', style: Theme.of(context).textTheme.titleLarge),
            ),
            ListTile(
              title: const Text('No mapping'),
              trailing: expense.chartOfAccountsId == null ? const Icon(Icons.check) : null,
              onTap: () => Navigator.of(context).pop((chartOfAccountsId: null)),
            ),
            if (candidates.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                child: Text('No EXPENSE accounts in the Chart of Accounts yet.'),
              )
            else
              for (final a in candidates)
                ListTile(
                  title: Text('${a.code} · ${a.name}'),
                  trailing: expense.chartOfAccountsId == a.id ? const Icon(Icons.check) : null,
                  onTap: () => Navigator.of(context).pop((chartOfAccountsId: a.id)),
                ),
          ],
        ),
      ),
    );
    if (selected == null) return;
    try {
      await ref.read(expensesRepositoryProvider).updateChartOfAccountsMapping(
            spaceId,
            expenseId,
            chartOfAccountsId: selected.chartOfAccountsId,
          );
      ref.invalidate(expenseDetailProvider(_key));
    } catch (e) {
      if (context.mounted) showErrorSnackBar(context, e is AppException ? e.message : 'Something went wrong.');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expense = ref.watch(expenseDetailProvider(_key));
    final payments = ref.watch(expensePaymentsProvider(_key));

    return Scaffold(
      appBar: AppBar(title: const Text('Expense')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(expenseDetailProvider(_key));
          ref.invalidate(expensePaymentsProvider(_key));
        },
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            expense.when(
              data: (e) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(e.category ?? 'Expense', style: Theme.of(context).textTheme.titleLarge),
                          Chip(
                            label: Text(e.status.name),
                            backgroundColor: expenseStatusColor(context, e.status).withValues(alpha: 0.15),
                          ),
                        ],
                      ),
                      Text(e.occurredOn, style: Theme.of(context).textTheme.bodySmall),
                      const Divider(height: AppSpacing.lg),
                      _row('Amount', e.amount),
                      _row('Paid', e.amountPaid),
                      _row('Remaining', e.amountRemaining),
                      if (e.notes != null) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Text(e.notes!),
                      ],
                      const SizedBox(height: AppSpacing.sm),
                      SecondaryButton(
                        label: e.chartOfAccountsId == null ? 'Map to ledger account' : 'Change ledger account mapping',
                        onPressed: () => _mapLedgerAccount(context, ref, e),
                      ),
                    ],
                  ),
                ),
              ),
              loading: () => const LoadingView(),
              error: (err, _) => ErrorView(error: err, onRetry: () => ref.invalidate(expenseDetailProvider(_key))),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Payment history', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            payments.when(
              data: (items) => items.isEmpty
                  ? const Padding(padding: EdgeInsets.symmetric(vertical: AppSpacing.lg), child: Text('No payments recorded yet.'))
                  : Column(
                      children: items
                          .map(
                            (p) => Card(
                              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                              child: ListTile(
                                title: Text('RM ${p.amount}'),
                                subtitle: Text(p.paidOn),
                              ),
                            ),
                          )
                          .toList(),
                    ),
              loading: () => const LoadingView(),
              error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(expensePaymentsProvider(_key))),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _recordPayment(context, ref),
        child: const Icon(Icons.payments_outlined),
      ),
    );
  }

  Widget _row(String label, String amount) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(label), Text('RM $amount')],
        ),
      );
}
