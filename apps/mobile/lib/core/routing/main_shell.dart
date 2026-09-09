import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/duitlah_icon.dart';

/// The reference's understated navigation, with an independent stack per tab.
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: navigationShell,
    bottomNavigationBar: DuitlahBottomNavigation(
      currentIndex: navigationShell.currentIndex,
      onSelect: (index) => navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      ),
    ),
  );
}

class DuitlahBottomNavigation extends StatelessWidget {
  const DuitlahBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onSelect,
  });
  final int currentIndex;
  final ValueChanged<int> onSelect;
  static const items = [
    (Icons.home_outlined, 'Home'),
    (Icons.receipt_long_outlined, 'Transactions'),
    (Icons.insights_outlined, 'Analytics'),
    (Icons.call_split, 'Bagilah'),
    (Icons.person_outline, 'Profile'),
  ];
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        side: BorderSide(
          color: theme.colorScheme.outline.withValues(alpha: .5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: Semantics(
                    selected: currentIndex == i,
                    button: true,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => onSelect(i),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DuitlahIcon(
                              items[i].$1,
                              size: 23,
                              color: currentIndex == i
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              items[i].$2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: currentIndex == i
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: currentIndex == i
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Container(
                              width: 4,
                              height: 3,
                              decoration: BoxDecoration(
                                color: currentIndex == i
                                    ? theme.colorScheme.primary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
