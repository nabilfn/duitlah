import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/dialogs.dart';
import '../../business/application/business_providers.dart';
import '../application/fixed_assets_providers.dart';
import '../domain/fixed_assets.dart';
import 'asset_labels.dart';
import 'widgets/asset_form_sheet.dart';

String _fmtDate(DateTime d) => d.toIso8601String().substring(0, 10);

/// One asset's detail (Phase 9) — reached by tapping a row on
/// [AssetsHubScreen]'s register list. A single scrollable page (no
/// `TabBar`, matching `product_inventory_screen.dart`'s section-per-concern
/// layout): the asset's core fields with accumulated depreciation/net book
/// value prominent, the depreciation history, "Run Depreciation", and
/// "Dispose" — the last two hidden once the asset is already
/// [FixedAssetStatus.DISPOSED], since the server would reject them anyway
/// with a 409 and there's no reason to invite that in normal use.
class AssetDetailScreen extends ConsumerWidget {
  const AssetDetailScreen({super.key, required this.spaceId, required this.assetId});

  final String spaceId;
  final String assetId;

  SpaceAssetKey get _key => (spaceId: spaceId, assetId: assetId);

  void _invalidateAll(WidgetRef ref) {
    ref.invalidate(assetDetailProvider(_key));
    ref.invalidate(depreciationEntryListProvider(_key));
    ref.invalidate(assetListProvider(spaceId));
  }

  Future<void> _openEditForm(BuildContext context, WidgetRef ref, FixedAssetResponse asset) async {
    final saved = await showAppBottomSheet<bool>(
      context,
      builder: (context) => AssetFormSheet(spaceId: spaceId, existing: asset),
    );
    if (saved == true) _invalidateAll(ref);
  }

  Future<void> _runDepreciation(BuildContext context, WidgetRef ref) async {
    var period = DateTime.now();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Run depreciation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'This posts depreciation for one month — normally the scheduler does this '
                'automatically. Use this to backfill a missed month or run one early.',
              ),
              const SizedBox(height: AppSpacing.md),
              OutlinedButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: period,
                    firstDate: DateTime(period.year - 5),
                    lastDate: DateTime(period.year + 1),
                    initialDatePickerMode: DatePickerMode.year,
                  );
                  if (picked != null) setDialogState(() => period = picked);
                },
                child: Text('Month: ${period.year}-${period.month.toString().padLeft(2, '0')}'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Run')),
          ],
        ),
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(fixedAssetsRepositoryProvider).runDepreciation(spaceId, assetId, period: _fmtDate(period));
      _invalidateAll(ref);
      if (context.mounted) showSuccessSnackBar(context, 'Depreciation posted.');
    } catch (e) {
      if (context.mounted) showErrorSnackBar(context, e is AppException ? e.message : 'Something went wrong.');
    }
  }

  Future<void> _openDisposeSheet(BuildContext context, WidgetRef ref, FixedAssetResponse asset) async {
    final disposed = await showAppBottomSheet<bool>(
      context,
      builder: (context) => _DisposeSheet(spaceId: spaceId, asset: asset),
    );
    if (disposed == true) _invalidateAll(ref);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asset = ref.watch(assetDetailProvider(_key));
    final entries = ref.watch(depreciationEntryListProvider(_key));

    return Scaffold(
      appBar: AppBar(
        title: Text(asset.valueOrNull?.name ?? 'Asset'),
        actions: [
          if (asset.valueOrNull != null && asset.valueOrNull!.status == FixedAssetStatus.ACTIVE)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => _openEditForm(context, ref, asset.valueOrNull!),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _invalidateAll(ref),
        child: asset.when(
          data: (a) => ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              _AssetHeaderCard(asset: a),
              const SizedBox(height: AppSpacing.md),
              if (a.status == FixedAssetStatus.ACTIVE) ...[
                Row(
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        label: 'Run depreciation',
                        onPressed: () => _runDepreciation(context, ref),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: SecondaryButton(
                        label: 'Dispose',
                        onPressed: () => _openDisposeSheet(context, ref, a),
                      ),
                    ),
                  ],
                ),
              ] else
                Card(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: ListTile(
                    leading: const Icon(Icons.inventory_2_outlined),
                    title: const Text('This asset has been disposed'),
                    subtitle: Text(
                      'Disposed on ${a.disposedOn ?? '-'}'
                      '${a.disposalProceeds != null ? ' · Proceeds RM ${a.disposalProceeds}' : ''}',
                    ),
                  ),
                ),
              const SizedBox(height: AppSpacing.xl),
              Text('Depreciation history', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              entries.when(
                data: (items) => items.isEmpty
                    ? const EmptyView(icon: Icons.timeline_outlined, title: 'No depreciation posted yet')
                    : Column(children: items.map((e) => _DepreciationTile(entry: e)).toList()),
                loading: () => const LoadingView(),
                error: (e, _) =>
                    ErrorView(error: e, onRetry: () => ref.invalidate(depreciationEntryListProvider(_key))),
              ),
            ],
          ),
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(assetDetailProvider(_key))),
        ),
      ),
    );
  }
}

