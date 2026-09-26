import 'package:duitlah_mobile/core/widgets/app_page_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_state_views.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/dialogs.dart';
import '../application/notification_rule_providers.dart';
import '../domain/notification_rule.dart';

String _label(NotificationRuleType type) => switch (type) {
  NotificationRuleType.BILL_DUE_SOON => 'Bill due soon',
  NotificationRuleType.BILL_OVERDUE => 'Bill overdue',
  NotificationRuleType.LOW_STOCK_ALERT => 'Low stock alert',
  NotificationRuleType.BUDGET_EXCEEDED => 'Budget exceeded',
  NotificationRuleType.LOW_BALANCE => 'Low balance',
};

String? _description(NotificationRuleType type) => switch (type) {
  NotificationRuleType.LOW_BALANCE =>
    'Notify when an account balance drops below the amount you set.',
  _ => null,
};

/// Notification rules (Phase 13) — per-type opt in/out for what
/// `NotificationService.notify` fans out. Every type is always shown (the
/// server synthesizes defaults for any row the user hasn't touched:
/// enabled for the first four, disabled for Low balance since it needs a
/// threshold to mean anything).
class NotificationRulesScreen extends ConsumerWidget {
  const NotificationRulesScreen({super.key});

  Future<void> _toggle(
    BuildContext context,
    WidgetRef ref,
    NotificationRule rule,
    bool enabled,
  ) async {
    try {
      await ref
          .read(notificationRuleRepositoryProvider)
          .update(
            rule.type,
            enabled: enabled,
            thresholdAmount: rule.thresholdAmount,
          );
      ref.invalidate(notificationRuleListProvider);
    } catch (e) {
      if (context.mounted) {
        showErrorSnackBar(
          context,
          e is AppException ? e.message : 'Something went wrong.',
        );
      }
    }
  }

  Future<void> _setThreshold(
    BuildContext context,
    WidgetRef ref,
    NotificationRule rule,
    String threshold,
  ) async {
    try {
      await ref
          .read(notificationRuleRepositoryProvider)
          .update(
            rule.type,
            enabled: rule.enabled,
            thresholdAmount: threshold.isEmpty ? null : threshold,
          );
      ref.invalidate(notificationRuleListProvider);
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
    final rules = ref.watch(notificationRuleListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Settings')),
      body: AppPageBody(
        child: RefreshIndicator(
          onRefresh: () async => ref.invalidate(notificationRuleListProvider),
          child: rules.when(
            data: (items) => ListView.separated(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: AppSpacing.scrollInsets(context, floatingAction: false),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final rule = items[index];
                final description = _description(rule.type);
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(_label(rule.type)),
                          subtitle: description == null
                              ? null
                              : Text(description),
                          value: rule.enabled,
                          onChanged: (v) => _toggle(context, ref, rule, v),
                        ),
                        if (rule.type == NotificationRuleType.LOW_BALANCE &&
                            rule.enabled)
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.md,
                            ),
                            child: _ThresholdField(
                              key: ValueKey(
                                '${rule.type}-${rule.thresholdAmount}',
                              ),
                              initialValue: rule.thresholdAmount,
                              onSubmitted: (value) =>
                                  _setThreshold(context, ref, rule, value),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            loading: () => const LoadingView(),
            error: (e, _) => ErrorView(
              error: e,
              onRetry: () => ref.invalidate(notificationRuleListProvider),
            ),
          ),
        ),
      ),
    );
  }
}

class _ThresholdField extends StatefulWidget {
  const _ThresholdField({
    super.key,
    this.initialValue,
    required this.onSubmitted,
  });

  final String? initialValue;
  final ValueChanged<String> onSubmitted;

  @override
  State<_ThresholdField> createState() => _ThresholdFieldState();
}

class _ThresholdFieldState extends State<_ThresholdField> {
  late final _controller = TextEditingController(
    text: widget.initialValue ?? '',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: 'Alert below (RM)',
      controller: _controller,
      keyboardType: TextInputType.number,
      onSubmitted: (value) => widget.onSubmitted(value.trim()),
    );
  }
}
