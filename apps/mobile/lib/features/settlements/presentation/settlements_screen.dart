import 'package:duitlah_mobile/core/widgets/app_adaptive_row.dart';
import 'package:duitlah_mobile/core/widgets/app_page_body.dart';
import 'package:duitlah_mobile/core/utils/money.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_semantic_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/amount_text.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/dialogs.dart';
import '../../../core/widgets/status_chip.dart';
import '../application/settlements_providers.dart';
import '../domain/settlement.dart';

/// Who-owes-whom, mark paid, partial payments (docs/bagilah-engine.md's
/// Phase 9 scope) — every number here is a `Settlement` row the backend
/// already generated at bill-finalize or group-settle time; this screen
/// only records payments against it and displays status, never recomputes
/// a balance itself.
class SettlementsScreen extends ConsumerWidget {
  const SettlementsScreen({super.key, this.personId});
  final String? personId;

  Color _statusColor(BuildContext context, SettlementStatus status) {
    final scheme = Theme.of(context).colorScheme;
    final semantic = context.semanticColors;
    return switch (status) {
      SettlementStatus.PAID => semantic.success,
      SettlementStatus.PARTIALLY_PAID => semantic.warning,
      SettlementStatus.DISPUTED => scheme.error,
      SettlementStatus.CANCELLED => scheme.outline,
      SettlementStatus.UNPAID => scheme.primary,
    };
  }

  Future<void> _recordPayment(
    BuildContext context,
    WidgetRef ref,
    Settlement settlement,
  ) async {
    final amountController = TextEditingController(
      text: settlement.amountRemaining,
    );
    await showAppBottomSheet(
      context,
      builder: (context) => SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.pageMargin,
            right: AppSpacing.pageMargin,
            top: AppSpacing.lg,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Record a payment',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Amount (RM)',
                controller: amountController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: 'Confirm payment',
                onPressed: () async {
                  try {
                    await ref
                        .read(settlementsRepositoryProvider)
                        .recordPayment(
                          settlement.id,
                          amount: amountController.text.trim(),
                          idempotencyKey: const Uuid().v4(),
                        );
                    ref.invalidate(settlementListProvider);
                    ref.invalidate(settlementSummaryProvider);
                    if (context.mounted) Navigator.of(context).pop();
                  } catch (e) {
                    if (context.mounted) {
                      showErrorSnackBar(
                        context,
                        e is AppException ? e.message : 'Something went wrong.',
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settlements = ref.watch(settlementListProvider);
    final summary = ref.watch(settlementSummaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(personId == null ? 'Settlements' : 'Shared settlements'),
      ),
      body: AppPageBody(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(settlementListProvider);
            ref.invalidate(settlementSummaryProvider);
          },
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: AppSpacing.scrollInsets(context, floatingAction: false),
            children: [
              summary.maybeWhen(
                data: (s) => AppMetricRow(
                  children: [
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "You're owed",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              AmountText(
                                s.totalOwedToMe,
                                tone: AmountTone.positive,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'You owe',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              AmountText(
                                s.totalIOwe,
                                tone: AmountTone.negative,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                orElse: () => const SizedBox.shrink(),
              ),
              const SizedBox(height: AppSpacing.xl),
              settlements.when(
                data: (all) {
                  final list = personId == null
                      ? all
                      : all
                            .where(
                              (s) =>
                                  s.fromUserId == personId ||
                                  s.toUserId == personId,
                            )
                            .toList();
                  return list.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 60),
                          child: EmptyView(
                            icon: Icons.handshake_outlined,
                            title: 'All settled up',
                          ),
                        )
                      : Column(
                          children: list
                              .map(
                                (s) => Card(
                                  margin: const EdgeInsets.only(
                                    bottom: AppSpacing.sm,
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      '${s.fromDisplayName} → ${s.toDisplayName}',
                                    ),
                                    subtitle: Text(
                                      '${Money.format(s.amountRemaining)} remaining',
                                    ),
                                    trailing: StatusChip(
                                      label: s.status.name,
                                      color: _statusColor(context, s.status),
                                    ),
                                    onTap:
                                        s.status == SettlementStatus.UNPAID ||
                                            s.status ==
                                                SettlementStatus.PARTIALLY_PAID
                                        ? () => _recordPayment(context, ref, s)
                                        : null,
                                  ),
                                ),
                              )
                              .toList(),
                        );
                },
                loading: () => const LoadingView(),
                error: (e, _) => ErrorView(error: e),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
