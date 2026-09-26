import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/digital_canvas.dart';
import '../../budgets/application/budgets_providers.dart';
import '../../budgets/domain/budget.dart';

/// One actual current budget; category and whole-account limits are never added.
class BudgetTrajectory extends ConsumerWidget {
  const BudgetTrajectory({super.key, required this.showAmounts});
  final bool showAmounts;
  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(budgetListProvider)
      .maybeWhen(
        data: (budgets) {
          final now = DateTime.now();
          final current = budgets.where(
            (b) =>
                b.cycleType == BudgetCycleType.CALENDAR_MONTH &&
                b.periodYear == now.year &&
                b.periodMonth == now.month,
          );
          if (current.isEmpty) return const SizedBox.shrink();
          final budget = current.first;
          final spent = double.tryParse(budget.spent) ?? 0;
          final limit = double.tryParse(budget.limit) ?? 0;
          final ratio = limit > 0 ? spent / limit : 0.0;
          return Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  showAmounts && limit > 0
                      ? '${(ratio * 100).round()}%'
                      : 'Your plan.',
                  style: Theme.of(context).textTheme.displaySmall
                      ?.copyWith(fontSize: 56),
                ),
                const SizedBox(height: 8),
                Text(
                  showAmounts
                      ? (limit > 0
                            ? 'of your ${budget.categoryName.toLowerCase()} budget\nis already in use.'
                            : 'No limit set for ${budget.categoryName.toLowerCase()}.')
                      : 'Budget amounts hidden.',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (showAmounts) ...[
                  const SizedBox(height: 16),
                  DuitlahTrajectory(
                    progress: ratio,
                    label: '${(ratio * 100).round()} percent of budget spent',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${Money.format(budget.spent)} spent · ${Money.format(budget.remaining)} remaining',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (spent > limit)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text('Over budget'),
                    ),
                ],
                TextButton(
                  onPressed: () => context.push(AppRoutes.budgets),
                  child: const Text('Review budget ↗'),
                ),
              ],
            ),
          );
        },
        orElse: () => const SizedBox.shrink(),
      );
}
