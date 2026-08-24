import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/amount_text.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/dialogs.dart';
import '../../liabilities/presentation/credit_card_details_screen.dart';
import '../application/finance_providers.dart';
import '../domain/finance.dart';

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  Future<void> _addAccount(BuildContext context, WidgetRef ref) async {
    final nameController = TextEditingController();
    var type = AccountType.CASH;
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
              Text('Add account', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              AppTextField(label: 'Name', controller: nameController),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<AccountType>(
                initialValue: type,
                decoration: const InputDecoration(labelText: 'Type'),
                items: AccountType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.name))).toList(),
                onChanged: (v) => setSheetState(() => type = v ?? AccountType.CASH),
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: 'Add',
                onPressed: () async {
                  try {
                    await ref.read(financeRepositoryProvider).createAccount(name: nameController.text.trim(), type: type);
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
    if (added == true) ref.invalidate(accountListProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Accounts')),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(accountListProvider),
        child: accounts.when(
          data: (list) => list.isEmpty
              ? ListView(
                  children: const [
                    SizedBox(height: 80),
                    EmptyView(icon: Icons.account_balance_wallet_outlined, title: 'No accounts yet'),
                  ],
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final a = list[index];
                    final isCreditCard = a.type == AccountType.CREDIT_CARD;
                    return Card(
                      child: ListTile(
                        title: Text(a.name),
                        subtitle: Text(a.type.name),
                        trailing: AmountText(a.balance, tone: AmountTone.auto),
                        onTap: isCreditCard
                            ? () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => CreditCardDetailsScreen(accountId: a.id, accountName: a.name),
                                  ),
                                )
                            : null,
                      ),
                    );
                  },
                ),
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(accountListProvider)),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => _addAccount(context, ref), child: const Icon(Icons.add)),
    );
  }
}
