import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_state_views.dart';
import '../application/financial_health_providers.dart';

/// A deterministic, explainable score (spec section 20) — never a black box, never implied to be
/// a credit score. Every component shown here carries its own weight and plain-language reasoning.
class FinancialHealthScreen extends ConsumerWidget {
  const FinancialHealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final health = ref.watch(financialHealthProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Financial Health')),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(financialHealthProvider),
        child: health.when(
          data: (h) => ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Center(
                child: Column(
                  children: [
                    Text('${double.parse(h.score).round()}', style: Theme.of(context).textTheme.displayMedium),
                    Text('out of 100', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              if (h.recommendations.isNotEmpty) ...[
                Text('Recommendations', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                ...h.recommendations.map(
                  (r) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const DuitlahIcon(Icons.lightbulb_outline, size: 18),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(child: Text(r)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
              Text('How this is calculated', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              ...h.components.map(
                (c) => Card(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(c.label, style: Theme.of(context).textTheme.titleSmall),
                            Text('${double.parse(c.score).round()}/100'),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(c.explanation, style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(financialHealthProvider)),
        ),
      ),
    );
  }
}
