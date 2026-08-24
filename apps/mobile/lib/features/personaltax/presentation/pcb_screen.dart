import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/dialogs.dart';
import '../application/personal_tax_providers.dart';

class PcbScreen extends ConsumerWidget {
  const PcbScreen({super.key});

  Future<void> _recordPcb(BuildContext context, WidgetRef ref) async {
    final amountController = TextEditingController();
    var month = DateTime.now().month;
    final ya = ref.read(selectedYearOfAssessmentProvider);

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
              Text('Record PCB — YA $ya', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<int>(
                initialValue: month,
                decoration: const InputDecoration(labelText: 'Month'),
                items: List.generate(12, (i) => i + 1).map((m) => DropdownMenuItem(value: m, child: Text('$m'))).toList(),
                onChanged: (v) => setSheetState(() => month = v ?? month),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Amount (RM)', controller: amountController, keyboardType: TextInputType.number),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: 'Save',
                onPressed: () async {
                  try {
                    await ref
                        .read(personalTaxRepositoryProvider)
                        .recordPcb(yearOfAssessment: ya, month: month, amount: amountController.text.trim());
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
    if (saved == true) {
      ref.invalidate(pcbListProvider);
      ref.invalidate(personalTaxCalculationProvider);
      ref.invalidate(filingReadinessProvider);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pcb = ref.watch(pcbListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('PCB')),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(pcbListProvider),
        child: pcb.when(
          data: (items) => items.isEmpty
              ? ListView(children: const [SizedBox(height: 80), EmptyView(icon: Icons.receipt_long_outlined, title: 'No PCB recorded yet')])
              : ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final payment = items[index];
                    return Card(
                      child: ListTile(title: Text('Month ${payment.month}'), trailing: Text('RM ${payment.amount}')),
                    );
                  },
                ),
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(pcbListProvider)),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => _recordPcb(context, ref), child: const Icon(Icons.add)),
    );
  }
}
