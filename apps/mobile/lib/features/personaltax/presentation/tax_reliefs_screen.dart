import 'package:duitlah_mobile/core/utils/money.dart';
import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
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

/// The pipeline's own last two boxes (spec section 27): a candidate — created either manually
/// here, or automatically from a TAX_EVIDENCE receipt upload in the Receipt Vault — is confirmed
/// or rejected here, never silently promoted.
class TaxReliefsScreen extends ConsumerWidget {
  const TaxReliefsScreen({super.key});

  Future<void> _confirm(BuildContext context, WidgetRef ref, TaxReliefCandidate candidate) async {
    var category = candidate.category ?? PersonalTaxReliefCategory.LIFESTYLE;
    final amountController = TextEditingController(text: candidate.suggestedAmount);

    final confirmed = await showAppBottomSheet<bool>(
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
              Text('Confirm relief', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<PersonalTaxReliefCategory>(
                icon: const DuitlahIcon(Icons.expand_more, size: 18),
initialValue: category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: PersonalTaxReliefCategory.values.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
                onChanged: (v) => setSheetState(() => category = v ?? category),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Amount (RM)', controller: amountController, keyboardType: TextInputType.number),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: 'Confirm',
                onPressed: () async {
                  try {
                    await ref.read(personalTaxRepositoryProvider).confirmReliefCandidate(
                          candidate.id,
                          category: category,
                          amount: amountController.text.trim(),
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
    if (confirmed == true) {
      ref.invalidate(reliefCandidateListProvider);
      ref.invalidate(confirmedReliefListProvider);
      ref.invalidate(personalTaxCalculationProvider);
      ref.invalidate(filingReadinessProvider);
    }
  }

  Future<void> _addCandidate(BuildContext context, WidgetRef ref) async {
    final amountController = TextEditingController();
    final ya = ref.read(selectedYearOfAssessmentProvider);
    final added = await showAppBottomSheet<bool>(
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
            Text('New relief — YA $ya', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            AppTextField(label: 'Amount (RM)', controller: amountController, keyboardType: TextInputType.number),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: 'Add',
              onPressed: () async {
                try {
                  await ref
                      .read(personalTaxRepositoryProvider)
                      .createReliefCandidate(yearOfAssessment: ya, suggestedAmount: amountController.text.trim());
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
    if (added == true) ref.invalidate(reliefCandidateListProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final candidates = ref.watch(reliefCandidateListProvider);
    final confirmed = ref.watch(confirmedReliefListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Tax Reliefs')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(reliefCandidateListProvider);
          ref.invalidate(confirmedReliefListProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text('Confirmed', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            confirmed.when(
              data: (items) => items.isEmpty
                  ? const Text('None confirmed yet.')
                  : Column(
                      children: items
                          .map((r) => Card(child: ListTile(title: Text(r.category.name), trailing: Text(Money.format(r.confirmedAmount)))))
                          .toList(),
                    ),
              loading: () => const LoadingView(),
              error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(confirmedReliefListProvider)),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Pending review', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            candidates.when(
              data: (items) {
                final pending = items.where((c) => c.status == TaxReliefCandidateStatus.NEEDS_REVIEW || c.status == TaxReliefCandidateStatus.POTENTIALLY_ELIGIBLE).toList();
                return pending.isEmpty
                    ? const Text('Nothing pending.')
                    : Column(
                        children: pending
                            .map(
                              (c) => Card(
                                child: ListTile(
                                  title: Text(c.category?.name ?? 'Uncategorized'),
                                  subtitle: Text('RM ${c.suggestedAmount} · ${c.status.name}'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextButton(
                                        onPressed: () async {
                                          await ref.read(personalTaxRepositoryProvider).rejectReliefCandidate(c.id);
                                          ref.invalidate(reliefCandidateListProvider);
                                        },
                                        child: const Text('Ignore'),
                                      ),
                                      FilledButton(onPressed: () => _confirm(context, ref, c), child: const Text('Confirm')),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      );
              },
              loading: () => const LoadingView(),
              error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(reliefCandidateListProvider)),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => _addCandidate(context, ref), child: const DuitlahIcon(Icons.add)),
    );
  }
}
