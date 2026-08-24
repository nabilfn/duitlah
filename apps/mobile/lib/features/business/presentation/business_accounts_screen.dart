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
import '../domain/banking.dart';

class BusinessAccountsScreen extends ConsumerWidget {
  const BusinessAccountsScreen({super.key, required this.spaceId});

  final String spaceId;

  Future<void> _addAccount(BuildContext context, WidgetRef ref) async {
    final nameController = TextEditingController();
    final currencyController = TextEditingController(text: 'MYR');
    final openingBalanceController = TextEditingController(text: '0');
    var type = BusinessAccountType.BANK;

    final saved = await showAppBottomSheet<bool>(
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
              Text('Add business account', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              AppTextField(label: 'Name', controller: nameController),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<BusinessAccountType>(
                initialValue: type,
                decoration: const InputDecoration(labelText: 'Type'),
                items: BusinessAccountType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.name))).toList(),
                onChanged: (v) => setSheetState(() => type = v ?? type),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Currency', controller: currencyController),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Opening balance', controller: openingBalanceController, keyboardType: TextInputType.number),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: 'Add',
                onPressed: () async {
                  final name = nameController.text.trim();
                  if (name.isEmpty) return;
                  try {
                    await ref.read(bankingRepositoryProvider).createAccount(
                          spaceId,
                          name: name,
                          type: type,
                          currency: currencyController.text.trim().isEmpty ? null : currencyController.text.trim(),
                          openingBalance: openingBalanceController.text.trim().isEmpty ? null : openingBalanceController.text.trim(),
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
    if (saved == true) ref.invalidate(businessAccountListProvider(spaceId));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(businessAccountListProvider(spaceId));
    return Scaffold(
      appBar: AppBar(title: const Text('Business Accounts')),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(businessAccountListProvider(spaceId)),
        child: accounts.when(
          data: (items) => items.isEmpty
              ? ListView(children: const [SizedBox(height: 80), EmptyView(icon: Icons.account_balance_outlined, title: 'No business accounts yet')])
              : ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final a = items[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: ListTile(
                        title: Text(a.name),
                        subtitle: Text('${a.type.name} · ${a.currency}${a.archived ? ' · Archived' : ''}'),
                        trailing: Text('RM ${a.balance}', style: Theme.of(context).textTheme.titleMedium),
                        onTap: () => context.push(AppRoutes.businessAccountDetail(spaceId, a.id)),
                      ),
                    );
                  },
                ),
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(businessAccountListProvider(spaceId))),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => _addAccount(context, ref), child: const Icon(Icons.add)),
    );
  }
}
