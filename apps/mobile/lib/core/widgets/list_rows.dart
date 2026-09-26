import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'amount_text.dart';
import 'app_adaptive_row.dart';

/// A generic row (transaction, group expense, settlement) with a leading
/// icon badge, title/subtitle, and a trailing amount — the one shape reused
/// across every "list of money-things" screen instead of a bespoke row per
/// feature.
class MoneyRow extends StatelessWidget {
  const MoneyRow({
    super.key,
    required this.title,
    required this.amount,
    this.currency = "RM",
    this.subtitle,
    this.leadingIcon,
    this.tone = AmountTone.neutral,
    this.onTap,
  });

  final String title;
  final String amount;
  final String currency;
  final String? subtitle;
  final IconData? leadingIcon;
  final AmountTone tone;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppRecordTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.xs,
      ),
      leading: leadingIcon == null
          ? null
          : Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
              child: DuitlahIcon(
                leadingIcon,
                size: 20,
                color: theme.colorScheme.onSurface,
              ),
            ),
      title: Text(title, style: theme.textTheme.bodyLarge),
      subtitle: subtitle == null
          ? null
          : Text(subtitle!, style: theme.textTheme.bodySmall),
      trailing: AmountText(
        amount,
        currency: currency,
        tone: tone,
        style: theme.textTheme.titleSmall,
      ),
    );
  }
}

/// A receipt line item row for Bagilah's review/claim screens.
class ReceiptItemRow extends StatelessWidget {
  const ReceiptItemRow({
    super.key,
    required this.name,
    required this.quantity,
    required this.totalPrice,
    this.claimStatus,
    this.onTap,
  });

  final String name;
  final String quantity;
  final String totalPrice;
  final Widget? claimStatus;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.xs,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: theme.textTheme.bodyLarge),
                  Text('Qty $quantity', style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            if (claimStatus != null) ...[
              claimStatus!,
              const SizedBox(width: AppSpacing.sm),
            ],
            Flexible(
              child: AmountText(totalPrice, style: theme.textTheme.titleSmall),
            ),
          ],
        ),
      ),
    );
  }
}
