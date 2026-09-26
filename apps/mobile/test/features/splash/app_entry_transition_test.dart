import 'dart:async';

import 'package:duitlah_mobile/core/api/api_client.dart';
import 'package:duitlah_mobile/core/api/providers.dart';
import 'package:duitlah_mobile/core/storage/secure_storage.dart';
import 'package:duitlah_mobile/features/auth/data/auth_repository.dart';
import 'package:duitlah_mobile/core/theme/app_theme.dart';
import 'package:duitlah_mobile/features/auth/application/auth_notifier.dart';
import 'package:duitlah_mobile/features/auth/application/auth_state.dart';
import 'package:duitlah_mobile/features/auth/domain/user.dart';
import 'package:duitlah_mobile/features/auth/presentation/login_screen.dart';
import 'package:duitlah_mobile/features/splash/presentation/app_entry_transition.dart';
import 'package:duitlah_mobile/features/splash/widgets/entry_visuals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// Stands in for the real notifier so a login can be held open, resolved or
/// failed on demand. Authentication logic itself is unchanged and covered
/// by the backend's auth tests — these are motion and hand-off tests.
class _FakeAuth extends AuthNotifier {
  _FakeAuth() : super(AuthRepository(ApiClient(SecureStorage()))) {
    state = const AuthState.unauthenticated();
  }
  final pending = Completer<void>();
  @override
  Future<void> bootstrap() async {}
  @override
  Future<void> login(String email, String password) async {
    await pending.future;
    state = const AuthState.authenticated(
      User(
        id: 'u1',
        email: 'nabil@example.com',
        displayName: 'Nabil Farhan',
        emailVerified: true,
      ),
    );
  }
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await (FontLoader('Plus Jakarta Sans')..addFont(
          rootBundle.load('assets/fonts/PlusJakartaSans-Variable.ttf'),
        ))
        .load();
  });

  // The login screen paints the same settled backdrop, so the live overlay is
  // matched by its own key rather than by the painter type.
  Finder environment() => find.byKey(entryStageKey);
  Finder environmentPaint() => find.descendant(
    of: environment(),
    matching: find.byWidgetPredicate(
      (w) => w is CustomPaint && w.painter is EntryEnvironmentPainter,
    ),
  );
  Finder signal() => find.byType(DuitlahSignal);

  Future<void> shot(WidgetTester t, String name) async {
    if (!const bool.fromEnvironment('RENDER_ENTRY')) return;
    await expectLater(
      find.byKey(const ValueKey('entry')),
      matchesGoldenFile('../../../../../docs/entry-animation/$name.png'),
    );
  }

  Future<void> frames(WidgetTester t, int ms) async {
    for (var elapsed = 0; elapsed < ms; elapsed += 10) {
      await t.pump(const Duration(milliseconds: 10));
    }
    await t.pump();
  }

  Future<void> mount(
    WidgetTester t, {
    double width = 390,
    ThemeMode mode = ThemeMode.light,
    bool reduced = false,
    ValueNotifier<bool>? ready,
    bool authenticated = false,
    Widget? destination,
    double scale = 1,
  }) async {
    t.view.physicalSize = Size(width, 844);
    t.view.devicePixelRatio = 1;
    addTearDown(() {
      t.view.resetPhysicalSize();
      t.view.resetDevicePixelRatio();
    });
    await t.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: mode,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              disableAnimations: reduced,
              textScaler: TextScaler.linear(scale),
              padding: const EdgeInsets.only(top: 44, bottom: 24),
            ),
            child: ValueListenableBuilder<bool>(
              valueListenable: ready ?? ValueNotifier(true),
              builder: (context, isReady, _) => RepaintBoundary(
                key: const ValueKey('entry'),
                child: AppEntryTransition(
                  ready: isReady,
                  authenticated: authenticated,
                  child: child!,
                ),
              ),
            ),
          ),
          home: destination ?? const LoginScreen(),
        ),
      ),
    );
    await t.pump();
  }

  bool interactive(WidgetTester t) => !t
      .widgetList<IgnorePointer>(
        find.ancestor(
          of: find.byType(LoginScreen),
          matching: find.byType(IgnorePointer),
        ),
      )
      .any((w) => w.ignoring);

  for (final width in [320.0, 390.0, 430.0]) {
    for (final mode in [ThemeMode.light, ThemeMode.dark]) {
      testWidgets('cold launch reaches an interactive login at $width $mode', (
        t,
      ) async {
        await mount(t, width: width, mode: mode);
        expect(environment(), findsOneWidget);
        expect(interactive(t), false);

        await frames(t, 250); // The wordmark is the first thing to register.
        expect(find.text('duitlah.'), findsOneWidget);

        await frames(t, 350);
        expect(signal(), findsOneWidget);
        expect(find.text('Getting things ready…'), findsOneWidget);

        await frames(t, 400); // ~1000ms — the welcome state.
        expect(find.text('Welcome to'), findsOneWidget);
        expect(find.text('Your money,\nat ease.'), findsOneWidget);

        await frames(t, 700); // ~1700ms — past the 1600ms target.
        expect(environment(), findsNothing);
        expect(interactive(t), true);
        await t.enterText(
          find.widgetWithText(TextField, 'Email or phone'),
          'nabil@example.com',
        );
        expect(find.text('nabil@example.com'), findsOneWidget);
        expect(t.takeException(), isNull);
      });
    }
  }

  testWidgets('login form is not interactive before the 1.4s brand window', (
    t,
  ) async {
    await mount(t);
    await frames(t, 1300);
    expect(interactive(t), false);
    expect(t.takeException(), isNull);
  });

  testWidgets('slow bootstrap holds on the d. signal and never times out', (
    t,
  ) async {
    final ready = ValueNotifier(false);
    addTearDown(ready.dispose);
    await mount(t, ready: ready);
    await frames(t, 900);
    await t.pump(const Duration(seconds: 4));
    // Parked on the loading stage: no welcome copy, no login.
    expect(signal(), findsOneWidget);
    expect(find.text('Welcome to'), findsNothing);
    expect(interactive(t), false);

    ready.value = true;
    await frames(t, 900);
    expect(environment(), findsNothing);
    expect(interactive(t), true);
    expect(t.takeException(), isNull);
  });

  testWidgets('returning authenticated session skips the introduction', (
    t,
  ) async {
    await mount(
      t,
      authenticated: true,
      destination: const Scaffold(body: Center(child: Text('Home'))),
    );
    await frames(t, 500);
    expect(signal(), findsOneWidget);
    // The marketing sequence never plays for a session that is already up.
    expect(find.text('Welcome to'), findsNothing);
    await frames(t, 500); // ~1000ms, past the short entry's 900ms.
    expect(environment(), findsNothing);
    expect(find.text('Home'), findsOneWidget);
    expect(t.takeException(), isNull);
  });

  testWidgets('login sections unfold in order', (t) async {
    await mount(t);
    await frames(t, 1400);
    double opacityFor(int order) {
      final section = find.byWidgetPredicate(
        (w) => w is EntryLoginSection && w.order == order,
      );
      return t
          .widget<Opacity>(
            find.descendant(of: section, matching: find.byType(Opacity)).first,
          )
          .opacity;
    }

    expect(opacityFor(1), greaterThan(0));
    expect(opacityFor(1), greaterThan(opacityFor(5)));
    await frames(t, 400);
    // Once the entry is over the sections stop wrapping the form at all.
    expect(
      find
          .descendant(
            of: find.byWidgetPredicate(
              (w) => w is EntryLoginSection && w.order == 5,
            ),
            matching: find.byType(Opacity),
          )
          .evaluate(),
      isEmpty,
    );
    expect(interactive(t), true);
    expect(t.takeException(), isNull);
  });

  testWidgets('reduced motion keeps the flow but shortens it', (t) async {
    await mount(t, reduced: true);
    final painter =
        t.widget<CustomPaint>(environmentPaint()).painter!
            as EntryEnvironmentPainter;
    expect(painter.reducedMotion, true);
    await frames(t, 400);
    expect(environment(), findsNothing);
    expect(interactive(t), true);
    expect(t.takeException(), isNull);
  });

  testWidgets('brightness change does not restart the timeline', (t) async {
    t.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(t.platformDispatcher.clearPlatformBrightnessTestValue);
    await mount(t, mode: ThemeMode.system);
    await frames(t, 700);
    expect(signal(), findsOneWidget);
    t.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    await t.pump();
    await frames(t, 300);
    // Still mid-flight rather than replayed from the wordmark.
    expect(find.text('Welcome to'), findsOneWidget);
    await frames(t, 800);
    expect(environment(), findsNothing);
  });

  testWidgets('resume does not replay the entry or clear the form', (t) async {
    await mount(t);
    await frames(t, 1800);
    await t.enterText(
      find.widgetWithText(TextField, 'Email or phone'),
      'saved@example.com',
    );
    t.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    t.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    t.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await t.pump(const Duration(seconds: 5));
    t.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    t.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    t.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await t.pump();
    expect(environment(), findsNothing);
    expect(find.text('saved@example.com'), findsOneWidget);
  });

  testWidgets('rapid disposal and fresh launch leave no active tickers', (
    t,
  ) async {
    for (var i = 0; i < 3; i++) {
      await mount(t);
      await t.pump(const Duration(milliseconds: 400));
      await t.pumpWidget(const SizedBox.shrink());
      await t.pump();
      expect(t.takeException(), isNull);
    }
    await mount(t);
    await frames(t, 1800);
    expect(environment(), findsNothing);
  });

  testWidgets('large accessibility text still fits the entry stages', (
    t,
  ) async {
    await mount(t, width: 320, scale: 1.8);
    await frames(t, 1000);
    expect(t.takeException(), isNull);
    await frames(t, 800);
    expect(environment(), findsNothing);
    expect(t.takeException(), isNull);
  });

  // Static review frames for the entry sequence. The environment is navy in
  // both app themes, so one pass covers the whole flow.
  testWidgets('review entry frames', (t) async {
    await mount(t);
    var elapsed = 0;
    for (final time in [0, 200, 400, 700, 1000, 1200, 1400, 1700]) {
      await frames(t, time - elapsed);
      elapsed = time;
      if (const bool.fromEnvironment('RENDER_ENTRY')) {
        await expectLater(
          find.byKey(const ValueKey('entry')),
          matchesGoldenFile(
            '../../../../../docs/entry-animation/entry-$time.png',
          ),
        );
      }
      expect(t.takeException(), isNull);
    }
    expect(environment(), findsNothing);
  });

  group('sign-in hand-off', () {
    Future<_FakeAuth> mountFlow(WidgetTester t) async {
      final auth = _FakeAuth();
      final router = GoRouter(
        initialLocation: '/login',
        routes: [
          GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
          GoRoute(
            path: '/home',
            builder: (_, _) =>
                const Scaffold(body: Center(child: Text('Home'))),
          ),
        ],
      );
      addTearDown(router.dispose);
      t.view.physicalSize = const Size(390, 844);
      t.view.devicePixelRatio = 1;
      addTearDown(() {
        t.view.resetPhysicalSize();
        t.view.resetDevicePixelRatio();
      });
      await t.pumpWidget(
        ProviderScope(
          overrides: [authProvider.overrideWith((_) => auth)],
          child: MaterialApp.router(
            theme: AppTheme.light(),
            routerConfig: router,
            builder: (context, child) => RepaintBoundary(
              key: const ValueKey('entry'),
              child: AppEntryTransition(ready: true, child: child!),
            ),
          ),
        ),
      );
      await t.pump();
      await frames(t, 1800);
      return auth;
    }

    testWidgets('success plays d. signal, welcome back, then Home', (t) async {
      final auth = await mountFlow(t);
      await t.enterText(
        find.widgetWithText(TextField, 'Email or phone'),
        'nabil@example.com',
      );
      await t.enterText(find.widgetWithText(TextField, 'Password'), 'secret');
      await t.tap(find.byType(EntrySignInButton));
      await frames(t, 300);
      // The navy layer leads the request so the redirect never hard-cuts.
      expect(environment(), findsOneWidget);
      expect(find.text('Signing you in…'), findsOneWidget);
      await shot(t, 'signin-wait');

      auth.pending.complete();
      await frames(t, 450);
      expect(find.text('Welcome back, Nabil.'), findsOneWidget);
      await shot(t, 'signin-welcome');
      await frames(t, 120);
      await shot(t, 'signin-lift');
      await frames(t, 400);
      expect(environment(), findsNothing);
      expect(find.text('Home'), findsOneWidget);
      expect(t.takeException(), isNull);
    });

    testWidgets('failure lowers the environment and shows the error in place', (
      t,
    ) async {
      final auth = await mountFlow(t);
      await t.enterText(
        find.widgetWithText(TextField, 'Email or phone'),
        'nabil@example.com',
      );
      await t.enterText(find.widgetWithText(TextField, 'Password'), 'wrong');
      await t.tap(find.byType(EntrySignInButton));
      await frames(t, 200);
      auth.pending.completeError(Exception('Offline'));
      await frames(t, 500);
      expect(environment(), findsNothing);
      expect(find.text('Something went wrong.'), findsOneWidget);
      expect(find.text('nabil@example.com'), findsOneWidget);
      expect(t.takeException(), isNull);
    });
  });
}
