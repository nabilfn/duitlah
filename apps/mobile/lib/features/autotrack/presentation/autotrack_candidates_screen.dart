import 'package:duitlah_mobile/core/widgets/duitlah_segmented_control.dart';
import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/dialogs.dart';
import '../../accounts/application/finance_providers.dart';
import '../../accounts/domain/finance.dart';
import '../application/autotrack_providers.dart';
import '../domain/transaction_candidate.dart';

/// The pipeline's own human-confirmation step (spec section 10): every
/// suggestion from a statement import or a Receipt Vault upload lands here
/// and stays PENDING until the user explicitly confirms, rejects, or — for
/// one flagged as a possible duplicate — merges it. Nothing here is ever
/// auto-promoted into a real transaction no matter how high its confidence.
class AutoTrackCandidatesScreen extends ConsumerWidget {
  const AutoTrackCandidatesScreen({super.key});

  Future<void> _confirm(
    BuildContext context,
    WidgetRef ref,
    TransactionCandidate candidate,
    List<Account> accounts,
  ) async {
    if (accounts.isEmpty) {
      showErrorSnackBar(context, 'Add an account first.');
      return;
    }
    final amountController = TextEditingController(text: candidate.detectedAmount);
    final merchantController = TextEditingController(text: candidate.detectedMerchant ?? '');
    String accountId = candidate.suggestedAccountId != null &&
            accounts.any((a) => a.id == candidate.suggestedAccountId)
        ? candidate.suggestedAccountId!
        : accounts.first.id;
    var type = candidate.detectedDirection == TransactionDirection.IN
        ? TransactionType.INCOME
        : TransactionType.EXPENSE;

    final confirmed = await showAppBottomSheet<bool>(
      context,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => SingleChildScrollView(child: Padding(
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
              Text('Confirm transaction', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              DuitlahSegmentedControl<TransactionType>(
                segments: const [
                  ButtonSegment(value: TransactionType.EXPENSE, label: Text('Expense')),
                  ButtonSegment(value: TransactionType.INCOME, label: Text('Income')),
                ],
                selected: {type},
                onSelectionChanged: (s) => setSheetState(() => type = s.first),
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String>(
                icon: const DuitlahIcon(Icons.expand_more, size: 18),
initialValue: accountId,
                decoration: const InputDecoration(labelText: 'Account'),
                items: accounts.map((a) => DropdownMenuItem(value: a.id, child: Text(a.name))).toList(),
                onChanged: (v) => setSheetState(() => accountId = v ?? accountId),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Amount (RM)', controller: amountController, keyboardType: TextInputType.number),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Merchant / description', controller: merchantController),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: 'Confirm',
                onPressed: () async {
                  try {
                    await ref.read(autoTrackRepositoryProvider).confirmCandidate(
                          candidate.id,
                          accountId: accountId,
                          type: type,
                          amount: amountController.text.trim(),
                          merchant: merchantController.text.trim(),
                          occurredOn: candidate.detectedDate,
                          idempotencyKey: const Uuid().v4(),
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
      ),
    );
    if (confirmed == true) {
      ref.invalidate(pendingCandidatesProvider);
      ref.invalidate(transactionsProvider);
      ref.invalidate(dashboardProvider);
    }
  }

  Future<void> _reject(WidgetRef ref, TransactionCandidate candidate) async {
    await ref.read(autoTrackRepositoryProvider).rejectCandidate(candidate.id);
    ref.invalidate(pendingCandidatesProvider);
  }

  Future<void> _merge(WidgetRef ref, TransactionCandidate candidate) async {
    await ref.read(autoTrackRepositoryProvider).mergeCandidate(candidate.id);
    ref.invalidate(pendingCandidatesProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final candidates = ref.watch(pendingCandidatesProvider);
    final accounts = ref.watch(accountListProvider).valueOrNull ?? const [];

    return Scaffold(
      appBar: AppBar(title: const Text('Review transactions')),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(pendingCandidatesProvider),
        child: candidates.when(
          data: (items) => items.isEmpty
              ? ListView(
                  children: const [
                    SizedBox(height: 80),
                    EmptyView(
                      icon: Icons.fact_check_outlined,
                      title: 'Nothing to review',
                      message: 'Import a statement or scan a receipt to see suggestions here.',
                    ),
                  ],
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final candidate = items[index];
                    final isDuplicate = candidate.duplicateOfTransactionId != null;
                    return Card(
                      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isDuplicate)
                              Padding(
                                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                                child: Row(
                                  children: [
                                    DuitlahIcon(Icons.warning_amber_rounded,
                                        size: 16, color: Theme.of(context).colorScheme.error),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Possible duplicate',
                                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                                    ),
                                  ],
                                ),
                              ),
                            Text(
                              candidate.detectedMerchant ?? 'Unknown merchant',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              '${candidate.detectedDirection == TransactionDirection.IN ? '+' : '-'}RM ${candidate.detectedAmount}  ·  ${candidate.detectedDate}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Row(
                              children: [
                                if (isDuplicate)
                                  TextButton(
                                    onPressed: () => _merge(ref, candidate),
                                    child: const Text('Merge'),
                                  ),
                                TextButton(
                                  onPressed: () => _reject(ref, candidate),
                                  child: const Text('Ignore'),
                                ),
                                const Spacer(),
                                FilledButton(
                                  onPressed: () => _confirm(context, ref, candidate, accounts),
                                  child: Text(isDuplicate ? 'Keep both' : 'Confirm'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(pendingCandidatesProvider)),
        ),
      ),
    );
  }
}
