import 'package:duitlah_mobile/core/widgets/app_page_body.dart';
import 'package:duitlah_mobile/core/utils/money.dart';
import 'package:duitlah_mobile/core/theme/duitlah_colors.dart';
import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/dialogs.dart';
import '../../accounts/application/finance_providers.dart';
import '../application/receipt_vault_providers.dart';
import '../domain/vault_receipt.dart';

final _vaultReceiptProvider = FutureProvider.autoDispose
    .family<VaultReceipt, String>((ref, receiptId) {
      return ref.watch(receiptVaultRepositoryProvider).get(receiptId);
    });

class VaultReceiptDetailScreen extends ConsumerWidget {
  const VaultReceiptDetailScreen({super.key, required this.receiptId});

  final String receiptId;

  Future<void> _attachTo(
    BuildContext context,
    WidgetRef ref,
    String transactionId,
  ) async {
    try {
      await ref
          .read(receiptVaultRepositoryProvider)
          .attachToTransaction(receiptId, transactionId);
      ref.invalidate(_vaultReceiptProvider(receiptId));
      if (context.mounted) showSuccessSnackBar(context, 'Receipt attached.');
    } catch (e) {
      if (context.mounted) {
        showErrorSnackBar(
          context,
          e is AppException ? e.message : 'Something went wrong.',
        );
      }
    }
  }

  Future<void> _attach(BuildContext context, WidgetRef ref) async {
    final transactions = await ref.read(transactionsProvider.future);
    if (!context.mounted) return;
    if (transactions.content.isEmpty) {
      showErrorSnackBar(context, 'No transactions to attach to yet.');
      return;
    }
    final selected = await showAppBottomSheet<String>(
      context,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: transactions.content
            .map(
              (t) => ListTile(
                title: Text(t.merchant ?? t.description ?? t.type.name),
                subtitle: Text('${Money.format(t.amount)}  ·  ${t.occurredOn}'),
                onTap: () => Navigator.of(context).pop(t.id),
              ),
            )
            .toList(),
      ),
    );
    if (selected == null || !context.mounted) return;
    await _attachTo(context, ref, selected);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receipt = ref.watch(_vaultReceiptProvider(receiptId));
    return Scaffold(
      appBar: AppBar(title: const Text('Receipt')),
      body: AppPageBody(
        child: receipt.when(
          data: (r) => ListView(
            padding: AppSpacing.scrollInsets(context, floatingAction: false),
            children: [
              if (r.needsReview) ...[
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: context.duitlahColors.warning.withValues(
                      alpha: 0.12,
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(
                      color: context.duitlahColors.warning.withValues(
                        alpha: 0.4,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      DuitlahIcon(
                        Icons.info_outline,
                        color: context.duitlahColors.warning,
                        size: 20,
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'Double-check this scan — some details look uncertain.',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  r.imageUrl,
                  errorBuilder: (context, error, stack) => const SizedBox(
                    height: 160,
                    child: EmptyView(
                      icon: Icons.receipt_long_outlined,
                      title: 'Preview unavailable',
                      message:
                          'Your receipt details are still available below.',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _Field('Merchant', r.merchant),
              _Field('Date', r.receiptDate),
              _Field(
                'Amount',
                r.totalAmount != null ? Money.format(r.totalAmount!) : null,
              ),
              _Field('Folder', r.folder),
              _Field('Tags', r.tags.isEmpty ? null : r.tags.join(', ')),
              const SizedBox(height: AppSpacing.lg),
              if (r.linkedTransactionId == null) ...[
                PrimaryButton(
                  label: 'Attach to a transaction',
                  onPressed: () => _attach(context, ref),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Possible matching transactions',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                _MatchSuggestionsList(
                  receiptId: receiptId,
                  onPick: (id) => _attachTo(context, ref, id),
                ),
              ] else
                const Text('Attached to a transaction.'),
            ],
          ),
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(
            error: e,
            onRetry: () => ref.invalidate(_vaultReceiptProvider(receiptId)),
          ),
        ),
      ),
    );
  }
}

/// Advisory suggestions from `ReceiptVaultService.suggestTransactionMatches`
/// — deterministic EXACT/PROBABLE, never auto-attached. Tapping one goes
/// through the same [ReceiptVaultRepository.attachToTransaction] call the
/// manual "Attach to a transaction" flow already uses.
class _MatchSuggestionsList extends ConsumerWidget {
  const _MatchSuggestionsList({required this.receiptId, required this.onPick});

  final String receiptId;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestions = ref.watch(receiptMatchSuggestionsProvider(receiptId));
    return suggestions.when(
      data: (items) => items.isEmpty
          ? Text(
              'No automatic suggestions for this receipt.',
              style: Theme.of(context).textTheme.bodySmall,
            )
          : Column(
              children: items
                  .map(
                    (s) => Card(
                      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                      child: ListTile(
                        leading: Chip(
                          label: Text(
                            s.confidence == ReceiptMatchConfidence.EXACT
                                ? 'EXACT'
                                : 'PROBABLE',
                          ),
                          backgroundColor:
                              s.confidence == ReceiptMatchConfidence.EXACT
                              ? Theme.of(context).colorScheme.primary
                              : null,
                          labelStyle: TextStyle(
                            color: s.confidence == ReceiptMatchConfidence.EXACT
                                ? Theme.of(context).colorScheme.onPrimary
                                : null,
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                        title: Text(s.merchant ?? s.occurredOn),
                        subtitle: Text(
                          '${Money.format(s.amount)}  ·  ${s.occurredOn}',
                        ),
                        onTap: () => onPick(s.transactionId),
                      ),
                    ),
                  )
                  .toList(),
            ),
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: LoadingView(),
      ),
      error: (e, _) => ErrorView(
        error: e,
        onRetry: () =>
            ref.invalidate(receiptMatchSuggestionsProvider(receiptId)),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field(this.label, this.value);

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 2),
          Text(
            value == null || value!.isEmpty ? 'Not set' : value!,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
