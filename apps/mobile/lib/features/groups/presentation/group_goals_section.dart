import 'package:duitlah_mobile/core/widgets/app_adaptive_row.dart';
import 'package:duitlah_mobile/core/widgets/app_progress.dart';
import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
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
import '../application/groups_providers.dart';
import '../domain/group.dart';

/// Shared goals (product spec section 27) — available on every group type, not just Trip. See
/// [GroupGoal] for the "current amount is always SUM(contributions)" rule shared with the
/// personal-goals feature.
class GroupGoalsSection extends ConsumerWidget {
  const GroupGoalsSection({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(groupGoalsProvider(groupId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppAdaptiveRow(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Shared goals',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton.icon(
              onPressed: () => _createGoal(context, ref),
              icon: const DuitlahIcon(Icons.add, size: 18),
              label: const Text('New goal'),
            ),
          ],
        ),
        goalsAsync.when(
          data: (goals) => goals.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: EmptyView(
                    icon: Icons.flag_outlined,
                    title: 'No shared goals yet',
                  ),
                )
              : Column(
                  children: goals
                      .map((g) => _GoalCard(groupId: groupId, goal: g))
                      .toList(),
                ),
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(error: e),
        ),
      ],
    );
  }

  Future<void> _createGoal(BuildContext context, WidgetRef ref) async {
    final nameController = TextEditingController();
    final targetController = TextEditingController();

    final created = await showAppBottomSheet<bool>(
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
                'New shared goal',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(label: 'Name', controller: nameController),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                label: 'Target amount (RM)',
                controller: targetController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: 'Create goal',
                onPressed: () async {
                  try {
                    await ref
                        .read(groupsRepositoryProvider)
                        .createGoal(
                          groupId,
                          name: nameController.text.trim(),
                          targetAmount: targetController.text.trim(),
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
    if (created == true) ref.invalidate(groupGoalsProvider(groupId));
  }
}

class _GoalCard extends ConsumerWidget {
  const _GoalCard({required this.groupId, required this.goal});

  final String groupId;
  final GroupGoal goal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final percentage = double.tryParse(goal.percentage) ?? 0;

    return Card(
      margin: const EdgeInsets.only(top: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppAdaptiveRow(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(goal.name, style: theme.textTheme.titleSmall),
                TextButton(
                  onPressed: () => _contribute(context, ref),
                  child: const Text('Contribute'),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: AppProgress(
                value: (percentage / 100).clamp(0, 1),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 8),
            AppAdaptiveRow(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AmountText(
                  goal.currentAmount,
                  style: theme.textTheme.bodyMedium,
                ),
                Text(
                  'of ${goal.targetAmount}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
            if (goal.byMember.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: goal.byMember
                    .map(
                      (m) => Text(
                        '${m.displayName}: RM${m.totalContributed}',
                        style: theme.textTheme.bodySmall,
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _contribute(BuildContext context, WidgetRef ref) async {
    final amountController = TextEditingController();

    final added = await showAppBottomSheet<bool>(
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
                'Contribute to ${goal.name}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Amount (RM)',
                controller: amountController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: 'Contribute',
                onPressed: () async {
                  try {
                    await ref
                        .read(groupsRepositoryProvider)
                        .addGoalContribution(
                          groupId,
                          goal.id,
                          amount: amountController.text.trim(),
                          occurredOn: DateTime.now()
                              .toIso8601String()
                              .split('T')
                              .first,
                          idempotencyKey: const Uuid().v4(),
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
    if (added == true) ref.invalidate(groupGoalsProvider(groupId));
  }
}
