import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/dialogs.dart';
import '../../budgets/application/budgets_providers.dart';
import '../../budgets/domain/budget.dart';

/// Existing goal creation, optionally seeded with an editable Wrapped recommendation.
class GoalEditorSheet extends ConsumerStatefulWidget {
  const GoalEditorSheet({super.key, this.wrappedAmount, this.wrappedMonth});
  final String? wrappedAmount, wrappedMonth;
  @override
  ConsumerState<GoalEditorSheet> createState() => _GoalEditorSheetState();
}

class _GoalEditorSheetState extends ConsumerState<GoalEditorSheet> {
  late final _name = TextEditingController(
    text: widget.wrappedAmount == null ? '' : 'Future You — monthly savings',
  );
  late final _target = TextEditingController(text: widget.wrappedAmount ?? '');
  bool _busy = false;
  @override
  void dispose() {
    _name.dispose();
    _target.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    if (_busy) return;
    if (_name.text.trim().isEmpty ||
        !RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(_target.text.trim()) ||
        !Money.isPositive(_target.text.trim())) {
      showErrorSnackBar(
        context,
        'Enter a name and a positive amount with up to two decimal places.',
      );
      return;
    }
    setState(() => _busy = true);
    try {
      await ref
          .read(goalsRepositoryProvider)
          .createGoal(
            name: _name.text.trim(),
            type: GoalType.CUSTOM,
            targetAmount: _target.text.trim(),
          );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() => _busy = false);
        showErrorSnackBar(
          context,
          e is AppException ? e.message : 'Something went wrong.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
    child: Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('New goal', style: Theme.of(context).textTheme.titleLarge),
          if (widget.wrappedAmount != null) ...[
            const SizedBox(height: 12),
            const Text('Suggested frequency: Monthly'),
            Text(
              'Source: Duitlah Wrapped recommendation${widget.wrappedMonth == null ? '' : ' · ${widget.wrappedMonth}'}',
            ),
            const SizedBox(height: 8),
            const Text(
              'A monthly target to work toward at your own pace. Creating a goal does not move money or schedule transfers.',
            ),
          ],
          const SizedBox(height: 12),
          AppTextField(label: 'Goal name', controller: _name),
          const SizedBox(height: 8),
          AppTextField(
            label: widget.wrappedAmount == null
                ? 'Target amount (RM)'
                : 'Target contribution (RM)',
            controller: _target,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: 'Create goal',
            loading: _busy,
            onPressed: _create,
          ),
        ],
      ),
    ),
  );
}
