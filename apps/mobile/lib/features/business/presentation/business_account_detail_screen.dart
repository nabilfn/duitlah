import 'package:duitlah_mobile/core/widgets/duitlah_segmented_control.dart';
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
import '../../accounting/application/accounting_providers.dart';
import '../../accounting/domain/chart_of_accounts.dart';
import '../application/business_providers.dart';
import '../domain/banking.dart';

/// Distinguishes "sheet dismissed without a choice" (returns null — no
/// change) from "user explicitly chose to clear the mapping" (returns a
/// record with a null [chartOfAccountsId] inside it), since both would
/// otherwise collapse to the same `null` if the sheet's result type were
/// just `String?`.
typedef _MappingChoice = ({String? chartOfAccountsId});

class BusinessAccountDetailScreen extends ConsumerWidget {
  const BusinessAccountDetailScreen({super.key, required this.spaceId, required this.accountId});

  final String spaceId;
  final String accountId;

  SpaceResourceKey get _key => (spaceId: spaceId, resourceId: accountId);

  Future<void> _addEntry(BuildContext context, WidgetRef ref) async {
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    final dateController = TextEditingController(text: DateTime.now().toIso8601String().substring(0, 10));
    var direction = EntryDirection.IN;

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
              Text('Add entry', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              DuitlahSegmentedControl<EntryDirection>(
                segments: const [
                  ButtonSegment(value: EntryDirection.IN, label: Text('Money in')),
                  ButtonSegment(value: EntryDirection.OUT, label: Text('Money out')),
                ],
                selected: {direction},
                onSelectionChanged: (s) => setSheetState(() => direction = s.first),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Amount', controller: amountController, keyboardType: TextInputType.number),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Date (YYYY-MM-DD)', controller: dateController),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Description (optional)', controller: descriptionController),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: 'Add',
                onPressed: () async {
                  final amount = amountController.text.trim();
                  if (amount.isEmpty) return;
                  try {
                    await ref.read(bankingRepositoryProvider).createEntry(
                          spaceId,
                          accountId,
                          direction: direction,
                          amount: amount,
                          occurredOn: dateController.text.trim(),
                          description:
                              descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
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
        )),
      ),
    );
    if (saved == true) {
      ref.invalidate(accountEntriesProvider(_key));
      ref.invalidate(businessAccountDetailProvider(_key));
      ref.invalidate(businessAccountListProvider(spaceId));
    }
  }

  Future<void> _transfer(BuildContext context, WidgetRef ref) async {
    final accounts = await ref.read(bankingRepositoryProvider).listAccounts(spaceId);
    final destinations = accounts.where((a) => a.id != accountId && !a.archived).toList();
    if (!context.mounted) return;
    if (destinations.isEmpty) {
      showErrorSnackBar(context, 'No other business accounts to transfer to.');
      return;
    }

    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    final dateController = TextEditingController(text: DateTime.now().toIso8601String().substring(0, 10));
    var destinationId = destinations.first.id;

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
              Text('Transfer to another account', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String>(
                icon: const DuitlahIcon(Icons.expand_more, size: 18),
initialValue: destinationId,
                decoration: const InputDecoration(labelText: 'To account'),
                items: destinations.map((a) => DropdownMenuItem(value: a.id, child: Text(a.name))).toList(),
                onChanged: (v) => setSheetState(() => destinationId = v ?? destinationId),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Amount', controller: amountController, keyboardType: TextInputType.number),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Date (YYYY-MM-DD)', controller: dateController),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Description (optional)', controller: descriptionController),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: 'Transfer',
                onPressed: () async {
                  final amount = amountController.text.trim();
                  if (amount.isEmpty) return;
                  try {
                    await ref.read(bankingRepositoryProvider).transfer(
                          spaceId,
                          accountId,
                          toBusinessAccountId: destinationId,
                          amount: amount,
                          occurredOn: dateController.text.trim(),
                          description:
                              descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
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
        )),
      ),
    );
    if (saved == true) {
      ref.invalidate(accountEntriesProvider(_key));
      ref.invalidate(businessAccountDetailProvider(_key));
      ref.invalidate(businessAccountListProvider(spaceId));
    }
  }

