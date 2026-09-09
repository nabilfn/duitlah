import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/amount_text.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/dialogs.dart';
import '../../budgets/application/budgets_providers.dart';
import '../../budgets/domain/budget.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  Future<void> _addGoal(BuildContext context, WidgetRef ref) async {
    final nameController = TextEditingController();
    final targetController = TextEditingController();
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
            Text('New goal', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            AppTextField(label: 'Goal name', controller: nameController),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(label: 'Target amount (RM)', controller: targetController, keyboardType: TextInputType.number),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: 'Create goal',
              onPressed: () async {
                try {
                  await ref.read(goalsRepositoryProvider).createGoal(
                        name: nameController.text.trim(),
                        type: GoalType.CUSTOM,
                        targetAmount: targetController.text.trim(),
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
    if (added == true) ref.invalidate(goalListProvider);
  }

  Future<void> _addContribution(BuildContext context, WidgetRef ref, String goalId) async {
    final amountController = TextEditingController();
    await showAppBottomSheet(
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
            Text('Add contribution', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            AppTextField(label: 'Amount (RM)', controller: amountController, keyboardType: TextInputType.number),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: 'Add contribution',
              onPressed: () async {
                try {
                  await ref.read(goalsRepositoryProvider).addContribution(
                        goalId,
                        amount: amountController.text.trim(),
                        occurredOn: DateTime.now().toIso8601String().split('T').first,
                        idempotencyKey: const Uuid().v4(),
                      );
                  ref.invalidate(goalListProvider);
                  if (context.mounted) Navigator.of(context).pop();
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
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(goalListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Goals')),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(goalListProvider),
        child: goals.when(
          data: (list) => list.isEmpty
              ? ListView(
                  children: const [
                    SizedBox(height: 80),
                    EmptyView(icon: Icons.flag_outlined, title: 'No goals yet'),
                  ],
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 104),
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final g = list[index];
                    final percentage = (double.tryParse(g.percentage) ?? 0).clamp(0.0, 100.0) / 100;
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: Text(g.name, style: Theme.of(context).textTheme.titleMedium)),
                                TextButton(
                                  onPressed: () => _addContribution(context, ref, g.id),
                                  child: const Text('Contribute'),
                                ),
                              ],
                            ),
                            AmountText(g.currentAmount, style: Theme.of(context).textTheme.headlineSmall),
                            const SizedBox(height: 4),
                            Text('of ${Money.format(g.targetAmount)} · ${g.percentage}% saved', style: Theme.of(context).textTheme.bodySmall),
                            if (g.targetDate != null) Text('Target date ${g.targetDate}', style: Theme.of(context).textTheme.bodySmall),
                            const SizedBox(height: AppSpacing.sm),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(value: percentage, minHeight: 8, backgroundColor: Theme.of(context).colorScheme.outline, semanticsLabel: g.name, semanticsValue: "${g.percentage}% saved"),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(goalListProvider)),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(label: const Text('New goal'), onPressed: () => _addGoal(context, ref), icon: const DuitlahIcon(Icons.add)),
    );
  }
}
