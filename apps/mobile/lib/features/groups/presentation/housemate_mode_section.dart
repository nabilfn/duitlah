import 'package:duitlah_mobile/core/widgets/app_adaptive_row.dart';
import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_state_views.dart';
import '../application/groups_providers.dart';

const _monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

/// Housemate mode's dashboard (product spec section 30): "Rent Paid / Electricity 1 unpaid" —
/// was at least one expense logged in each household category this month?
class HousemateModeSection extends ConsumerWidget {
  const HousemateModeSection({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = ref.watch(housemateMonthProvider(groupId));
    final dashboardAsync = ref.watch(
      housemateDashboardProvider((
        groupId: groupId,
        year: month.year,
        month: month.month,
      )),
    );
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppAdaptiveRow(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Housemate dashboard', style: theme.textTheme.titleMedium),
            Row(
              children: [
                IconButton(
                  icon: const DuitlahIcon(Icons.chevron_left),
                  onPressed: () =>
                      ref.read(housemateMonthProvider(groupId).notifier).state =
                          DateTime(month.year, month.month - 1),
                ),
                Text(
                  '${_monthNames[month.month - 1]} ${month.year}',
                  style: theme.textTheme.bodyMedium,
                ),
                IconButton(
                  icon: const DuitlahIcon(Icons.chevron_right),
                  onPressed: () =>
                      ref.read(housemateMonthProvider(groupId).notifier).state =
                          DateTime(month.year, month.month + 1),
                ),
              ],
            ),
          ],
        ),
        dashboardAsync.when(
          data: (dashboard) => Column(
            children: dashboard.categories
                .map(
                  (c) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: AppAdaptiveRow(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          c.category.name,
                          style: theme.textTheme.bodyMedium,
                        ),
                        Chip(
                          label: Text(c.paid ? 'Paid' : 'Unpaid'),
                          backgroundColor: c.paid
                              ? theme.colorScheme.primaryContainer
                              : theme.colorScheme.errorContainer,
                          labelStyle: TextStyle(
                            color: c.paid
                                ? theme.colorScheme.onPrimaryContainer
                                : theme.colorScheme.onErrorContainer,
                          ),
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(error: e),
        ),
      ],
    );
  }
}
