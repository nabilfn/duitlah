import 'package:flutter/material.dart';

import '../theme/app_semantic_colors.dart';
import '../utils/money.dart';

enum AmountTone { neutral, positive, negative, auto }

/// A prominent monetary display — balances, bill totals, settlement
/// amounts. [tone] `auto` colors by sign (a positive net = you're owed =
/// success green; negative = you owe = destructive), matching the
/// convention already established across the web app's balance displays.
class AmountText extends StatelessWidget {
  const AmountText(
    this.amount, {
    super.key,
    this.currency = 'RM',
    this.tone = AmountTone.neutral,
    this.style,
  });

  final String amount;
  final String currency;
  final AmountTone tone;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = context.semanticColors;

    Color color;
    switch (tone) {
      case AmountTone.positive:
        color = semantic.success;
      case AmountTone.negative:
        color = theme.colorScheme.error;
      case AmountTone.auto:
        color = Money.isNegative(amount)
            ? theme.colorScheme.error
            : Money.isPositive(amount)
            ? semantic.success
            : theme.colorScheme.onSurface;
      case AmountTone.neutral:
        color = style?.color ?? theme.colorScheme.onSurface;
    }

    return Text(
      Money.format(amount, currency: currency),
      style: (style ?? theme.textTheme.headlineSmall)?.copyWith(
        color: color,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}
