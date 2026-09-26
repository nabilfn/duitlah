import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:duitlah_mobile/core/routing/main_shell.dart';
import 'package:duitlah_mobile/core/routing/app_routes.dart';
import 'package:duitlah_mobile/core/theme/app_theme.dart';
import 'package:duitlah_mobile/core/theme/glass_accessibility.dart';
import 'package:duitlah_mobile/core/theme/glass_tokens.dart';
import 'package:duitlah_mobile/core/widgets/editorial_surfaces.dart';
import 'package:duitlah_mobile/core/widgets/dock_insets.dart';
import 'package:duitlah_mobile/core/widgets/glass_account_selector.dart';
import 'package:duitlah_mobile/core/widgets/dialogs.dart';

void main() {
  for (final dark in [false, true]) {
    testWidgets(
      'reduced transparency replaces frosted glass with opaque material, dark=$dark',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: dark ? AppTheme.dark() : AppTheme.light(),
            home: GlassTransparencyScope(
              reduceTransparency: true,
              child: Scaffold(
                body: DuitlahGlassSurface(
                  material: GlassMaterial.strong,
                  child: const Text('Financial details'),
                ),
              ),
            ),
          ),
        );
        expect(
          tester
              .widgetList<BackdropFilter>(find.byType(BackdropFilter))
              .every((f) => !f.enabled),
          true,
        );
        final fills = tester
            .widgetList<DecoratedBox>(
              find.descendant(
                of: find.byType(DuitlahGlassSurface),
                matching: find.byType(DecoratedBox),
              ),
            )
            .map((w) => w.decoration)
            .whereType<BoxDecoration>()
            .where((d) => d.color != null);
        expect(fills.single.color!.a, 1);
        expect(find.text('Financial details'), findsOneWidget);
      },
    );
  }
  for (final dark in [false, true]) {
    testWidgets(
      'material retains frosted coverage over contrasting content, dark=$dark',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: dark ? AppTheme.dark() : AppTheme.light(),
            home: Scaffold(
              body: Center(
                child: RepaintBoundary(
                  key: const ValueKey('sample'),
                  child: ColoredBox(
                    color: dark ? Colors.white : Colors.black,
                    child: const DuitlahGlassSurface(
                      blur: false,
                      material: GlassMaterial.strong,
                      child: SizedBox(width: 100, height: 100),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        final boundary = tester.renderObject<RenderRepaintBoundary>(
          find.byKey(const ValueKey('sample')),
        );
        final red = await tester.runAsync(() async {
          final image = await boundary.toImage();
          final bytes = await image.toByteData(
            format: ui.ImageByteFormat.rawRgba,
          );
          final center =
              ((image.height ~/ 2) * image.width + image.width ~/ 2) * 4;
          final value = bytes!.getUint8(center);
          image.dispose();
          return value;
        });
        expect(red, dark ? lessThan(100) : greaterThan(175));
      },
    );
  }

  testWidgets(
    'iOS transparency preference is read once and responds to system changes',
    (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      const channel = MethodChannel('duitlah/accessibility');
      var reads = 0;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
        call,
      ) async {
        reads++;
        return true;
      });
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          channel,
          null,
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          builder: (_, child) => GlassAccessibility(child: child!),
          home: const Scaffold(
            body: DuitlahGlassSurface(child: Text('Details')),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(reads, 1);
      expect(
        tester.widget<BackdropFilter>(find.byType(BackdropFilter)).enabled,
        false,
      );
      ui.channelBuffers.push(
        'duitlah/accessibility',
        const StandardMethodCodec().encodeMethodCall(
          const MethodCall('reduceTransparencyChanged', false),
        ),
        (_) {},
      );
      await tester.pumpAndSettle();
      expect(
        tester.widget<BackdropFilter>(find.byType(BackdropFilter)).enabled,
        true,
      );
      await tester.pumpWidget(const SizedBox.shrink());
      debugDefaultTargetPlatformOverride = null;
    },
  );
  testWidgets('high contrast also provides an opaque, unblurred fallback', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(highContrast: true),
          child: Scaffold(body: DuitlahGlassSurface(child: Text('Details'))),
        ),
      ),
    );
    expect(
      tester.widget<BackdropFilter>(find.byType(BackdropFilter)).enabled,
      false,
    );
  });
  testWidgets(
    'glass buttons compress and strengthen on press without duplicate activation',
    (tester) async {
      var calls = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: DuitlahGlassButton(
                onPressed: () => calls++,
                child: const Text('Add expense'),
              ),
            ),
          ),
        ),
      );
      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Add expense')),
      );
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<DuitlahGlassSurface>(find.byType(DuitlahGlassSurface))
            .pressed,
        true,
      );
      expect(
        tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale,
        .98,
      );
      await gesture.up();
      await tester.pumpAndSettle();
      expect(calls, 1);
      expect(tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale, 1);
    },
  );
  testWidgets(
    'the anchored account menu routes Both to the existing combined view',
    (tester) async {
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) =>
                const Scaffold(body: SafeArea(child: GlassAccountSelector())),
          ),
          GoRoute(
            path: AppRoutes.home,
            builder: (_, _) => const Scaffold(body: Text('Personal view')),
          ),
          GoRoute(
            path: AppRoutes.spaces,
            builder: (_, _) => const Scaffold(body: Text('Workspaces')),
          ),
          GoRoute(
            path: AppRoutes.combinedNetWorth,
            builder: (_, _) => const Scaffold(body: Text('Combined view')),
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        MaterialApp.router(theme: AppTheme.light(), routerConfig: router),
      );
      await tester.tap(find.text('Personal'));
      await tester.pumpAndSettle();
      expect(find.text('Business'), findsOneWidget);
      await tester.tap(find.text('Both · combined net worth'));
      await tester.pumpAndSettle();
      expect(find.text('Combined view'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'scroll-under navigation preserves access to the last content action',
    (tester) async {
      var tapped = false;
      final scroll = ScrollController();
      addTearDown(scroll.dispose);
      final router = GoRouter(
        initialLocation: '/one',
        routes: [
          StatefulShellRoute.indexedStack(
            builder: (_, _, shell) => MainShell(navigationShell: shell),
            branches: [
              for (final path in ['/one', '/two', '/three', '/four', '/five'])
                StatefulShellBranch(
                  routes: [
                    GoRoute(
                      path: path,
                      builder: (context, _) => Scaffold(
                        body: ListView(
                          controller: path == '/one' ? scroll : null,
                          padding: EdgeInsets.only(
                            bottom: DuitlahDockInsets.of(context) + 16,
                          ),
                          children: [
                            for (var i = 0; i < 30; i++)
                              SizedBox(height: 48, child: Text('Activity $i')),
                            TextButton(
                              onPressed: () => tapped = true,
                              child: const Text('Final action'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        MaterialApp.router(theme: AppTheme.light(), routerConfig: router),
      );
      await tester.pumpAndSettle();
      expect(
        tester
            .widgetList<BackdropFilter>(
              find.descendant(
                of: find.byType(DuitlahBottomNavigation),
                matching: find.byType(BackdropFilter),
              ),
            )
            .any((f) => f.enabled),
        true,
      );
      scroll.jumpTo(scroll.position.maxScrollExtent);
      await tester.pumpAndSettle();
      expect(
        tester.getRect(find.text('Final action')).bottom,
        lessThan(tester.getRect(find.byType(AssistantFab)).top),
      );
      await tester.tap(find.text('Final action'));
      expect(tapped, true);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'shared glass sheets keep their controls usable and return values',
    (tester) async {
      String? result;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () async {
                  result = await showAppBottomSheet<String>(
                    context,
                    builder: (context) => TextButton(
                      onPressed: () => Navigator.pop(context, 'saved'),
                      child: const Text('Save'),
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.byType(DuitlahGlassSheet), findsOneWidget);
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(result, 'saved');
      expect(tester.takeException(), isNull);
    },
  );
}
