import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';
import '../theme/duitlah_colors.dart';
import '../widgets/duitlah_icon.dart';
import 'app_routes.dart';

/// The reference's understated navigation, with an independent stack per tab,
/// plus a persistent assistant entry point floating above the bar.
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final destination = DuitlahBottomNavigation.destinationForBranch(
      navigationShell.currentIndex,
    );
    // The keyboard occupies the same corner, so the button stands down rather
    // than fighting it for space. Every other "hide it" case is structural:
    // the assistant screen, full-screen modals and detail routes are pushed
    // over this shell, so they never render it in the first place.
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    final safeRight = MediaQuery.paddingOf(context).right;

    return Scaffold(
      body: Stack(
        children: [
          navigationShell,
          if (!keyboardOpen)
            Positioned(
              right: AppSpacing.lg + safeRight,
              // Sits clear of a screen that already owns a floating action
              // button (a 56pt button 16 from the bottom), so the two stack
              // instead of colliding; otherwise it rests just above the bar.
              bottom: destination.ownsScreenFab ? 84 : 20,
              child: const AssistantFab(),
            ),
        ],
      ),
      bottomNavigationBar: DuitlahBottomNavigation(
        currentBranch: navigationShell.currentIndex,
        onSelect: (branch) => navigationShell.goBranch(
          branch,
          initialLocation: branch == navigationShell.currentIndex,
        ),
      ),
    );
  }
}

/// One bottom-navigation destination.
///
/// [branch] is the router's own `StatefulShellBranch` index, kept deliberately
/// separate from this list's visual order: Bagilah occupies the centre slot
/// while still resolving to the branch it always has, so repositioning a
/// destination never touches the route table.
class NavDestination {
  const NavDestination(
    this.icon,
    this.label,
    this.branch, {
    this.ownsScreenFab = false,
  });
  final IconData icon;
  final String label;
  final int branch;

  /// Whether the destination's own screen already renders a floating action
  /// button in the bottom-right corner.
  final bool ownsScreenFab;
}

class DuitlahBottomNavigation extends StatelessWidget {
  const DuitlahBottomNavigation({
    super.key,
    required this.currentBranch,
    required this.onSelect,
  });
  final int currentBranch;
  final ValueChanged<int> onSelect;

  /// Visual order. Bagilah sits in the centre as Duitlah's signature feature;
  /// Analytics takes the ordinary slot Bagilah used to hold.
  static const destinations = [
    NavDestination(Icons.home_outlined, 'Home', 0),
    NavDestination(
      Icons.receipt_long_outlined,
      'Transactions',
      1,
      ownsScreenFab: true,
    ),
    NavDestination(Icons.call_split, 'Bagilah', 3),
    NavDestination(Icons.insights_outlined, 'Analytics', 2),
    NavDestination(Icons.person_outline, 'Profile', 4),
  ];

  /// The centre slot of an odd-length row.
  static const centreSlot = 2;

  static NavDestination destinationForBranch(int branch) =>
      destinations.firstWhere(
        (destination) => destination.branch == branch,
        orElse: () => destinations.first,
      );

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
              for (var slot = 0; slot < destinations.length; slot++)
                Expanded(
                  child: _NavItem(
                    destination: destinations[slot],
                    selected: destinations[slot].branch == currentBranch,
                    centre: slot == centreSlot,
                    onTap: () => onSelect(destinations[slot].branch),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.destination,
    required this.selected,
    required this.centre,
    required this.onTap,
  });
  final NavDestination destination;
  final bool selected;
  final bool centre;
  final VoidCallback onTap;

  /// Every destination reserves the same icon slot, so giving the centre one a
  /// plate keeps the row exactly as balanced as it was without one.
  static const _slotHeight = 32.0;
  static const _slotWidth = 46.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.duitlahColors;
    final tint = selected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant;
    // The centre plate reads as branded whether or not it is the active tab —
    // that steady tint is the whole of its extra prominence. Nothing here is
    // larger, rounder or louder than its neighbours.
    final iconColor = centre
        ? (selected ? palette.textOnPrimary : palette.primary)
        : tint;

    return Semantics(
      selected: selected,
      button: true,
      label: destination.label,
      child: ExcludeSemantics(
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  height: _slotHeight,
                  width: _slotWidth,
                  alignment: Alignment.center,
                  decoration: centre
                      ? BoxDecoration(
                          color: selected
                              ? palette.primary
                              : palette.primarySubtle,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        )
                      : null,
                  child: DuitlahIcon(
                    destination.icon,
                    size: 23,
                    color: iconColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  destination.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: tint,
                  ),
                ),
                const SizedBox(height: 3),
                Container(
                  width: 4,
                  height: 3,
                  decoration: BoxDecoration(
                    color: selected
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
    );
  }
}

/// A faster way into the assistant that already exists at
/// [AppRoutes.assistant] — this only opens that screen, it never duplicates
/// any of its behaviour. Styled from the app's own
/// `floatingActionButtonTheme` (soft rounded square, primary fill,
/// elevation 2) so it reads as part of Duitlah in both themes.
class AssistantFab extends StatelessWidget {
  const AssistantFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      // A screen underneath may own a FAB too; distinct tags keep the two
      // out of each other's hero flights.
      heroTag: 'duitlah-assistant-fab',
      onPressed: () => context.push(AppRoutes.assistant),
      tooltip: 'Duitlah assistant',
      child: DuitlahIcon(
        Icons.smart_toy_outlined,
        size: 24,
        color: Theme.of(context).colorScheme.onPrimary,
        semanticLabel: 'Duitlah assistant',
      ),
    );
  }
}
