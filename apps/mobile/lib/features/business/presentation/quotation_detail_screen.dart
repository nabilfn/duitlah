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
import '../domain/sales.dart';
import 'quotations_screen.dart' show quotationStatusColor;

class QuotationDetailScreen extends ConsumerWidget {
  const QuotationDetailScreen({super.key, required this.spaceId, required this.quotationId});

  final String spaceId;
  final String quotationId;

  SpaceResourceKey get _key => (spaceId: spaceId, resourceId: quotationId);

  Future<void> _changeStatus(BuildContext context, WidgetRef ref, QuotationStatus current) async {
    final status = await showAppBottomSheet<QuotationStatus>(
      context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: QuotationStatus.values
            .map((s) => ListTile(
                  title: Text(s.name),
                  trailing: s == current ? const Icon(Icons.check) : null,
                  onTap: () => Navigator.of(context).pop(s),
                ))
            .toList(),
      ),
    );
    if (status == null || status == current) return;
    try {
      await ref.read(salesRepositoryProvider).changeQuotationStatus(spaceId, quotationId, status);
      ref.invalidate(quotationDetailProvider(_key));
      ref.invalidate(quotationListProvider(spaceId));
    } catch (e) {
      if (context.mounted) showErrorSnackBar(context, e is AppException ? e.message : 'Something went wrong.');
    }
  }

  Future<void> _convertToInvoice(BuildContext context, WidgetRef ref) async {
    final dueDateController = TextEditingController(text: DateTime.now().toIso8601String().substring(0, 10));
    final confirmed = await showAppBottomSheet<bool>(
      context,
      builder: (context) => Padding(
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
            Text('Convert to invoice', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            AppTextField(label: 'Due date (YYYY-MM-DD)', controller: dueDateController),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(label: 'Convert', onPressed: () => Navigator.of(context).pop(true)),
          ],
        ),
      ),
    );
    if (confirmed != true) return;
    try {
      final invoice = await ref
          .read(salesRepositoryProvider)
          .convertToInvoice(spaceId, quotationId, dueDate: dueDateController.text.trim());
      ref.invalidate(quotationDetailProvider(_key));
      ref.invalidate(invoiceListProvider(spaceId));
      if (context.mounted) {
        context.pushReplacement(AppRoutes.businessInvoiceDetail(spaceId, invoice.id));
      }
    } catch (e) {
      if (context.mounted) {
        final message = e is AppException && e.code == 'QUOTATION_NOT_ACCEPTED'
            ? 'Accept the quotation first before converting it to an invoice.'
            : (e is AppException ? e.message : 'Something went wrong.');
        showErrorSnackBar(context, message);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quotation = ref.watch(quotationDetailProvider(_key));
    return Scaffold(
      appBar: AppBar(
        title: Text(quotation.valueOrNull?.quoteNumber ?? 'Quotation'),
        actions: [
          if (quotation.valueOrNull != null)
            TextButton(
              onPressed: () => _changeStatus(context, ref, quotation.value!.status),
              child: const Text('Status', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(quotationDetailProvider(_key)),
        child: quotation.when(
          data: (q) => ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(q.quoteNumber, style: Theme.of(context).textTheme.titleLarge),
                          Chip(
                            label: Text(q.status.name),
                            backgroundColor: quotationStatusColor(context, q.status).withValues(alpha: 0.15),
                          ),
                        ],
                      ),
                      Text('Issued ${q.issueDate}${q.expiryDate != null ? ' · Expires ${q.expiryDate}' : ''}',
                          style: Theme.of(context).textTheme.bodySmall),
                      const Divider(height: AppSpacing.lg),
                      ...q.lineItems.map(
                        (li) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Expanded(child: Text('${li.description} × ${li.quantity}')),
                              Text('RM ${li.lineTotal}'),
                            ],
                          ),
                        ),
                      ),
                      const Divider(height: AppSpacing.lg),
                      _row('Subtotal', q.subtotal),
                      _row('Tax (${q.taxPercent}%)', q.taxAmount),
                      _row('Total', q.total, bold: true),
                      if (q.notes != null) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Text(q.notes!),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (q.status == QuotationStatus.ACCEPTED)
                PrimaryButton(label: 'Convert to invoice', onPressed: () => _convertToInvoice(context, ref)),
            ],
          ),
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(quotationDetailProvider(_key))),
        ),
      ),
    );
  }

  Widget _row(String label, String amount, {bool bold = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: bold ? const TextStyle(fontWeight: FontWeight.bold) : null),
            Text('RM $amount', style: bold ? const TextStyle(fontWeight: FontWeight.bold) : null),
          ],
        ),
      );
}
