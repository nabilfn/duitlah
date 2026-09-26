import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';
import '../theme/duitlah_colors.dart';
import '../widgets/duitlah_icon.dart';
import '../widgets/editorial_surfaces.dart';
import '../widgets/dock_insets.dart';
import '../theme/glass_tokens.dart';
import 'app_routes.dart';

/// The reference's understated navigation, with an independent stack per tab,
/// plus a persistent assistant entry point floating above the bar.
class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  bool _moving = false;
  @override
  Widget build(BuildContext context) {
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    return Scaffold(
      extendBody: true,
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.axis == Axis.vertical) {
            final moving = notification is ScrollStartNotification
                ? true
                : notification is ScrollEndNotification
                ? false
                : _moving;
            if (_moving != moving) setState(() => _moving = moving);
          }
          return false;
        },
        child: DuitlahDockBody(child: widget.navigationShell),
      ),
      bottomNavigationBar: keyboardOpen
          ? null
          : DuitlahNavigationDock(
              currentBranch: widget.navigationShell.currentIndex,
              moving: _moving,
              onSelect: (branch) => widget.navigationShell.goBranch(
                branch,
                initialLocation: branch == widget.navigationShell.currentIndex,
              ),
            ),
    );
  }
}

/// A stable material dock; scroll content remains reachable via measured insets.
class DuitlahNavigationDock extends StatelessWidget {
  const DuitlahNavigationDock({
    super.key,
    required this.currentBranch,
    required this.onSelect,
    this.moving = false,
  });
  final int currentBranch;
  final ValueChanged<int> onSelect;
  final bool moving;
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.only(right: 16, bottom: 2),
          child: AssistantFab(),
        ),
      ),
      DuitlahBottomNavigation(
        currentBranch: currentBranch,
        onSelect: onSelect,
        moving: moving,
      ),
    ],
  );
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
    this.moving = false,
  });
  final int currentBranch;
  final ValueChanged<int> onSelect;
  final bool moving;

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
    final slot = destinations.indexWhere((d) => d.branch == currentBranch);
    return DuitlahGlassSurface(
      material: GlassMaterial.strong,
      elevated: true,
      active: moving,
      child: Material(
        color: Colors.transparent,
        child: SafeArea(
          top: false,
          child: Stack(
            children: [
              Positioned(
                top: 4,
                left: 8,
                right: 8,
                height: 28,
                child: IgnorePointer(
                  child: AnimatedAlign(
                    duration: EditorialMotion.of(context),
                    curve: EditorialMotion.curve,
                    alignment: AlignmentDirectional(
                      -1 + 2 * slot / (destinations.length - 1),
                      0,
                    ),
                    child: FractionallySizedBox(
                      widthFactor: 1 / destinations.length,
                      child: Center(
                        child: DuitlahGlassSurface(
                          radius: 12,
                          material: GlassMaterial.soft,
                          blur: false,
                          child: const SizedBox(width: 46, height: 28),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 8,
                right: 8,
                height: 2,
                child: AnimatedAlign(
                  duration: EditorialMotion.of(context),
                  curve: EditorialMotion.curve,
                  alignment: AlignmentDirectional(
                    -1 + 2 * slot / (destinations.length - 1),
                    0,
                  ),
                  child: FractionallySizedBox(
                    widthFactor: 1 / destinations.length,
                    child: Center(
                      child: Container(
                        width: 24,
                        height: 2,
                        color: context.duitlahColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < destinations.length; i++)
                      Expanded(
                        child: _NavItem(
                          destination: destinations[i],
                          selected: destinations[i].branch == currentBranch,
                          centre: i == centreSlot,
                          onTap: () => onSelect(destinations[i].branch),
                        ),
                      ),
                  ],
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
  static const _slotHeight = 26.0;
  static const _slotWidth = 46.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.duitlahColors;
    final tint = selected
        ? theme.colorScheme.primary
        : palette.textPrimary.withValues(alpha: .8);
    // The centre plate reads as branded whether or not it is the active tab —
    // that steady tint is the whole of its extra prominence. Nothing here is
    // larger, rounder or louder than its neighbours.
    final iconColor = centre
        ? (selected ? palette.balanceText : palette.primary)
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
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: EditorialMotion.of(context),
                  curve: Curves.easeOut,
                  height: _slotHeight,
                  width: _slotWidth,
                  alignment: Alignment.center,
                  decoration: centre
                      ? BoxDecoration(
                          color: selected
                              ? palette.balanceBackground
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
    final colors = context.duitlahColors;
    return DuitlahGlassButton(
      label: 'Duitlah assistant',
      onPressed: () {
        final box = context.findRenderObject();
        final origin = box is RenderBox
            ? box.localToGlobal(Offset.zero) & box.size
            : null;
        context.push(AppRoutes.assistant, extra: origin);
      },
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      material: GlassMaterial.strong,
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.balanceBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'd.',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: colors.balanceText,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Ask Duitlah',
              style: TextStyle(
                fontSize: 12,
                color: colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Text('↗', style: TextStyle(color: colors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
