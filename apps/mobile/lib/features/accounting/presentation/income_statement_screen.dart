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

/// Income Statement — Revenue and Expense sections plus Net Income, colored
/// by sign, over a date range.
class IncomeStatementScreen extends ConsumerStatefulWidget {
  const IncomeStatementScreen({super.key, required this.spaceId});

  final String spaceId;

  @override
  ConsumerState<IncomeStatementScreen> createState() => _IncomeStatementScreenState();
}

class _IncomeStatementScreenState extends ConsumerState<IncomeStatementScreen> {
  late DateTime _from;
  late DateTime _to;
  bool _exporting = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _from = DateTime(now.year, now.month, 1);
    _to = DateTime(now.year, now.month + 1, 0);
  }

  Future<void> _export(ExportFormat format) async {
    setState(() => _exporting = true);
    try {
      final file = await ref.read(accountingExportRepositoryProvider).incomeStatement(
            widget.spaceId,
            from: _fmtDate(_from),
            to: _fmtDate(_to),
            format: format,
          );
      await Share.shareXFiles([XFile(file.path)]);
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e is AppException ? e.message : 'Export failed.');
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final report = ref.watch(
      incomeStatementReportProvider((spaceId: widget.spaceId, from: _fmtDate(_from), to: _fmtDate(_to))),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Income Statement'),
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

  final IncomeStatementReport report;

  @override
  Widget build(BuildContext context) {
    final netIncome = double.tryParse(report.netIncome) ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Revenue', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.xs),
        for (final l in report.revenueLines) _lineRow(context, l),
        const Divider(),
        _totalRow(context, 'Total Revenue', report.totalRevenue),
        const SizedBox(height: AppSpacing.lg),
        Text('Expenses', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.xs),
        for (final l in report.expenseLines) _lineRow(context, l),
        const Divider(),
        _totalRow(context, 'Total Expenses', report.totalExpenses),
        const SizedBox(height: AppSpacing.lg),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: (netIncome >= 0 ? Colors.green : Colors.red).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Net Income', style: Theme.of(context).textTheme.titleMedium),
              Text(
                'RM ${report.netIncome}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: netIncome >= 0 ? Colors.green : Colors.red,
                ),
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

  Widget _totalRow(BuildContext context, String label, String amount) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleSmall),
          Text(Money.format(amount), style: Theme.of(context).textTheme.titleSmall),
        ],
      );
}
