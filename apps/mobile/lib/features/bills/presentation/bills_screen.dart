import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/dialogs.dart';
import '../../accounts/application/finance_providers.dart';
import '../../accounts/domain/finance.dart';
import '../../receipts/application/receipt_vault_providers.dart';
import '../application/bills_providers.dart';
import '../domain/personal_bill.dart';

/// Personal Bills (spec section 16) — distinct from Recurring & Subscriptions: a bill is a
/// due-date-tracked obligation with its own payment history, not a schedule that silently
/// materializes transactions on its own.
class BillsScreen extends ConsumerWidget {
  const BillsScreen({super.key});

  Color _statusColor(BuildContext context, BillStatus status) {
    final semantic = context.semanticColors;
    return switch (status) {
      BillStatus.PAID => semantic.success,
      BillStatus.DUE => semantic.warning,
      BillStatus.OVERDUE => Theme.of(context).colorScheme.error,
      BillStatus.UPCOMING => Theme.of(context).colorScheme.onSurfaceVariant,
      BillStatus.SKIPPED => Theme.of(context).colorScheme.onSurfaceVariant,
    };
  }

  Future<void> _addBill(BuildContext context, WidgetRef ref) async {
    final nameController = TextEditingController();
    final providerController = TextEditingController();
    final amountController = TextEditingController();
    DateTime dueDate = DateTime.now().add(const Duration(days: 7));
    var recurrence = BillRecurrence.NONE;

    final added = await showAppBottomSheet<bool>(
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
              Text('New bill', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              AppTextField(label: 'Name', controller: nameController),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Provider (optional)', controller: providerController),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Expected amount (RM)', controller: amountController, keyboardType: TextInputType.number),
              const SizedBox(height: AppSpacing.sm),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Due: ${dueDate.toIso8601String().split('T').first}'),
                trailing: const DuitlahIcon(Icons.calendar_month_outlined),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: dueDate,
                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
                  );
                  if (picked != null) setSheetState(() => dueDate = picked);
                },
              ),
              DropdownButtonFormField<BillRecurrence>(
                icon: const DuitlahIcon(Icons.expand_more, size: 18),
initialValue: recurrence,
                decoration: const InputDecoration(labelText: 'Repeats'),
                items: BillRecurrence.values
                    .map((r) => DropdownMenuItem(value: r, child: Text(r.name)))
                    .toList(),
                onChanged: (v) => setSheetState(() => recurrence = v ?? recurrence),
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: 'Create',
                onPressed: () async {
                  try {
                    await ref.read(personalBillRepositoryProvider).create(
                          name: nameController.text.trim(),
                          provider: providerController.text.trim().isEmpty ? null : providerController.text.trim(),
                          dueDate: dueDate.toIso8601String().split('T').first,
                          expectedAmount: amountController.text.trim(),
                          recurrence: recurrence,
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
    if (added == true) ref.invalidate(personalBillListProvider);
  }

  Future<void> _attachReceipt(BuildContext context, WidgetRef ref, PersonalBill bill) async {
    final receipts = await ref.read(receiptVaultRepositoryProvider).search();
    if (!context.mounted) return;
    if (receipts.isEmpty) {
      showErrorSnackBar(context, 'No receipts in your vault yet.');
      return;
    }
    final selected = await showAppBottomSheet<String>(
      context,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: receipts
            .map(
              (r) => ListTile(
                title: Text(r.merchant ?? 'Unknown merchant'),
                subtitle: Text(r.receiptDate ?? ''),
                onTap: () => Navigator.of(context).pop(r.id),
              ),
            )
            .toList(),
      ),
    );
    if (selected == null) return;
    try {
      await ref.read(personalBillRepositoryProvider).attachReceipt(bill.id, selected);
      ref.invalidate(personalBillListProvider);
      if (context.mounted) showSuccessSnackBar(context, 'Receipt attached.');
    } catch (e) {
      if (context.mounted) showErrorSnackBar(context, e is AppException ? e.message : 'Something went wrong.');
    }
  }

  Future<void> _markPaid(BuildContext context, WidgetRef ref, PersonalBill bill, List<Account> accounts) async {
    if (accounts.isEmpty) {
      showErrorSnackBar(context, 'Add an account first.');
      return;
    }
    final amountController = TextEditingController(text: bill.expectedAmount);
    String accountId = accounts.first.id;

    final paid = await showAppBottomSheet<bool>(
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
              Text('Mark "${bill.name}" as paid', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String>(
                icon: const DuitlahIcon(Icons.expand_more, size: 18),
initialValue: accountId,
                decoration: const InputDecoration(labelText: 'Paid from'),
                items: accounts.map((a) => DropdownMenuItem(value: a.id, child: Text(a.name))).toList(),
                onChanged: (v) => setSheetState(() => accountId = v ?? accountId),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Amount (RM)', controller: amountController, keyboardType: TextInputType.number),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: 'Confirm payment',
                onPressed: () async {
                  try {
                    await ref.read(personalBillRepositoryProvider).markPaid(
                          bill.id,
                          accountId: accountId,
                          amount: amountController.text.trim(),
                          paidOn: DateTime.now().toIso8601String().split('T').first,
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
    if (paid == true) {
      ref.invalidate(personalBillListProvider);
      ref.invalidate(dashboardProvider);
      ref.invalidate(transactionsProvider);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bills = ref.watch(personalBillListProvider);
    final accounts = ref.watch(accountListProvider).valueOrNull ?? const [];

    return Scaffold(
      appBar: AppBar(title: const Text('Bills')),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(personalBillListProvider),
        child: bills.when(
          data: (items) => items.isEmpty
              ? ListView(
                  children: const [
                    SizedBox(height: 80),
                    EmptyView(icon: Icons.receipt_outlined, title: 'No bills tracked yet'),
                  ],
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final bill = items[index];
                    final resolved = bill.status == BillStatus.PAID || bill.status == BillStatus.SKIPPED;
                    return Card(
                      child: ListTile(
                        title: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(bill.name),
                            if (bill.receiptId != null) ...[
                              const SizedBox(width: AppSpacing.xs),
                              const DuitlahIcon(Icons.attach_file, size: 14),
                            ],
                          ],
                        ),
                        subtitle: Text('Due ${bill.dueDate} · RM ${bill.expectedAmount}'),
                        trailing: resolved
                            ? Chip(label: Text(bill.status.name), backgroundColor: _statusColor(context, bill.status).withValues(alpha: 0.15))
                            : PopupMenuButton<String>(
                                onSelected: (value) async {
                                  if (value == 'pay') {
                                    await _markPaid(context, ref, bill, accounts);
                                  } else if (value == 'skip') {
                                    await ref.read(personalBillRepositoryProvider).skip(bill.id);
                                    ref.invalidate(personalBillListProvider);
                                  } else if (value == 'attach') {
                                    await _attachReceipt(context, ref, bill);
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(value: 'pay', child: Text('Mark paid')),
                                  const PopupMenuItem(value: 'skip', child: Text('Skip')),
                                  PopupMenuItem(
                                    value: 'attach',
                                    child: Text(bill.receiptId == null ? 'Attach receipt' : 'Replace receipt'),
                                  ),
                                ],
                                child: Chip(
                                  label: Text(bill.status.name),
                                  backgroundColor: _statusColor(context, bill.status).withValues(alpha: 0.15),
                                ),
                              ),
                      ),
                    );
                  },
                ),
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(personalBillListProvider)),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => _addBill(context, ref), child: const DuitlahIcon(Icons.add)),
    );
  }
}
