import 'package:duitlah_mobile/core/widgets/duitlah_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/duitlah_icon.dart';
import '../../../core/widgets/transaction_row.dart';
import '../../accounts/application/finance_providers.dart';
import '../../accounts/domain/finance.dart';
import 'transaction_form_sheet.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});
  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  String _query = '';
  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionsProvider);
    final accounts = ref.watch(accountListProvider);
    final type = ref.watch(transactionTypeFilterProvider);
    final pageIndex = ref.watch(transactionPageIndexProvider);
    final accountId = ref.watch(transactionAccountFilterProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(transactionsProvider.future),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (v) =>
                                setState(() => _query = v.toLowerCase().trim()),
                            decoration: InputDecoration(
                              hintText: 'Search this page…',
                              prefixIcon: const Padding(
                                padding: EdgeInsets.all(14),
                                child: DuitlahIcon(Icons.search, size: 20),
                              ),
                              fillColor:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerHighest
                                  : const Color(0xFFEEF0ED),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton.filledTonal(
                          tooltip: 'Filter by account',
                          onPressed: () => showModalBottomSheet<void>(
                            context: context,
                            useSafeArea: true,
                            isScrollControlled: true,
                            builder: (ctx) => SafeArea(
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Filter by account',
                                        style: Theme.of(ctx)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      ListTile(
                                        title: const Text('All accounts'),
                                        selected: accountId == null,
                                        onTap: () {
                                          ref
                                                  .read(
                                                    transactionAccountFilterProvider
                                                        .notifier,
                                                  )
                                                  .state =
                                              null;
                                          ref
                                                  .read(
                                                    transactionPageIndexProvider
                                                        .notifier,
                                                  )
                                                  .state =
                                              0;
                                          Navigator.pop(ctx);
                                        },
                                      ),
                                      ...?accounts.valueOrNull?.map(
                                        (a) => ListTile(
                                          title: Text(a.name),
                                          selected: accountId == a.id,
                                          onTap: () {
                                            ref
                                                .read(
                                                  transactionAccountFilterProvider
                                                      .notifier,
                                                )
                                                .state = a
                                                .id;
                                            ref
                                                    .read(
                                                      transactionPageIndexProvider
                                                          .notifier,
                                                    )
                                                    .state =
                                                0;
                                            Navigator.pop(ctx);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          icon: const DuitlahIcon(Icons.filter_list),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: DuitlahSegmentedControl<TransactionType?>(
                        showSelectedIcon: false,
                        segments: const [
                          ButtonSegment(value: null, label: Text('All')),
                          ButtonSegment(
                            value: TransactionType.INCOME,
                            label: Text('Income'),
                          ),
                          ButtonSegment(
                            value: TransactionType.EXPENSE,
                            label: Text('Expenses'),
                          ),
                          ButtonSegment(
                            value: TransactionType.TRANSFER,
                            label: Text('Transfer'),
                          ),
                        ],
                        selected: {type},
                        onSelectionChanged: (s) {
                          ref
                                  .read(transactionTypeFilterProvider.notifier)
                                  .state =
                              s.first;
                          ref
                                  .read(transactionPageIndexProvider.notifier)
                                  .state =
                              0;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            transactions.when(
              loading: () => const SliverToBoxAdapter(child: LoadingView()),
              error: (e, _) => SliverToBoxAdapter(
                child: ErrorView(
                  error: e,
                  onRetry: () => ref.invalidate(transactionsProvider),
                ),
              ),
              data: (page) {
                final list = page.content
                    .where(
                      (t) =>
                          '${t.merchant ?? ''} ${t.description ?? ''} ${t.notes ?? ''}'
                              .toLowerCase()
                              .contains(_query),
                    )
                    .toList();
                if (list.isEmpty) {
                  return SliverToBoxAdapter(
                    child: EmptyView(
                      icon: Icons.receipt_outlined,
                      title: _query.isEmpty
                          ? 'No transactions yet'
                          : 'No matches on this page',
                      message: _query.isEmpty
                          ? 'Record income, expenses or a transfer to start your money story.'
                          : 'Try another search or use the page controls below.',
                      actionLabel: _query.isEmpty ? 'Add transaction' : null,
                      onAction: () => showTransactionForm(context),
                    ),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final t = list[index];
                      final account = accounts.valueOrNull
                          ?.where((a) => a.id == t.accountId)
                          .firstOrNull;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index == 0 ||
                              list[index - 1].occurredOn != t.occurredOn)
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 20,
                                bottom: 4,
                              ),
                              child: Text(
                                transactionDateLabel(t.occurredOn),
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ),
                          TransactionRow(
                            transaction: t,
                            accountName: account?.name,
                            currency: account?.currency == "MYR"
                                ? "RM"
                                : account?.currency ?? "RM",
                          ),
                          const Divider(indent: 58),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 104),
                child: transactions.maybeWhen(
                  data: (page) => Row(
                    children: [
                      TextButton(
                        onPressed: pageIndex > 0
                            ? () => ref
                                  .read(transactionPageIndexProvider.notifier)
                                  .state--
                            : null,
                        child: const Text('Previous'),
                      ),
                      Expanded(
                        child: Text(
                          '${page.totalElements} records · Page ${pageIndex + 1} of ${page.totalPages == 0 ? 1 : page.totalPages}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      TextButton(
                        onPressed: pageIndex + 1 < page.totalPages
                            ? () => ref
                                  .read(transactionPageIndexProvider.notifier)
                                  .state++
                            : null,
                        child: const Text('Next'),
                      ),
                    ],
                  ),
                  orElse: () => const SizedBox.shrink(),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showTransactionForm(context),
        icon: const DuitlahIcon(Icons.add),
        label: const Text('Add transaction'),
      ),
    );
  }
}
