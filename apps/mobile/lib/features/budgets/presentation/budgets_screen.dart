import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/dialogs.dart';
import '../application/budgets_providers.dart';
import '../domain/budget.dart';

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  Color _statusColor(BuildContext context, BudgetStatus status) {
    final semantic = context.semanticColors;
    return switch (status) {
      BudgetStatus.OK => semantic.success,
      BudgetStatus.WARNING => semantic.warning,
      BudgetStatus.EXCEEDED => Theme.of(context).colorScheme.error,
    };
  }

  Future<void> _addBudget(BuildContext context, WidgetRef ref) async {
    final limitController = TextEditingController();
    final now = DateTime.now();
    var cycleType = BudgetCycleType.CALENDAR_MONTH;
    DateTime? periodStart;
    DateTime? periodEnd;

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
              Text('New budget', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              AppTextField(label: 'Limit (RM)', controller: limitController, keyboardType: TextInputType.number),
              const SizedBox(height: AppSpacing.md),
              SegmentedButton<BudgetCycleType>(
                segments: const [
                  ButtonSegment(value: BudgetCycleType.CALENDAR_MONTH, label: Text('This month')),
                  ButtonSegment(value: BudgetCycleType.PAYDAY, label: Text('Payday cycle')),
                ],
                selected: {cycleType},
                onSelectionChanged: (s) => setSheetState(() {
                  cycleType = s.first;
                  periodStart = null;
                  periodEnd = null;
                }),
              ),
              if (cycleType != BudgetCycleType.CALENDAR_MONTH) ...[
                const SizedBox(height: AppSpacing.md),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(periodStart == null ? 'Start date' : periodStart!.toIso8601String().split('T').first),
                  trailing: const Icon(Icons.calendar_month_outlined),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: now,
                      firstDate: DateTime(now.year - 1),
                      lastDate: DateTime(now.year + 1),
                    );
                    if (picked != null) setSheetState(() => periodStart = picked);
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(periodEnd == null ? 'End date' : periodEnd!.toIso8601String().split('T').first),
                  trailing: const Icon(Icons.calendar_month_outlined),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: (periodStart ?? now).add(const Duration(days: 29)),
                      firstDate: DateTime(now.year - 1),
                      lastDate: DateTime(now.year + 2),
                    );
                    if (picked != null) setSheetState(() => periodEnd = picked);
                  },
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: 'Create',
                onPressed: () async {
                  try {
                    await ref.read(budgetsRepositoryProvider).createBudget(
                          periodYear: cycleType == BudgetCycleType.CALENDAR_MONTH ? now.year : null,
                          periodMonth: cycleType == BudgetCycleType.CALENDAR_MONTH ? now.month : null,
                          limit: limitController.text.trim(),
                          cycleType: cycleType,
                          periodStartDate: periodStart?.toIso8601String().split('T').first,
                          periodEndDate: periodEnd?.toIso8601String().split('T').first,
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
    if (added == true) ref.invalidate(budgetListProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgets = ref.watch(budgetListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Budgets')),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(budgetListProvider),
        child: budgets.when(
          data: (list) => list.isEmpty
              ? ListView(
                  children: const [
                    SizedBox(height: 80),
                    EmptyView(icon: Icons.pie_chart_outline, title: 'No budgets set for this month'),
                  ],
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final b = list[index];
                    final spent = double.tryParse(b.spent) ?? 0;
                    final limit = double.tryParse(b.limit) ?? 1;
                    final percentage = (spent / (limit == 0 ? 1 : limit)).clamp(0.0, 1.0);
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(b.categoryName, style: Theme.of(context).textTheme.titleSmall),
                                Text('RM ${b.spent} / ${b.limit}', style: Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: percentage,
                                minHeight: 8,
                                color: _statusColor(context, b.status),
                                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(budgetListProvider)),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => _addBudget(context, ref), child: const Icon(Icons.add)),
    );
  }
}
