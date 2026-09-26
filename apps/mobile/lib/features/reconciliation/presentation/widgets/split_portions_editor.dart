import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/reconciliation.dart';

/// One portion being edited in [SplitPortionsEditor] — mirrors `accounting/
/// presentation/widgets/journal_line_editor.dart`'s `JournalLineDraft`
/// pattern: live controllers here, a plain immutable [SplitPortionInput]
/// handed to the server.
class SplitPortionDraft {
  SplitPortionDraft({String description = '', String amount = ''})
    : descriptionController = TextEditingController(text: description),
      amountController = TextEditingController(text: amount);

  final TextEditingController descriptionController;
  final TextEditingController amountController;

  double get amountValue => double.tryParse(amountController.text.trim()) ?? 0;

  SplitPortionInput? toInput() {
    final amount = amountController.text.trim();
    if (amount.isEmpty) return null;
    return SplitPortionInput(
      description: descriptionController.text.trim().isEmpty
          ? null
          : descriptionController.text.trim(),
      amount: amount,
    );
  }

  void dispose() {
    descriptionController.dispose();
    amountController.dispose();
  }
}

/// Dynamic portion rows for splitting one lump-sum statement line into
/// several new ledger entries. The running-total-vs-target indicator lives
/// in the caller (which owns the [Listenable] driving live updates), same
/// division of responsibility as [JournalLineEditor].
class SplitPortionsEditor extends StatelessWidget {
  const SplitPortionsEditor({
    super.key,
    required this.portions,
    required this.onChanged,
  });

  final List<SplitPortionDraft> portions;
  final ValueChanged<List<SplitPortionDraft>> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < portions.length; i++) _portion(context, i),
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton.icon(
          onPressed: () => onChanged([...portions, SplitPortionDraft()]),
          icon: const DuitlahIcon(Icons.add),
          label: const Text('Add portion'),
        ),
      ],
    );
  }

  Widget _portion(BuildContext context, int index) {
    final portion = portions[index];
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                AppTextField(
                  label: 'Description (optional)',
                  controller: portion.descriptionController,
                ),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(
                  label: 'Amount',
                  controller: portion.amountController,
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const DuitlahIcon(Icons.close),
            onPressed: portions.length <= 2
                ? null
                : () => onChanged([...portions]..removeAt(index)),
          ),
        ],
      ),
    );
  }
}
