import 'package:duitlah_mobile/core/widgets/app_adaptive_row.dart';
import 'package:duitlah_mobile/core/widgets/app_page_body.dart';
import 'package:duitlah_mobile/core/widgets/app_field_group.dart';
import 'package:duitlah_mobile/core/theme/duitlah_colors.dart';
import 'package:duitlah_mobile/core/utils/money.dart';
import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/dialogs.dart';
import '../application/business_providers.dart';
import '../domain/contacts.dart';
import '../domain/sales.dart';

Color creditNoteStatusColor(BuildContext context, CreditNoteStatus status) {
  return status == CreditNoteStatus.VOID
      ? Theme.of(context).colorScheme.error
      : context.duitlahColors.positive;
}

/// Reachable both standalone (from the business dashboard) and from an
/// invoice's detail screen, which pre-fills [prefillCustomerId] and
/// [prefillInvoiceId] so the "issue credit note" flow doesn't ask the user
/// to re-pick a customer/invoice they already navigated from.
class CreditNotesScreen extends ConsumerWidget {
  const CreditNotesScreen({
    super.key,
    required this.spaceId,
    this.prefillCustomerId,
    this.prefillInvoiceId,
  });

  final String spaceId;
  final String? prefillCustomerId;
  final String? prefillInvoiceId;

  Future<void> _newCreditNote(BuildContext context, WidgetRef ref) async {
    final customers = await ref
        .read(contactsRepositoryProvider)
        .listCustomers(spaceId);
    if (!context.mounted) return;

    final amountController = TextEditingController();
    final issueDateController = TextEditingController(
      text: DateTime.now().toIso8601String().substring(0, 10),
    );
    final reasonController = TextEditingController();
    Customer? customer;
    if (prefillCustomerId != null) {
      final matches = customers.where((c) => c.id == prefillCustomerId);
      customer = matches.isEmpty ? null : matches.first;
    }

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
                  'New credit note',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.md),
                AppFieldGroup(
                  label: 'Customer',
                  child: DropdownButtonFormField<Customer>(
                    itemHeight: null,
                    isExpanded: true,
                    icon: const DuitlahIcon(Icons.expand_more, size: 18),
                    initialValue: customer,
                    decoration: const InputDecoration(),
                    items: customers
                        .map(
                          (c) =>
                              DropdownMenuItem(value: c, child: Text(c.name)),
                        )
                        .toList(),
                    onChanged: (v) => setSheetState(() => customer = v),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(
                  label: 'Issue date (YYYY-MM-DD)',
                  controller: issueDateController,
                ),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(
                  label: 'Amount',
                  controller: amountController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(
                  label: 'Reason (optional)',
                  controller: reasonController,
                ),
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(
                  label: 'Issue credit note',
                  onPressed: customer == null
                      ? null
                      : () async {
                          final amount = amountController.text.trim();
                          if (amount.isEmpty) return;
                          try {
                            await ref
                                .read(salesRepositoryProvider)
                                .createCreditNote(
                                  spaceId,
                                  customerId: customer!.id,
                                  invoiceId: prefillInvoiceId,
                                  issueDate: issueDateController.text.trim(),
                                  amount: amount,
                                  reason: reasonController.text.trim().isEmpty
                                      ? null
                                      : reasonController.text.trim(),
                                );
                            if (context.mounted) {
                              Navigator.of(context).pop(true);
                            }
                          } catch (e) {
                            if (context.mounted) {
                              showErrorSnackBar(
                                context,
                                e is AppException
                                    ? e.message
                                    : 'Something went wrong.',
                              );
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
    if (saved == true) ref.invalidate(creditNoteListProvider(spaceId));
  }

  Future<void> _void(BuildContext context, WidgetRef ref, String id) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Void credit note?',
      message: 'This cannot be undone.',
      confirmLabel: 'Void',
      destructive: true,
    );
    if (!confirmed) return;
    try {
      await ref.read(salesRepositoryProvider).voidCreditNote(spaceId, id);
      ref.invalidate(creditNoteListProvider(spaceId));
    } catch (e) {
      if (context.mounted) {
        showErrorSnackBar(
          context,
          e is AppException ? e.message : 'Something went wrong.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creditNotes = ref.watch(creditNoteListProvider(spaceId));
    return Scaffold(
      appBar: AppBar(title: const Text('Credit Notes')),
      body: AppPageBody(
        child: RefreshIndicator(
          onRefresh: () async =>
              ref.invalidate(creditNoteListProvider(spaceId)),
          child: creditNotes.when(
            data: (items) => items.isEmpty
                ? ListView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    children: const [
                      SizedBox(height: 80),
                      EmptyView(
                        icon: Icons.assignment_return_outlined,
                        title: 'No credit notes yet',
                      ),
                    ],
                  )
                : ListView.builder(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: AppSpacing.scrollInsets(
                      context,
                      floatingAction: true,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final cn = items[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: AppRecordTile(
                          title: Text(cn.creditNoteNumber),
                          subtitle: Text(cn.issueDate),
                          // Wraps rather than overflows once the tile stacks
                          // its trailing content on a narrow or scaled screen.
                          trailing: Wrap(
                            spacing: AppSpacing.sm,
                            runSpacing: AppSpacing.xs,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(Money.format(cn.amount)),
                              Chip(
                                label: Text(
                                  cn.status.name,
                                  style: const TextStyle(fontSize: 11),
                                ),
                                backgroundColor: creditNoteStatusColor(
                                  context,
                                  cn.status,
                                ).withValues(alpha: 0.15),
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                              ),
                              if (cn.status == CreditNoteStatus.ISSUED)
                                IconButton(
                                  icon: const DuitlahIcon(Icons.block),
                                  onPressed: () => _void(context, ref, cn.id),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            loading: () => const LoadingView(),
            error: (e, _) => ErrorView(
              error: e,
              onRetry: () => ref.invalidate(creditNoteListProvider(spaceId)),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _newCreditNote(context, ref),
        child: const DuitlahIcon(Icons.add),
      ),
    );
  }
}
