import 'package:flutter/material.dart';

/// A slim segmented "Stories"-style progress indicator — one pill segment per page, filled
/// solid up to and including [currentIndex], the rest left at low-opacity. Deliberately not
/// a single continuous bar (that would read as a generic loading indicator, not pagination).
class StoryProgressBar extends StatelessWidget {
  const StoryProgressBar({
    super.key,
    required this.pageCount,
    required this.currentIndex,
    required this.color,
    this.progress = 1,
  });

  final int pageCount;
  final int currentIndex;
  final Color color;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < pageCount; i++) ...[
          if (i > 0) const SizedBox(width: 6),
          Expanded(
            child: Semantics(
              label: 'Story ${i + 1} of $pageCount',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: SizedBox(
                  height: 3,
                  child: ColoredBox(
                    color: color.withValues(alpha: .28),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: AnimatedFractionallySizedBox(
                        heightFactor: 1,
                        duration: Duration(
                          milliseconds: MediaQuery.disableAnimationsOf(context)
                              ? 0
                              : 220,
                        ),
                        widthFactor: i < currentIndex
                            ? 1
                            : i == currentIndex
                            ? progress
                            : 0,
                        child: ColoredBox(color: color),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
