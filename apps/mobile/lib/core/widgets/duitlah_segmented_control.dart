import 'package:duitlah_mobile/core/theme/duitlah_colors.dart';
import 'package:flutter/material.dart';

import 'editorial_surfaces.dart';
import '../theme/glass_tokens.dart';

/// Independent rounded selection pills, matching the reference on every form.
class DuitlahSegmentedControl<T> extends StatelessWidget {
  const DuitlahSegmentedControl({
    super.key,
    required this.segments,
    required this.selected,
    this.onSelectionChanged,
    this.showSelectedIcon = false,
  });
  final List<ButtonSegment<T>> segments;
  final Set<T> selected;
  final ValueChanged<Set<T>>? onSelectionChanged;
  final bool showSelectedIcon;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = DuitlahGlassSurface(
      radius: 14,
      blur: false,
      material: GlassMaterial.soft,
      child: Stack(
        children: [
          if (segments.any((segment) => selected.contains(segment.value)))
            Positioned.fill(
              child: AnimatedAlign(
                alignment: AlignmentDirectional(
                  segments.length == 1
                      ? 0
                      : -1 +
                            2 *
                                segments.indexWhere(
                                  (s) => selected.contains(s.value),
                                ) /
                                (segments.length - 1),
                  0,
                ),
                duration: EditorialMotion.of(context),
                curve: EditorialMotion.curve,
                child: FractionallySizedBox(
                  widthFactor: 1 / segments.length,
                  heightFactor: 1,
                  child: const DuitlahGlassSurface(
                    radius: 14,
                    blur: false,
                    material: GlassMaterial.strong,
                    child: SizedBox.expand(),
                  ),
                ),
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (final segment in segments)
                Expanded(
                  child: Semantics(
                    selected: selected.contains(segment.value),
                    child: TextButton(
                      onPressed: onSelectionChanged != null && segment.enabled
                          ? () => onSelectionChanged!({segment.value})
                          : null,
                      style: TextButton.styleFrom(
                        minimumSize: const Size(44, 44),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 10,
                        ),
                        backgroundColor: Colors.transparent,
                        foregroundColor: selected.contains(segment.value)
                            ? context.duitlahColors.textPrimary
                            : theme.colorScheme.onSurfaceVariant,
                        disabledForegroundColor:
                            selected.contains(segment.value)
                            ? context.duitlahColors.textPrimary.withValues(
                                alpha: .6,
                              )
                            : theme.disabledColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        textStyle: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          fontWeight: selected.contains(segment.value)
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                      child: DefaultTextStyle.merge(
                        textAlign: TextAlign.center,
                        child:
                            segment.label ??
                            segment.icon ??
                            const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        var minimum = 64.0;
        for (final segment in segments) {
          final label = segment.label;
          if (label is Text && label.data != null) {
            final painter = TextPainter(
              text: TextSpan(
                text: label.data,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              textDirection: Directionality.of(context),
              textScaler: MediaQuery.textScalerOf(context),
              maxLines: 1,
            )..layout();
            minimum = minimum > painter.width + 24
                ? minimum
                : painter.width + 24;
            painter.dispose();
          }
        }
        final requiredWidth = minimum * segments.length;
        if (constraints.maxWidth >= requiredWidth) return surface;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(width: requiredWidth, child: surface),
        );
      },
    );
  }
}
