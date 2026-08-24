import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/chart_of_accounts.dart';
import '../../domain/journal_entries.dart';

/// One row being edited in [JournalLineEditor] — mirrors
/// `business/presentation/widgets/line_items_editor.dart`'s `LineItemDraft`
/// pattern: live controllers here, a plain immutable [JournalEntryLineInput]
/// handed to the server. [amountController] is a plain [ChangeNotifier]
/// (every [TextEditingController] is), so a caller can drive a live running
/// total by listening to it directly rather than needing an explicit
/// `onChanged` callback on every keystroke.
class JournalLineDraft {
  JournalLineDraft({this.account, this.direction = LedgerDirection.DEBIT, String amount = '', String description = ''})
      : amountController = TextEditingController(text: amount),
        descriptionController = TextEditingController(text: description);

  LedgerAccount? account;
  LedgerDirection direction;
  final TextEditingController amountController;
  final TextEditingController descriptionController;

  double get amountValue => double.tryParse(amountController.text.trim()) ?? 0;

  JournalEntryLineInput? toInput() {
    if (account == null) return null;
    final amount = amountController.text.trim();
    if (amount.isEmpty) return null;
    return JournalEntryLineInput(
      accountId: account!.id,
      direction: direction,
      amount: amount,
      description: descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
    );
  }
}

/// Dynamic journal-entry line rows: an account picker (Chart of Accounts,
/// archived accounts already excluded by the caller), a DEBIT/CREDIT
/// toggle, an amount, an optional description, plus add/remove. The
/// running debit/credit/difference indicator lives in the caller (which
/// also owns the [Listenable] driving live updates) rather than here, since
/// it needs to react to every line's amount at once.
class JournalLineEditor extends StatelessWidget {
  const JournalLineEditor({
    super.key,
    required this.lines,
    required this.accounts,
    required this.onChanged,
  });

  final List<JournalLineDraft> lines;
  final List<LedgerAccount> accounts;
  final ValueChanged<List<JournalLineDraft>> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < lines.length; i++) _line(context, i),
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton.icon(
          onPressed: () => onChanged([...lines, JournalLineDraft()]),
          icon: const Icon(Icons.add),
          label: const Text('Add line'),
        ),
      ],
    );
  }

  Widget _line(BuildContext context, int index) {
    final line = lines[index];
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<LedgerAccount>(
                  initialValue: line.account,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Account'),
                  items: accounts
                      .map((a) => DropdownMenuItem(value: a, child: Text('${a.code} · ${a.name}')))
                      .toList(),
                  onChanged: (a) {
                    line.account = a;
                    onChanged(lines);
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: lines.length <= 1 ? null : () => onChanged([...lines]..removeAt(index)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          SegmentedButton<LedgerDirection>(
            segments: const [
              ButtonSegment(value: LedgerDirection.DEBIT, label: Text('Debit')),
              ButtonSegment(value: LedgerDirection.CREDIT, label: Text('Credit')),
            ],
            selected: {line.direction},
            onSelectionChanged: (s) {
              line.direction = s.first;
              onChanged(lines);
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            label: 'Amount',
            controller: line.amountController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(label: 'Description (optional)', controller: line.descriptionController),
        ],
      ),
    );
  }
}
