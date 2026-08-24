import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/dialogs.dart';
import '../application/accounting_providers.dart';
import '../domain/chart_of_accounts.dart';
import '../domain/journal_entries.dart';
import 'widgets/journal_line_editor.dart';

String _fmtDate(DateTime d) => d.toIso8601String().substring(0, 10);

double _sum(JournalEntry entry, LedgerDirection direction) => entry.lines
    .where((l) => l.direction == direction)
    .fold(0.0, (sum, l) => sum + (double.tryParse(l.amount) ?? 0));

String sourceLabel(JournalSourceType type) {
  switch (type) {
    case JournalSourceType.MANUAL:
      return 'Manual';
    case JournalSourceType.INVOICE_ISSUED:
      return 'Auto-posted: Invoice Issued';
    case JournalSourceType.INVOICE_PAYMENT:
      return 'Auto-posted: Invoice Payment';
    case JournalSourceType.EXPENSE_PAYMENT:
      return 'Auto-posted: Expense Payment';
    case JournalSourceType.CREDIT_NOTE:
      return 'Auto-posted: Credit Note';
  }
}

/// Journal entries — a date-range-filterable list (defaulting to the
/// current month) of both manual entries and the four auto-posted source
/// types (shown read-only), plus a "New manual entry" form with a
/// dynamic list of DEBIT/CREDIT lines and a live balance indicator.
class JournalEntriesScreen extends ConsumerStatefulWidget {
  const JournalEntriesScreen({super.key, required this.spaceId});

  final String spaceId;

  @override
  ConsumerState<JournalEntriesScreen> createState() => _JournalEntriesScreenState();
}

class _JournalEntriesScreenState extends ConsumerState<JournalEntriesScreen> {
  late DateTime _from;
  late DateTime _to;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _from = DateTime(now.year, now.month, 1);
    _to = DateTime(now.year, now.month + 1, 0);
  }

  JournalEntriesFilter get _filter => (spaceId: widget.spaceId, from: _fmtDate(_from), to: _fmtDate(_to));

  Future<void> _pickRange(BuildContext context) async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(_from.year - 5),
      lastDate: DateTime(_to.year + 5),
      initialDateRange: DateTimeRange(start: _from, end: _to),
    );
    if (range != null) {
      setState(() {
        _from = range.start;
        _to = range.end;
      });
    }
  }

  Future<void> _viewEntry(BuildContext context, JournalEntry entry) {
    return showAppBottomSheet<void>(
      context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(entry.description, style: Theme.of(context).textTheme.titleLarge),
              Text(entry.entryDate, style: Theme.of(context).textTheme.bodySmall),
              if (entry.sourceType != JournalSourceType.MANUAL) ...[
                const SizedBox(height: AppSpacing.xs),
                Chip(label: Text(sourceLabel(entry.sourceType)), visualDensity: VisualDensity.compact),
              ],
              const Divider(height: AppSpacing.lg),
              for (final line in entry.lines)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${line.accountCode} · ${line.accountName}'
                          '${line.description != null ? ' — ${line.description}' : ''}',
                        ),
                      ),
                      Text(
                        '${line.direction == LedgerDirection.DEBIT ? 'Dr' : 'Cr'} RM ${line.amount}',
                        style: TextStyle(
                          color: line.direction == LedgerDirection.DEBIT ? Colors.blue : Colors.orange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _newEntry(BuildContext context) async {
    final accounts = await ref.read(chartOfAccountsRepositoryProvider).listAccounts(widget.spaceId);
    final active = accounts.where((a) => !a.archived).toList();
    if (!context.mounted) return;
    if (active.isEmpty) {
      showErrorSnackBar(context, 'Set up the Chart of Accounts first.');
      return;
    }
    final saved = await showAppBottomSheet<bool>(
      context,
      builder: (context) => _JournalEntryFormSheet(spaceId: widget.spaceId, accounts: active),
    );
    if (saved == true) ref.invalidate(journalEntryListProvider(_filter));
  }

  @override
  Widget build(BuildContext context) {
    final entries = ref.watch(journalEntryListProvider(_filter));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal Entries'),
        actions: [
          IconButton(icon: const Icon(Icons.date_range_outlined), onPressed: () => _pickRange(context)),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('${_fmtDate(_from)} to ${_fmtDate(_to)}', style: Theme.of(context).textTheme.bodySmall),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => ref.invalidate(journalEntryListProvider(_filter)),
              child: entries.when(
                data: (items) => items.isEmpty
                    ? ListView(
                        children: const [
                          SizedBox(height: 80),
                          EmptyView(icon: Icons.book_outlined, title: 'No journal entries in this range'),
                        ],
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final e = items[index];
                          final debit = _sum(e, LedgerDirection.DEBIT);
                          final credit = _sum(e, LedgerDirection.CREDIT);
                          return Card(
                            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                            child: ListTile(
                              title: Text(e.description),
                              subtitle: Text('${e.entryDate} · ${sourceLabel(e.sourceType)}'),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('Dr ${debit.toStringAsFixed(2)}', style: const TextStyle(fontSize: 12)),
                                  Text('Cr ${credit.toStringAsFixed(2)}', style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                              onTap: () => _viewEntry(context, e),
                            ),
                          );
                        },
                      ),
                loading: () => const LoadingView(),
                error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(journalEntryListProvider(_filter))),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => _newEntry(context), child: const Icon(Icons.add)),
    );
  }
}

