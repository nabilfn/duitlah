import 'package:flutter/material.dart';

/// Summary labels and actions stack at narrow widths instead of competing
/// with financial values. Wide layouts retain their original reading order.
class AppAdaptiveRow extends StatelessWidget {
  const AppAdaptiveRow({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
  });
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth < 360 ||
          MediaQuery.textScalerOf(context).scale(14) > 17) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) const SizedBox(height: 6),
              children[i],
            ],
          ],
        );
      }
      return Row(
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        children: [for (final child in children) Flexible(child: child)],
      );
    },
  );
}

/// Multi-line amounts and status chips cannot fit ListTile's fixed trailing
/// slot. This row gives them natural height and stacks at larger text scales.
class AppRecordTile extends StatelessWidget {
  const AppRecordTile({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.contentPadding,
    this.selected = false,
    this.enabled = true,
    this.dense,
    this.isThreeLine = false,
    this.tileColor,
    this.visualDensity,
  });
  final Widget? title, subtitle, leading, trailing;
  final VoidCallback? onTap, onLongPress;
  final EdgeInsetsGeometry? contentPadding;
  final bool selected, enabled, isThreeLine;
  final bool? dense;
  final Color? tileColor;
  final VisualDensity? visualDensity;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          DefaultTextStyle(style: theme.textTheme.bodyLarge!, child: title!),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          DefaultTextStyle(style: theme.textTheme.bodySmall!, child: subtitle!),
        ],
      ],
    );
    return Semantics(
      selected: selected,
      enabled: enabled,
      child: Material(
        color: tileColor ?? Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          onLongPress: enabled ? onLongPress : null,
          child: Padding(
            padding: contentPadding ?? const EdgeInsets.all(16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final stacked =
                    constraints.maxWidth < 360 ||
                    MediaQuery.textScalerOf(context).scale(14) > 17;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (leading != null) ...[
                      leading!,
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (stacked)
                            text
                          else
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: text),
                                if (trailing != null) ...[
                                  const SizedBox(width: 12),
                                  Flexible(child: trailing!),
                                ],
                              ],
                            ),
                          if (stacked && trailing != null) ...[
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: trailing!,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Keep metrics side by side only when each retains a readable measure.
class AppMetricRow extends StatelessWidget {
  const AppMetricRow({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final metrics = children.whereType<Flexible>().toList();
      final minimum = 140 * MediaQuery.textScalerOf(context).scale(14) / 14;
      if (metrics.isNotEmpty &&
          constraints.maxWidth / metrics.length < minimum) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < metrics.length; i++) ...[
              if (i > 0) const SizedBox(height: 16),
              metrics[i].child,
            ],
          ],
        );
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      );
    },
  );
}
