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
import '../domain/catalog.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key, required this.spaceId});

  final String spaceId;

  Future<void> _openForm(
    BuildContext context,
    WidgetRef ref, {
    Product? existing,
  }) async {
    final nameController = TextEditingController(text: existing?.name);
    final skuController = TextEditingController(text: existing?.sku);
    final unitController = TextEditingController(text: existing?.unit);
    final unitPriceController = TextEditingController(text: existing?.unitPrice);
    final descriptionController = TextEditingController(text: existing?.description);
    final costController = TextEditingController(text: existing?.cost);
    final reorderPointController = TextEditingController(text: existing?.reorderPoint);
    var type = existing?.type ?? ProductType.GOODS;
    var taxClassification = existing?.taxClassification ?? TaxClassification.NOT_APPLICABLE;
    var trackInventory = existing?.trackInventory ?? false;

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
              Text(existing == null ? 'Add product' : 'Edit product', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              AppTextField(label: 'Name', controller: nameController),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'SKU (optional)', controller: skuController),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<ProductType>(
                icon: const DuitlahIcon(Icons.expand_more, size: 18),
initialValue: type,
                decoration: const InputDecoration(labelText: 'Type'),
                items: ProductType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.name))).toList(),
                onChanged: (v) => setSheetState(() => type = v ?? type),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Unit (optional, e.g. "unit", "hour")', controller: unitController),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Unit price (RM)', controller: unitPriceController, keyboardType: TextInputType.number),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Description (optional)', controller: descriptionController),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                label: 'Cost (RM, optional — reference/standard cost)',
                controller: costController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<TaxClassification>(
                icon: const DuitlahIcon(Icons.expand_more, size: 18),
initialValue: taxClassification,
                decoration: const InputDecoration(labelText: 'Tax classification'),
                items: TaxClassification.values
                    .map((t) => DropdownMenuItem(value: t, child: Text(t.name)))
                    .toList(),
                onChanged: (v) => setSheetState(() => taxClassification = v ?? taxClassification),
              ),
              const SizedBox(height: AppSpacing.sm),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Track inventory'),
                subtitle: const Text('Record stock movements and weighted average cost for this product'),
                value: trackInventory,
                onChanged: (v) => setSheetState(() => trackInventory = v),
              ),
              if (trackInventory) ...[
                const SizedBox(height: AppSpacing.sm),
                AppTextField(
                  label: 'Reorder point (optional)',
                  controller: reorderPointController,
                  keyboardType: TextInputType.number,
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: existing == null ? 'Add' : 'Save',
                onPressed: () async {
                  final name = nameController.text.trim();
                  final unitPrice = unitPriceController.text.trim();
                  if (name.isEmpty || unitPrice.isEmpty) return;
                  try {
                    final repo = ref.read(catalogRepositoryProvider);
                    if (existing == null) {
                      await repo.createProduct(
                        spaceId,
                        name: name,
                        sku: skuController.text.trim().isEmpty ? null : skuController.text.trim(),
                        type: type,
                        unit: unitController.text.trim().isEmpty ? null : unitController.text.trim(),
                        unitPrice: unitPrice,
                        description: descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
                        cost: costController.text.trim().isEmpty ? null : costController.text.trim(),
                        taxClassification: taxClassification,
                        trackInventory: trackInventory,
                        reorderPoint: trackInventory && reorderPointController.text.trim().isNotEmpty
                            ? reorderPointController.text.trim()
                            : null,
                      );
                    } else {
                      await repo.updateProduct(
                        spaceId,
                        existing.id,
                        name: name,
                        sku: skuController.text.trim().isEmpty ? null : skuController.text.trim(),
                        type: type,
                        unit: unitController.text.trim().isEmpty ? null : unitController.text.trim(),
                        unitPrice: unitPrice,
                        description: descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
                        cost: costController.text.trim().isEmpty ? null : costController.text.trim(),
                        taxClassification: taxClassification,
                        trackInventory: trackInventory,
                        reorderPoint: trackInventory && reorderPointController.text.trim().isNotEmpty
                            ? reorderPointController.text.trim()
                            : null,
                      );
                    }
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
    if (saved == true) ref.invalidate(productListProvider(spaceId));
  }

  Future<void> _archive(BuildContext context, WidgetRef ref, String id) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Archive product?',
      message: 'This hides it from active lists — it is not permanently deleted.',
      confirmLabel: 'Archive',
      destructive: true,
    );
    if (!confirmed) return;
    try {
      await ref.read(catalogRepositoryProvider).archiveProduct(spaceId, id);
      ref.invalidate(productListProvider(spaceId));
    } catch (e) {
      if (context.mounted) showErrorSnackBar(context, e is AppException ? e.message : 'Something went wrong.');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productListProvider(spaceId));
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(productListProvider(spaceId)),
        child: products.when(
          data: (items) => items.isEmpty
              ? ListView(children: const [SizedBox(height: 80), EmptyView(icon: Icons.inventory_2_outlined, title: 'No products yet')])
              : ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final p = items[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: ListTile(
                        title: Text(p.name),
                        subtitle: Text(p.sku != null ? '${p.type.name} · ${p.sku}' : p.type.name),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(Money.format(p.unitPrice)),
                            if (!p.active) const Padding(padding: EdgeInsets.only(left: 8), child: Chip(label: Text('Archived'))),
                            IconButton(
                              icon: const DuitlahIcon(Icons.archive_outlined),
                              onPressed: () => _archive(context, ref, p.id),
                            ),
                          ],
                        ),
                        onTap: () => _openForm(context, ref, existing: p),
                      ),
                    );
                  },
                ),
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(productListProvider(spaceId))),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => _openForm(context, ref), child: const DuitlahIcon(Icons.add)),
    );
  }
}
