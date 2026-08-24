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
import '../../receipts/application/receipts_providers.dart';

class _EditableItem {
  _EditableItem({String? name, String? quantity, String? unitPrice, this.confidence = 1})
      : nameController = TextEditingController(text: name ?? ''),
        quantityController = TextEditingController(text: quantity ?? '1'),
        unitPriceController = TextEditingController(text: unitPrice ?? '0.00');

  final TextEditingController nameController;
  final TextEditingController quantityController;
  final TextEditingController unitPriceController;
  final double confidence;
}

/// "Never trust OCR completely" (docs/bagilah-engine.md) applies here as
/// much as on the web: every field the model extracted is editable, and
/// confirming sends a fully independent payload built from whatever this
/// form currently holds — nothing from the original scan is silently
/// re-merged in.
class ReceiptReviewScreen extends ConsumerStatefulWidget {
  const ReceiptReviewScreen({super.key, required this.scanId});

  final String scanId;

  @override
  ConsumerState<ReceiptReviewScreen> createState() => _ReceiptReviewScreenState();
}

class _ReceiptReviewScreenState extends ConsumerState<ReceiptReviewScreen> {
  final _merchantController = TextEditingController();
  final _taxController = TextEditingController(text: '0.00');
  final _serviceController = TextEditingController(text: '0.00');
  final _discountController = TextEditingController(text: '0.00');
  DateTime _date = DateTime.now();
  final List<_EditableItem> _items = [];
  bool _initialized = false;
  bool _submitting = false;

  void _initFromScan(dynamic scan) {
    if (_initialized) return;
    _initialized = true;
    final parsed = scan.parsedReceipt;
    _merchantController.text = parsed.merchant ?? '';
    _taxController.text = parsed.tax ?? '0.00';
    _serviceController.text = parsed.serviceCharge ?? '0.00';
    _discountController.text = parsed.discount ?? '0.00';
    if (parsed.receiptDate != null) {
      _date = DateTime.tryParse(parsed.receiptDate as String) ?? DateTime.now();
    }
    for (final item in parsed.items) {
      _items.add(_EditableItem(
        name: item.name,
        quantity: item.quantity,
        unitPrice: item.unitPrice,
        confidence: item.confidence,
      ));
    }
    if (_items.isEmpty) _items.add(_EditableItem());
  }

  Future<void> _confirm() async {
    setState(() => _submitting = true);
    try {
      final result = await ref.read(receiptScanRepositoryProvider).confirm(
            widget.scanId,
            merchant: _merchantController.text.trim(),
            receiptDate: _date.toIso8601String().split('T').first,
            items: _items
                .where((i) => i.nameController.text.trim().isNotEmpty)
                .map((i) => {
                      'name': i.nameController.text.trim(),
                      'quantity': i.quantityController.text.trim(),
                      'unitPrice': i.unitPriceController.text.trim(),
                    })
                .toList(),
            tax: _taxController.text.trim().isEmpty ? '0' : _taxController.text.trim(),
            serviceCharge: _serviceController.text.trim().isEmpty ? '0' : _serviceController.text.trim(),
            discount: _discountController.text.trim().isEmpty ? '0' : _discountController.text.trim(),
          );
      final billId = result['billId'] as String? ?? result['id'] as String;
      if (mounted) context.pushReplacement(AppRoutes.bagilahDetail(billId));
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e is AppException ? e.message : 'Something went wrong.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  void dispose() {
    _merchantController.dispose();
    _taxController.dispose();
    _serviceController.dispose();
    _discountController.dispose();
    for (final item in _items) {
      item.nameController.dispose();
      item.quantityController.dispose();
      item.unitPriceController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scanAsync = ref.watch(receiptScanForReviewProvider(widget.scanId));
    return Scaffold(
      appBar: AppBar(title: const Text('Review receipt')),
      body: scanAsync.when(
        data: (scan) {
          _initFromScan(scan);
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              if (scan.needsReview) ...[
                _needsReviewBanner(),
                const SizedBox(height: AppSpacing.md),
              ],
              AppTextField(label: 'Merchant', controller: _merchantController),
              const SizedBox(height: AppSpacing.md),
              OutlinedButton.icon(
                icon: const Icon(Icons.calendar_today_outlined),
                label: Text(_date.toIso8601String().split('T').first),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _date,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) setState(() => _date = picked);
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('Items', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              for (var i = 0; i < _items.length; i++) _buildItemRow(i),
              TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add item'),
                onPressed: () => setState(() => _items.add(_EditableItem())),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(child: AppTextField(label: 'Tax', controller: _taxController, keyboardType: TextInputType.number)),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: AppTextField(label: 'Service', controller: _serviceController, keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Discount', controller: _discountController, keyboardType: TextInputType.number),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(label: 'Create bill from this receipt', onPressed: _confirm, loading: _submitting),
            ],
          );
        },
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(error: e),
      ),
    );
  }

  Widget _needsReviewBanner() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.4)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: Colors.orange, size: 20),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Double-check this scan — some details look uncertain, so review every field before confirming.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(int index) {
    final item = _items[index];
    final lowConfidence = item.confidence < 0.6;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: AppTextField(
              label: lowConfidence ? 'Name (double-check)' : 'Name',
              controller: item.nameController,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: AppTextField(label: 'Qty', controller: item.quantityController, keyboardType: TextInputType.number),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            flex: 2,
            child: AppTextField(label: 'Price', controller: item.unitPriceController, keyboardType: TextInputType.number),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () => setState(() => _items.removeAt(index)),
          ),
        ],
      ),
    );
  }
}
