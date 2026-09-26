import 'package:duitlah_mobile/core/widgets/app_adaptive_row.dart';
import 'package:duitlah_mobile/core/widgets/app_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/amount_text.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/dialogs.dart';
import '../application/groups_providers.dart';

/// Trip mode's budget + category breakdown (product spec section 32: "Budget RM12,000 / Spent
/// RM8,920 / Remaining RM3,080").
class TripModeSection extends ConsumerWidget {
  const TripModeSection({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(tripSummaryProvider(groupId));
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppAdaptiveRow(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Trip budget', style: theme.textTheme.titleMedium),
            TextButton(
              onPressed: () => _setBudget(context, ref),
              child: Text(
                summaryAsync.valueOrNull?.budgetAmount == null
                    ? 'Set budget'
                    : 'Edit',
              ),
            ),
          ],
        ),
        summaryAsync.when(
          data: (summary) {
            if (summary.budgetAmount == null) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: EmptyView(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'No budget set yet',
                ),
              );
            }
            final budget = double.tryParse(summary.budgetAmount!) ?? 0;
            final spent = double.tryParse(summary.spent) ?? 0;
            final fraction = budget <= 0
                ? 0.0
                : (spent / budget).clamp(0, 1).toDouble();
            return Card(
              margin: const EdgeInsets.only(top: AppSpacing.sm),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      child: AppProgress(value: fraction, minHeight: 8),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppAdaptiveRow(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _Stat(label: 'Budget', amount: summary.budgetAmount!),
                        _Stat(label: 'Spent', amount: summary.spent),
                        _Stat(
                          label: 'Remaining',
                          amount: summary.remaining ?? '0',
                        ),
                      ],
                    ),
                    if (summary.spendingByCategory.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      const Divider(height: 1),
                      const SizedBox(height: AppSpacing.sm),
                      ...summary.spendingByCategory.map(
                        (c) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: AppAdaptiveRow(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                c.category.name,
                                style: theme.textTheme.bodySmall,
                              ),
                              AmountText(
                                c.amount,
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(error: e),
        ),
      ],
    );
  }

  Future<void> _setBudget(BuildContext context, WidgetRef ref) async {
    final amountController = TextEditingController();
    final currentAmount = ref
        .read(tripSummaryProvider(groupId))
        .valueOrNull
        ?.budgetAmount;
    if (currentAmount != null) amountController.text = currentAmount;

    final saved = await showAppBottomSheet<bool>(
      context,
      builder: (context) => SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.pageMargin,
            right: AppSpacing.pageMargin,
            top: AppSpacing.lg,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Trip budget',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Budget (RM)',
                controller: amountController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: 'Save',
                onPressed: () async {
                  try {
                    await ref
                        .read(groupsRepositoryProvider)
                        .setBudget(
                          groupId,
                          amount: amountController.text.trim(),
                        );
                    if (context.mounted) Navigator.of(context).pop(true);
                  } catch (e) {
                    if (context.mounted) {
                      showErrorSnackBar(
                        context,
                        e is AppException ? e.message : 'Something went wrong.',
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
    if (saved == true) ref.invalidate(tripSummaryProvider(groupId));
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.amount});

  final String label;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        AmountText(amount, style: Theme.of(context).textTheme.titleSmall),
      ],
    );
  }
}
