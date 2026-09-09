import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_state_views.dart';
import '../application/subscriptions_providers.dart';
import '../domain/entitlement.dart';

const _plusFeatures = [
  'Unlimited groups',
  'More smart receipt scans',
  'Advanced analytics & forecasting',
  'AI financial assistant',
  'Trip mode & multi-currency',
  'Unlimited goals',
  'Full financial calendar',
];

/// Shows the user's current plan/usage and, for FREE users, what Duitlah+ unlocks. Deliberately
/// does not offer an in-app purchase button: this build has no real StoreKit/Play Billing/Stripe
/// integration wired up (see backend `SubscriptionVerifier` — every source currently rejects
/// verification honestly rather than faking a successful purchase), so there is nothing yet for a
/// "Subscribe" button to actually do.
class DuitlahPlusScreen extends ConsumerWidget {
  const DuitlahPlusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entitlementAsync = ref.watch(entitlementProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Duitlah+')),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(entitlementProvider),
        child: entitlementAsync.when(
          data: (entitlement) => ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Card(
                color: entitlement.tier == SubscriptionTier.PLUS
                    ? theme.colorScheme.primaryContainer
                    : null,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          DuitlahIcon(
                            entitlement.tier == SubscriptionTier.PLUS
                                ? Icons.workspace_premium
                                : Icons.workspace_premium_outlined,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            entitlement.tier == SubscriptionTier.PLUS ? 'Duitlah+' : 'Duitlah Free',
                            style: theme.textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _UsageRow(
                        label: 'Groups',
                        used: entitlement.activeGroupCount,
                        max: entitlement.maxActiveGroups,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _UsageRow(
                        label: 'Receipt scans this month',
                        used: entitlement.receiptScansThisMonth,
                        max: entitlement.maxReceiptScansPerMonth,
                      ),
                    ],
                  ),
                ),
              ),
              if (entitlement.tier == SubscriptionTier.FREE) ...[
                const SizedBox(height: AppSpacing.xl),
                Text('Duitlah+ unlocks', style: theme.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                Card(
                  child: Column(
                    children: _plusFeatures
                        .map((f) => ListTile(
                              leading: const DuitlahIcon(Icons.check_circle_outline),
                              title: Text(f),
                              dense: true,
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'RM9.90/month or RM89.90/year',
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Text(
                    "In-app purchases aren't available in this build yet — Duitlah+ checkout is "
                    'coming soon.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ),
              ],
            ],
          ),
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(entitlementProvider)),
        ),
      ),
    );
  }
}

class _UsageRow extends StatelessWidget {
  const _UsageRow({required this.label, required this.used, required this.max});

  final String label;
  final int used;
  final int? max;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unlimited = max == null;
    final fraction = unlimited ? 0.0 : (max! == 0 ? 1.0 : used / max!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: theme.textTheme.bodyMedium),
            Text(
              unlimited ? 'Unlimited' : '$used / $max',
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        if (!unlimited) ...[
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: LinearProgressIndicator(value: fraction.clamp(0, 1)),
          ),
        ],
      ],
    );
  }
}
