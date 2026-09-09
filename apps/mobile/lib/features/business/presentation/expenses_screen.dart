import 'package:duitlah_mobile/core/theme/duitlah_colors.dart';
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
import '../application/business_providers.dart';
import '../domain/contacts.dart';
import '../domain/expenses.dart';

Color expenseStatusColor(BuildContext context, ExpenseStatus status) {
  switch (status) {
    case ExpenseStatus.PAID:
      return context.duitlahColors.positive;
    case ExpenseStatus.PARTIALLY_PAID:
      return context.duitlahColors.warning;
    case ExpenseStatus.UNPAID:
      return Theme.of(context).colorScheme.error;
  }
}

class ExpensesScreen extends ConsumerWidget {
  const ExpensesScreen({super.key, required this.spaceId});

  final String spaceId;

  Future<void> _addExpense(BuildContext context, WidgetRef ref) async {
    final suppliers = await ref.read(contactsRepositoryProvider).listSuppliers(spaceId);
    if (!context.mounted) return;

    final categoryController = TextEditingController();
    final amountController = TextEditingController();
    final dateController = TextEditingController(text: DateTime.now().toIso8601String().substring(0, 10));
    final notesController = TextEditingController();
    Supplier? supplier;

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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Add expense', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: AppSpacing.md),
                DropdownButtonFormField<Supplier?>(
                  icon: const DuitlahIcon(Icons.expand_more, size: 18),
initialValue: supplier,
                  decoration: const InputDecoration(labelText: 'Supplier (optional — makes this a payable)'),
                  items: [
                    const DropdownMenuItem<Supplier?>(value: null, child: Text('None')),
                    ...suppliers.map((s) => DropdownMenuItem<Supplier?>(value: s, child: Text(s.name))),
                  ],
                  onChanged: (v) => setSheetState(() => supplier = v),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(label: 'Category (optional)', controller: categoryController),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(label: 'Amount', controller: amountController, keyboardType: TextInputType.number),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(label: 'Date (YYYY-MM-DD)', controller: dateController),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(label: 'Notes (optional)', controller: notesController),
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(
                  label: 'Add',
                  onPressed: () async {
                    final amount = amountController.text.trim();
                    if (amount.isEmpty) return;
                    try {
                      await ref.read(expensesRepositoryProvider).createExpense(
                            spaceId,
                            supplierId: supplier?.id,
                            category: categoryController.text.trim().isEmpty ? null : categoryController.text.trim(),
                            amount: amount,
                            occurredOn: dateController.text.trim(),
                            notes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
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
      ),
    );
    if (saved == true) ref.invalidate(expenseListProvider(spaceId));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expenseListProvider(spaceId));
    return Scaffold(
      appBar: AppBar(title: const Text('Expenses')),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(expenseListProvider(spaceId)),
        child: expenses.when(
          data: (items) => items.isEmpty
              ? ListView(children: const [SizedBox(height: 80), EmptyView(icon: Icons.request_quote_outlined, title: 'No expenses yet')])
              : ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final e = items[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: ListTile(
                        title: Text(e.category ?? 'Expense'),
                        subtitle: Text(e.occurredOn),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(Money.format(e.amount)),
                            Chip(
                              label: Text(e.status.name, style: const TextStyle(fontSize: 11)),
                              backgroundColor: expenseStatusColor(context, e.status).withValues(alpha: 0.15),
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                        onTap: () => context.push(AppRoutes.businessExpenseDetail(spaceId, e.id)),
                      ),
                    );
                  },
                ),
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(expenseListProvider(spaceId))),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => _addExpense(context, ref), child: const DuitlahIcon(Icons.add)),
    );
  }
}
