import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/dialogs.dart';
import '../../business/application/business_providers.dart';
import '../../business/domain/banking.dart';
import '../application/reconciliation_providers.dart';
import '../domain/reconciliation.dart';
import 'widgets/split_portions_editor.dart';

/// The main working screen for one reconciliation session (Phase 7): a
/// summary header, the statement's parsed lines, and — for any line still
/// [StatementLineStatus.UNMATCHED] — the four resolving actions (Match,
/// Create Transaction, Ignore, Split). "Resolve Difference" completes the
/// session; it's reachable at any time rather than gated behind every line
/// being resolved, since a user may want to check the balance comparison
/// mid-way through.
class ReconciliationSessionScreen extends ConsumerWidget {
  const ReconciliationSessionScreen({super.key, required this.spaceId, required this.sessionId});

  final String spaceId;
  final String sessionId;

  SpaceSessionKey get _sessionKey => (spaceId: spaceId, sessionId: sessionId);

  void _invalidateAll(WidgetRef ref, String importId) {
    ref.invalidate(reconciliationSessionProvider(_sessionKey));
    ref.invalidate(reconciliationSummaryProvider(_sessionKey));
    ref.invalidate(statementLinesProvider((spaceId: spaceId, importId: importId)));
    ref.invalidate(statementImportListProvider(spaceId));
    ref.invalidate(reconciliationSessionListProvider(spaceId));
  }

