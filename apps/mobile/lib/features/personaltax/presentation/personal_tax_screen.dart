import 'package:duitlah_mobile/core/widgets/app_adaptive_row.dart';
import 'package:duitlah_mobile/core/widgets/app_page_body.dart';
import 'package:duitlah_mobile/core/theme/duitlah_colors.dart';
import 'package:duitlah_mobile/core/utils/money.dart';
import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/dialogs.dart';
import '../application/personal_tax_providers.dart';
import '../domain/personal_tax.dart';

/// The Personal Tax Centre (spec section 25) — a tax-preparation and estimation system, not an
/// LHDN filing integration. Every number shown here traces back to {@link
/// PersonalTaxCalculationService}'s own deterministic pipeline, and the disclaimer is always
/// shown alongside it, never omitted.
class PersonalTaxScreen extends ConsumerWidget {
  const PersonalTaxScreen({super.key});

  Future<void> _pickYear(BuildContext context, WidgetRef ref) async {
    final current = ref.read(selectedYearOfAssessmentProvider);
    final years = [current - 2, current - 1, current, current + 1];
    final picked = await showAppBottomSheet<int>(
      context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: years
            .map(
              (y) => ListTile(
                title: Text('YA $y'),
                onTap: () => Navigator.of(context).pop(y),
              ),
            )
            .toList(),
      ),
    );
    if (picked != null) {
      ref.read(selectedYearOfAssessmentProvider.notifier).state = picked;
    }
  }

  Future<void> _downloadSummary(BuildContext context, WidgetRef ref) async {
    try {
      final ya = ref.read(selectedYearOfAssessmentProvider);
      final bytes = await ref
          .read(personalTaxRepositoryProvider)
          .downloadPreparationSummary(ya);
      final file = File(
        '${Directory.systemTemp.path}/tax-preparation-ya$ya.pdf',
      );
      await file.writeAsBytes(bytes);
      await Share.shareXFiles([XFile(file.path)]);
    } catch (e) {
      if (context.mounted) {
        showErrorSnackBar(
          context,
          e is AppException ? e.message : 'Could not generate summary.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final yearOfAssessment = ref.watch(selectedYearOfAssessmentProvider);
    final calculation = ref.watch(personalTaxCalculationProvider);
    final readiness = ref.watch(filingReadinessProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Tax Centre'),
        actions: [
          TextButton(
            onPressed: () => _pickYear(context, ref),
            child: Text(
              'YA $yearOfAssessment',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
      body: AppPageBody(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(personalTaxCalculationProvider);
            ref.invalidate(filingReadinessProvider);
          },
          child: ListView(
            padding: AppSpacing.scrollInsets(context, floatingAction: false),
            children: [
              calculation.when(
                data: (c) => _CalculationCard(calculation: c),
                loading: () => const LoadingView(),
                error: (e, _) =>
                    e is AppException && e.code == 'TAX_YEAR_NOT_CONFIGURED'
                    ? EmptyView(
                        icon: Icons.calendar_month_outlined,
                        title: 'YA $yearOfAssessment not available',
                        message: e.message,
                      )
                    : ErrorView(
                        error: e,
                        onRetry: () =>
                            ref.invalidate(personalTaxCalculationProvider),
                      ),
              ),
              const SizedBox(height: AppSpacing.lg),
              readiness.when(
                data: (r) => _ReadinessCard(readiness: r),
                loading: () => const SizedBox.shrink(),
                error: (e, _) => const SizedBox.shrink(),
              ),
              const SizedBox(height: AppSpacing.lg),
              _NavTile(
                icon: Icons.payments_outlined,
                label: 'Income',
                route: AppRoutes.personalTaxIncome,
              ),
              _NavTile(
                icon: Icons.receipt_long_outlined,
                label: 'PCB',
                route: AppRoutes.personalTaxPcb,
              ),
              _NavTile(
                icon: Icons.volunteer_activism_outlined,
                label: 'Zakat',
                route: AppRoutes.personalTaxZakat,
              ),
              _NavTile(
                icon: Icons.fact_check_outlined,
                label: 'Tax Reliefs',
                route: AppRoutes.personalTaxReliefs,
              ),
              _NavTile(
                icon: Icons.description_outlined,
                label: 'Documents',
                route: AppRoutes.personalTaxDocuments,
              ),
              const SizedBox(height: AppSpacing.lg),
              OutlinedButton.icon(
                onPressed: () => _downloadSummary(context, ref),
                icon: const DuitlahIcon(Icons.picture_as_pdf_outlined),
                label: const Text('Download preparation summary'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalculationCard extends StatelessWidget {
  const _CalculationCard({required this.calculation});

  final PersonalTaxCalculation calculation;

  @override
  Widget build(BuildContext context) {
    final owesMoney = double.parse(calculation.estimatedPayableOrRefund) >= 0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              owesMoney ? 'Estimated payable' : 'Estimated refund',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'RM ${calculation.estimatedPayableOrRefund.replaceFirst('-', '')}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Divider(height: AppSpacing.lg),
            _Row('Total income', calculation.totalIncome),
            _Row('Chargeable income', calculation.chargeableIncome),
            _Row('Gross tax payable', calculation.grossTaxPayable),
            _Row('Rebate', calculation.rebate),
            _Row('Zakat rebate', calculation.zakatRebate),
            _Row('PCB already paid', calculation.pcbPaid),
            const SizedBox(height: AppSpacing.sm),
            Text(
              calculation.disclaimer,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.amount);

  final String label;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: AppAdaptiveRow(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), Text(Money.format(amount))],
      ),
    );
  }
}

class _ReadinessCard extends StatelessWidget {
  const _ReadinessCard({required this.readiness});

  final FilingReadiness readiness;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppAdaptiveRow(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filing readiness',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text('${readiness.readyPercent}% ready'),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ...readiness.items.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    DuitlahIcon(
                      item.ready
                          ? Icons.check_circle
                          : Icons.warning_amber_rounded,
                      size: 18,
                      color: item.ready
                          ? context.duitlahColors.positive
                          : context.duitlahColors.warning,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(child: Text(item.label)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.icon,
    required this.label,
    required this.route,
  });

  final IconData icon;
  final String label;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: ListTile(
        leading: DuitlahIcon(icon),
        title: Text(label),
        trailing: const DuitlahIcon(Icons.chevron_right),
        onTap: () => context.push(route),
      ),
    );
  }
}
