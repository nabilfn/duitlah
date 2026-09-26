import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:duitlah_mobile/features/auth/presentation/login_screen.dart';

/// Priority-flow coverage per the Phase 9.5 migration doc's test list:
/// this is UI/state coverage (the form renders and holds input), not a
/// re-test of login's business rules — those live in the backend's own
/// auth integration tests (docs/security.md).
void main() {
  testWidgets('LoginScreen renders email/password fields and a sign-in action', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: LoginScreen()),
      ),
    );

    expect(find.text('Hi again.'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Email or phone'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.widgetWithText(EntrySignInButton, 'Sign in'), findsOneWidget);
  });

  testWidgets('LoginScreen accepts typed email and password', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: LoginScreen()),
      ),
    );

    await tester.enterText(find.widgetWithText(TextField, 'Email or phone'), 'ameer@example.com');
    await tester.enterText(find.widgetWithText(TextField, 'Password'), 'hunter2');
    await tester.pump();

    expect(find.text('ameer@example.com'), findsOneWidget);
  });
}
