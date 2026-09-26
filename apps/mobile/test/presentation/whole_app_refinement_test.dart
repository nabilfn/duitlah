import 'package:duitlah_mobile/core/widgets/editorial_surfaces.dart';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duitlah_mobile/core/api/api_client.dart';
import 'package:duitlah_mobile/core/api/providers.dart';
import 'package:duitlah_mobile/core/auth/biometric_lock_service.dart';
import 'package:duitlah_mobile/core/storage/secure_storage.dart';
import 'package:duitlah_mobile/core/theme/app_theme.dart';
import 'package:duitlah_mobile/features/auth/application/auth_notifier.dart';
import 'package:duitlah_mobile/features/auth/application/auth_state.dart';
import 'package:duitlah_mobile/features/auth/data/auth_repository.dart';
import 'package:duitlah_mobile/features/auth/domain/user.dart';

import 'whole_app_fixtures.dart';
import 'whole_app_screens.dart';

class _Auth extends AuthNotifier {
  _Auth() : super(AuthRepository(ApiClient(SecureStorage()))) {
    state = const AuthState.authenticated(
      User(
        id: 'fixture',
        email: 'nabil@example.com',
        displayName: 'Nabil Farhan',
        emailVerified: true,
      ),
    );
  }
}

class _Biometric extends BiometricLockService {
  _Biometric() : super(SecureStorage());
  @override
  Future<bool> isDeviceSupported() async => false;
  @override
  Future<bool> isEnabled() async => false;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final font = FontLoader('Plus Jakarta Sans')
      ..addFont(rootBundle.load('assets/fonts/PlusJakartaSans-Variable.ttf'));
    await font.load();
  });
  for (final scenario in [
    (name: 'compact', width: 320.0, scale: 1.3, dark: false, failed: false),
    (name: 'dark', width: 390.0, scale: 1.0, dark: true, failed: false),
    (name: 'offline', width: 320.0, scale: 1.3, dark: true, failed: true),
  ]) {
    for (final entry in wholeAppScreens.entries) {
      testWidgets('${entry.key} ${scenario.name}', (tester) async {
        tester.view.physicalSize = Size(scenario.width, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              ...wholeAppOverrides(failed: scenario.failed),
              authProvider.overrideWith((ref) => _Auth()),
              biometricLockServiceProvider.overrideWith((ref) => _Biometric()),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: scenario.dark ? AppTheme.dark() : AppTheme.light(),
              home: MediaQuery(
                data: MediaQueryData(
                  size: Size(scenario.width, 844),
                  textScaler: TextScaler.linear(scenario.scale),
                  padding: const EdgeInsets.only(top: 32, bottom: 24),
                  viewPadding: const EdgeInsets.only(top: 32, bottom: 24),
                  disableAnimations: true,
                ),
                child: RepaintBoundary(
                  key: const ValueKey('screen'),
                  child: entry.key == 'AssistantScreen'
                      ? Scaffold(body: DuitlahGlassSheet(child: entry.value))
                      : entry.value,
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        expect(tester.takeException(), isNull);
        if (const bool.fromEnvironment('RENDER_WHOLE_APP') &&
            !scenario.failed) {
          final dir = Directory('../../docs/whole-app-refinement/previews')
            ..createSync(recursive: true);
          await expectLater(
            find.byKey(const ValueKey('screen')),
            matchesGoldenFile(
              '${dir.absolute.path}/${entry.key}_${scenario.name}.png',
            ),
          );
        }
        // Inspect lower content too, where floating actions and dense rows live.
        final scrollables = find.byType(Scrollable);
        if (scrollables.evaluate().isNotEmpty) {
          final state = tester.state<ScrollableState>(scrollables.first);
          if (state.position.hasContentDimensions &&
              state.position.maxScrollExtent.isFinite) {
            state.position.jumpTo(state.position.maxScrollExtent);
            await tester.pump();
            expect(tester.takeException(), isNull);
          }
        }
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();
      });
    }
  }
}
