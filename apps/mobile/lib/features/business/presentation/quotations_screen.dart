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

Color quotationStatusColor(BuildContext context, QuotationStatus status) {
  switch (status) {
    case QuotationStatus.ACCEPTED:
      return Theme.of(context).extension<AppSemanticColors>()!.success;
    case QuotationStatus.DECLINED:
    case QuotationStatus.EXPIRED:
      return Theme.of(context).colorScheme.error;
    case QuotationStatus.SENT:
      return Theme.of(context).colorScheme.primary;
    case QuotationStatus.DRAFT:
      return Theme.of(context).colorScheme.onSurfaceVariant;
  }
}

class QuotationsScreen extends ConsumerWidget {
  const QuotationsScreen({super.key, required this.spaceId});

  final String spaceId;

  Future<void> _newQuotation(BuildContext context, WidgetRef ref) async {
    final saved = await showAppBottomSheet<bool>(
      context,
      builder: (context) => _QuotationFormSheet(spaceId: spaceId),
    );
    if (saved == true) ref.invalidate(quotationListProvider(spaceId));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quotations = ref.watch(quotationListProvider(spaceId));
    return Scaffold(
      appBar: AppBar(title: const Text('Quotations')),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(quotationListProvider(spaceId)),
        child: quotations.when(
          data: (items) => items.isEmpty
              ? ListView(children: const [SizedBox(height: 80), EmptyView(icon: Icons.description_outlined, title: 'No quotations yet')])
              : ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final q = items[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: ListTile(
                        title: Text(q.quoteNumber),
                        subtitle: Text(q.issueDate),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(Money.format(q.total)),
                            Chip(
                              label: Text(q.status.name, style: const TextStyle(fontSize: 11)),
                              backgroundColor: quotationStatusColor(context, q.status).withValues(alpha: 0.15),
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                        onTap: () => context.push(AppRoutes.businessQuotationDetail(spaceId, q.id)),
                      ),
                    );
                  },
                ),
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(quotationListProvider(spaceId))),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => _newQuotation(context, ref), child: const DuitlahIcon(Icons.add)),
    );
  }
}

class _QuotationFormSheet extends ConsumerStatefulWidget {
  const _QuotationFormSheet({required this.spaceId});

  final String spaceId;

  @override
  ConsumerState<_QuotationFormSheet> createState() => _QuotationFormSheetState();
}

class _QuotationFormSheetState extends ConsumerState<_QuotationFormSheet> {
  final _issueDateController = TextEditingController(text: DateTime.now().toIso8601String().substring(0, 10));
  final _expiryDateController = TextEditingController();
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
      await ref.read(salesRepositoryProvider).createQuotation(
            widget.spaceId,
            customerId: _customer!.id,
            issueDate: _issueDateController.text.trim(),
            expiryDate: _expiryDateController.text.trim().isEmpty ? null : _expiryDateController.text.trim(),
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
                  Text('New quotation', style: Theme.of(context).textTheme.titleLarge),
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
                  AppTextField(label: 'Expiry date (optional)', controller: _expiryDateController),
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
                  PrimaryButton(label: 'Create quotation', onPressed: _customer == null ? null : _submit),
                ],
              ),
            ),
    );
  }
}
