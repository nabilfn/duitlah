import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/duitlah_colors.dart';
import '../utils/money.dart';

/// A hero surface accepting display text, including privacy and loading states.
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
    final palette = context.duitlahColors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: palette.balanceBackground,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: palette.balanceSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 24),
          Text(
            num.tryParse(amount) == null ? amount : Money.format(amount),
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: palette.balanceText,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 24),
            Text(
              subtitle!,
              style: TextStyle(
                color: palette.balanceSecondary,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
