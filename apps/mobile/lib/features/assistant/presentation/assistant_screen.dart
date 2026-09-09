import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/dialogs.dart';
import '../../spaces/application/spaces_providers.dart';
import '../../spaces/domain/financial_space.dart';
import '../application/assistant_providers.dart';
import '../domain/assistant.dart';

/// The AI financial assistant (product spec sections 40-42): a chat surface backed entirely by
/// read-only backend tools (see `com.duitlah.api.ai.FinanceQueryService`) plus a dedicated
/// affordability check. Every number shown here came from the backend, never from the model
/// itself -- this screen only renders what `ChatResult`/`AffordabilityResult` already computed.
class AssistantScreen extends ConsumerStatefulWidget {
  const AssistantScreen({super.key});

  @override
  ConsumerState<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends ConsumerState<AssistantScreen> {
  final List<ChatTurn> _turns = [];
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _sending = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final message = _messageController.text.trim();
    if (message.isEmpty || _sending) return;

    setState(() {
      _turns.add(ChatTurn(role: ChatMessageRole.USER, content: message));
      _sending = true;
      _messageController.clear();
    });
    _scrollToBottom();

    try {
      final history = _turns.length > 1 ? _turns.sublist(0, _turns.length - 1) : <ChatTurn>[];
      final activeSpaceId = ref.read(assistantActiveSpaceIdProvider);
      final result = await ref
          .read(assistantRepositoryProvider)
          .chat(message, history, activeSpaceId: activeSpaceId);
      setState(() {
        _turns.add(ChatTurn(role: ChatMessageRole.ASSISTANT, content: result.reply));
      });
    } catch (e) {
      setState(() {
        _turns.add(ChatTurn(
          role: ChatMessageRole.ASSISTANT,
          content: e is AppException ? e.message : 'Something went wrong. Please try again.',
        ));
      });
    } finally {
      setState(() => _sending = false);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _openAffordabilityCheck() async {
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    // Hoisted outside the StatefulBuilder's builder callback deliberately: that callback re-runs
    // on every setSheetState call, so locals declared *inside* it would reset to their initial
    // values on every rebuild instead of persisting -- the result would always vanish right after
    // being set.
    AffordabilityResult? result;
    bool checking = false;
    String? error;

    await showAppBottomSheet<void>(
      context,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          Future<void> check() async {
            final amount = amountController.text.trim();
            if (amount.isEmpty) return;
            setSheetState(() {
              checking = true;
              error = null;
            });
            try {
              final response = await ref
                  .read(assistantRepositoryProvider)
                  .checkAffordability(amount, descriptionController.text.trim());
              setSheetState(() => result = response);
            } catch (e) {
              setSheetState(
                () => error = e is AppException ? e.message : 'Something went wrong.',
              );
            } finally {
              setSheetState(() => checking = false);
            }
          }

          return Padding(
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
                Text('Can I afford this?', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Amount (RM)',
                  controller: amountController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(label: 'What is it? (optional)', controller: descriptionController),
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(label: 'Check', onPressed: check, loading: checking),
                if (error != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                ],
                if (result != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Builder(
                    builder: (context) {
                      final scheme = Theme.of(context).colorScheme;
                      final onColor =
                          result!.canAfford ? scheme.onPrimaryContainer : scheme.onErrorContainer;
                      return Card(
                        color: result!.canAfford ? scheme.primaryContainer : scheme.errorContainer,
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                result!.canAfford
                                    ? 'You can afford it'
                                    : "You can't afford it right now",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(color: onColor),
                              ),
                              const SizedBox(height: 8),
                              Text(result!.narrative, style: TextStyle(color: onColor)),
                              const SizedBox(height: AppSpacing.md),
                              Divider(color: onColor.withValues(alpha: 0.25), height: 1),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                'What this is checked against',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(color: onColor),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              _ObligationRow(
                                label: 'Owed to others',
                                amount: result!.totalOwedToOthers,
                                color: onColor,
                              ),
                              _ObligationRow(
                                label: 'Upcoming bills',
                                amount: result!.upcomingBillsTotal,
                                color: onColor,
                              ),
                              _ObligationRow(
                                label: 'Debt repayments',
                                amount: result!.debtRepaymentsTotal,
                                color: onColor,
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              _ObligationRow(
                                label: 'Total obligations',
                                amount: result!.totalObligations,
                                color: onColor,
                                emphasize: true,
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Divider(color: onColor.withValues(alpha: 0.25), height: 1),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                'Also worth knowing',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(color: onColor),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              if (result!.averageCreditUtilization != null)
                                _ObligationRow(
                                  label: 'Avg. credit utilization',
                                  value:
                                      '${((num.tryParse(result!.averageCreditUtilization!) ?? 0) * 100).toStringAsFixed(1)}%',
                                  color: onColor,
                                ),
                              _ObligationRow(
                                label: 'Savings goals remaining',
                                amount: result!.totalSavingsGoalsRemaining,
                                color: onColor,
                              ),
                              _ObligationRow(
                                label: 'Budget remaining this period',
                                amount: result!.budgetRemainingThisPeriod,
                                color: onColor,
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                result!.disclaimer,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: onColor),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assistant'),
        actions: [
          IconButton(
            icon: const DuitlahIcon(Icons.calculate_outlined),
            tooltip: 'Can I afford this?',
            onPressed: _openAffordabilityCheck,
          ),
        ],
      ),
      body: Column(
        children: [
          const _SpaceContextBar(),
          Expanded(
            child: _turns.isEmpty
                ? const EmptyView(
                    icon: Icons.smart_toy_outlined,
                    title: 'Ask about your money',
                    message: '"Where did most of my money go this month?"\n'
                        '"Can I afford something for RM200?"\n'
                        '"How much can I save this month?"',
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    itemCount: _turns.length,
                    itemBuilder: (context, index) => _ChatBubble(turn: _turns[index]),
                  ),
          ),
          if (_sending)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: LinearProgressIndicator(),
            ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Ask a question',
                      controller: _messageController,
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  IconButton.filled(
                    onPressed: _sending ? null : _send,
                    icon: const DuitlahIcon(Icons.arrow_upward),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Lets the user say "ask about my {business}" for this chat turn onward, by setting
/// [assistantActiveSpaceIdProvider] which [_AssistantScreenState._send] threads through to
/// `AssistantRepository.chat`'s `activeSpaceId`. Screen-local only -- there is no app-wide
/// "active space" concept (see docs/ai-assistant-v2.md). Hidden entirely for a user with no
/// Business spaces, since there'd be nothing to pick besides the Personal default.
class _SpaceContextBar extends ConsumerWidget {
  const _SpaceContextBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spaces = ref.watch(spaceListProvider).valueOrNull ?? const <FinancialSpace>[];
    final businesses = spaces.where((s) => s.type == SpaceType.BUSINESS).toList();
    if (businesses.isEmpty) return const SizedBox.shrink();

    final selectedId = ref.watch(assistantActiveSpaceIdProvider);
    FinancialSpace? selected;
    for (final b in businesses) {
      if (b.id == selectedId) {
        selected = b;
        break;
      }
    }

    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 0),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        children: [
          DuitlahIcon(Icons.workspaces_outlined, size: 18, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: AppSpacing.sm),
          Text('Asking about:', style: theme.textTheme.bodySmall),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String?>(
                value: selected?.id,
                isDense: true,
                isExpanded: true,
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface),
                items: [
                  DropdownMenuItem<String?>(value: null, child: const Text('Personal')),
                  for (final b in businesses)
                    DropdownMenuItem<String?>(
                      value: b.id,
                      child: Text(b.name, overflow: TextOverflow.ellipsis),
                    ),
                ],
                onChanged: (value) => ref.read(assistantActiveSpaceIdProvider.notifier).state = value,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.turn});

  final ChatTurn turn;

  @override
  Widget build(BuildContext context) {
    final isUser = turn.role == ChatMessageRole.USER;
    final theme = Theme.of(context);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        decoration: BoxDecoration(
          color: isUser ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Text(
          turn.content,
          style: TextStyle(color: isUser ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface),
        ),
      ),
    );
  }
}

/// One label/value line in the affordability result card's obligation breakdown. Pass either
/// [amount] (a `BigDecimal` string, formatted via [Money.format]) or a pre-formatted [value]
/// (used for the credit-utilization percentage, which isn't itself an amount).
class _ObligationRow extends StatelessWidget {
  const _ObligationRow({
    required this.label,
    this.amount,
    this.value,
    required this.color,
    this.emphasize = false,
  }) : assert(amount != null || value != null);

  final String label;
  final String? amount;
  final String? value;
  final Color color;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = (emphasize ? theme.textTheme.bodyMedium : theme.textTheme.bodySmall)
        ?.copyWith(color: color, fontWeight: emphasize ? FontWeight.w700 : FontWeight.w400);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: textStyle),
          Text(value ?? Money.format(amount!), style: textStyle),
        ],
      ),
    );
  }
}
