import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/duitlah_colors.dart';
import 'amount_text.dart';

/// The existing balance card with the dedicated balance palette — a solid
/// surface, not a gradient (the redesign spec explicitly calls out
/// "excessive gradients" as something to avoid), so the primary number
/// reads as the page's focal point through contrast and typography alone.
/// Its background and text use separate balance tokens in both themes.
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
    final palette = context.duitlahColors;
    final onPrimary = palette.balanceText;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: palette.balanceBackground,
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
                    color: palette.balanceSecondary,
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
                      color: palette.balanceSecondary,
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
