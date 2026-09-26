import 'package:duitlah_mobile/core/widgets/app_adaptive_row.dart';
import 'package:duitlah_mobile/core/widgets/app_page_body.dart';
import 'package:duitlah_mobile/core/widgets/app_field_group.dart';
import 'package:duitlah_mobile/core/utils/money.dart';
import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
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
import '../application/business_providers.dart';
import '../domain/banking.dart';
import '../domain/sales.dart';
import 'invoices_screen.dart' show invoiceEffectiveStatusColor;
import 'widgets/einvoice_section.dart';

class InvoiceDetailScreen extends ConsumerWidget {
  const InvoiceDetailScreen({
    super.key,
    required this.spaceId,
    required this.invoiceId,
  });

  final String spaceId;
  final String invoiceId;

  SpaceResourceKey get _key => (spaceId: spaceId, resourceId: invoiceId);

  /// Only DRAFT/SENT/VOID are ever settable directly — PARTIALLY_PAID/PAID/
  /// OVERDUE only ever appear on [Invoice.effectiveStatus], server-computed
  /// from payments and the due date.
  Future<void> _changeStatus(
    BuildContext context,
    WidgetRef ref,
    InvoiceStatus current,
  ) async {
    final status = await showAppBottomSheet<InvoiceStatus>(
      context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: InvoiceStatus.values
            .map(
              (s) => ListTile(
                title: Text(s.name),
                trailing: s == current ? const DuitlahIcon(Icons.check) : null,
                onTap: () => Navigator.of(context).pop(s),
              ),
            )
            .toList(),
      ),
    );
    if (status == null || status == current) return;
    try {
      await ref
          .read(salesRepositoryProvider)
          .changeInvoiceStatus(spaceId, invoiceId, status);
      ref.invalidate(invoiceDetailProvider(_key));
      ref.invalidate(invoiceListProvider(spaceId));
    } catch (e) {
      if (context.mounted) {
        showErrorSnackBar(
          context,
          e is AppException ? e.message : 'Something went wrong.',
        );
      }
    }
  }

  Future<void> _recordPayment(BuildContext context, WidgetRef ref) async {
    final accounts = await ref
        .read(bankingRepositoryProvider)
        .listAccounts(spaceId);
    final active = accounts.where((a) => !a.archived).toList();
    if (!context.mounted) return;
    if (active.isEmpty) {
      showErrorSnackBar(context, 'Add a business account first.');
      return;
    }

    final amountController = TextEditingController();
    final dateController = TextEditingController(
      text: DateTime.now().toIso8601String().substring(0, 10),
    );
    final notesController = TextEditingController();
    var account = active.first;

    final saved = await showAppBottomSheet<bool>(
      context,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: EdgeInsets.only(
              left: AppSpacing.pageMargin,
              right: AppSpacing.pageMargin,
              top: AppSpacing.lg,
              bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Record payment',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.md),
                AppFieldGroup(
                  label: 'Paid into',
                  child: DropdownButtonFormField<BusinessAccount>(
                    itemHeight: null,
                    isExpanded: true,
                    icon: const DuitlahIcon(Icons.expand_more, size: 18),
                    initialValue: account,
                    decoration: const InputDecoration(),
                    items: active
                        .map(
                          (a) =>
                              DropdownMenuItem(value: a, child: Text(a.name)),
                        )
                        .toList(),
                    onChanged: (v) =>
                        setSheetState(() => account = v ?? account),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(
                  label: 'Amount',
                  controller: amountController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(
                  label: 'Paid on (YYYY-MM-DD)',
                  controller: dateController,
                ),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(
                  label: 'Notes (optional)',
                  controller: notesController,
                ),
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(
                  label: 'Record payment',
                  onPressed: () async {
                    final amount = amountController.text.trim();
                    if (amount.isEmpty) return;
                    try {
                      await ref
                          .read(salesRepositoryProvider)
                          .recordInvoicePayment(
                            spaceId,
                            invoiceId,
                            businessAccountId: account.id,
                            amount: amount,
                            paidOn: dateController.text.trim(),
                            notes: notesController.text.trim().isEmpty
                                ? null
                                : notesController.text.trim(),
                          );
                      if (context.mounted) Navigator.of(context).pop(true);
                    } catch (e) {
                      if (context.mounted) {
                        final message =
                            e is AppException && e.code == 'INVOICE_VOID'
                            ? 'This invoice is void and cannot take payments.'
                            : (e is AppException
                                  ? e.message
                                  : 'Something went wrong.');
                        showErrorSnackBar(context, message);
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (saved == true) {
      ref.invalidate(invoiceDetailProvider(_key));
      ref.invalidate(invoicePaymentsProvider(_key));
      ref.invalidate(invoiceListProvider(spaceId));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoice = ref.watch(invoiceDetailProvider(_key));
    final payments = ref.watch(invoicePaymentsProvider(_key));

    return Scaffold(
      appBar: AppBar(
        title: Text(invoice.valueOrNull?.invoiceNumber ?? 'Invoice'),
        actions: [
          if (invoice.valueOrNull != null)
            TextButton(
              onPressed: () =>
                  _changeStatus(context, ref, invoice.value!.status),
              child: const Text('Status'),
            ),
        ],
      ),
      body: AppPageBody(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(invoiceDetailProvider(_key));
            ref.invalidate(invoicePaymentsProvider(_key));
          },
          child: invoice.when(
            data: (inv) => ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: AppSpacing.scrollInsets(context, floatingAction: true),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppAdaptiveRow(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              inv.invoiceNumber,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Chip(
                              label: Text(inv.effectiveStatus.name),
                              backgroundColor: invoiceEffectiveStatusColor(
                                context,
                                inv.effectiveStatus,
                              ).withValues(alpha: 0.15),
                            ),
                          ],
                        ),
                        Text(
                          'Issued ${inv.issueDate} · Due ${inv.dueDate}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const Divider(height: AppSpacing.lg),
                        ...inv.lineItems.map(
                          (li) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${li.description} × ${li.quantity}',
                                  ),
                                ),
                                Flexible(
                                  child: Text(Money.format(li.lineTotal)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(height: AppSpacing.lg),
                        _row('Subtotal', inv.subtotal),
                        _row('Tax (${inv.taxPercent}%)', inv.taxAmount),
                        _row('Total', inv.total, bold: true),
                        const Divider(height: AppSpacing.lg),
                        _row('Paid', inv.amountPaid),
                        _row('Credited', inv.amountCredited),
                        _row('Outstanding', inv.amountOutstanding, bold: true),
                        if (inv.notes != null) ...[
                          const SizedBox(height: AppSpacing.sm),
                          Text(inv.notes!),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        label: 'Issue credit note',
                        onPressed: () => context.push(
                          AppRoutes.businessCreditNotes(spaceId),
                          extra: {
                            'customerId': inv.customerId,
                            'invoiceId': inv.id,
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                EInvoiceSection(spaceId: spaceId, invoiceId: inv.id),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Payment history',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                payments.when(
                  data: (items) => items.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: AppSpacing.lg,
                          ),
                          child: Text('No payments recorded yet.'),
                        )
                      : Column(
                          children: items
                              .map(
                                (p) => Card(
                                  margin: const EdgeInsets.only(
                                    bottom: AppSpacing.sm,
                                  ),
                                  child: ListTile(
                                    title: Text(Money.format(p.amount)),
                                    subtitle: Text(p.paidOn),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                  loading: () => const LoadingView(),
                  error: (e, _) => ErrorView(
                    error: e,
                    onRetry: () =>
                        ref.invalidate(invoicePaymentsProvider(_key)),
                  ),
                ),
              ],
            ),
            loading: () => const LoadingView(),
            error: (e, _) => ErrorView(
              error: e,
              onRetry: () => ref.invalidate(invoiceDetailProvider(_key)),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _recordPayment(context, ref),
        child: const DuitlahIcon(Icons.payments_outlined),
      ),
    );
  }

  Widget _row(String label, String amount, {bool bold = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: AppAdaptiveRow(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: bold ? const TextStyle(fontWeight: FontWeight.bold) : null,
        ),
        Text(
          Money.format(amount),
          style: bold ? const TextStyle(fontWeight: FontWeight.bold) : null,
        ),
      ],
    ),
  );
}