class _JournalEntryFormSheet extends ConsumerStatefulWidget {
  const _JournalEntryFormSheet({required this.spaceId, required this.accounts});

  final String spaceId;
  final List<LedgerAccount> accounts;

  @override
  ConsumerState<_JournalEntryFormSheet> createState() => _JournalEntryFormSheetState();
}

class _JournalEntryFormSheetState extends ConsumerState<_JournalEntryFormSheet> {
  final _descriptionController = TextEditingController();
  DateTime _entryDate = DateTime.now();
  List<JournalLineDraft> _lines = [JournalLineDraft(), JournalLineDraft()];
  bool _submitting = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    for (final line in _lines) {
      line.amountController.dispose();
      line.descriptionController.dispose();
    }
    super.dispose();
  }

  double get _totalDebit =>
      _lines.where((l) => l.direction == LedgerDirection.DEBIT).fold(0.0, (s, l) => s + l.amountValue);
  double get _totalCredit =>
      _lines.where((l) => l.direction == LedgerDirection.CREDIT).fold(0.0, (s, l) => s + l.amountValue);
  double get _difference => _totalDebit - _totalCredit;

  bool get _canSubmit =>
      !_submitting &&
      _lines.length >= 2 &&
      _difference.abs() < 0.005 &&
      _totalDebit > 0 &&
      _descriptionController.text.trim().isNotEmpty &&
      _lines.every((l) => l.account != null && l.amountValue > 0);

  Future<void> _submit() async {
    final inputs = _lines.map((l) => l.toInput()).whereType<JournalEntryLineInput>().toList();
    setState(() => _submitting = true);
    try {
      await ref.read(journalEntriesRepositoryProvider).create(
            widget.spaceId,
            entryDate: _fmtDate(_entryDate),
            description: _descriptionController.text.trim(),
            lines: inputs,
          );
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        setState(() => _submitting = false);
        showErrorSnackBar(context, e is AppException ? e.message : 'Something went wrong.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([..._lines.map((l) => l.amountController), _descriptionController]),
      builder: (context, _) => Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.lg,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('New manual entry', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Date'),
                subtitle: Text(_fmtDate(_entryDate)),
                trailing: const Icon(Icons.calendar_month_outlined),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _entryDate,
                    firstDate: DateTime(_entryDate.year - 5),
                    lastDate: DateTime(_entryDate.year + 5),
                  );
                  if (picked != null) setState(() => _entryDate = picked);
                },
              ),
              AppTextField(label: 'Description', controller: _descriptionController),
              const SizedBox(height: AppSpacing.md),
              JournalLineEditor(
                lines: _lines,
                accounts: widget.accounts,
                onChanged: (l) => setState(() => _lines = l),
              ),
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: (_difference.abs() < 0.005 ? Colors.green : Colors.red).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Debits: ${_totalDebit.toStringAsFixed(2)}'),
                        Text('Credits: ${_totalCredit.toStringAsFixed(2)}'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Difference: ${_difference.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _difference.abs() < 0.005 ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(label: 'Submit', loading: _submitting, onPressed: _canSubmit ? _submit : null),
            ],
          ),
        ),
      ),
    );
  }
}
