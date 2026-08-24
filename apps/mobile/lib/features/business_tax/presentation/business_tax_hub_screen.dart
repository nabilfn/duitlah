import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_state_views.dart';
import '../application/business_tax_providers.dart';
import '../domain/business_tax.dart';

String _fmtDate(DateTime d) => d.toIso8601String().substring(0, 10);

/// Maps a raw `missingFields` entry from `einvoice-readiness` to plain-
/// language copy — the backend sends field names, not user-facing text.
String _missingFieldLabel(String field) {
  switch (field) {
    case 'registrationNumber':
      return 'Add your business registration number';
    case 'tin':
      return "Add your business's TIN";
    case 'businessType':
      return 'Set your business type';
    case 'annualRevenue':
      return 'Add your annual revenue';
    case 'industry':
      return 'Set your industry';
    case 'financialYear':
      return 'Set your financial year start and end dates';
    default:
      return field;
  }
}

/// Landing screen for Phase 10 — Business Tax (LHDN / MyInvois / SST),
/// reached from the Business Dashboard's "Business Tax" tile. All three
/// endpoints are reads, so — mirroring `inventory_hub_screen.dart`'s
/// report-plus-list single-hub shape rather than a route per concern — this
/// combines the e-Invoice readiness checklist, the SST collected/payable
/// report over a date range, and the global SST rate table on one screen.
class BusinessTaxHubScreen extends ConsumerStatefulWidget {
  const BusinessTaxHubScreen({super.key, required this.spaceId});

  final String spaceId;

  @override
  ConsumerState<BusinessTaxHubScreen> createState() => _BusinessTaxHubScreenState();
}

class _BusinessTaxHubScreenState extends ConsumerState<BusinessTaxHubScreen> {
  late DateTime _from;
  late DateTime _to;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _from = DateTime(now.year, now.month, 1);
    _to = DateTime(now.year, now.month + 1, 0);
  }

  SstReportFilter get _reportFilter => (spaceId: widget.spaceId, from: _fmtDate(_from), to: _fmtDate(_to));

  @override
  Widget build(BuildContext context) {
    final readiness = ref.watch(einvoiceReadinessProvider(widget.spaceId));
    final report = ref.watch(sstReportProvider(_reportFilter));
    final rates = ref.watch(sstRateListProvider(widget.spaceId));

    return Scaffold(
      appBar: AppBar(title: const Text('Business Tax')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(einvoiceReadinessProvider(widget.spaceId));
          ref.invalidate(sstReportProvider(_reportFilter));
          ref.invalidate(sstRateListProvider(widget.spaceId));
        },
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text('e-Invoice readiness', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            readiness.when(
              data: (r) => _ReadinessCard(spaceId: widget.spaceId, readiness: r),
              loading: () => const LoadingView(),
              error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(einvoiceReadinessProvider(widget.spaceId))),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('SST report', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton(
              onPressed: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(_from.year - 5),
                  lastDate: DateTime(_to.year + 5),
                  initialDateRange: DateTimeRange(start: _from, end: _to),
                );
                if (picked != null) {
                  setState(() {
                    _from = picked.start;
                    _to = picked.end;
                  });
                }
              },
              child: Text('${_fmtDate(_from)} to ${_fmtDate(_to)}'),
            ),
            const SizedBox(height: AppSpacing.sm),
            report.when(
              data: (r) => Card(
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Collected tax'),
                      subtitle: Text('${r.from} to ${r.to}'),
                      trailing: Text('RM ${r.collectedTax}', style: Theme.of(context).textTheme.titleMedium),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: const Text('Payable tax'),
                      trailing: Text('RM ${r.payableTax}', style: Theme.of(context).textTheme.titleMedium),
                    ),
                  ],
                ),
              ),
              loading: () => const LoadingView(),
              error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(sstReportProvider(_reportFilter))),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('SST rates', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Reference rates set by LHDN — not editable here.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            rates.when(
              data: (items) => items.isEmpty
                  ? const EmptyView(icon: Icons.percent_outlined, title: 'No SST rates published yet')
                  : Column(children: items.map((r) => _SstRateTile(rate: r)).toList()),
              loading: () => const LoadingView(),
              error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(sstRateListProvider(widget.spaceId))),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadinessCard extends StatelessWidget {
  const _ReadinessCard({required this.spaceId, required this.readiness});

  final String spaceId;
  final EInvoiceReadiness readiness;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ready = readiness.ready;
    return Card(
      color: readiness.mandated
          ? (ready ? theme.colorScheme.primaryContainer : theme.colorScheme.errorContainer)
          : null,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  ready ? Icons.check_circle_outline : Icons.warning_amber_outlined,
                  color: ready ? theme.colorScheme.primary : theme.colorScheme.error,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    readiness.mandated
                        ? 'e-Invoicing is mandatory for your business'
                        : 'e-Invoicing is not yet mandatory for your business',
                    style: theme.textTheme.titleSmall,
                  ),
                ),
              ],
            ),
            if (readiness.currentRuleEffectiveDate != null || readiness.currentRuleThreshold != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                [
                  if (readiness.currentRuleThreshold != null)
                    'Threshold: RM ${readiness.currentRuleThreshold}',
                  if (readiness.currentRuleEffectiveDate != null)
                    'Effective ${readiness.currentRuleEffectiveDate}',
                ].join(' · '),
                style: theme.textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            if (ready)
              Text('Your business profile has everything needed to submit e-Invoices.', style: theme.textTheme.bodyMedium)
            else ...[
              Text('Missing before you can submit e-Invoices:', style: theme.textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.xs),
              ...readiness.missingFields.map(
                (f) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.circle, size: 6),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(child: Text(_missingFieldLabel(f), style: theme.textTheme.bodySmall)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              SecondaryButton(
                label: 'Update business profile',
                onPressed: () => context.push(AppRoutes.businessProfile(spaceId)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SstRateTile extends StatelessWidget {
  const _SstRateTile({required this.rate});

  final SstRate rate;

  @override
  Widget build(BuildContext context) {
    final isCurrent = rate.effectiveTo == null;
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        title: Text('${rate.taxType == TaxType.SALES ? 'Sales' : 'Service'} tax — ${rate.ratePercent}%'),
        subtitle: Text(
          isCurrent
              ? 'Effective from ${rate.effectiveFrom}${rate.description != null ? '\n${rate.description}' : ''}'
              : 'From ${rate.effectiveFrom} to ${rate.effectiveTo}${rate.description != null ? '\n${rate.description}' : ''}',
        ),
        isThreeLine: rate.description != null,
        trailing: isCurrent
            ? Chip(
                label: const Text('Current'),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                visualDensity: VisualDensity.compact,
              )
            : null,
      ),
    );
  }
}
