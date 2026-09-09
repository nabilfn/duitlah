import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'amount_text.dart';

/// The premium hero balance card used on Home / Wallet — a solid teal
/// surface, not a gradient (the redesign spec explicitly calls out
/// "excessive gradients" as something to avoid), so the primary number
/// reads as the page's focal point through contrast and typography alone.
/// Colored via `colorScheme.primary`/`onPrimary` rather than a hardcoded
/// constant so it stays correct in both light mode (white text on teal) and
/// dark mode (dark text on the brightened dark-mode teal).
class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.label,
    required this.amount,
    this.subtitle,
    this.trailing,
  });

  final String label;
  final String amount;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onPrimary = theme.colorScheme.onPrimary;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.lg)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: onPrimary.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                AmountText(
                  amount,
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: onPrimary,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      color: onPrimary.withValues(alpha: 0.9),
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
