import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/sales_repository.dart';
import '../../domain/catalog.dart';

/// One row being edited in [LineItemsEditor] — kept separate from
/// [LineItemInput] since it owns live [TextEditingController]s while a row
/// is being edited, whereas [LineItemInput] is the plain immutable value
/// sent to the server.
class LineItemDraft {
  LineItemDraft({this.product, String description = '', String quantity = '1', String unitPrice = ''})
      : descriptionController = TextEditingController(text: description),
        quantityController = TextEditingController(text: quantity),
        unitPriceController = TextEditingController(text: unitPrice);

  Product? product;
  final TextEditingController descriptionController;
  final TextEditingController quantityController;
  final TextEditingController unitPriceController;

  double get lineTotal {
    final qty = double.tryParse(quantityController.text.trim()) ?? 0;
    final price = double.tryParse(unitPriceController.text.trim()) ?? 0;
    return qty * price;
  }

  LineItemInput toInput() => LineItemInput(
        productId: product?.id,
        description: descriptionController.text.trim(),
        quantity: quantityController.text.trim(),
        unitPrice: unitPriceController.text.trim(),
      );
}

/// Dynamic quotation/invoice line-item rows: a product picker (optional,
/// auto-fills description/unit price when chosen), free-text description,
/// quantity, unit price, plus a running total — shared verbatim between the
/// quotation and invoice creation forms since the backend line-item input
/// shape is identical for both.
class LineItemsEditor extends StatelessWidget {
  const LineItemsEditor({
    super.key,
    required this.items,
    required this.products,
    required this.onChanged,
  });

  final List<LineItemDraft> items;
  final List<Product> products;
  final ValueChanged<List<LineItemDraft>> onChanged;

  double get total => items.fold(0, (sum, item) => sum + item.lineTotal);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < items.length; i++) _line(context, i),
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton.icon(
          onPressed: () => onChanged([...items, LineItemDraft()]),
          icon: const DuitlahIcon(Icons.add),
          label: const Text('Add line item'),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Lines total', style: Theme.of(context).textTheme.titleSmall),
            Text(total.toStringAsFixed(2), style: Theme.of(context).textTheme.titleSmall),
          ],
        ),
      ],
    );
  }

  Widget _line(BuildContext context, int index) {
    final item = items[index];
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<Product?>(
                  icon: const DuitlahIcon(Icons.expand_more, size: 18),
initialValue: item.product,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Product (optional)'),
                  items: [
                    const DropdownMenuItem<Product?>(value: null, child: Text('Custom line')),
                    ...products.map((p) => DropdownMenuItem<Product?>(value: p, child: Text(p.name))),
                  ],
                  onChanged: (p) {
                    item.product = p;
                    if (p != null) {
                      item.descriptionController.text = p.name;
                      item.unitPriceController.text = p.unitPrice;
                    }
                    onChanged(items);
                  },
                ),
              ),
              IconButton(
                icon: const DuitlahIcon(Icons.close),
                onPressed: () => onChanged([...items]..removeAt(index)),
              ),
            ],
          ),
          AppTextField(label: 'Description', controller: item.descriptionController),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  label: 'Qty',
                  controller: item.quantityController,
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) => onChanged(items),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppTextField(
                  label: 'Unit price',
                  controller: item.unitPriceController,
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) => onChanged(items),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
