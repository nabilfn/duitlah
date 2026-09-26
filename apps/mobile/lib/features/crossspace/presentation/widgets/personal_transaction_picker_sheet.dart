import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/amount_text.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/list_rows.dart';
import '../../../accounts/application/finance_providers.dart';
import '../../../accounts/domain/finance.dart';

/// Lets the user pick one of their existing Personal transactions to link
/// to a business action from `link_form_sheet.dart` — none of the four
/// Cross-Space actions ever create a new transaction, they only ever
/// reference one that was already recorded the normal way. Shows the most
/// recent page from the same `transactionsProvider` the Transactions tab
/// itself uses; the backend has no "unlinked transactions" filter, so
/// nothing here hides a transaction that's already been linked once — the
/// server, not this picker, is the source of truth on what's valid for a
/// given link type.
class PersonalTransactionPickerSheet extends ConsumerWidget {
  const PersonalTransactionPickerSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsProvider);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select a personal transaction',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Only your own transactions can be linked.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: transactions.when(
                data: (page) => page.content.isEmpty
                    ? const EmptyView(
                        icon: Icons.receipt_long_outlined,
                        title: 'No personal transactions yet',
                      )
                    : ListView.builder(
                        itemCount: page.content.length,
                        itemBuilder: (context, index) {
                          final t = page.content[index];
                          return MoneyRow(
                            title: t.merchant ?? t.description ?? t.type.name,
                            subtitle: t.occurredOn,
                            amount: t.amount,
                            tone: t.direction == TransactionDirection.IN
                                ? AmountTone.positive
                                : AmountTone.negative,
                            leadingIcon: t.direction == TransactionDirection.IN
                                ? Icons.arrow_downward_rounded
                                : Icons.arrow_upward_rounded,
                            onTap: () => Navigator.of(context).pop(t),
                          );
                        },
                      ),
                loading: () => const LoadingView(),
                error: (e, _) => ErrorView(
                  error: e,
                  onRetry: () => ref.invalidate(transactionsProvider),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
