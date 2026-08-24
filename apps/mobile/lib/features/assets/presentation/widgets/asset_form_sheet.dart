import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/dialogs.dart';
import '../../../business/application/business_providers.dart';
import '../../application/fixed_assets_providers.dart';
import '../../domain/fixed_assets.dart';
import '../asset_labels.dart';

String _fmtDate(DateTime d) => d.toIso8601String().substring(0, 10);

/// Create/edit form for one asset. On create, an optional business-account
/// picker chooses which account paid for it (omitted means bought on
/// credit) — the server has no way to change that after the fact, so it's
/// create-only. On edit, once [existing] already has any accumulated
/// depreciation, cost/salvageValue/usefulLifeMonths/depreciationMethod/
/// acquisitionDate are shown read-only (the server would otherwise reject
/// the change with 409 `ASSET_FINANCIALS_LOCKED`) — only name/category stay
/// editable, matching how `products_screen.dart` reuses one sheet for both
/// add and edit.
class AssetFormSheet extends ConsumerStatefulWidget {
  const AssetFormSheet({super.key, required this.spaceId, this.existing});

  final String spaceId;
  final FixedAssetResponse? existing;

  @override
  ConsumerState<AssetFormSheet> createState() => _AssetFormSheetState();
}

class _AssetFormSheetState extends ConsumerState<AssetFormSheet> {
  late final _nameController = TextEditingController(text: widget.existing?.name);
  late final _categoryController = TextEditingController(text: widget.existing?.category);
  late final _costController = TextEditingController(text: widget.existing?.cost);
  late final _salvageValueController = TextEditingController(text: widget.existing?.salvageValue);
  late final _usefulLifeController =
      TextEditingController(text: widget.existing?.usefulLifeMonths.toString());
  late DateTime _acquisitionDate =
      DateTime.tryParse(widget.existing?.acquisitionDate ?? '') ?? DateTime.now();
  late DepreciationMethod _method = widget.existing?.depreciationMethod ?? DepreciationMethod.STRAIGHT_LINE;
  String? _businessAccountId;
  bool _submitting = false;

  bool get _isEdit => widget.existing != null;

  /// Once any depreciation has been posted, the financial fields are
  /// permanently locked server-side.
  bool get _financialsLocked =>
      _isEdit && (double.tryParse(widget.existing!.accumulatedDepreciation) ?? 0) > 0;

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _costController.dispose();
    _salvageValueController.dispose();
    _usefulLifeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final cost = _costController.text.trim();
    final usefulLife = int.tryParse(_usefulLifeController.text.trim());
    if (name.isEmpty || cost.isEmpty || usefulLife == null) return;

    setState(() => _submitting = true);
    try {
      final repo = ref.read(fixedAssetsRepositoryProvider);
      final category = _categoryController.text.trim().isEmpty ? null : _categoryController.text.trim();
      final salvageValue =
          _salvageValueController.text.trim().isEmpty ? null : _salvageValueController.text.trim();
      if (_isEdit) {
        await repo.updateAsset(
          widget.spaceId,
          widget.existing!.id,
          name: name,
          category: category,
          acquisitionDate: _fmtDate(_acquisitionDate),
          cost: cost,
          salvageValue: salvageValue,
          usefulLifeMonths: usefulLife,
          depreciationMethod: _method,
        );
      } else {
        await repo.createAsset(
          widget.spaceId,
          name: name,
          category: category,
          acquisitionDate: _fmtDate(_acquisitionDate),
          cost: cost,
          salvageValue: salvageValue,
          usefulLifeMonths: usefulLife,
          depreciationMethod: _method,
          businessAccountId: _businessAccountId,
        );
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        setState(() => _submitting = false);
        showErrorSnackBar(context, e is AppException ? e.message : 'Something went wrong.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final accounts = ref.watch(businessAccountListProvider(widget.spaceId)).valueOrNull ?? const [];
    final activeAccounts = accounts.where((a) => !a.archived).toList();
    final locked = _financialsLocked;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(_isEdit ? 'Edit asset' : 'New asset', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            AppTextField(label: 'Name', controller: _nameController),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(label: 'Category (optional)', controller: _categoryController),
            const SizedBox(height: AppSpacing.sm),
            if (locked) ...[
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lock_outline, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Depreciation has already been posted for this asset, so cost, salvage value, '
                        'useful life, method, and acquisition date can no longer be changed.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Acquisition date'),
              subtitle: Text(_fmtDate(_acquisitionDate)),
              trailing: locked ? null : const Icon(Icons.calendar_month_outlined),
              enabled: !locked,
              onTap: locked
                  ? null
                  : () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _acquisitionDate,
                        firstDate: DateTime(_acquisitionDate.year - 20),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) setState(() => _acquisitionDate = picked);
                    },
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              label: 'Cost (RM)',
              controller: _costController,
              enabled: !locked,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              label: 'Salvage value (RM, optional — default 0)',
              controller: _salvageValueController,
              enabled: !locked,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              label: 'Useful life (months)',
              controller: _usefulLifeController,
              enabled: !locked,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.sm),
            DropdownButtonFormField<DepreciationMethod>(
              initialValue: _method,
              decoration: const InputDecoration(labelText: 'Depreciation method'),
              items: DepreciationMethod.values
                  .map((m) => DropdownMenuItem(value: m, child: Text(depreciationMethodLabel(m))))
                  .toList(),
              onChanged: locked ? null : (v) => setState(() => _method = v ?? _method),
            ),
            if (!_isEdit) ...[
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<String?>(
                initialValue: _businessAccountId,
                decoration: const InputDecoration(labelText: 'Paid from (optional — omit if bought on credit)'),
                items: [
                  const DropdownMenuItem<String?>(value: null, child: Text('On credit / not set')),
                  ...activeAccounts.map((a) => DropdownMenuItem<String?>(value: a.id, child: Text(a.name))),
                ],
                onChanged: (v) => setState(() => _businessAccountId = v),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(label: _isEdit ? 'Save' : 'Add asset', loading: _submitting, onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