  Future<void> _createTransaction(BuildContext context, WidgetRef ref, String importId, StatementLineResponse line) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Create transaction',
      message: 'Post a new ledger entry for this line (${line.occurredOn}, ${line.amount})?',
    );
    if (!confirmed) return;
    try {
      await ref.read(reconciliationRepositoryProvider).createTransactionForLine(spaceId, importId, line.id);
      _invalidateAll(ref, importId);
      if (context.mounted) showSuccessSnackBar(context, 'Transaction created.');
    } catch (e) {
      if (context.mounted) showErrorSnackBar(context, e is AppException ? e.message : 'Something went wrong.');
    }
  }

  Future<void> _ignoreLine(BuildContext context, WidgetRef ref, String importId, StatementLineResponse line) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Ignore line',
      message: 'Mark this line as not a real business transaction? It will be excluded from reconciliation.',
    );
    if (!confirmed) return;
    try {
      await ref.read(reconciliationRepositoryProvider).ignoreLine(spaceId, importId, line.id);
      _invalidateAll(ref, importId);
      if (context.mounted) showSuccessSnackBar(context, 'Line ignored.');
    } catch (e) {
      if (context.mounted) showErrorSnackBar(context, e is AppException ? e.message : 'Something went wrong.');
    }
  }

  Future<void> _openMatchSheet(
    BuildContext context,
    WidgetRef ref,
    String importId,
    String businessAccountId,
    StatementLineResponse line,
  ) async {
    final matched = await showAppBottomSheet<bool>(
      context,
      builder: (context) => _MatchSheet(
        spaceId: spaceId,
        importId: importId,
        businessAccountId: businessAccountId,
        line: line,
      ),
    );
    if (matched == true) _invalidateAll(ref, importId);
  }

  Future<void> _openSplitSheet(BuildContext context, WidgetRef ref, String importId, StatementLineResponse line) async {
    final split = await showAppBottomSheet<bool>(
      context,
      builder: (context) => _SplitSheet(spaceId: spaceId, importId: importId, line: line),
    );
    if (split == true) _invalidateAll(ref, importId);
  }

  Future<void> _openLineActions(
    BuildContext context,
    WidgetRef ref,
    String importId,
    String businessAccountId,
    StatementLineResponse line,
  ) async {
    final action = await showAppBottomSheet<String>(
      context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(line.description ?? line.occurredOn, style: Theme.of(context).textTheme.titleLarge),
            ),
            ListTile(
              leading: const DuitlahIcon(Icons.link),
              title: const Text('Match to an existing entry'),
              onTap: () => Navigator.of(context).pop('match'),
            ),
            ListTile(
              leading: const DuitlahIcon(Icons.add_circle_outline),
              title: const Text('Create transaction'),
              subtitle: const Text('No existing entry — post a new one'),
              onTap: () => Navigator.of(context).pop('create'),
            ),
            ListTile(
              leading: const DuitlahIcon(Icons.call_split),
              title: const Text('Split into portions'),
              subtitle: const Text('One statement line, several ledger entries'),
              onTap: () => Navigator.of(context).pop('split'),
            ),
            ListTile(
              leading: const DuitlahIcon(Icons.visibility_off_outlined),
              title: const Text('Ignore'),
              subtitle: const Text('Not a real business transaction'),
              onTap: () => Navigator.of(context).pop('ignore'),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
    if (!context.mounted || action == null) return;
    if (action == 'match') {
      await _openMatchSheet(context, ref, importId, businessAccountId, line);
    } else if (action == 'create') {
      await _createTransaction(context, ref, importId, line);
    } else if (action == 'ignore') {
      await _ignoreLine(context, ref, importId, line);
    } else if (action == 'split') {
      await _openSplitSheet(context, ref, importId, line);
    }
  }

  Future<void> _autoMatch(BuildContext context, WidgetRef ref, String importId) async {
    try {
      final result = await ref.read(reconciliationRepositoryProvider).autoMatch(spaceId, importId);
      _invalidateAll(ref, importId);
      if (context.mounted) {
        showSuccessSnackBar(
          context,
          result.matchedCount == 0
              ? 'No unambiguous matches found.'
              : 'Matched ${result.matchedCount}, ${result.skippedCount} left for review.',
        );
      }
    } catch (e) {
      if (context.mounted) showErrorSnackBar(context, e is AppException ? e.message : 'Something went wrong.');
    }
  }

  Future<void> _resolveDifference(BuildContext context, WidgetRef ref, ReconciliationSessionResponse session) async {
    final balanceController = TextEditingController(text: session.statementEndingBalance ?? '');
    final descriptionController = TextEditingController();

    final saved = await showAppBottomSheet<bool>(
      context,
      builder: (context) => SingleChildScrollView(child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.lg,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Resolve difference', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'If the statement ending balance still differs from your ledger balance, '
              'Duitlah will post one adjustment entry for the gap before completing this session.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Statement ending balance (optional)',
              controller: balanceController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(label: 'Adjustment description (optional)', controller: descriptionController),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: 'Complete session',
              onPressed: () async {
                try {
                  await ref.read(reconciliationRepositoryProvider).resolveDifference(
                        spaceId,
                        session.id,
                        statementEndingBalance: balanceController.text.trim().isEmpty ? null : balanceController.text.trim(),
                        description: descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
                      );
                  if (context.mounted) Navigator.of(context).pop(true);
                } catch (e) {
                  if (context.mounted) {
                    showErrorSnackBar(context, e is AppException ? e.message : 'Something went wrong.');
                  }
                }
              },
            ),
          ],
        ),
      )),
    );
    if (saved == true) _invalidateAll(ref, session.businessStatementImportId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(reconciliationSessionProvider(_sessionKey));

    return Scaffold(
      appBar: AppBar(title: const Text('Reconciliation')),
      body: session.when(
        data: (s) => _Body(spaceId: spaceId, session: s, screen: this),
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(reconciliationSessionProvider(_sessionKey))),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.spaceId, required this.session, required this.screen});

  final String spaceId;
  final ReconciliationSessionResponse session;
  final ReconciliationSessionScreen screen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = (spaceId: spaceId, sessionId: session.id);
    final summary = ref.watch(reconciliationSummaryProvider(key));
    final lines = ref.watch(statementLinesProvider((spaceId: spaceId, importId: session.businessStatementImportId)));

    return RefreshIndicator(
      onRefresh: () async => screen._invalidateAll(ref, session.businessStatementImportId),
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          summary.when(
            data: (s) => _SummaryCard(session: session, summary: s),
            loading: () => const LoadingView(),
            error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(reconciliationSummaryProvider(key))),
          ),
          const SizedBox(height: AppSpacing.md),
          if (session.status == ReconciliationSessionStatus.IN_PROGRESS) ...[
            SecondaryButton(
              label: 'Auto-match exact lines',
              onPressed: () => screen._autoMatch(context, ref, session.businessStatementImportId),
            ),
            const SizedBox(height: AppSpacing.sm),
            SecondaryButton(
              label: 'Resolve difference',
              onPressed: () => screen._resolveDifference(context, ref, session),
            ),
          ] else
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: const ListTile(
                leading: DuitlahIcon(Icons.check_circle_outline),
                title: Text('Session completed'),
              ),
            ),
          const SizedBox(height: AppSpacing.lg),
          Text('Statement lines', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const DuitlahIcon(Icons.info_outline, size: 16),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'View the account\'s own entries here:',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              TextButton(
                onPressed: () => context.push(AppRoutes.businessAccountDetail(spaceId, session.businessAccountId)),
                child: const Text('Open ledger'),
              ),
            ],
          ),
          lines.when(
            data: (items) => items.isEmpty
                ? const EmptyView(icon: Icons.receipt_long_outlined, title: 'No lines in this statement')
                : Column(
                    children: items
                        .map((line) => _LineTile(
                              line: line,
                              onTap: line.status == StatementLineStatus.UNMATCHED
                                  ? () => screen._openLineActions(
                                        context,
                                        ref,
                                        session.businessStatementImportId,
                                        session.businessAccountId,
                                        line,
                                      )
                                  : null,
                            ))
                        .toList(),
                  ),
            loading: () => const LoadingView(),
            error: (e, _) => ErrorView(
              error: e,
              onRetry: () => ref.invalidate(statementLinesProvider((spaceId: spaceId, importId: session.businessStatementImportId))),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.session, required this.summary});

  final ReconciliationSessionResponse session;
  final ReconciliationSummaryResponse summary;

  @override
  Widget build(BuildContext context) {
    final difference = summary.difference;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: _Count(label: 'Unmatched', value: summary.unmatchedCount, color: Colors.orange)),
                Expanded(child: _Count(label: 'Matched', value: summary.matchedCount, color: Colors.blue)),
                Expanded(child: _Count(label: 'Created', value: summary.createdCount, color: Colors.green)),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(child: _Count(label: 'Ignored', value: summary.ignoredCount, color: Colors.grey)),
                Expanded(child: _Count(label: 'Split', value: summary.splitCount, color: Colors.purple)),
                const Expanded(child: SizedBox()),
              ],
            ),
            const Divider(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ledger balance', style: Theme.of(context).textTheme.bodyMedium),
                Text(summary.ledgerBalance, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Statement ending balance', style: Theme.of(context).textTheme.bodyMedium),
                Text(summary.statementEndingBalance ?? 'Not set', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            if (difference != null) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Difference'),
                  Text(
                    difference,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: (double.tryParse(difference) ?? 0).abs() < 0.005 ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Count extends StatelessWidget {
  const _Count({required this.label, required this.value, required this.color});

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$value', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _LineTile extends StatelessWidget {
  const _LineTile({required this.line, required this.onTap});

  final StatementLineResponse line;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isOutflow = (double.tryParse(line.amount) ?? 0) < 0;
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: DuitlahIcon(
          isOutflow ? Icons.arrow_upward : Icons.arrow_downward,
          color: isOutflow ? Colors.red : Colors.green,
        ),
        title: Text(line.description ?? line.occurredOn),
        subtitle: Text(line.occurredOn),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(line.amount, style: Theme.of(context).textTheme.titleSmall),
            Chip(label: Text(line.status.name), visualDensity: VisualDensity.compact, padding: EdgeInsets.zero),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

/// "Match" sheet: EXACT suggestions shown as filled chips, PROBABLE ones
/// outlined, plus a manual fallback listing every entry on the account (in
/// case the deterministic engine missed the right one).
class _MatchSheet extends ConsumerWidget {
  const _MatchSheet({
    required this.spaceId,
    required this.importId,
    required this.businessAccountId,
    required this.line,
  });

  final String spaceId;
  final String importId;
  final String businessAccountId;
  final StatementLineResponse line;

  Future<void> _match(BuildContext context, WidgetRef ref, String businessAccountEntryId) async {
    try {
      await ref.read(reconciliationRepositoryProvider).matchLine(
            spaceId,
            importId,
            line.id,
            businessAccountEntryId: businessAccountEntryId,
          );
      if (context.mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (context.mounted) showErrorSnackBar(context, e is AppException ? e.message : 'Something went wrong.');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestionsKey = (spaceId: spaceId, importId: importId, lineId: line.id);
    final suggestions = ref.watch(matchSuggestionsProvider(suggestionsKey));
    final entriesKey = (spaceId: spaceId, resourceId: businessAccountId);
    final entries = ref.watch(accountEntriesProvider(entriesKey));

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      builder: (context, scrollController) => SafeArea(
        child: ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text('Match "${line.description ?? line.occurredOn}"', style: Theme.of(context).textTheme.titleLarge),
            Text('${line.occurredOn} · ${line.amount}', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: AppSpacing.md),
            Text('Suggestions', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            suggestions.when(
              data: (items) => items.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                      child: Text('No automatic suggestions for this line.'),
                    )
                  : Column(
                      children: items
                          .map((s) => _SuggestionTile(
                                suggestion: s,
                                onTap: () => _match(context, ref, s.businessAccountEntryId),
                              ))
                          .toList(),
                    ),
              loading: () => const Padding(padding: EdgeInsets.all(AppSpacing.md), child: LoadingView()),
              error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(matchSuggestionsProvider(suggestionsKey))),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Or pick any entry manually', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            entries.when(
              data: (items) => items.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                      child: Text('No entries on this account.'),
                    )
                  : Column(
                      children: items
                          .map((e) => ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(e.description ?? (e.direction == EntryDirection.IN ? 'Money in' : 'Money out')),
                                subtitle: Text(e.occurredOn),
                                trailing: Text(e.amount),
                                onTap: () => _match(context, ref, e.id),
                              ))
                          .toList(),
                    ),
              loading: () => const LoadingView(),
              error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(accountEntriesProvider(entriesKey))),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  const _SuggestionTile({required this.suggestion, required this.onTap});

  final MatchSuggestionResponse suggestion;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isExact = suggestion.confidence == MatchConfidence.EXACT;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Chip(
        label: Text(isExact ? 'EXACT' : 'PROBABLE'),
        backgroundColor: isExact ? Theme.of(context).colorScheme.primary : null,
        labelStyle: TextStyle(color: isExact ? Theme.of(context).colorScheme.onPrimary : null),
        side: isExact ? null : BorderSide(color: Theme.of(context).colorScheme.outline),
        visualDensity: VisualDensity.compact,
      ),
      title: Text(suggestion.description ?? suggestion.occurredOn),
      subtitle: Text(suggestion.occurredOn),
      trailing: Text(suggestion.signedAmount),
      onTap: onTap,
    );
  }
}

/// Split-into-portions sheet — a live running total vs. the line's absolute
/// amount, mirroring the accounting module's debit/credit balance
/// indicator (`journal_entries_screen.dart`'s `_JournalEntryFormSheet`).
class _SplitSheet extends ConsumerStatefulWidget {
  const _SplitSheet({required this.spaceId, required this.importId, required this.line});

  final String spaceId;
  final String importId;
  final StatementLineResponse line;

  @override
  ConsumerState<_SplitSheet> createState() => _SplitSheetState();
}

class _SplitSheetState extends ConsumerState<_SplitSheet> {
  List<SplitPortionDraft> _portions = [SplitPortionDraft(), SplitPortionDraft()];
  bool _submitting = false;

  double get _target => (double.tryParse(widget.line.amount) ?? 0).abs();
  double get _total => _portions.fold(0.0, (sum, p) => sum + p.amountValue);
  double get _diff => _target - _total;

  bool get _canSubmit =>
      !_submitting &&
      _portions.length >= 2 &&
      _diff.abs() < 0.005 &&
      _portions.every((p) => p.amountValue > 0);

  @override
  void dispose() {
    for (final p in _portions) {
      p.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    final inputs = _portions.map((p) => p.toInput()).whereType<SplitPortionInput>().toList();
    setState(() => _submitting = true);
    try {
      await ref.read(reconciliationRepositoryProvider).splitLine(
            widget.spaceId,
            widget.importId,
            widget.line.id,
            portions: inputs,
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
      animation: Listenable.merge([
        for (final p in _portions) p.amountController,
      ]),
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
              Text('Split into portions', style: Theme.of(context).textTheme.titleLarge),
              Text(
                'Line total: ${widget.line.amount}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.md),
              SplitPortionsEditor(
                portions: _portions,
                onChanged: (p) => setState(() => _portions = p),
              ),
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: (_diff.abs() < 0.005 ? Colors.green : Colors.red).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Portions total: ${_total.toStringAsFixed(2)}'),
                        Text('Target: ${_target.toStringAsFixed(2)}'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Remaining: ${_diff.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _diff.abs() < 0.005 ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(label: 'Submit split', loading: _submitting, onPressed: _canSubmit ? _submit : null),
            ],
          ),
        ),
      ),
    );
  }
}
