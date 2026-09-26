import 'package:duitlah_mobile/core/widgets/app_adaptive_row.dart';
import 'package:duitlah_mobile/core/widgets/app_page_body.dart';
import 'package:duitlah_mobile/core/theme/duitlah_colors.dart';
import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/api/providers.dart';
import '../../../core/api/sse_client.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/haptics.dart';
import '../../../core/widgets/amount_text.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/dialogs.dart';
import '../../../core/widgets/list_rows.dart';
import '../../../core/widgets/participant_avatar.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../core/widgets/financial_surfaces.dart';
import '../../../core/utils/money.dart';
import '../application/bagilah_providers.dart';
import '../domain/bagilah_enums.dart';
import '../domain/bill.dart';
import 'claim_item_sheet.dart';
import 'qr_invite_sheet.dart';

/// The full authenticated Bagilah flow in one screen: items with live
/// claim status, participants, a real-time breakdown (via SSE, docs/
/// bagilah-engine.md's `BillEventBroadcaster`), and owner-only actions
/// (add item/participant, invite, finalize). Every number shown here
/// comes straight from `GET /breakdown` / `/balances` — this screen never
/// recomputes a split, a total, or a settlement.
class BillDetailScreen extends ConsumerStatefulWidget {
  const BillDetailScreen({super.key, required this.billId});

  final String billId;

  @override
  ConsumerState<BillDetailScreen> createState() => _BillDetailScreenState();
}

class _BillDetailScreenState extends ConsumerState<BillDetailScreen> {
  SseSubscription? _sse;

  @override
  void initState() {
    super.initState();
    final token = ref.read(apiClientProvider).accessToken;
    _sse = SseSubscription.connect(
      '/api/v1/bills/${widget.billId}/events',
      accessToken: token,
    );
    _sse!.events.listen((_) => _refreshAll());
  }

  void _refreshAll() {
    ref.invalidate(billDetailProvider(widget.billId));
    ref.invalidate(billItemsProvider(widget.billId));
    ref.invalidate(billParticipantsProvider(widget.billId));
    ref.invalidate(billBreakdownProvider(widget.billId));
    ref.invalidate(billBalancesProvider(widget.billId));
    ref.invalidate(billPaymentsProvider(widget.billId));
  }

  /// The server's own rejection of the last finalize attempt. Kept on screen
  /// rather than shown as a snackbar: `PAYMENTS_DONT_MATCH_TOTAL` names both
  /// figures, and the owner needs it while correcting the amounts.
  String? _finalizeError;

  /// Records or corrects what one participant actually paid. The amount is
  /// sent to the backend verbatim; nothing is summed or validated here,
  /// because the split and total are the backend's to own.
  Future<void> _recordPayment(Participant participant, String? current) async {
    final controller = TextEditingController(text: current ?? '');
    final saved = await showAppBottomSheet<bool>(
      context,
      builder: (context) => _PaymentSheet(
        participant: participant,
        controller: controller,
        onSubmit: (amount) => ref
            .read(bagilahRepositoryProvider)
            .recordPayment(
              widget.billId,
              participantId: participant.id,
              amountPaid: amount,
            ),
        onRemove: current == null
            ? null
            : () => ref
                  .read(bagilahRepositoryProvider)
                  .removePayment(widget.billId, participant.id),
      ),
    );
    controller.dispose();
    if (saved == true) {
      setState(() => _finalizeError = null);
      _refreshAll();
    }
  }

  @override
  void dispose() {
    _sse?.close();
    super.dispose();
  }

