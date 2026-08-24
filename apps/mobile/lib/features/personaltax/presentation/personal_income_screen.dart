import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/dialogs.dart';
import '../application/personal_tax_providers.dart';
import '../domain/personal_tax.dart';

class PersonalIncomeScreen extends ConsumerWidget {
  const PersonalIncomeScreen({super.key});

  Future<void> _addIncome(BuildContext context, WidgetRef ref) async {
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    var type = IncomeType.EMPLOYMENT;
    final ya = ref.read(selectedYearOfAssessmentProvider);

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
              Text('Add income — YA $ya', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<IncomeType>(
                initialValue: type,
                decoration: const InputDecoration(labelText: 'Type'),
                items: IncomeType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.name))).toList(),
                onChanged: (v) => setSheetState(() => type = v ?? type),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Amount (RM)', controller: amountController, keyboardType: TextInputType.number),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Description (optional)', controller: descriptionController),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: 'Add',
                onPressed: () async {
                  try {
                    await ref.read(personalTaxRepositoryProvider).addIncome(
                          yearOfAssessment: ya,
                          incomeType: type,
                          amount: amountController.text.trim(),
                          description: descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
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
      ref.invalidate(personalIncomeListProvider);
      ref.invalidate(personalTaxCalculationProvider);
      ref.invalidate(filingReadinessProvider);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final income = ref.watch(personalIncomeListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Income')),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(personalIncomeListProvider),
        child: income.when(
          data: (items) => items.isEmpty
              ? ListView(children: const [SizedBox(height: 80), EmptyView(icon: Icons.payments_outlined, title: 'No income recorded yet')])
              : ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final record = items[index];
                    return Card(
                      child: ListTile(
                        title: Text(record.incomeType.name),
                        subtitle: record.description != null ? Text(record.description!) : null,
                        trailing: Text('RM ${record.amount}'),
                      ),
                    );
                  },
                ),
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(personalIncomeListProvider)),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => _addIncome(context, ref), child: const Icon(Icons.add)),
    );
  }
}
