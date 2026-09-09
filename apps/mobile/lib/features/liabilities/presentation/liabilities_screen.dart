import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/dialogs.dart';
import '../application/liabilities_providers.dart';
import '../domain/liability.dart';

/// Loans, BNPL, PTPTN, and other non-card liabilities (spec section 17). Credit cards are handled
/// separately, on the account itself (see [creditCardDetailsProvider]) — a card's spending is
/// already an ordinary account, not a second liability record.
class LiabilitiesScreen extends ConsumerWidget {
  const LiabilitiesScreen({super.key});

  Future<void> _addLiability(BuildContext context, WidgetRef ref) async {
    final nameController = TextEditingController();
    final lenderController = TextEditingController();
    final amountController = TextEditingController();
    var type = LiabilityType.PERSONAL_LOAN;

    final added = await showAppBottomSheet<bool>(
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
              Text('New loan / liability', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<LiabilityType>(
                icon: const DuitlahIcon(Icons.expand_more, size: 18),
initialValue: type,
                decoration: const InputDecoration(labelText: 'Type'),
                items: LiabilityType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.name))).toList(),
                onChanged: (v) => setSheetState(() => type = v ?? type),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Name', controller: nameController),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Lender (optional)', controller: lenderController),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Original amount (RM)', controller: amountController, keyboardType: TextInputType.number),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: 'Create',
                onPressed: () async {
                  try {
                    await ref.read(liabilityRepositoryProvider).create(
                          type: type,
                          name: nameController.text.trim(),
                          lender: lenderController.text.trim().isEmpty ? null : lenderController.text.trim(),
                          originalAmount: amountController.text.trim(),
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
    if (added == true) ref.invalidate(liabilityListProvider);
  }

  Future<void> _recordPayment(BuildContext context, WidgetRef ref, Liability liability) async {
    final amountController = TextEditingController();
    final principalController = TextEditingController();

    final recorded = await showAppBottomSheet<bool>(
      context,
      builder: (context) => SingleChildScrollView(child: Padding(
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
            Text('Record payment', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            AppTextField(label: 'Amount paid (RM)', controller: amountController, keyboardType: TextInputType.number),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(label: 'Principal portion (RM)', controller: principalController, keyboardType: TextInputType.number),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: 'Save',
              onPressed: () async {
                try {
                  await ref.read(liabilityRepositoryProvider).recordPayment(
                        liability.id,
                        amount: amountController.text.trim(),
                        principalPortion: principalController.text.trim(),
                        paidOn: DateTime.now().toIso8601String().split('T').first,
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
    );
    if (recorded == true) ref.invalidate(liabilityListProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liabilities = ref.watch(liabilityListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Loans & Liabilities')),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(liabilityListProvider),
        child: liabilities.when(
          data: (items) => items.isEmpty
              ? ListView(
                  children: const [
                    SizedBox(height: 80),
                    EmptyView(icon: Icons.account_balance_outlined, title: 'No loans tracked yet'),
                  ],
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final liability = items[index];
                    return Card(
                      child: ListTile(
                        title: Text(liability.name),
                        subtitle: Text(
                          'Outstanding RM ${liability.outstandingPrincipal} of RM ${liability.originalAmount}',
                        ),
                        trailing: liability.status == LiabilityStatus.ACTIVE
                            ? TextButton(
                                onPressed: () => _recordPayment(context, ref, liability),
                                child: const Text('Pay'),
                              )
                            : Chip(label: Text(liability.status.name)),
                      ),
                    );
                  },
                ),
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(liabilityListProvider)),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => _addLiability(context, ref), child: const DuitlahIcon(Icons.add)),
    );
  }
}