  Future<void> _finalize() async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Finalize this bill?',
      message:
          'Every item must be fully claimed. Once finalized, splits are locked and '
          'settlements are generated — this cannot be undone.',
      confirmLabel: 'Finalize',
    );
    if (!confirmed) return;
    try {
      await ref
          .read(bagilahRepositoryProvider)
          .finalizeBill(widget.billId, idempotencyKey: const Uuid().v4());
      AppHaptics.billFinalized();
      if (mounted) setState(() => _finalizeError = null);
      _refreshAll();
      if (mounted) showSuccessSnackBar(context, 'Bill finalized.');
    } catch (e) {
      final message = e is AppException ? e.message : 'Something went wrong.';
      if (mounted) setState(() => _finalizeError = message);
    }
  }

  Future<void> _showInvite() async {
    try {
      final token = await ref
          .read(bagilahRepositoryProvider)
          .getInviteToken(widget.billId);
      if (!mounted) return;
      showAppBottomSheet(
        context,
        builder: (context) =>
            QrInviteSheet(token: token, title: 'Invite people to this bill'),
      );
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(
          context,
          e is AppException ? e.message : 'Something went wrong.',
        );
      }
    }
  }

  Future<void> _addItem() async {
    final nameController = TextEditingController();
    final qtyController = TextEditingController(text: '1');
    final priceController = TextEditingController(text: '0.00');
    final added = await showAppBottomSheet<bool>(
      context,
      builder: (context) => Padding(
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
            Text('Add item', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            AppTextField(label: 'Name', controller: nameController),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'Quantity',
                    controller: qtyController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AppTextField(
                    label: 'Unit price',
                    controller: priceController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: 'Add item',
              onPressed: () async {
                try {
                  await ref
                      .read(bagilahRepositoryProvider)
                      .addItem(
                        widget.billId,
                        name: nameController.text.trim(),
                        quantity: qtyController.text.trim(),
                        unitPrice: priceController.text.trim(),
                      );
                  if (context.mounted) Navigator.of(context).pop(true);
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
    );
    if (added == true) {
      ref.invalidate(billItemsProvider(widget.billId));
      ref.invalidate(billBreakdownProvider(widget.billId));
    }
  }

  Future<void> _addParticipant() async {
    final nameController = TextEditingController();
    final added = await showAppBottomSheet<bool>(
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
                'Add participant',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(label: 'Name', controller: nameController),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: 'Add',
                onPressed: () async {
                  try {
                    await ref
                        .read(bagilahRepositoryProvider)
                        .addParticipant(
                          widget.billId,
                          displayName: nameController.text.trim(),
                        );
                    if (context.mounted) Navigator.of(context).pop(true);
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
    if (added == true) ref.invalidate(billParticipantsProvider(widget.billId));
  }

  @override
  Widget build(BuildContext context) {
    final billAsync = ref.watch(billDetailProvider(widget.billId));
    final itemsAsync = ref.watch(billItemsProvider(widget.billId));
    final participantsAsync = ref.watch(
      billParticipantsProvider(widget.billId),
    );
    final breakdownAsync = ref.watch(billBreakdownProvider(widget.billId));
    final balancesAsync = ref.watch(billBalancesProvider(widget.billId));
    final paymentsAsync = ref.watch(billPaymentsProvider(widget.billId));

    return Scaffold(
      appBar: AppBar(
        title: Text(billAsync.valueOrNull?.merchant ?? 'Bill'),
        actions: [
          if (billAsync.valueOrNull?.status == BillStatus.DRAFT)
            IconButton(
              icon: const DuitlahIcon(Icons.person_add_alt_1_outlined),
              onPressed: _showInvite,
            ),
        ],
      ),
      body: AppPageBody(
        child: billAsync.when(
          data: (bill) => RefreshIndicator(
            onRefresh: () async => _refreshAll(),
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: AppSpacing.scrollInsets(context, floatingAction: false),
              children: [
                ForestSurface(
                  radius: 22,
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bill.merchant ?? 'Shared bill',
                            style: TextStyle(
                              color: context.duitlahColors.balanceText,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            bill.total != null
                                ? Money.format(
                                    bill.total!,
                                    currency: bill.currency == 'MYR'
                                        ? 'RM'
                                        : bill.currency,
                                  )
                                : 'Build your split',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: context.duitlahColors.balanceText,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            bill.status == BillStatus.DRAFT
                                ? 'Add items, invite people and choose your shares.'
                                : 'Your shared expense, all in one place.',
                            style: TextStyle(
                              color: context.duitlahColors.balanceSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                AppAdaptiveRow(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      bill.receiptDate,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    StatusChip(
                      label: bill.status.name,
                      color: bill.status == BillStatus.DRAFT
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                participantsAsync.maybeWhen(
                  data: (participants) => SizedBox(
                    height: 56,
                    child: ListView.separated(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          participants.length +
                          (bill.status == BillStatus.DRAFT ? 1 : 0),
                      separatorBuilder: (_, _) =>
                          const SizedBox(width: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        if (index == participants.length) {
                          return InkWell(
                            onTap: _addParticipant,
                            borderRadius: BorderRadius.circular(28),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                              child: const DuitlahIcon(Icons.add),
                            ),
                          );
                        }
                        final p = participants[index];
                        return Tooltip(
                          message: p.displayName,
                          child: ParticipantAvatar(
                            name: p.displayName,
                            isGuest: p.guest,
                            size: 40,
                          ),
                        );
                      },
                    ),
                  ),
                  orElse: () => const SizedBox.shrink(),
                ),
                const SizedBox(height: AppSpacing.xl),
                AppAdaptiveRow(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Items',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (bill.status == BillStatus.DRAFT)
                      TextButton.icon(
                        onPressed: _addItem,
                        icon: const DuitlahIcon(Icons.add, size: 18),
                        label: const Text('Add item'),
                      ),
                  ],
                ),
                itemsAsync.when(
                  data: (items) {
                    final participants =
                        participantsAsync.valueOrNull ?? const [];
                    if (items.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                        child: EmptyView(
                          icon: Icons.receipt_outlined,
                          title: 'No items yet',
                        ),
                      );
                    }
                    return Column(
                      children: items
                          .map(
                            (item) => ReceiptItemRow(
                              name: item.name,
                              quantity: item.quantity,
                              totalPrice: item.totalPrice,
                              onTap: () => showAppBottomSheet(
                                context,
                                builder: (context) => ClaimItemSheet(
                                  billId: widget.billId,
                                  item: item,
                                  participants: participants,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    );
                  },
                  loading: () => const Padding(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: LoadingView(),
                  ),
                  error: (e, _) => ErrorView(error: e),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'Breakdown',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                breakdownAsync.when(
                  data: (breakdown) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!breakdown.valid)
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSpacing.sm,
                              ),
                              child: Text(
                                '${breakdown.issues.length} item(s) still need claiming before this bill can be finalized.',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ),
                          for (final p in breakdown.participants)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: Text(p.displayName)),
                                  Flexible(
                                    child: AmountText(
                                      p.finalAmount,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  loading: () => const LoadingView(),
                  error: (e, _) => ErrorView(error: e),
                ),
                if (bill.status == BillStatus.FINALIZED) ...[
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'Balances',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  balancesAsync.when(
                    data: (balances) => Column(
                      children: balances
                          .map(
                            (b) => MoneyRow(
                              title: b.displayName,
                              amount: b.net,
                              tone: AmountTone.auto,
                              subtitle:
                                  'Paid ${Money.format(b.paid)} · Owed ${Money.format(b.owed)}',
                            ),
                          )
                          .toList(),
                    ),
                    loading: () => const LoadingView(),
                    error: (e, _) => ErrorView(error: e),
                  ),
                ],
                if (bill.status == BillStatus.DRAFT) ...[
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'Who paid',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Record what each person actually paid the merchant. The '
                    'recorded payments must add up to the bill total before it '
                    'can be finalized.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  paymentsAsync.when(
                    data: (payments) => _PaymentList(
                      participants: participantsAsync.valueOrNull ?? const [],
                      payments: payments,
                      total:
                          bill.declaredTotal ??
                          breakdownAsync.valueOrNull?.computedTotal,
                      onEdit: _recordPayment,
                    ),
                    loading: () => const LoadingView(),
                    error: (e, _) => ErrorView(error: e),
                  ),
                  if (_finalizeError != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Semantics(
                      liveRegion: true,
                      child: Text(
                        _finalizeError!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xxl),
                  PrimaryButton(
                    label: 'Finalize bill',
                    // The backend owns whether the recorded payments add up;
                    // this only blocks the two states it can see locally.
                    onPressed:
                        breakdownAsync.valueOrNull?.valid == true &&
                            (paymentsAsync.valueOrNull?.isNotEmpty ?? false)
                        ? _finalize
                        : null,
                  ),
                ],
              ],
            ),
          ),
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(error: e, onRetry: _refreshAll),
        ),
      ),
    );
  }
}

/// Each participant with what they have been recorded as paying. Amounts are
/// rendered exactly as the backend returned them; nothing is summed here.
class _PaymentList extends StatelessWidget {
  const _PaymentList({
    required this.participants,
    required this.payments,
    required this.total,
    required this.onEdit,
  });

  final List<Participant> participants;
  final List<BillPayment> payments;

  /// The figure the recorded payments have to reach, straight from the bill's
  /// declared total or the breakdown's computed one — the same precedence the
  /// backend's `finalizeBill` uses.
  final String? total;
  final void Function(Participant participant, String? current) onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recorded = {for (final p in payments) p.participantId: p.amountPaid};
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final participant in participants)
              AppRecordTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.sm,
                ),
                leading: ParticipantAvatar(name: participant.displayName),
                title: Text(participant.displayName),
                subtitle: Text(
                  recorded.containsKey(participant.id)
                      ? 'Paid ${Money.format(recorded[participant.id]!)}'
                      : 'Nothing recorded',
                ),
                trailing: DuitlahIcon(
                  recorded.containsKey(participant.id)
                      ? Icons.edit_outlined
                      : Icons.add,
                  size: 20,
                ),
                onTap: () => onEdit(participant, recorded[participant.id]),
              ),
            if (total != null) ...[
              const Divider(height: AppSpacing.lg),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Bill total to cover',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    AmountText(total!, style: theme.textTheme.titleSmall),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Captures one participant's payment. The amount is passed through to the
/// backend as typed; this sheet never adds it to anything.
class _PaymentSheet extends StatefulWidget {
  const _PaymentSheet({
    required this.participant,
    required this.controller,
    required this.onSubmit,
    required this.onRemove,
  });

  final Participant participant;
  final TextEditingController controller;
  final Future<void> Function(String amount) onSubmit;
  final Future<void> Function()? onRemove;

  @override
  State<_PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends State<_PaymentSheet> {
  bool _busy = false;
  String? _error;

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e is AppException ? e.message : 'Something went wrong.';
        _busy = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
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
          'What did ${widget.participant.displayName} pay?',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Amount paid',
          controller: widget.controller,
          enabled: !_busy,
          keyboardType: TextInputType.number,
          errorText: _error,
          onSubmitted: (_) =>
              _run(() => widget.onSubmit(widget.controller.text.trim())),
        ),
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(
          label: 'Save payment',
          loading: _busy,
          onPressed: () =>
              _run(() => widget.onSubmit(widget.controller.text.trim())),
        ),
        if (widget.onRemove != null) ...[
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: _busy ? null : () => _run(widget.onRemove!),
            child: const Text('Remove this payment'),
          ),
        ],
      ],
    ),
  );
}
