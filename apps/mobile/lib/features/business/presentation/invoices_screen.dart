import 'package:duitlah_mobile/core/theme/app_semantic_colors.dart';
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
import '../domain/catalog.dart';
import '../domain/contacts.dart';
import '../domain/sales.dart';
import 'widgets/line_items_editor.dart';

/// [InvoiceEffectiveStatus] is the one to show prominently — it's
/// server-computed and reflects PARTIALLY_PAID/PAID/OVERDUE, none of which
/// the client (or even the user) can ever set directly.
Color invoiceEffectiveStatusColor(BuildContext context, InvoiceEffectiveStatus status) {
  switch (status) {
    case InvoiceEffectiveStatus.PAID:
      return Theme.of(context).extension<AppSemanticColors>()!.success;
    case InvoiceEffectiveStatus.PARTIALLY_PAID:
      return Theme.of(context).extension<AppSemanticColors>()!.warning;
    case InvoiceEffectiveStatus.OVERDUE:
      return Theme.of(context).colorScheme.error;
    case InvoiceEffectiveStatus.VOID:
      return Theme.of(context).colorScheme.onSurfaceVariant;
    case InvoiceEffectiveStatus.SENT:
      return Theme.of(context).colorScheme.primary;
    case InvoiceEffectiveStatus.DRAFT:
      return Theme.of(context).colorScheme.onSurfaceVariant;
  }
}

class InvoicesScreen extends ConsumerWidget {
  const InvoicesScreen({super.key, required this.spaceId});

  final String spaceId;

  Future<void> _newInvoice(BuildContext context, WidgetRef ref) async {
    final saved = await showAppBottomSheet<bool>(
      context,
      builder: (context) => _InvoiceFormSheet(spaceId: spaceId),
    );
    if (saved == true) ref.invalidate(invoiceListProvider(spaceId));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoices = ref.watch(invoiceListProvider(spaceId));
    return Scaffold(
      appBar: AppBar(title: const Text('Invoices')),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(invoiceListProvider(spaceId)),
        child: invoices.when(
          data: (items) => items.isEmpty
              ? ListView(children: const [SizedBox(height: 80), EmptyView(icon: Icons.receipt_long_outlined, title: 'No invoices yet')])
              : ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final inv = items[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: ListTile(
                        title: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(inv.invoiceNumber),
                            if (inv.sourceRecurringInvoiceId != null) ...[
                              const SizedBox(width: AppSpacing.xs),
                              const DuitlahIcon(Icons.event_repeat_outlined, size: 14),
                            ],
                          ],
                        ),
                        subtitle: Text('Due ${inv.dueDate}'),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(Money.format(inv.total)),
                            Chip(
                              label: Text(inv.effectiveStatus.name, style: const TextStyle(fontSize: 11)),
                              backgroundColor: invoiceEffectiveStatusColor(context, inv.effectiveStatus).withValues(alpha: 0.15),
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                        onTap: () => context.push(AppRoutes.businessInvoiceDetail(spaceId, inv.id)),
                      ),
                    );
                  },
                ),
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(invoiceListProvider(spaceId))),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => _newInvoice(context, ref), child: const DuitlahIcon(Icons.add)),
    );
  }
}

class _InvoiceFormSheet extends ConsumerStatefulWidget {
  const _InvoiceFormSheet({required this.spaceId});

  final String spaceId;

  @override
  ConsumerState<_InvoiceFormSheet> createState() => _InvoiceFormSheetState();
}

class _InvoiceFormSheetState extends ConsumerState<_InvoiceFormSheet> {
  final _issueDateController = TextEditingController(text: DateTime.now().toIso8601String().substring(0, 10));
  final _dueDateController = TextEditingController(
    text: DateTime.now().add(const Duration(days: 30)).toIso8601String().substring(0, 10),
  );
  final _taxPercentController = TextEditingController(text: '0');
  final _notesController = TextEditingController();
  List<LineItemDraft> _lineItems = [LineItemDraft()];

  Customer? _customer;
  List<Customer> _customers = [];
  List<Product> _products = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final customers = await ref.read(contactsRepositoryProvider).listCustomers(widget.spaceId);
    final products = await ref.read(catalogRepositoryProvider).listProducts(widget.spaceId);
    if (!mounted) return;
    setState(() {
      _customers = customers;
      _products = products;
      _loading = false;
    });
  }

  Future<void> _submit() async {
    if (_customer == null || _lineItems.isEmpty) return;
    try {
      await ref.read(salesRepositoryProvider).createInvoice(
            widget.spaceId,
            customerId: _customer!.id,
            issueDate: _issueDateController.text.trim(),
            dueDate: _dueDateController.text.trim(),
            taxPercent: _taxPercentController.text.trim().isEmpty ? null : _taxPercentController.text.trim(),
            notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
            lineItems: _lineItems.map((e) => e.toInput()).toList(),
          );
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e is AppException ? e.message : 'Something went wrong.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: _loading
          ? const Padding(padding: EdgeInsets.all(AppSpacing.xxl), child: LoadingView())
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('New invoice', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<Customer>(
                    icon: const DuitlahIcon(Icons.expand_more, size: 18),
initialValue: _customer,
                    decoration: const InputDecoration(labelText: 'Customer'),
                    items: _customers.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
                    onChanged: (v) => setState(() => _customer = v),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppTextField(label: 'Issue date (YYYY-MM-DD)', controller: _issueDateController),
                  const SizedBox(height: AppSpacing.sm),
                  AppTextField(label: 'Due date (YYYY-MM-DD)', controller: _dueDateController),
                  const SizedBox(height: AppSpacing.sm),
                  AppTextField(label: 'Tax %', controller: _taxPercentController, keyboardType: TextInputType.number),
                  const SizedBox(height: AppSpacing.sm),
                  AppTextField(label: 'Notes (optional)', controller: _notesController),
                  const SizedBox(height: AppSpacing.md),
                  LineItemsEditor(
                    items: _lineItems,
                    products: _products,
                    onChanged: (items) => setState(() => _lineItems = items),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  PrimaryButton(label: 'Create invoice', onPressed: _customer == null ? null : _submit),
                ],
              ),
            ),
    );
  }
}
