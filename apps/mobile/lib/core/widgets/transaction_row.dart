import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../features/accounts/domain/finance.dart';
import '../theme/app_colors.dart';
import '../utils/money.dart';
import 'duitlah_icon.dart';

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

class TransactionRow extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final t = transaction;
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
        ? (theme.brightness == Brightness.dark
              ? AppColors.positiveBright
              : AppColors.positive)
        : theme.colorScheme.onSurface;
    final sign = incoming ? '+' : '−';
    final text =
        '$sign ${Money.format(t.amount.replaceFirst(RegExp(r'^-'), ''), currency: currency)}';
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: incoming
                    ? AppColors.sage
                    : transfer
                    ? AppColors.blue
                    : AppColors.coral,
                shape: BoxShape.circle,
              ),
              child: DuitlahIcon(
                transfer
                    ? Icons.swap_horiz_outlined
                    : incoming
                    ? Icons.account_balance_wallet_outlined
                    : Icons.receipt_outlined,
                color: AppColors.forest,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
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
                    accountName == null ? label : '$label · $accountName',
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
    );
  }
}
