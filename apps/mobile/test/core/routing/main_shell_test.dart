import 'package:duitlah_mobile/core/routing/app_routes.dart';
import 'package:duitlah_mobile/core/routing/main_shell.dart';
import 'package:duitlah_mobile/core/theme/app_theme.dart';
import 'package:duitlah_mobile/core/theme/duitlah_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// The bar renders in visual order but reports the router's own branch index,
/// so these two must never be conflated: Bagilah sits in the centre slot while
/// still resolving to the branch it has always had.
void main() {
  Future<void> pumpBar(
    WidgetTester tester, {
    required int currentBranch,
    required ValueChanged<int> onSelect,
    bool dark = false,
  }) => tester.pumpWidget(
    MaterialApp(
      theme: dark ? AppTheme.dark() : AppTheme.light(),
      home: Scaffold(
        bottomNavigationBar: DuitlahBottomNavigation(
          currentBranch: currentBranch,
          onSelect: onSelect,
        ),
      ),
    ),
  );

  Rect rectOfLabel(WidgetTester tester, String label) =>
      tester.getRect(find.text(label));

  testWidgets('Bagilah holds the centre slot and Analytics the one beside it', (
    tester,
  ) async {
    await pumpBar(tester, currentBranch: 0, onSelect: (_) {});

    final centres = {
      for (final label in ['Home', 'Transactions', 'Bagilah', 'Analytics', 'Profile'])
        label: rectOfLabel(tester, label).center.dx,
    };
    final ordered = centres.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    expect(
      ordered.map((entry) => entry.key).toList(),
      ['Home', 'Transactions', 'Bagilah', 'Analytics', 'Profile'],
    );

    // The centre slot is the middle of the bar, not merely "somewhere after
    // Transactions" — assert it against the bar's own midpoint.
    final barMidpoint = tester
        .getRect(find.byType(DuitlahBottomNavigation))
        .center
        .dx;
    expect(centres['Bagilah'], moreOrLessEquals(barMidpoint, epsilon: 1));
  });

  testWidgets('each destination still selects the branch it always had', (
    tester,
  ) async {
    final selected = <int>[];
    await pumpBar(tester, currentBranch: 0, onSelect: selected.add);

    for (final label in ['Bagilah', 'Analytics', 'Home', 'Transactions', 'Profile']) {
      await tester.tap(find.text(label));
    }

    // Bagilah is branch 3 and Analytics branch 2 in the router's branch list,
    // regardless of having swapped visual places.
    expect(selected, [3, 2, 0, 1, 4]);
  });

  // The plate is a sibling of the label inside the destination's own column,
  // so it is reached through the item's InkWell rather than as an ancestor.
  BoxDecoration? plateFor(WidgetTester tester, String label) =>
      tester
              .widget<AnimatedContainer>(
                find.descendant(
                  of: find.ancestor(
                    of: find.text(label),
                    matching: find.byType(InkWell),
                  ),
                  matching: find.byType(AnimatedContainer),
                ),
              )
              .decoration
          as BoxDecoration?;

  for (final dark in [false, true]) {
    testWidgets('centre destination carries a branded plate, dark=$dark', (
      tester,
    ) async {
      await pumpBar(tester, currentBranch: 0, onSelect: (_) {}, dark: dark);
      final palette = dark ? DuitlahColors.dark : DuitlahColors.light;

      // Unselected Bagilah is still tinted — that steady brand plate is the
      // whole of its extra prominence.
      expect(plateFor(tester, 'Bagilah')?.color, palette.primarySubtle);

      // Its neighbours carry no plate at all.
      expect(plateFor(tester, 'Analytics'), isNull);
      expect(plateFor(tester, 'Home'), isNull);
    });
  }

  testWidgets('centre plate fills with primary once Bagilah is selected', (
    tester,
  ) async {
    await pumpBar(tester, currentBranch: 3, onSelect: (_) {});
    expect(plateFor(tester, 'Bagilah')?.color, DuitlahColors.light.primary);
  });

  testWidgets('every destination keeps an accessible touch target', (
    tester,
  ) async {
    await pumpBar(tester, currentBranch: 0, onSelect: (_) {});
    for (final label in ['Home', 'Transactions', 'Bagilah', 'Analytics', 'Profile']) {
      final target = tester.getRect(
        find.ancestor(of: find.text(label), matching: find.byType(InkWell)),
      );
      expect(target.height, greaterThanOrEqualTo(44));
      expect(target.width, greaterThanOrEqualTo(44));
    }
  });

  testWidgets('the assistant button is labelled for screen readers', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(body: AssistantFab()),
      ),
    );
    expect(
      find.bySemanticsLabel('Duitlah assistant'),
      findsAtLeastNWidgets(1),
    );
  });

  group('assistant button inside the shell', () {
    // A stand-in for the real shell: same branch order and paths as the app
    // router, with placeholder screens so this exercises MainShell itself
    // rather than any feature screen's data loading.
    Widget shellApp({double keyboardInset = 0}) {
      final router = GoRouter(
        initialLocation: AppRoutes.home,
        routes: [
          GoRoute(
            path: AppRoutes.assistant,
            builder: (context, state) =>
                const Scaffold(body: Text('assistant screen')),
          ),
          StatefulShellRoute.indexedStack(
            builder: (context, state, shell) =>
                MainShell(navigationShell: shell),
            branches: [
              for (final path in [
                AppRoutes.home,
                AppRoutes.transactions,
                AppRoutes.insights,
                AppRoutes.bagilah,
                AppRoutes.profile,
              ])
                StatefulShellBranch(
                  routes: [
                    GoRoute(
                      path: path,
                      builder: (context, state) => Scaffold(body: Text(path)),
                    ),
                  ],
                ),
            ],
          ),
        ],
      );
      return MaterialApp.router(
        theme: AppTheme.light(),
        routerConfig: router,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(viewInsets: EdgeInsets.only(bottom: keyboardInset)),
          child: child!,
        ),
      );
    }

    testWidgets('rides above the bar and opens the existing assistant screen', (
      tester,
    ) async {
      await tester.pumpWidget(shellApp());
      await tester.pumpAndSettle();

      final fab = find.byType(AssistantFab);
      expect(fab, findsOneWidget);

      // Right-aligned, and clear of the navigation bar rather than over it.
      final fabRect = tester.getRect(fab);
      final barRect = tester.getRect(find.byType(DuitlahBottomNavigation));
      final screen = tester.getRect(find.byType(MaterialApp));
      expect(fabRect.bottom, lessThanOrEqualTo(barRect.top));
      expect(screen.right - fabRect.right, lessThanOrEqualTo(20));

      await tester.tap(fab);
      await tester.pumpAndSettle();
      expect(find.text('assistant screen'), findsOneWidget);

      // It opens the one that already exists — it does not follow you onto it.
      expect(find.byType(AssistantFab), findsNothing);
    });

    testWidgets('stands down while the keyboard is open', (tester) async {
      await tester.pumpWidget(shellApp(keyboardInset: 320));
      await tester.pumpAndSettle();
      expect(find.byType(AssistantFab), findsNothing);
    });

    testWidgets('clears a screen that owns a floating action button', (
      tester,
    ) async {
      await tester.pumpWidget(shellApp());
      await tester.pumpAndSettle();
      final onHome = tester.getRect(find.byType(AssistantFab));

      await tester.tap(find.text('Transactions'));
      await tester.pumpAndSettle();
      final onTransactions = tester.getRect(find.byType(AssistantFab));

      // Transactions owns an "Add transaction" button in the same corner, so
      // the assistant sits above it instead of on top of it.
      expect(onTransactions.bottom, lessThan(onHome.bottom));
    });
  });
}
