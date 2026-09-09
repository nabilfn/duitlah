import 'package:duitlah_mobile/core/utils/money.dart';
import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/dialogs.dart';
import '../../exports/data/export_repository.dart' show ExportFormat;
import '../application/accounting_providers.dart';
import '../domain/reports.dart';

String _fmtDate(DateTime d) => d.toIso8601String().substring(0, 10);

/// Balance Sheet — Assets, Liabilities, Equity (including "Current
/// Earnings", the real cumulative net income not yet formally closed to
/// Retained Earnings — a documented simplification, not a bug) as of a
/// date, with a visual confirmation that Total Assets == Total Liabilities
/// + Equity.
class BalanceSheetScreen extends ConsumerStatefulWidget {
  const BalanceSheetScreen({super.key, required this.spaceId});

  final String spaceId;

  @override
  ConsumerState<BalanceSheetScreen> createState() => _BalanceSheetScreenState();
}

class _BalanceSheetScreenState extends ConsumerState<BalanceSheetScreen> {
  DateTime _asOf = DateTime.now();
  bool _exporting = false;

  Future<void> _export(ExportFormat format) async {
    setState(() => _exporting = true);
    try {
      final file = await ref
          .read(accountingExportRepositoryProvider)
          .balanceSheet(widget.spaceId, asOf: _fmtDate(_asOf), format: format);
      await Share.shareXFiles([XFile(file.path)]);
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e is AppException ? e.message : 'Export failed.');
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final report = ref.watch(balanceSheetReportProvider((spaceId: widget.spaceId, asOf: _fmtDate(_asOf))));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Balance Sheet'),
        actions: [
          PopupMenuButton<ExportFormat>(
            enabled: !_exporting,
            icon: const DuitlahIcon(Icons.ios_share),
            onSelected: _export,
            itemBuilder: (context) =>
                ExportFormat.values.map((f) => PopupMenuItem(value: f, child: Text('Share as ${f.name}'))).toList(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          OutlinedButton(
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _asOf,
                firstDate: DateTime(_asOf.year - 5),
                lastDate: DateTime(_asOf.year + 5),
              );
              if (picked != null) setState(() => _asOf = picked);
            },
            child: Text('As of ${_fmtDate(_asOf)}'),
          ),
          const SizedBox(height: AppSpacing.md),
          report.when(
            data: (r) => _Body(report: r),
            loading: () => const LoadingView(),
            error: (e, _) => ErrorView(error: e),
          ),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.report});

  final BalanceSheetReport report;

  @override
  Widget build(BuildContext context) {
    final totalAssets = double.tryParse(report.totalAssets) ?? 0;
    final totalLiabilitiesAndEquity = double.tryParse(report.totalLiabilitiesAndEquity) ?? 0;
    final balanced = (totalAssets - totalLiabilitiesAndEquity).abs() < 0.005;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Assets', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.xs),
        for (final l in report.assets) _lineRow(context, l),
        const Divider(),
        _totalRow(context, 'Total Assets', report.totalAssets),
        const SizedBox(height: AppSpacing.lg),
        Text('Liabilities', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.xs),
        for (final l in report.liabilities) _lineRow(context, l),
        const Divider(),
        _totalRow(context, 'Total Liabilities', report.totalLiabilities),
        const SizedBox(height: AppSpacing.lg),
        Text('Equity', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.xs),
        for (final l in report.equity) _lineRow(context, l),
        _lineRowRaw(context, 'Current Earnings', report.currentEarnings),
        const Divider(),
        _totalRow(context, 'Total Equity', report.totalEquity),
        const SizedBox(height: AppSpacing.lg),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: (balanced ? Colors.green : Colors.red).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Liabilities + Equity'),
                  Text(Money.format(report.totalLiabilitiesAndEquity), style: Theme.of(context).textTheme.titleSmall),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DuitlahIcon(
                    balanced ? Icons.check_circle_outline : Icons.error_outline,
                    color: balanced ? Colors.green : Colors.red,
                    size: 18,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    balanced ? 'Total Assets = Total Liabilities + Equity' : 'Assets do not match Liabilities + Equity',
                    style: TextStyle(color: balanced ? Colors.green : Colors.red, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _lineRow(BuildContext context, AccountAmountLine l) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text('${l.accountCode} ${l.accountName}'), Text(Money.format(l.amount))],
        ),
      );

  Widget _lineRowRaw(BuildContext context, String label, String amount) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(label), Text(Money.format(amount))],
        ),
      );

  Widget _totalRow(BuildContext context, String label, String amount) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleSmall),
          Text(Money.format(amount), style: Theme.of(context).textTheme.titleSmall),
        ],
      );
}
