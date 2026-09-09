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

/// Trial Balance — the double-entry self-check: every ledger account's
/// debit/credit balance as of a date, with a totals row that should always
/// match (visually called out below the table).
class TrialBalanceScreen extends ConsumerStatefulWidget {
  const TrialBalanceScreen({super.key, required this.spaceId});

  final String spaceId;

  @override
  ConsumerState<TrialBalanceScreen> createState() => _TrialBalanceScreenState();
}

class _TrialBalanceScreenState extends ConsumerState<TrialBalanceScreen> {
  DateTime _asOf = DateTime.now();
  bool _exporting = false;

  Future<void> _export(ExportFormat format) async {
    setState(() => _exporting = true);
    try {
      final file = await ref
          .read(accountingExportRepositoryProvider)
          .trialBalance(widget.spaceId, asOf: _fmtDate(_asOf), format: format);
      await Share.shareXFiles([XFile(file.path)]);
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e is AppException ? e.message : 'Export failed.');
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final report = ref.watch(trialBalanceReportProvider((spaceId: widget.spaceId, asOf: _fmtDate(_asOf))));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trial Balance'),
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
            data: (r) => _Table(report: r),
            loading: () => const LoadingView(),
            error: (e, _) => ErrorView(error: e),
          ),
        ],
      ),
    );
  }
}

class _Table extends StatelessWidget {
  const _Table({required this.report});

  final TrialBalanceReport report;

  @override
  Widget build(BuildContext context) {
    final totalDebit = double.tryParse(report.totalDebit) ?? 0;
    final totalCredit = double.tryParse(report.totalCredit) ?? 0;
    final balanced = (totalDebit - totalCredit).abs() < 0.005;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Account')),
              DataColumn(label: Text('Debit'), numeric: true),
              DataColumn(label: Text('Credit'), numeric: true),
            ],
            rows: [
              for (final line in report.lines)
                DataRow(cells: [
                  DataCell(Text('${line.accountCode} ${line.accountName}')),
                  DataCell(Text(line.debit)),
                  DataCell(Text(line.credit)),
                ]),
              DataRow(cells: [
                const DataCell(Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
                DataCell(Text(report.totalDebit, style: const TextStyle(fontWeight: FontWeight.bold))),
                DataCell(Text(report.totalCredit, style: const TextStyle(fontWeight: FontWeight.bold))),
              ]),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: (balanced ? Colors.green : Colors.red).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DuitlahIcon(
                balanced ? Icons.check_circle_outline : Icons.error_outline,
                color: balanced ? Colors.green : Colors.red,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                balanced ? 'Debits equal credits — books balance' : 'Debits and credits do not match',
                style: TextStyle(color: balanced ? Colors.green : Colors.red, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
