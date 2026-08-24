import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_semantic_colors.dart';

/// The primary bottom navigation: Home / Transactions / Bagilah (the most
/// prominent, center action — per the Phase 9.5 migration doc) / Groups /
/// More. Built on [StatefulShellRoute.indexedStack] so each tab keeps its
/// own navigation stack when switching away and back.
///
/// Bagilah is rendered as a lifted circular button floating above the bar
/// (not a same-row destination like the other four) — the mobile redesign's
/// explicit call for the flagship feature's nav entry to read as its own
/// raised, distinctive moment rather than just another tab icon.
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      // No `extendBody` — the reserved bottomNavigationBar height already
      // includes the lifted circle's extra allowance (see `_BottomNavBar`'s
      // SizedBox height below), so the body stops exactly where the Stack
      // begins rather than needing to render underneath it.
      bottomNavigationBar: _BottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onSelect: (index) =>
            navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.icon, required this.selectedIcon, required this.label});
  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

const _barHeight = 64.0;
const _circleSize = 58.0;

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.currentIndex, required this.onSelect});

  final int currentIndex;
  final ValueChanged<int> onSelect;

  static const _items = <_NavItem?>[
    _NavItem(icon: Icons.home_outlined, selectedIcon: Icons.home, label: 'Home'),
    _NavItem(icon: Icons.receipt_long_outlined, selectedIcon: Icons.receipt_long, label: 'Transactions'),
    null, // Bagilah — the lifted circle, positioned separately below.
    _NavItem(icon: Icons.groups_outlined, selectedIcon: Icons.groups, label: 'Groups'),
    _NavItem(icon: Icons.more_horiz, selectedIcon: Icons.more_horiz, label: 'More'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = context.semanticColors;
    final isDark = theme.brightness == Brightness.dark;
    final selectedColor = isDark ? const Color(0xFF1DC4C9) : const Color(0xFF007F84);
    final unselectedColor = theme.colorScheme.onSurface.withValues(alpha: 0.55);
    // The system gesture-nav inset has to be *added* height, not carved out
    // of the fixed bar height -- wrapping the row in `SafeArea` instead
    // (the first version of this widget) compressed the icon+label content
    // into less vertical space than it needs, overflowing by exactly the
    // inset amount on every destination. Found live on the emulator.
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return SizedBox(
      height: _barHeight + _circleSize * 0.55 + bottomInset,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: _barHeight + bottomInset,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              border: Border(top: BorderSide(color: theme.colorScheme.outline)),
            ),
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: Row(
                children: List.generate(_items.length, (index) {
                  final item = _items[index];
                  if (item == null) {
                    return const Expanded(child: SizedBox.shrink());
                  }
                  final selected = currentIndex == index;
                  final color = selected ? selectedColor : unselectedColor;
                  return Expanded(
                    child: InkWell(
                      onTap: () => onSelect(index),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(selected ? item.selectedIcon : item.icon, color: color, size: 24),
                          const SizedBox(height: 2),
                          Text(
                            item.label,
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          Positioned(
            bottom: _barHeight - _circleSize * 0.42 + bottomInset,
            child: _LiftedBagilahButton(
              selected: currentIndex == 2,
              color: semantic.bagilah,
              foreground: semantic.bagilahForeground,
              onTap: () => onSelect(2),
            ),
          ),
        ],
      ),
    );
  }
}

/// The lifted circular Bagilah button — raised above the bar's top edge on
/// its own elevated surface, rather than sitting flush in the row like an
/// ordinary destination.
class _LiftedBagilahButton extends StatelessWidget {
  const _LiftedBagilahButton({
    required this.selected,
    required this.color,
    required this.foreground,
    required this.onTap,
  });

  final bool selected;
  final Color color;
  final Color foreground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: _circleSize,
        height: _circleSize,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            width: 3,
          ),
        ),
        child: Icon(Icons.receipt_rounded, color: foreground, size: 26),
      ),
    );
  }
}
