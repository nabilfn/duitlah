import 'package:flutter/material.dart';

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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? theme.colorScheme.surfaceContainerHighest
            : const Color(0xFFEEF0ED),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
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
                    backgroundColor: selected.contains(segment.value)
                        ? theme.colorScheme.primary
                        : Colors.transparent,
                    foregroundColor: selected.contains(segment.value)
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurfaceVariant,
                    disabledForegroundColor: selected.contains(segment.value)
                        ? theme.colorScheme.onPrimary.withValues(alpha: .6)
                        : theme.disabledColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    textStyle: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
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
    );
  }
}