class _AssetHeaderCard extends StatelessWidget {
  const _AssetHeaderCard({required this.asset});

  final FixedAssetResponse asset;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(asset.category ?? 'Uncategorized', style: Theme.of(context).textTheme.bodyMedium),
                ),
                Chip(
                  label: Text(asset.status == FixedAssetStatus.DISPOSED ? 'Disposed' : 'Active'),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const Divider(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(child: _Stat(label: 'Accumulated depreciation', value: 'RM ${asset.accumulatedDepreciation}')),
                Expanded(child: _Stat(label: 'Net book value', value: 'RM ${asset.netBookValue}')),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(child: _Stat(label: 'Cost', value: 'RM ${asset.cost}')),
                Expanded(child: _Stat(label: 'Salvage value', value: 'RM ${asset.salvageValue}')),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(child: _Stat(label: 'Useful life', value: '${asset.usefulLifeMonths} months')),
                Expanded(child: _Stat(label: 'Method', value: depreciationMethodLabel(asset.depreciationMethod))),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _Stat(label: 'Acquired on', value: asset.acquisitionDate),
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

class _DepreciationTile extends StatelessWidget {
  const _DepreciationTile({required this.entry});

  final DepreciationEntryResponse entry;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: const Icon(Icons.calendar_month_outlined),
        title: Text(entry.period),
        trailing: Text('RM ${entry.amount}', style: Theme.of(context).textTheme.titleSmall),
      ),
    );
  }
}

/// Disposal is irreversible from the UI's perspective (once disposed, an
/// asset can no longer be depreciated or disposed again), so this is a
/// dedicated form sheet — not a one-tap button — that itself ends in a
/// destructive [showConfirmDialog] before firing the request, mirroring
/// `reconciliation_session_screen.dart`'s `_resolveDifference` shape (a
/// sheet collecting the fields the action needs) plus the extra irreversible
/// confirmation this action specifically calls for.
class _DisposeSheet extends ConsumerStatefulWidget {
  const _DisposeSheet({required this.spaceId, required this.asset});

  final String spaceId;
  final FixedAssetResponse asset;

  @override
  ConsumerState<_DisposeSheet> createState() => _DisposeSheetState();
}

class _DisposeSheetState extends ConsumerState<_DisposeSheet> {
  DateTime _disposedOn = DateTime.now();
  final _proceedsController = TextEditingController(text: '0');
  String? _businessAccountId;
  bool _submitting = false;

  double get _proceedsValue => double.tryParse(_proceedsController.text.trim()) ?? 0;
  bool get _needsAccount => _proceedsValue > 0;
  bool get _canSubmit => !_submitting && (!_needsAccount || _businessAccountId != null);

  @override
  void dispose() {
    _proceedsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Dispose "${widget.asset.name}"?',
      message: 'This is permanent. Once disposed, this asset can no longer be depreciated or disposed again.',
      confirmLabel: 'Dispose',
      destructive: true,
    );
    if (!confirmed || !mounted) return;

    setState(() => _submitting = true);
    try {
      final proceeds = _proceedsController.text.trim().isEmpty ? '0' : _proceedsController.text.trim();
      await ref.read(fixedAssetsRepositoryProvider).disposeAsset(
            widget.spaceId,
            widget.asset.id,
            disposedOn: _fmtDate(_disposedOn),
            proceeds: proceeds,
            businessAccountId: _needsAccount ? _businessAccountId : null,
          );
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

    return AnimatedBuilder(
      animation: _proceedsController,
      builder: (context, _) => Padding(
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
              Text('Dispose asset', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Recording a disposal is permanent — the asset can no longer be depreciated afterwards.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.md),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Disposal date'),
                subtitle: Text(_fmtDate(_disposedOn)),
                trailing: const Icon(Icons.calendar_month_outlined),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _disposedOn,
                    firstDate: DateTime(_disposedOn.year - 20),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) setState(() => _disposedOn = picked);
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                label: 'Proceeds (RM)',
                controller: _proceedsController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<String?>(
                initialValue: _businessAccountId,
                decoration: InputDecoration(
                  labelText: _needsAccount ? 'Received into (required)' : 'Received into (optional)',
                ),
                items: [
                  if (!_needsAccount) const DropdownMenuItem<String?>(value: null, child: Text('Not applicable')),
                  ...activeAccounts.map((a) => DropdownMenuItem<String?>(value: a.id, child: Text(a.name))),
                ],
                onChanged: (v) => setState(() => _businessAccountId = v),
              ),
              if (_needsAccount && _businessAccountId == null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Required because proceeds are greater than zero.',
                  style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: 'Dispose',
                loading: _submitting,
                onPressed: _canSubmit ? _submit : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
