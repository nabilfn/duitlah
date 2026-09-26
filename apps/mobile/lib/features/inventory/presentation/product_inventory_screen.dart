import 'package:duitlah_mobile/core/widgets/app_adaptive_row.dart';
import 'package:duitlah_mobile/core/widgets/app_page_body.dart';
import 'package:duitlah_mobile/core/utils/money.dart';
import 'package:duitlah_mobile/core/widgets/app_field_group.dart';
import 'package:duitlah_mobile/core/theme/duitlah_colors.dart';
import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/dialogs.dart';
import '../../business/application/business_providers.dart';
import '../application/inventory_providers.dart';
import '../domain/inventory.dart';

String _fmtDate(DateTime d) => d.toIso8601String().substring(0, 10);

/// One product's inventory detail (Phase 8) — reached by tapping a row on
/// [InventoryHubScreen]'s stock valuation list, or from the product's own
/// entry in `products_screen.dart` once it has `trackInventory` on. Three
/// sections on one scrollable screen (no `TabBar` — nothing else in this
/// app uses one, so a single page mirrors
/// `reconciliation_session_screen.dart`'s section-per-concern layout
/// instead): current valuation + "Record Movement", the movement history,
/// and the optional recipe/ingredients list with its cost/margin summary.
class ProductInventoryScreen extends ConsumerWidget {
  const ProductInventoryScreen({
    super.key,
    required this.spaceId,
    required this.productId,
  });

  final String spaceId;
  final String productId;

  SpaceProductKey get _key => (spaceId: spaceId, productId: productId);

  void _invalidateMovements(WidgetRef ref) {
    ref.invalidate(productValuationProvider(_key));
    ref.invalidate(movementListProvider(_key));
  }

  void _invalidateRecipe(WidgetRef ref) {
    ref.invalidate(recipeItemsProvider(_key));
    ref.invalidate(recipeCostProvider(_key));
  }

  Future<void> _openMovementForm(BuildContext context, WidgetRef ref) async {
    final saved = await showAppBottomSheet<bool>(
      context,
      builder: (context) =>
          _MovementFormSheet(spaceId: spaceId, productId: productId),
    );
    if (saved == true) _invalidateMovements(ref);
  }

  Future<void> _openAddIngredientSheet(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final added = await showAppBottomSheet<bool>(
      context,
      builder: (context) =>
          _AddIngredientSheet(spaceId: spaceId, productId: productId),
    );
    if (added == true) _invalidateRecipe(ref);
  }

