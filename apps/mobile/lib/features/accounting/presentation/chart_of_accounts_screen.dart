import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/dialogs.dart';
import '../application/accounting_providers.dart';
import '../domain/chart_of_accounts.dart';

const _sectionOrder = [
  LedgerAccountType.ASSET,
  LedgerAccountType.LIABILITY,
  LedgerAccountType.EQUITY,
  LedgerAccountType.REVENUE,
  LedgerAccountType.EXPENSE,
];

String sectionTitle(LedgerAccountType type) {
  switch (type) {
    case LedgerAccountType.ASSET:
      return 'Assets';
    case LedgerAccountType.LIABILITY:
      return 'Liabilities';
    case LedgerAccountType.EQUITY:
      return 'Equity';
    case LedgerAccountType.REVENUE:
      return 'Revenue';
    case LedgerAccountType.EXPENSE:
      return 'Expenses';
  }
}

/// Chart of Accounts management — an empty-state "seed defaults" bootstrap,
/// then a 5-section (Assets/Liabilities/Equity/Revenue/Expenses) list with
/// add/edit/archive. `systemDefault` accounts get a badge but stay fully
/// editable — the backend doesn't lock them, it just means automatic
/// posting for this space silently stops finding them by their well-known
/// code if renamed or archived.
class ChartOfAccountsScreen extends ConsumerWidget {
  const ChartOfAccountsScreen({super.key, required this.spaceId});

  final String spaceId;

  Future<void> _seedDefaults(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(chartOfAccountsRepositoryProvider).seedDefaults(spaceId);
      ref.invalidate(chartOfAccountsListProvider(spaceId));
    } catch (e) {
      if (context.mounted) showErrorSnackBar(context, e is AppException ? e.message : 'Something went wrong.');
    }
  }

  Future<void> _addOrEdit(BuildContext context, WidgetRef ref, {LedgerAccount? existing}) async {
    final codeController = TextEditingController(text: existing?.code ?? '');
    final nameController = TextEditingController(text: existing?.name ?? '');
    var type = existing?.type ?? LedgerAccountType.ASSET;
    var cashEquivalent = existing?.cashEquivalent ?? false;

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
              Text(
                existing == null ? 'Add ledger account' : 'Edit ledger account',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(label: 'Code (e.g. 1000)', controller: codeController),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Name', controller: nameController),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<LedgerAccountType>(
                icon: const DuitlahIcon(Icons.expand_more, size: 18),
initialValue: type,
                decoration: const InputDecoration(labelText: 'Type'),
                items: _sectionOrder.map((t) => DropdownMenuItem(value: t, child: Text(sectionTitle(t)))).toList(),
                onChanged: (v) => setSheetState(() => type = v ?? type),
              ),
              if (type == LedgerAccountType.ASSET) ...[
                const SizedBox(height: AppSpacing.sm),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Cash-equivalent'),
                  subtitle: const Text('Included in the Cash Flow report'),
                  value: cashEquivalent,
                  onChanged: (v) => setSheetState(() => cashEquivalent = v),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: existing == null ? 'Add' : 'Save',
                onPressed: () async {
                  final code = codeController.text.trim();
                  final name = nameController.text.trim();
                  if (code.isEmpty || name.isEmpty) return;
                  final effectiveCashEquivalent = type == LedgerAccountType.ASSET && cashEquivalent;
                  try {
                    if (existing == null) {
                      await ref.read(chartOfAccountsRepositoryProvider).createAccount(
                            spaceId,
                            code: code,
                            name: name,
                            type: type,
                            cashEquivalent: effectiveCashEquivalent,
                          );
                    } else {
                      await ref.read(chartOfAccountsRepositoryProvider).updateAccount(
                            spaceId,
                            existing.id,
                            code: code,
                            name: name,
                            type: type,
                            cashEquivalent: effectiveCashEquivalent,
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
    if (saved == true) ref.invalidate(chartOfAccountsListProvider(spaceId));
  }

  Future<void> _archive(BuildContext context, WidgetRef ref, LedgerAccount account) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Archive ${account.name}?',
      message: 'Archived accounts are hidden from pickers but kept for historical reports.',
      confirmLabel: 'Archive',
      destructive: true,
    );
    if (!confirmed) return;
    try {
      await ref.read(chartOfAccountsRepositoryProvider).archiveAccount(spaceId, account.id);
      ref.invalidate(chartOfAccountsListProvider(spaceId));
    } catch (e) {
      if (context.mounted) showErrorSnackBar(context, e is AppException ? e.message : 'Something went wrong.');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(chartOfAccountsListProvider(spaceId));
    return Scaffold(
      appBar: AppBar(title: const Text('Chart of Accounts')),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(chartOfAccountsListProvider(spaceId)),
        child: accounts.when(
          data: (items) {
            if (items.isEmpty) {
              return ListView(
                children: [
                  const SizedBox(height: 60),
                  const EmptyView(
                    icon: Icons.account_tree_outlined,
                    title: 'Set up your Chart of Accounts',
                    message: 'Seed a standard set of asset, liability, equity, revenue and expense '
                        'accounts to start recording double-entry journals.',
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                    child: PrimaryButton(
                      label: 'Set up Chart of Accounts',
                      onPressed: () => _seedDefaults(context, ref),
                    ),
                  ),
                ],
              );
            }
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                Text(
                  'Accounts marked "Default" can still be edited or archived — doing so just means '
                  'automatic posting for this space stops finding them by their well-known code.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.md),
                for (final section in _sectionOrder)
                  if (items.any((a) => a.type == section)) ...[
                    Text(sectionTitle(section), style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.sm),
                    for (final a in items.where((a) => a.type == section))
                      Card(
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: ListTile(
                          title: Row(
                            children: [
                              Flexible(child: Text(a.name)),
                              if (a.systemDefault) ...[
                                const SizedBox(width: AppSpacing.xs),
                                const Chip(
                                  label: Text('Default', style: TextStyle(fontSize: 10)),
                                  visualDensity: VisualDensity.compact,
                                  padding: EdgeInsets.zero,
                                ),
                              ],
                            ],
                          ),
                          subtitle: Text(
                            '${a.code}${a.cashEquivalent ? ' · Cash-equivalent' : ''}${a.archived ? ' · Archived' : ''}',
                          ),
                          onTap: () => _addOrEdit(context, ref, existing: a),
                          trailing: IconButton(
                            icon: const DuitlahIcon(Icons.archive_outlined),
                            onPressed: a.archived ? null : () => _archive(context, ref, a),
                          ),
                        ),
                      ),
                    const SizedBox(height: AppSpacing.md),
                  ],
              ],
            );
          },
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(chartOfAccountsListProvider(spaceId))),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => _addOrEdit(context, ref), child: const DuitlahIcon(Icons.add)),
    );
  }
}
