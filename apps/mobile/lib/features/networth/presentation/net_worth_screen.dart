import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/dialogs.dart';
import '../application/net_worth_providers.dart';
import '../domain/net_worth.dart';

/// Assets - Liabilities (spec section 19), always computed fresh — see [NetWorthRepository]. A
/// snapshot is only ever written when the user explicitly asks for one.
class NetWorthScreen extends ConsumerWidget {
  const NetWorthScreen({super.key});

  Future<void> _addOtherAsset(BuildContext context, WidgetRef ref) async {
    final nameController = TextEditingController();
    final valueController = TextEditingController();
    var type = AssetType.OTHER;

    final added = await showAppBottomSheet<bool>(
      context,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
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
              Text('Add asset', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<AssetType>(
                initialValue: type,
                decoration: const InputDecoration(labelText: 'Type'),
                items: AssetType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.name))).toList(),
                onChanged: (v) => setSheetState(() => type = v ?? type),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Name', controller: nameController),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Estimated value (RM)', controller: valueController, keyboardType: TextInputType.number),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: 'Add',
                onPressed: () async {
                  try {
                    await ref.read(netWorthRepositoryProvider).addOtherAsset(
                          type: type,
                          name: nameController.text.trim(),
                          estimatedValue: valueController.text.trim(),
                        );
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
        ),
      ),
    );
    if (added == true) {
      ref.invalidate(netWorthProvider);
      ref.invalidate(otherAssetListProvider);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final netWorth = ref.watch(netWorthProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Net Worth'),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined),
            tooltip: 'Take a snapshot',
            onPressed: () async {
              await ref.read(netWorthRepositoryProvider).takeSnapshot();
              if (context.mounted) showSuccessSnackBar(context, 'Snapshot saved.');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(netWorthProvider);
          ref.invalidate(otherAssetListProvider);
        },
        child: netWorth.when(
          data: (nw) => ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      Text('Net worth', style: Theme.of(context).textTheme.bodyMedium),
                      Text('RM ${nw.netWorth}', style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _Summary('Assets', nw.totalAssets),
                          _Summary('Liabilities', nw.totalLiabilities),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Assets', style: Theme.of(context).textTheme.titleMedium),
              ...nw.assetsBreakdown.map((line) => _BreakdownTile(line)),
              const SizedBox(height: AppSpacing.lg),
              Text('Liabilities', style: Theme.of(context).textTheme.titleMedium),
              ...nw.liabilitiesBreakdown.map((line) => _BreakdownTile(line)),
              const SizedBox(height: AppSpacing.lg),
              OutlinedButton.icon(
                onPressed: () => _addOtherAsset(context, ref),
                icon: const Icon(Icons.add),
                label: const Text('Add property, vehicle, or other asset'),
              ),
            ],
          ),
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(netWorthProvider)),
        ),
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary(this.label, this.amount);

  final String label;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        Text('RM $amount', style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}

class _BreakdownTile extends StatelessWidget {
  const _BreakdownTile(this.line);

  final BreakdownLine line;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(line.label),
      trailing: Text('RM ${line.amount}'),
    );
  }
}
