import 'package:duitlah_mobile/core/widgets/app_adaptive_row.dart';
import 'package:duitlah_mobile/core/widgets/app_page_body.dart';
import 'package:duitlah_mobile/core/widgets/app_field_group.dart';
import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:duitlah_mobile/core/utils/money.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_state_views.dart';
import '../application/accounting_providers.dart';
import '../domain/chart_of_accounts.dart';
import '../domain/journal_entries.dart';

String _fmtDate(DateTime d) => d.toIso8601String().substring(0, 10);

/// General Ledger — pick an account plus a date range, see its opening
/// balance, every posted line with a running balance, and the closing
/// balance.
class GeneralLedgerScreen extends ConsumerStatefulWidget {
  const GeneralLedgerScreen({super.key, required this.spaceId});

  final String spaceId;

  @override
  ConsumerState<GeneralLedgerScreen> createState() =>
      _GeneralLedgerScreenState();
}

class _GeneralLedgerScreenState extends ConsumerState<GeneralLedgerScreen> {
  late DateTime _from;
  late DateTime _to;
  LedgerAccount? _account;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _from = DateTime(now.year, now.month, 1);
    _to = DateTime(now.year, now.month + 1, 0);
  }

  @override
  Widget build(BuildContext context) {
    final accounts = ref.watch(chartOfAccountsListProvider(widget.spaceId));
    return Scaffold(
      appBar: AppBar(title: const Text('General Ledger')),
      body: AppPageBody(
        child: accounts.when(
          data: (items) {
            final active = items.where((a) => !a.archived).toList();
            if (active.isEmpty) {
              return const EmptyView(
                icon: Icons.account_tree_outlined,
                title: 'Set up the Chart of Accounts first',
              );
            }
            _account ??= active.first;
            return ListView(
              padding: AppSpacing.scrollInsets(context, floatingAction: false),
              children: [
                AppFieldGroup(
                  label: 'Account',
                  child: DropdownButtonFormField<LedgerAccount>(
                    itemHeight: null,
                    icon: const DuitlahIcon(Icons.expand_more, size: 18),
                    initialValue: _account,
                    isExpanded: true,
                    decoration: const InputDecoration(),
                    items: active
                        .map(
                          (a) => DropdownMenuItem(
                            value: a,
                            child: Text('${a.code} · ${a.name}'),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _account = v),
                  ),
                ),
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
                const SizedBox(height: AppSpacing.lg),
                if (_account != null)
                  _ReportBody(
                    spaceId: widget.spaceId,
                    accountId: _account!.id,
                    from: _fmtDate(_from),
                    to: _fmtDate(_to),
                  ),
              ],
            );
          },
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(error: e),
        ),
      ),
    );
  }
}

class _ReportBody extends ConsumerWidget {
  const _ReportBody({
    required this.spaceId,
    required this.accountId,
    required this.from,
    required this.to,
  });

  final String spaceId;
  final String accountId;
  final String from;
  final String to;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(
      generalLedgerReportProvider((
        spaceId: spaceId,
        accountId: accountId,
        from: from,
        to: to,
      )),
    );
    return report.when(
      data: (r) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: AppAdaptiveRow(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Opening balance'),
                  Text(
                    Money.format(r.openingBalance),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (r.lines.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: Text('No activity in this range.'),
            )
          else
            for (final line in r.lines)
              Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: AppRecordTile(
                  title: Text(line.description ?? '—'),
                  subtitle: Text(line.entryDate),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${line.direction == LedgerDirection.DEBIT ? 'Dr' : 'Cr'} ${Money.format(line.amount)}',
                      ),
                      Text(
                        'Bal ${Money.format(line.runningBalance)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
          const SizedBox(height: AppSpacing.sm),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: AppAdaptiveRow(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Closing balance',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    Money.format(r.closingBalance),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
        child: LoadingView(),
      ),
      error: (e, _) => ErrorView(error: e),
    );
  }
}
