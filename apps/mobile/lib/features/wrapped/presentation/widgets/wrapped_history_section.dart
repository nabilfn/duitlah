import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/duitlah_colors.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/financial_surfaces.dart';
import '../../application/wrapped_providers.dart';
import '../../domain/wrapped.dart';

/// Analytics → "Monthly Stories" — every completed month's Wrapped, newest first, so a
/// user who skipped the Home promo can still find any past story. Renders nothing when
/// history is empty (a brand-new account with no completed month yet) rather than an
/// empty-state card, since this section is a bonus, not a primary Analytics feature.
class WrappedHistorySection extends ConsumerWidget {
  const WrappedHistorySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(wrappedHistoryProvider);
    return history.when(
      data: (items) {
        if (items.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SectionHeader('Monthly Stories'),
            const SizedBox(height: 12),
            SizedBox(
              height: 128,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, i) =>
                    _WrappedHistoryTile(item: items[i]),
              ),
            ),
          ],
        );
      },
      loading: () => const LoadingView(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

class _WrappedHistoryTile extends StatelessWidget {
  const _WrappedHistoryTile({required this.item});
  final WrappedHistoryItem item;

  @override
  Widget build(BuildContext context) {
    final label = DateFormat('MMM').format(DateTime(item.year, item.month));
    return Material(
      color: context.duitlahColors.surfaceElevated,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: () => context.push(AppRoutes.wrapped(item.year, item.month)),
        child: Container(
          width: 108,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: context.duitlahColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: context.duitlahColors.textPrimary,
                    ),
                  ),
                  if (!item.viewed)
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: context.duitlahColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              Text(
                item.viewed
                    ? (item.personaName ?? 'Your monthly story')
                    : 'Discover your story',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  color: context.duitlahColors.textSecondary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
