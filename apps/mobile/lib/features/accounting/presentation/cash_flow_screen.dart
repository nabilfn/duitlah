import 'package:duitlah_mobile/core/theme/duitlah_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_state_views.dart';
import '../application/accounting_providers.dart';

String _fmtDate(DateTime d) => d.toIso8601String().substring(0, 10);

/// Cash Flow — a direct-method summary (opening cash, total in, total out,
/// net change, closing cash) over a date range, computed over accounts
/// flagged `cashEquivalent` in the Chart of Accounts. This is a documented
/// simplification of this phase (no Operating/Investing/Financing
/// categorization), not a bug.
class CashFlowScreen extends ConsumerStatefulWidget {
  const CashFlowScreen({super.key, required this.spaceId});

  final String spaceId;

  @override
  ConsumerState<CashFlowScreen> createState() => _CashFlowScreenState();
}

class _CashFlowScreenState extends ConsumerState<CashFlowScreen> {
  late DateTime _from;
  late DateTime _to;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _from = DateTime(now.year, now.month, 1);
    _to = DateTime(now.year, now.month + 1, 0);
  }

  @override
  Widget build(BuildContext context) {
    final report = ref.watch(cashFlowReportProvider((spaceId: widget.spaceId, from: _fmtDate(_from), to: _fmtDate(_to))));
    return Scaffold(
      appBar: AppBar(title: const Text('Cash Flow')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
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
          const SizedBox(height: AppSpacing.md),
          Text(
            'A direct-method summary over accounts flagged cash-equivalent — not a full '
            'Operating/Investing/Financing categorization.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.lg),
          report.when(
            data: (r) => Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    _row(context, 'Opening cash', r.openingCash),
                    const Divider(),
                    _row(context, 'Total cash in', r.totalCashIn, color: context.duitlahColors.positive),
                    _row(context, 'Total cash out', r.totalCashOut, color: context.duitlahColors.negative),
                    const Divider(),
                    _row(context, 'Net change', r.netChange),
                    const Divider(),
                    _row(context, 'Closing cash', r.closingCash, bold: true),
                  ],
                ),
              ),
            ),
            loading: () => const LoadingView(),
            error: (e, _) => ErrorView(error: e),
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String label, String amount, {Color? color, bool bold = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: bold ? Theme.of(context).textTheme.titleMedium : null),
            Text(
              'RM $amount',
              style: (bold ? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.bodyMedium)
                  ?.copyWith(color: color, fontWeight: bold ? FontWeight.bold : null),
            ),
          ],
        ),
      );
}