  Future<void> _removeIngredient(
    BuildContext context,
    WidgetRef ref,
    RecipeItemResponse item,
  ) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Remove ingredient?',
      message: 'Remove "${item.ingredientName}" from this recipe?',
      confirmLabel: 'Remove',
      destructive: true,
    );
    if (!confirmed) return;
    try {
      await ref
          .read(inventoryRepositoryProvider)
          .removeRecipeItem(spaceId, productId, item.id);
      _invalidateRecipe(ref);
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
    final productKey = (spaceId: spaceId, resourceId: productId);
    final product = ref.watch(productDetailProvider(productKey));
    final valuation = ref.watch(productValuationProvider(_key));
    final movements = ref.watch(movementListProvider(_key));
    final recipeItems = ref.watch(recipeItemsProvider(_key));
    final recipeCost = ref.watch(recipeCostProvider(_key));
    final hasRecipeItems = (recipeItems.valueOrNull ?? const []).isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: Text(product.valueOrNull?.name ?? 'Product')),
      body: AppPageBody(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(productDetailProvider(productKey));
            _invalidateMovements(ref);
            _invalidateRecipe(ref);
          },
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: AppSpacing.scrollInsets(context, floatingAction: false),
            children: [
              valuation.when(
                data: (v) => _ValuationCard(valuation: v),
                loading: () => const LoadingView(),
                error: (e, _) => ErrorView(
                  error: e,
                  onRetry: () => ref.invalidate(productValuationProvider(_key)),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              PrimaryButton(
                label: 'Record movement',
                onPressed: () => _openMovementForm(context, ref),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Movement history',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              movements.when(
                data: (items) => items.isEmpty
                    ? const EmptyView(
                        icon: Icons.receipt_long_outlined,
                        title: 'No movements recorded yet',
                      )
                    : Column(
                        children: items
                            .map((m) => _MovementTile(movement: m))
                            .toList(),
                      ),
                loading: () => const LoadingView(),
                error: (e, _) => ErrorView(
                  error: e,
                  onRetry: () => ref.invalidate(movementListProvider(_key)),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              AppAdaptiveRow(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recipe / ingredients',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  TextButton.icon(
                    onPressed: () => _openAddIngredientSheet(context, ref),
                    icon: const DuitlahIcon(Icons.add),
                    label: const Text('Add'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              recipeItems.when(
                data: (items) => items.isEmpty
                    ? const EmptyView(
                        icon: Icons.restaurant_menu_outlined,
                        title: 'No recipe set',
                        message: 'Add ingredients to compute this product\'s cost and margin. Entirely optional.',
                      )
                    : Column(
                        children: items
                            .map(
                              (item) => Card(
                                margin: const EdgeInsets.only(
                                  bottom: AppSpacing.sm,
                                ),
                                child: AppRecordTile(
                                  title: Text(item.ingredientName),
                                  subtitle: Text(
                                    '${item.quantityPerUnit} × ${item.ingredientUnitCost}',
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(item.lineCost),
                                      IconButton(
                                        icon: const DuitlahIcon(
                                          Icons.delete_outline,
                                        ),
                                        onPressed: () => _removeIngredient(
                                          context,
                                          ref,
                                          item,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                loading: () => const LoadingView(),
                error: (e, _) => ErrorView(
                  error: e,
                  onRetry: () => ref.invalidate(recipeItemsProvider(_key)),
                ),
              ),
              if (hasRecipeItems) ...[
                const SizedBox(height: AppSpacing.sm),
                recipeCost.when(
                  data: (c) => _RecipeCostCard(cost: c),
                  loading: () => const LoadingView(),
                  error: (e, _) => ErrorView(
                    error: e,
                    onRetry: () => ref.invalidate(recipeCostProvider(_key)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ValuationCard extends StatelessWidget {
  const _ValuationCard({required this.valuation});

  final ProductValuationResponse valuation;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: AppMetricRow(
          children: [
            Expanded(
              child: _Stat(label: 'On hand', value: valuation.quantityOnHand),
            ),
            Expanded(
              child: _Stat(
                label: 'WAC',
                value: Money.format(valuation.weightedAverageCost),
              ),
            ),
            Expanded(
              child: _Stat(
                label: 'Total value',
                value: Money.format(valuation.totalValue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}

class _MovementTile extends StatelessWidget {
  const _MovementTile({required this.movement});

  final MovementResponse movement;

  @override
  Widget build(BuildContext context) {
    final isInbound = (double.tryParse(movement.quantity) ?? 0) >= 0;
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppRecordTile(
        leading: DuitlahIcon(
          isInbound ? Icons.arrow_downward : Icons.arrow_upward,
          color: isInbound
              ? context.duitlahColors.positive
              : context.duitlahColors.negative,
        ),
        title: Text(movement.type.name),
        subtitle: Text(
          movement.notes != null
              ? '${movement.occurredOn} · ${movement.notes}'
              : movement.occurredOn,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${movement.quantity} @ ${movement.unitCost}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(movement.value, style: Theme.of(context).textTheme.titleSmall),
          ],
        ),
      ),
    );
  }
}

class _RecipeCostCard extends StatelessWidget {
  const _RecipeCostCard({required this.cost});

  final RecipeCostResponse cost;

  @override
  Widget build(BuildContext context) {
    final marginPositive = (double.tryParse(cost.grossMargin) ?? 0) >= 0;
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppAdaptiveRow(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [const Text('Unit cost'), Text(cost.unitCost)],
            ),
            const SizedBox(height: 4),
            AppAdaptiveRow(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [const Text('Selling price'), Text(cost.sellingPrice)],
            ),
            const Divider(),
            AppAdaptiveRow(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Gross margin'),
                Text(
                  '${cost.grossMargin} (${cost.grossMarginPercent}%)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: marginPositive
                        ? context.duitlahColors.positive
                        : context.duitlahColors.negative,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// "Record Movement" sheet — unit cost is disabled once quantity parses
/// negative, since the server always computes it itself from the current
/// Weighted Average Cost for an outbound movement (see
/// `inventory_repository.dart`'s `recordMovement` doc).
class _MovementFormSheet extends ConsumerStatefulWidget {
  const _MovementFormSheet({required this.spaceId, required this.productId});

  final String spaceId;
  final String productId;

  @override
  ConsumerState<_MovementFormSheet> createState() => _MovementFormSheetState();
}

class _MovementFormSheetState extends ConsumerState<_MovementFormSheet> {
  var _type = MovementType.PURCHASE;
  final _quantityController = TextEditingController();
  final _unitCostController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _occurredOn = DateTime.now();
  String? _businessAccountId;
  bool _submitting = false;

  bool get _isNegative =>
      (double.tryParse(_quantityController.text.trim()) ?? 0) < 0;

  @override
  void dispose() {
    _quantityController.dispose();
    _unitCostController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final quantity = _quantityController.text.trim();
    if (quantity.isEmpty) return;
    setState(() => _submitting = true);
    try {
      await ref
          .read(inventoryRepositoryProvider)
          .recordMovement(
            widget.spaceId,
            widget.productId,
            type: _type,
            quantity: quantity,
            unitCost: _isNegative || _unitCostController.text.trim().isEmpty
                ? null
                : _unitCostController.text.trim(),
            occurredOn: _fmtDate(_occurredOn),
            notes: _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim(),
            businessAccountId: _type == MovementType.PURCHASE
                ? _businessAccountId
                : null,
          );
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        setState(() => _submitting = false);
        showErrorSnackBar(
          context,
          e is AppException ? e.message : 'Something went wrong.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final accounts =
        ref.watch(businessAccountListProvider(widget.spaceId)).valueOrNull ??
        const [];
    final activeAccounts = accounts.where((a) => !a.archived).toList();

    return AnimatedBuilder(
      animation: _quantityController,
      builder: (context, _) => Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.pageMargin,
          right: AppSpacing.pageMargin,
          top: AppSpacing.lg,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
        ),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Record movement',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              AppFieldGroup(
                label: 'Type',
                child: DropdownButtonFormField<MovementType>(
                  itemHeight: null,
                  isExpanded: true,
                  icon: const DuitlahIcon(Icons.expand_more, size: 18),
                  initialValue: _type,
                  decoration: const InputDecoration(),
                  items: MovementType.values
                      .map(
                        (t) => DropdownMenuItem(value: t, child: Text(t.name)),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _type = v ?? _type),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                label: 'Quantity (negative for outbound)',
                controller: _quantityController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                label: _isNegative
                    ? 'Unit cost (computed by server)'
                    : 'Unit cost (RM)',
                controller: _unitCostController,
                enabled: !_isNegative,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _occurredOn,
                    firstDate: DateTime(_occurredOn.year - 5),
                    lastDate: DateTime(_occurredOn.year + 5),
                  );
                  if (picked != null) setState(() => _occurredOn = picked);
                },
                child: Text('Occurred on ${_fmtDate(_occurredOn)}'),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                label: 'Notes (optional)',
                controller: _notesController,
              ),
              if (_type == MovementType.PURCHASE) ...[
                const SizedBox(height: AppSpacing.sm),
                AppFieldGroup(
                  label: 'Paid from (optional — omit if bought on credit)',
                  child: DropdownButtonFormField<String?>(
                    itemHeight: null,
                    isExpanded: true,
                    icon: const DuitlahIcon(Icons.expand_more, size: 18),
                    initialValue: _businessAccountId,
                    decoration: const InputDecoration(),
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('On credit / not set'),
                      ),
                      ...activeAccounts.map(
                        (a) => DropdownMenuItem<String?>(
                          value: a.id,
                          child: Text(a.name),
                        ),
                      ),
                    ],
                    onChanged: (v) => setState(() => _businessAccountId = v),
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: 'Save',
                loading: _submitting,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// "Add ingredient" sheet — picks any other active product in the space as
/// the ingredient (the server itself rejects a product naming itself, 400
/// `PRODUCT_CANNOT_BE_ITS_OWN_INGREDIENT`, so this is a convenience filter
/// rather than the sole guard).
class _AddIngredientSheet extends ConsumerStatefulWidget {
  const _AddIngredientSheet({required this.spaceId, required this.productId});

  final String spaceId;
  final String productId;

  @override
  ConsumerState<_AddIngredientSheet> createState() =>
      _AddIngredientSheetState();
}

class _AddIngredientSheetState extends ConsumerState<_AddIngredientSheet> {
  String? _ingredientProductId;
  final _quantityController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final ingredientId = _ingredientProductId;
    final quantity = _quantityController.text.trim();
    if (ingredientId == null || quantity.isEmpty) return;
    setState(() => _submitting = true);
    try {
      await ref
          .read(inventoryRepositoryProvider)
          .addRecipeItem(
            widget.spaceId,
            widget.productId,
            ingredientProductId: ingredientId,
            quantityPerUnit: quantity,
          );
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        setState(() => _submitting = false);
        showErrorSnackBar(
          context,
          e is AppException ? e.message : 'Something went wrong.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final products =
        ref.watch(productListProvider(widget.spaceId)).valueOrNull ?? const [];
    final candidates = products
        .where((p) => p.id != widget.productId && p.active)
        .toList();

    return Padding(
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
          Text('Add ingredient', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.md),
          if (candidates.isEmpty)
            const Text('No other products available to use as an ingredient.')
          else
            AppFieldGroup(
              label: 'Ingredient product',
              child: DropdownButtonFormField<String>(
                itemHeight: null,
                isExpanded: true,
                icon: const DuitlahIcon(Icons.expand_more, size: 18),
                initialValue: _ingredientProductId,
                decoration: const InputDecoration(),
                items: candidates
                    .map(
                      (p) => DropdownMenuItem(value: p.id, child: Text(p.name)),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _ingredientProductId = v),
              ),
            ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            label: 'Quantity per unit',
            controller: _quantityController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: 'Add',
            loading: _submitting,
            onPressed: candidates.isEmpty ? null : _submit,
          ),
        ],
      ),
    );
  }
}
