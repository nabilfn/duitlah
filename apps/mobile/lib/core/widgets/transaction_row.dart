import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../features/accounts/domain/finance.dart';
import '../theme/duitlah_colors.dart';
import '../utils/money.dart';
import 'editorial_surfaces.dart';

String transactionDateLabel(String raw, {DateTime? now}) {
  final date = DateTime.tryParse(raw);
  if (date == null) return raw;
  final today = now ?? DateTime.now();
  final day = DateTime(today.year, today.month, today.day);
  final target = DateTime(date.year, date.month, date.day);
  if (target == day) return 'Today';
  if (target == day.subtract(const Duration(days: 1))) return 'Yesterday';
  return DateFormat('d MMM yyyy').format(date);
}

class TransactionRow extends StatefulWidget {
  const TransactionRow({
    super.key,
    required this.transaction,
    this.accountName,
    this.currency = "RM",
    this.onTap,
  });
  final Transaction transaction;
  final String? accountName;
  final String currency;
  final VoidCallback? onTap;
  @override
  State<TransactionRow> createState() => _TransactionRowState();
}

class _TransactionRowState extends State<TransactionRow> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    final t = widget.transaction;
    final theme = Theme.of(context);
    final transfer = t.type == TransactionType.TRANSFER;
    final incoming = t.direction == TransactionDirection.IN;
    final label = transfer
        ? 'Transfer'
        : incoming
        ? 'Income'
        : 'Expense';
    final color = transfer
        ? theme.colorScheme.onSurface
        : incoming
        ? context.duitlahColors.positive
        : theme.colorScheme.onSurface;
    final sign = incoming ? '+' : '−';
    final text =
        '$sign ${Money.format(t.amount.replaceFirst(RegExp(r'^-'), ''), currency: widget.currency)}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          expanded: expanded,
          child: InkWell(
            onTap: widget.onTap ?? () => setState(() => expanded = !expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.merchant ?? t.description ?? label,
                          style: theme.textTheme.titleSmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          widget.accountName == null
                              ? label
                              : '$label · ${widget.accountName}',
                          style: theme.textTheme.bodySmall,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    flex: 4,
                    child: Text(
                      text,
                      textAlign: TextAlign.end,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: color,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        DuitlahExpand(
          duration: EditorialMotion.of(context),
          curve: EditorialMotion.curve,
          alignment: Alignment.topCenter,
          child: !expanded
              ? const SizedBox(width: double.infinity)
              : Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transactionDateLabel(t.occurredOn),
                        style: theme.textTheme.bodySmall,
                      ),
                      if (t.description != null && t.description != t.merchant)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(t.description!),
                        ),
                      if (t.notes != null && t.notes!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(t.notes!),
                        ),
                      if (t.recurringTransactionId != null)
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text('Recurring transaction'),
                        ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
