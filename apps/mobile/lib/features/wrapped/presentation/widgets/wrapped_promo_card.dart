import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/duitlah_colors.dart';
import '../../../../core/widgets/duitlah_icon.dart';
import '../../application/wrapped_providers.dart';

/// Home's "your Wrapped is ready" nudge — cheap to render on every load since
/// [wrappedPromoProvider] never generates anything, only checks whether a completed
/// month's story already exists and hasn't been viewed yet. Renders nothing at all
/// while loading, on error, or once [WrappedPromo.available] is false — this is a
/// bonus surface, never a spot that should show a spinner or an error state.
class WrappedPromoCard extends ConsumerWidget {
  const WrappedPromoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promo = ref.watch(wrappedPromoProvider);
    return promo.maybeWhen(
      data: (p) {
        if (!p.available || p.year == null || p.month == null) {
          return const SizedBox.shrink();
        }
        final monthLabel = DateFormat('MMMM')
            .format(DateTime(p.year!, p.month!));
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Material(
            color: context.duitlahColors.primaryDark,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              onTap: () => context.push(AppRoutes.wrapped(p.year!, p.month!)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .14),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: DuitlahIcon(
                          Icons.auto_awesome,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your $monthLabel Wrapped is ready',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'See your story →',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: .78),
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const DuitlahIcon(Icons.chevron_right, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
