import 'package:duitlah_mobile/core/widgets/duitlah_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/duitlah_icon.dart';
import '../../accounts/application/finance_providers.dart';
import '../../accounts/domain/finance.dart';
import '../../budgets/application/budgets_providers.dart';
import '../../insights/application/insights_providers.dart';

Future<void> showTransactionForm(
  BuildContext context, {
  TransactionType initialType = TransactionType.EXPENSE,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  showDragHandle: false,
  builder: (_) => TransactionFormSheet(initialType: initialType),
);

class TransactionFormSheet extends ConsumerStatefulWidget {
  const TransactionFormSheet({
    super.key,
    this.initialType = TransactionType.EXPENSE,
  });
  final TransactionType initialType;
  @override
  ConsumerState<TransactionFormSheet> createState() =>
      _TransactionFormSheetState();
}

class _TransactionFormSheetState extends ConsumerState<TransactionFormSheet> {
  final _form = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _merchant = TextEditingController();
  final _note = TextEditingController();
  late TransactionType _type = widget.initialType;
  String? _account, _destination, _category, _error, _lastPayload;
  String _idempotencyKey = const Uuid().v4();
  DateTime _date = DateTime.now();
  bool _saving = false;
  @override
  void dispose() {
    _amount.dispose();
    _merchant.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _save(List<Account> accounts) async {
    if (_saving || !_form.currentState!.validate()) return;
    final from = _account ?? accounts.first.id;
    final payload =
        '$_type|$from|$_destination|$_category|${_amount.text}|${_merchant.text}|${_note.text}|$_date';
    if (_lastPayload != payload) {
      _idempotencyKey = const Uuid().v4();
      _lastPayload = payload;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final repo = ref.read(financeRepositoryProvider);
      if (_type == TransactionType.TRANSFER) {
        await repo.transfer(
          fromAccountId: from,
          toAccountId: _destination!,
          amount: _amount.text.trim(),
          occurredOn: DateFormat('yyyy-MM-dd').format(_date),
          idempotencyKey: _idempotencyKey,
        );
      } else {
        await repo.createTransaction(
          accountId: from,
          type: _type,
          categoryId: _category,
          amount: _amount.text.trim(),
          merchant: _merchant.text.trim(),
          notes: _note.text.trim(),
          occurredOn: DateFormat('yyyy-MM-dd').format(_date),
          idempotencyKey: _idempotencyKey,
        );
      }
      ref.invalidate(transactionsProvider);
      ref.invalidate(dashboardProvider);
      ref.invalidate(accountListProvider);
      ref.invalidate(budgetListProvider);
      ref.invalidate(spendingByCategoryProvider);
      ref.invalidate(monthlyTrendProvider);
      ref.invalidate(forecastProvider);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(
          () => _error = e is AppException
              ? e.message
              : 'Could not save your transaction. Please try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accountsAsync = ref.watch(accountListProvider);
    final categoriesAsync = ref.watch(categoryListProvider);
    return PopScope(
      canPop: !_saving,
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * .92,
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.fromLTRB(
              20,
              12,
              20,
              MediaQuery.viewInsetsOf(context).bottom + 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    tooltip: 'Close transaction',
                    onPressed: _saving ? null : () => Navigator.pop(context),
                    icon: const DuitlahIcon(Icons.close),
                  ),
                ),
                const SizedBox(height: 8),
                DuitlahSegmentedControl<TransactionType>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(
                      value: TransactionType.EXPENSE,
                      label: Text('Expense'),
                    ),
                    ButtonSegment(
                      value: TransactionType.INCOME,
                      label: Text('Income'),
                    ),
                    ButtonSegment(
                      value: TransactionType.TRANSFER,
                      label: Text('Transfer'),
                    ),
                  ],
                  selected: {_type},
                  onSelectionChanged: _saving
                      ? null
                      : (s) => setState(() {
                          _type = s.first;
                          _category = null;
                        }),
                ),
                const SizedBox(height: 24),
                accountsAsync.when(
                  loading: () => const LoadingView(),
                  error: (e, _) => ErrorView(
                    error: e,
                    onRetry: () => ref.invalidate(accountListProvider),
                  ),
                  data: (accounts) {
                    if (accounts.isEmpty) {
                      return const EmptyView(
                        icon: Icons.account_balance_wallet_outlined,
                        title: 'Add an account first',
                        message: 'Create an account in Profile → My Accounts, then record your transaction.',
                      );
                    }
                    final account = _account ?? accounts.first.id;
                    final currency = accounts
                        .firstWhere((a) => a.id == account)
                        .currency;
                    final categoryType = _type == TransactionType.INCOME
                        ? CategoryType.INCOME
                        : CategoryType.EXPENSE;
                    final categories =
                        categoriesAsync.valueOrNull
                            ?.where((c) => c.type == categoryType)
                            .toList() ??
                        [];
                    return Form(
                      key: _form,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _amount,
                            enabled: !_saving,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            textInputAction: TextInputAction.next,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.displaySmall,
                            decoration: InputDecoration(
                              labelText:
                                  'Amount (${currency == 'MYR' ? 'RM' : currency})',
                              hintText:
                                  '${currency == 'MYR' ? 'RM' : currency} 0.00',
                              hintStyle: theme.textTheme.displaySmall,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              floatingLabelAlignment:
                                  FloatingLabelAlignment.center,
                              filled: false,
                              enabledBorder: InputBorder.none,
                              border: InputBorder.none,
                            ),
                            validator: (v) {
                              final value = v?.trim() ?? '';
                              return !RegExp(r'^\d+(\.\d{1,2})?$')
                                          .hasMatch(value) ||
                                      !RegExp(r'[1-9]').hasMatch(value)
                                  ? 'Enter an amount greater than zero, with up to 2 decimals.'
                                  : null;
                            },
                          ),
                          const SizedBox(height: 28),
                          DropdownButtonFormField<String>(
                            icon: const DuitlahIcon(
                              Icons.expand_more,
                              size: 18,
                            ),
                            initialValue: account,
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: _type == TransactionType.TRANSFER
                                  ? 'From account'
                                  : 'Account',
                            ),
                            items: accounts
                                .map(
                                  (a) => DropdownMenuItem(
                                    value: a.id,
                                    child: Text(a.name),
                                  ),
                                )
                                .toList(),
                            onChanged: _saving
                                ? null
                                : (v) => setState(() {
                                    _account = v;
                                    if (_destination == v) _destination = null;
                                  }),
                          ),
                          const SizedBox(height: 16),
                          if (_type == TransactionType.TRANSFER) ...[
                            DropdownButtonFormField<String>(
                              icon: const DuitlahIcon(
                                Icons.expand_more,
                                size: 18,
                              ),
                              key: ValueKey(account),
                              initialValue: _destination,
                              isExpanded: true,
                              decoration: const InputDecoration(
                                labelText: 'To account',
                              ),
                              items: accounts
                                  .where((a) => a.id != account)
                                  .map(
                                    (a) => DropdownMenuItem(
                                      value: a.id,
                                      child: Text(a.name),
                                    ),
                                  )
                                  .toList(),
                              onChanged: _saving
                                  ? null
                                  : (v) => setState(() => _destination = v),
                              validator: (v) => v == null
                                  ? 'Choose a different destination account.'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                          ] else ...[
                            if (categoriesAsync.hasError)
                              Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      'Categories unavailable. You can retry or save without one.',
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        ref.invalidate(categoryListProvider),
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            DropdownButtonFormField<String>(
                              icon: const DuitlahIcon(
                                Icons.expand_more,
                                size: 18,
                              ),
                              key: ValueKey(_type),
                              initialValue: _category,
                              isExpanded: true,
                              decoration: const InputDecoration(
                                labelText: 'Category (optional)',
                              ),
                              items: categories
                                  .map(
                                    (c) => DropdownMenuItem(
                                      value: c.id,
                                      child: Text(c.name),
                                    ),
                                  )
                                  .toList(),
                              onChanged: _saving
                                  ? null
                                  : (v) => setState(() => _category = v),
                            ),
                            const SizedBox(height: 16),
                          ],
                          OutlinedButton(
                            onPressed: _saving
                                ? null
                                : () async {
                                    final d = await showDatePicker(
                                      context: context,
                                      initialDate: _date,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime.now(),
                                    );
                                    if (d != null && mounted) {
                                      setState(() => _date = d);
                                    }
                                  },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    DateFormat('d MMM yyyy').format(_date),
                                  ),
                                ),
                                const DuitlahIcon(
                                  Icons.calendar_today_outlined,
                                ),
                              ],
                            ),
                          ),
                          if (_type != TransactionType.TRANSFER) ...[
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _merchant,
                              enabled: !_saving,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'Merchant / payee (optional)',
                                hintText: 'e.g. Lunch with friends',
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _note,
                              enabled: !_saving,
                              maxLines: 3,
                              decoration: const InputDecoration(
                                labelText: 'Note (optional)',
                                hintText: 'Anything you would like to remember',
                              ),
                            ),
                          ],
                          if (_error != null) ...[
                            const SizedBox(height: 16),
                            Semantics(
                              liveRegion: true,
                              child: Text(
                                _error!,
                                style: TextStyle(
                                  color: theme.colorScheme.error,
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 32),
                          PrimaryButton(
                            label: _type == TransactionType.TRANSFER
                                ? 'Save transfer'
                                : 'Save transaction',
                            loading: _saving,
                            onPressed: () => _save(accounts),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
