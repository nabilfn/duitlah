import 'package:duitlah_mobile/core/widgets/app_adaptive_row.dart';
import 'package:duitlah_mobile/core/widgets/app_field_group.dart';
import 'package:duitlah_mobile/core/widgets/duitlah_segmented_control.dart';
import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/amount_text.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/dialogs.dart';
import '../../../core/widgets/status_chip.dart';
import '../../accounts/application/finance_providers.dart';
import '../../accounts/domain/finance.dart';
import '../application/recurring_providers.dart';
import '../domain/recurring_transaction.dart';

/// Recurring transactions (rent, salary, ...) and, via the [RecurringTransaction.isSubscription]
/// flag, the "Subscriptions" view from the master spec — same schedule machinery, just a
/// different lens (see docs/database.md). One screen rather than two, with a filter chip.
class RecurringTransactionsScreen extends ConsumerStatefulWidget {
  const RecurringTransactionsScreen({super.key});

  @override
  ConsumerState<RecurringTransactionsScreen> createState() =>
      _RecurringTransactionsScreenState();
}

class _RecurringTransactionsScreenState
    extends ConsumerState<RecurringTransactionsScreen> {
  bool _subscriptionsOnly = false;

  void _invalidateAll() {
    ref.invalidate(recurringTransactionListProvider);
    ref.invalidate(subscriptionsSummaryProvider);
  }

  @override
  Widget build(BuildContext context) {
    final rules = ref.watch(recurringTransactionListProvider);
    final summary = ref.watch(subscriptionsSummaryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Recurring & Subscriptions')),
      body: RefreshIndicator(
        onRefresh: () async => _invalidateAll(),
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: AppSpacing.scrollInsets(context, floatingAction: true),
          children: [
            summary.maybeWhen(
              data: (s) => s.subscriptions.isEmpty
                  ? const SizedBox.shrink()
                  : Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: AppAdaptiveRow(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Monthly subscriptions',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 4),
                                AmountText(
                                  s.estimatedMonthlyTotal,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall,
                                ),
                              ],
                            ),
                            Text(
                              '${s.subscriptions.length} active',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
              orElse: () => const SizedBox.shrink(),
            ),
            const SizedBox(height: AppSpacing.md),
            // Filter chips wrap onto a second line at large text sizes
            // instead of running off the edge of a narrow phone.
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: !_subscriptionsOnly,
                  onSelected: (_) => setState(() => _subscriptionsOnly = false),
                ),
                ChoiceChip(
                  label: const Text('Subscriptions'),
                  selected: _subscriptionsOnly,
                  onSelected: (_) => setState(() => _subscriptionsOnly = true),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            rules.when(
              data: (list) {
                final filtered = _subscriptionsOnly
                    ? list.where((r) => r.isSubscription).toList()
                    : list;
                if (filtered.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                    child: EmptyView(
                      icon: Icons.repeat_rounded,
                      title: 'Nothing recurring yet',
                      message: 'Add rent, salary, or a subscription to track it automatically.',
                    ),
                  );
                }
                return Column(
                  children: filtered
                      .map(
                        (rule) =>
                            _RuleCard(rule: rule, onChanged: _invalidateAll),
                      )
                      .toList(),
                );
              },
              loading: () => const LoadingView(),
              error: (e, _) => ErrorView(error: e, onRetry: _invalidateAll),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateSheet(context),
        icon: const DuitlahIcon(Icons.add),
        label: const Text('Add recurring'),
      ),
    );
  }

  Future<void> _showCreateSheet(BuildContext context) async {
    // Nothing on this screen watches the account list, so on a cold open a
    // cached read is still loading and every user would be told to add an
    // account they already have. Await the value instead.
    final accounts = await ref.read(accountListProvider.future);
    if (!context.mounted) return;
    if (accounts.isEmpty) {
      showErrorSnackBar(context, 'Add an account first.');
      return;
    }
    final created = await showAppBottomSheet<bool>(
      context,
      builder: (context) => _RecurringTransactionForm(accounts: accounts),
    );
    if (created == true) _invalidateAll();
  }
}

class _RuleCard extends ConsumerWidget {
  const _RuleCard({required this.rule, required this.onChanged});

  final RecurringTransaction rule;
  final VoidCallback onChanged;

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete this recurring transaction?',
      message: 'This stops future occurrences. Transactions already posted are kept.',
      confirmLabel: 'Delete',
      destructive: true,
    );
    if (!confirmed) return;
    try {
      await ref.read(recurringTransactionsRepositoryProvider).delete(rule.id);
      onChanged();
    } catch (e) {
      if (context.mounted) {
        showErrorSnackBar(
          context,
          e is AppException ? e.message : 'Something went wrong.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppRecordTile(
        title: Text(rule.merchant ?? rule.description ?? rule.type.name),
        subtitle: Text(
          '${rule.frequency.name.toLowerCase()} · next ${rule.nextOccurrenceDate}',
        ),
        // Wraps rather than overflows once the tile stacks its trailing
        // content on a narrow or scaled screen.
        trailing: Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            AmountText(
              rule.amount,
              tone: rule.direction == TransactionDirection.IN
                  ? AmountTone.positive
                  : AmountTone.negative,
              style: theme.textTheme.titleSmall,
            ),
            if (!rule.active)
              StatusChip(
                label: 'Ended',
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            IconButton(
              icon: const DuitlahIcon(Icons.delete_outline, size: 18),
              onPressed: () => _confirmDelete(context, ref),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecurringTransactionForm extends ConsumerStatefulWidget {
  const _RecurringTransactionForm({required this.accounts});

  final List<Account> accounts;

  @override
  ConsumerState<_RecurringTransactionForm> createState() =>
      _RecurringTransactionFormState();
}

class _RecurringTransactionFormState
    extends ConsumerState<_RecurringTransactionForm> {
  final _amountController = TextEditingController();
  final _merchantController = TextEditingController();
  late String _accountId = widget.accounts.first.id;
  TransactionType _type = TransactionType.EXPENSE;
  RecurrenceFrequency _frequency = RecurrenceFrequency.MONTHLY;
  DateTime _startDate = DateTime.now();
  bool _isSubscription = false;
  bool _submitting = false;

  @override
  void dispose() {
    _amountController.dispose();
    _merchantController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      await ref
          .read(recurringTransactionsRepositoryProvider)
          .create(
            accountId: _accountId,
            type: _type,
            amount: _amountController.text.trim(),
            merchant: _merchantController.text.trim().isEmpty
                ? null
                : _merchantController.text.trim(),
            frequency: _frequency,
            startDate: _startDate.toIso8601String().split('T').first,
            isSubscription: _isSubscription,
          );
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(
          context,
          e is AppException ? e.message : 'Something went wrong.',
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.pageMargin,
        right: AppSpacing.pageMargin,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'New recurring transaction',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            DuitlahSegmentedControl<TransactionType>(
              segments: const [
                ButtonSegment(
                  value: TransactionType.EXPENSE,
                  label: Text('Expense'),
                ),
                ButtonSegment(
                  value: TransactionType.INCOME,
                  label: Text('Income'),
                ),
              ],
              selected: {_type},
              onSelectionChanged: (s) => setState(() => _type = s.first),
            ),
            const SizedBox(height: AppSpacing.md),
            AppFieldGroup(
              label: 'Account',
              child: DropdownButtonFormField<String>(
                itemHeight: null,
                isExpanded: true,
                icon: const DuitlahIcon(Icons.expand_more, size: 18),
                initialValue: _accountId,
                decoration: const InputDecoration(),
                items: widget.accounts
                    .map(
                      (a) => DropdownMenuItem(value: a.id, child: Text(a.name)),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _accountId = v ?? _accountId),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              label: 'Amount (RM)',
              controller: _amountController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              label: 'Merchant / description',
              controller: _merchantController,
            ),
            const SizedBox(height: AppSpacing.md),
            AppFieldGroup(
              label: 'Repeats',
              child: DropdownButtonFormField<RecurrenceFrequency>(
                itemHeight: null,
                isExpanded: true,
                icon: const DuitlahIcon(Icons.expand_more, size: 18),
                initialValue: _frequency,
                decoration: const InputDecoration(),
                items: RecurrenceFrequency.values
                    .map(
                      (f) => DropdownMenuItem(
                        value: f,
                        child: Text(f.name.toLowerCase()),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _frequency = v ?? _frequency),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton.icon(
              icon: const DuitlahIcon(Icons.calendar_today_outlined),
              label: Text(
                'Starts ${_startDate.toIso8601String().split('T').first}',
              ),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _startDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => _startDate = picked);
              },
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('This is a subscription'),
              subtitle: const Text('Shows up in the subscriptions total.'),
              value: _isSubscription,
              onChanged: (v) => setState(() => _isSubscription = v),
            ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: 'Add',
              onPressed: _submit,
              loading: _submitting,
            ),
          ],
        ),
      ),
    );
  }
}
