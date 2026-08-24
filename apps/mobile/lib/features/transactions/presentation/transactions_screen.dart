import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/amount_text.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/dialogs.dart';
import '../../../core/widgets/list_rows.dart';
import '../../accounts/application/finance_providers.dart';
import '../../accounts/domain/finance.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  Future<void> _addTransaction(BuildContext context, WidgetRef ref, List<Account> accounts) async {
    if (accounts.isEmpty) {
      showErrorSnackBar(context, 'Add an account first.');
      return;
    }
    final amountController = TextEditingController();
    final merchantController = TextEditingController();
    String accountId = accounts.first.id;
    var direction = TransactionDirection.OUT;

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
              Text('Add transaction', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              SegmentedButton<TransactionDirection>(
                segments: const [
                  ButtonSegment(value: TransactionDirection.OUT, label: Text('Expense')),
                  ButtonSegment(value: TransactionDirection.IN, label: Text('Income')),
                ],
                selected: {direction},
                onSelectionChanged: (s) => setSheetState(() => direction = s.first),
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String>(
                initialValue: accountId,
                decoration: const InputDecoration(labelText: 'Account'),
                items: accounts.map((a) => DropdownMenuItem(value: a.id, child: Text(a.name))).toList(),
                onChanged: (v) => setSheetState(() => accountId = v ?? accountId),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Amount (RM)', controller: amountController, keyboardType: TextInputType.number),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Merchant / description', controller: merchantController),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: 'Add',
                onPressed: () async {
                  try {
                    await ref.read(financeRepositoryProvider).createTransaction(
                          accountId: accountId,
                          type: direction == TransactionDirection.IN
                              ? TransactionType.INCOME
                              : TransactionType.EXPENSE,
                          amount: amountController.text.trim(),
                          merchant: merchantController.text.trim(),
                          occurredOn: DateTime.now().toIso8601String().split('T').first,
                          idempotencyKey: const Uuid().v4(),
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
      ref.invalidate(transactionsProvider);
      ref.invalidate(dashboardProvider);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsProvider);
    final accounts = ref.watch(accountListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(transactionsProvider),
        child: transactions.when(
          data: (page) => page.content.isEmpty
              ? ListView(
                  children: const [
                    SizedBox(height: 80),
                    EmptyView(icon: Icons.receipt_long_outlined, title: 'No transactions yet'),
                  ],
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: page.content.length,
                  itemBuilder: (context, index) {
                    final t = page.content[index];
                    return MoneyRow(
                      title: t.merchant ?? t.description ?? t.type.name,
                      subtitle: t.occurredOn,
                      amount: t.amount,
                      tone: t.direction == TransactionDirection.IN ? AmountTone.positive : AmountTone.negative,
                      leadingIcon: t.direction == TransactionDirection.IN
                          ? Icons.arrow_downward_rounded
                          : Icons.arrow_upward_rounded,
                    );
                  },
                ),
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(transactionsProvider)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTransaction(context, ref, accounts.valueOrNull ?? const []),
        child: const Icon(Icons.add),
      ),
    );
  }
}
