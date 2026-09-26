import 'package:duitlah_mobile/core/widgets/app_page_body.dart';
import 'package:duitlah_mobile/core/widgets/app_field_group.dart';
import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/amount_text.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/dialogs.dart';
import '../../../core/widgets/list_rows.dart';
import '../../../core/widgets/participant_avatar.dart';
import '../../bagilah/presentation/qr_invite_sheet.dart';
import '../application/groups_providers.dart';
import '../domain/group.dart';
import 'group_goals_section.dart';
import 'housemate_mode_section.dart';
import 'trip_mode_section.dart';

class GroupDetailScreen extends ConsumerWidget {
  const GroupDetailScreen({super.key, required this.groupId});

  final String groupId;

  Future<void> _showInvite(BuildContext context, WidgetRef ref) async {
    try {
      final token = await ref
          .read(groupsRepositoryProvider)
          .getInviteToken(groupId);
      if (!context.mounted) return;
      showAppBottomSheet(
        context,
        builder: (context) =>
            QrInviteSheet(token: token, title: 'Invite people to this group'),
      );
    } catch (e) {
      if (context.mounted) {
        showErrorSnackBar(
          context,
          e is AppException ? e.message : 'Something went wrong.',
        );
      }
    }
  }

  Future<void> _settle(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Settle up this group?',
      message: 'This locks in current balances and generates settlements between members.',
      confirmLabel: 'Settle up',
    );
    if (!confirmed) return;
    try {
      await ref
          .read(groupsRepositoryProvider)
          .settleGroup(groupId, idempotencyKey: const Uuid().v4());
      ref.invalidate(groupBalancesProvider(groupId));
      if (context.mounted) showSuccessSnackBar(context, 'Group settled.');
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
    final groupAsync = ref.watch(groupDetailProvider(groupId));
    final membersAsync = ref.watch(groupMembersProvider(groupId));
    final expensesAsync = ref.watch(groupExpensesProvider(groupId));
    final balancesAsync = ref.watch(groupBalancesProvider(groupId));

    return Scaffold(
      appBar: AppBar(
        title: Text(groupAsync.valueOrNull?.name ?? 'Group'),
        actions: [
          IconButton(
            icon: const DuitlahIcon(Icons.person_add_alt_1_outlined),
            onPressed: () => _showInvite(context, ref),
          ),
        ],
      ),
      body: AppPageBody(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(groupDetailProvider(groupId));
            ref.invalidate(groupMembersProvider(groupId));
            ref.invalidate(groupExpensesProvider(groupId));
            ref.invalidate(groupBalancesProvider(groupId));
            ref.invalidate(groupGoalsProvider(groupId));
            ref.invalidate(tripSummaryProvider(groupId));
            final month = ref.read(housemateMonthProvider(groupId));
            ref.invalidate(
              housemateDashboardProvider((
                groupId: groupId,
                year: month.year,
                month: month.month,
              )),
            );
          },
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: AppSpacing.scrollInsets(context, floatingAction: true),
            children: [
              membersAsync.maybeWhen(
                data: (members) => Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: members
                      .map(
                        (m) => Chip(
                          avatar: ParticipantAvatar(
                            name: m.displayName,
                            size: 24,
                          ),
                          label: Text(m.displayName),
                        ),
                      )
                      .toList(),
                ),
                orElse: () => const SizedBox.shrink(),
              ),
              if (groupAsync.valueOrNull?.type == GroupType.COUPLE) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Mine · Yours · Ours — what you share here is only what you both '
                  'log in this group. Your own personal accounts stay private.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              if (groupAsync.valueOrNull?.type == GroupType.TRIP) ...[
                TripModeSection(groupId: groupId),
                const SizedBox(height: AppSpacing.xl),
              ],
              if (groupAsync.valueOrNull?.type == GroupType.HOUSEMATES) ...[
                HousemateModeSection(groupId: groupId),
                const SizedBox(height: AppSpacing.xl),
              ],
              GroupGoalsSection(groupId: groupId),
              const SizedBox(height: AppSpacing.xl),
              Text('Balances', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              balancesAsync.when(
                data: (balances) => balances.isEmpty
                    ? const EmptyView(
                        icon: Icons.balance_outlined,
                        title: 'No expenses yet',
                      )
                    : Column(
                        children: balances
                            .map(
                              (b) => MoneyRow(
                                title: b.displayName,
                                amount: b.net,
                                tone: AmountTone.auto,
                              ),
                            )
                            .toList(),
                      ),
                loading: () => const LoadingView(),
                error: (e, _) => ErrorView(error: e),
              ),
              const SizedBox(height: AppSpacing.md),
              OutlinedButton(
                onPressed: () => _settle(context, ref),
                child: const Text('Settle up'),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('Expenses', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              expensesAsync.when(
                data: (expenses) => expenses.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                        child: EmptyView(
                          icon: Icons.receipt_long_outlined,
                          title: 'No expenses yet',
                        ),
                      )
                    : Column(
                        children: expenses
                            .map(
                              (e) => MoneyRow(
                                title: e.description,
                                subtitle:
                                    'Paid by ${e.paidByName} · ${e.occurredOn}',
                                amount: e.amount,
                                leadingIcon: Icons.receipt_outlined,
                              ),
                            )
                            .toList(),
                      ),
                loading: () => const LoadingView(),
                error: (e, _) => ErrorView(error: e),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addExpense(
          context,
          ref,
          membersAsync.valueOrNull ?? const [],
          groupAsync.valueOrNull?.type,
        ),
        icon: const DuitlahIcon(Icons.add),
        label: const Text('Add expense'),
      ),
    );
  }

  Future<void> _addExpense(
    BuildContext context,
    WidgetRef ref,
    List<dynamic> members,
    GroupType? groupType,
  ) async {
    final descController = TextEditingController();
    final amountController = TextEditingController();
    final originalCurrencyController = TextEditingController();
    final originalAmountController = TextEditingController();
    final exchangeRateController = TextEditingController();
    String? paidByUserId = members.isNotEmpty
        ? members.first.userId as String
        : null;
    final selectedShares = <String>{
      for (final m in members) m.userId as String,
    };
    GroupExpenseCategory? category;
    bool recordCurrencySnapshot = false;

    final added = await showAppBottomSheet<bool>(
      context,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => SingleChildScrollView(
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
                  'Add expense',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(label: 'Description', controller: descController),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(
                  label: 'Amount (RM)',
                  controller: amountController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: AppSpacing.md),
                AppFieldGroup(
                  label: 'Paid by',
                  child: DropdownButtonFormField<String>(
                    itemHeight: null,
                    isExpanded: true,
                    icon: const DuitlahIcon(Icons.expand_more, size: 18),
                    initialValue: paidByUserId,
                    decoration: const InputDecoration(),
                    items: members
                        .map(
                          (m) => DropdownMenuItem(
                            value: m.userId as String,
                            child: Text(m.displayName as String),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setSheetState(() => paidByUserId = v),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Split between',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                Wrap(
                  spacing: 8,
                  children: members
                      .map(
                        (m) => FilterChip(
                          label: Text(m.displayName as String),
                          selected: selectedShares.contains(m.userId),
                          onSelected: (sel) => setSheetState(() {
                            if (sel) {
                              selectedShares.add(m.userId as String);
                            } else {
                              selectedShares.remove(m.userId as String);
                            }
                          }),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: AppSpacing.md),
                AppFieldGroup(
                  label: 'Category (optional)',
                  child: DropdownButtonFormField<GroupExpenseCategory?>(
                    itemHeight: null,
                    isExpanded: true,
                    icon: const DuitlahIcon(Icons.expand_more, size: 18),
                    initialValue: category,
                    decoration: const InputDecoration(),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('None')),
                      ...GroupExpenseCategory.values.map(
                        (c) => DropdownMenuItem(value: c, child: Text(c.name)),
                      ),
                    ],
                    onChanged: (v) => setSheetState(() => category = v),
                  ),
                ),
                if (groupType == GroupType.TRIP) ...[
                  const SizedBox(height: AppSpacing.md),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Paid in a foreign currency'),
                    value: recordCurrencySnapshot,
                    onChanged: (v) =>
                        setSheetState(() => recordCurrencySnapshot = v),
                  ),
                  if (recordCurrencySnapshot) ...[
                    AppTextField(
                      label: 'Currency (e.g. JPY)',
                      controller: originalCurrencyController,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppTextField(
                      label: 'Original amount',
                      controller: originalAmountController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppTextField(
                      label: 'Exchange rate (to RM)',
                      controller: exchangeRateController,
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ],
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(
                  label: 'Add expense',
                  onPressed: () async {
                    if (paidByUserId == null) return;
                    try {
                      await ref
                          .read(groupsRepositoryProvider)
                          .addExpense(
                            groupId,
                            description: descController.text.trim(),
                            amount: amountController.text.trim(),
                            occurredOn: DateTime.now()
                                .toIso8601String()
                                .split('T')
                                .first,
                            paidByUserId: paidByUserId!,
                            participantUserIds: selectedShares.toList(),
                            category: category,
                            originalCurrency: recordCurrencySnapshot
                                ? originalCurrencyController.text.trim()
                                : null,
                            originalAmount: recordCurrencySnapshot
                                ? originalAmountController.text.trim()
                                : null,
                            exchangeRate: recordCurrencySnapshot
                                ? exchangeRateController.text.trim()
                                : null,
                          );
                      if (context.mounted) Navigator.of(context).pop(true);
                    } catch (e) {
                      if (context.mounted) {
                        showErrorSnackBar(
                          context,
                          e is AppException
                              ? e.message
                              : 'Something went wrong.',
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (added == true) {
      ref.invalidate(groupExpensesProvider(groupId));
      ref.invalidate(groupBalancesProvider(groupId));
      ref.invalidate(tripSummaryProvider(groupId));
      final month = ref.read(housemateMonthProvider(groupId));
      ref.invalidate(
        housemateDashboardProvider((
          groupId: groupId,
          year: month.year,
          month: month.month,
        )),
      );
    }
  }
}