  Future<void> _mapLedgerAccount(BuildContext context, WidgetRef ref, BusinessAccount account) async {
    final ledgerAccounts = await ref.read(chartOfAccountsRepositoryProvider).listAccounts(spaceId);
    if (!context.mounted) return;
    if (ledgerAccounts.isEmpty) {
      context.push(AppRoutes.accountingChartOfAccounts(spaceId));
      return;
    }

    final candidates = ledgerAccounts.where((a) => a.type == LedgerAccountType.ASSET && !a.archived).toList();
    final selected = await showAppBottomSheet<_MappingChoice>(
      context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text('Map to ledger account', style: Theme.of(context).textTheme.titleLarge),
            ),
            ListTile(
              title: const Text('No mapping'),
              trailing: account.chartOfAccountsId == null ? const DuitlahIcon(Icons.check) : null,
              onTap: () => Navigator.of(context).pop((chartOfAccountsId: null)),
            ),
            if (candidates.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                child: Text('No ASSET accounts in the Chart of Accounts yet.'),
              )
            else
              for (final a in candidates)
                ListTile(
                  title: Text('${a.code} · ${a.name}'),
                  trailing: account.chartOfAccountsId == a.id ? const DuitlahIcon(Icons.check) : null,
                  onTap: () => Navigator.of(context).pop((chartOfAccountsId: a.id)),
                ),
          ],
        ),
      ),
    );
    if (selected == null) return;
    try {
      await ref.read(bankingRepositoryProvider).updateChartOfAccountsMapping(
            spaceId,
            accountId,
            chartOfAccountsId: selected.chartOfAccountsId,
          );
      ref.invalidate(businessAccountDetailProvider(_key));
    } catch (e) {
      if (context.mounted) showErrorSnackBar(context, e is AppException ? e.message : 'Something went wrong.');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(businessAccountDetailProvider(_key));
    final entries = ref.watch(accountEntriesProvider(_key));

    return Scaffold(
      appBar: AppBar(title: Text(account.valueOrNull?.name ?? 'Account')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(businessAccountDetailProvider(_key));
          ref.invalidate(accountEntriesProvider(_key));
        },
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            account.when(
              data: (a) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Balance', style: Theme.of(context).textTheme.bodyMedium),
                      Text('${a.currency} ${a.balance}', style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: AppSpacing.sm),
                      Text('${a.type.name} · Opening balance ${a.openingBalance}', style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: AppSpacing.md),
                      SecondaryButton(
                        label: 'Transfer to another account',
                        onPressed: () => _transfer(context, ref),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      SecondaryButton(
                        label: a.chartOfAccountsId == null ? 'Map to ledger account' : 'Change ledger account mapping',
                        onPressed: () => _mapLedgerAccount(context, ref, a),
                      ),
                    ],
                  ),
                ),
              ),
              loading: () => const LoadingView(),
              error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(businessAccountDetailProvider(_key))),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Entries', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            entries.when(
              data: (items) => items.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                      child: Text('No entries yet.'),
                    )
                  : Column(
                      children: items
                          .map(
                            (e) => Card(
                              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                              child: ListTile(
                                leading: DuitlahIcon(
                                  e.direction == EntryDirection.IN ? Icons.arrow_downward : Icons.arrow_upward,
                                  color: e.direction == EntryDirection.IN ? Colors.green : Colors.red,
                                ),
                                title: Text(e.description ?? (e.direction == EntryDirection.IN ? 'Money in' : 'Money out')),
                                subtitle: Text(e.occurredOn),
                                trailing: Text(Money.format(e.amount)),
                              ),
                            ),
                          )
                          .toList(),
                    ),
              loading: () => const LoadingView(),
              error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(accountEntriesProvider(_key))),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => _addEntry(context, ref), child: const DuitlahIcon(Icons.add)),
    );
  }
}
