import 'package:flutter/material.dart';

import '../theme/app_motion.dart';

/// Animates only when the authoritative progress value changes.
class AppProgress extends StatelessWidget {
  const AppProgress({
    super.key,
    required this.value,
    this.color,
    this.backgroundColor,
    this.minHeight = 6,
    this.semanticsLabel,
    this.semanticsValue,
  });
  final double value, minHeight;
  final Color? color, backgroundColor;
  final String? semanticsLabel, semanticsValue;
  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: value.clamp(0, 1)),
    duration: AppMotion.of(context, AppMotion.success),
    curve: AppMotion.curve,
    builder: (context, progress, _) => LinearProgressIndicator(
      value: progress,
      color: color,
      backgroundColor:
          backgroundColor ?? Theme.of(context).colorScheme.outlineVariant,
      minHeight: minHeight,
      borderRadius: BorderRadius.circular(8),
      semanticsLabel: [
        if (semanticsLabel != null) semanticsLabel!,
        if (semanticsValue != null) semanticsValue!,
      ].join(', '),
      semanticsValue: '${(value.clamp(0, 1) * 100).round()}',
    ),
  );
}
