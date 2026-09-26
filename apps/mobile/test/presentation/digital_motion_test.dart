import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:duitlah_mobile/core/api/api_client.dart';
import 'package:duitlah_mobile/core/api/providers.dart';
import 'package:duitlah_mobile/core/storage/secure_storage.dart';
import 'package:duitlah_mobile/core/theme/app_theme.dart';
import 'package:duitlah_mobile/core/widgets/transaction_row.dart';
import 'package:duitlah_mobile/core/widgets/digital_canvas.dart';
import 'package:duitlah_mobile/features/accounts/domain/finance.dart';
import 'package:duitlah_mobile/features/auth/application/auth_notifier.dart';
import 'package:duitlah_mobile/features/auth/application/auth_state.dart';
import 'package:duitlah_mobile/features/auth/data/auth_repository.dart';
import 'package:duitlah_mobile/features/auth/presentation/login_screen.dart';
import 'package:duitlah_mobile/features/bagilah/presentation/shared_money_composition.dart';
import 'package:duitlah_mobile/features/settlements/application/settlements_providers.dart';
import 'package:duitlah_mobile/features/settlements/domain/settlement.dart';

class _PendingAuth extends AuthNotifier {
  _PendingAuth() : super(AuthRepository(ApiClient(SecureStorage()))) {
    state = const AuthState.unauthenticated();
  }
  int calls = 0;
  final pending = Completer<void>();
  @override
  Future<void> login(String email, String password) {
    calls++;
    return pending.future;
  }
}

void main() {
  testWidgets(
    'login preserves credentials and rejects duplicate submits while pending',
    (tester) async {
      final auth = _PendingAuth();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [authProvider.overrideWith((_) => auth)],
          child: MaterialApp(
            theme: AppTheme.light(),
            home: const LoginScreen(),
          ),
        ),
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Email or phone'),
        'person@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Password'),
        'correct password',
      );
      final password = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Password'),
      );
      password.onSubmitted!('correct password');
      password.onSubmitted!('correct password');
      await tester.pump();
      expect(auth.calls, 1);
      expect(
        tester.widget<EntrySignInButton>(find.byType(EntrySignInButton)).loading,
        true,
      );
      auth.pending.completeError(Exception('Offline'));
      await tester.pumpAndSettle();
      expect(find.text('Something went wrong.'), findsOneWidget);
      expect(find.text('person@example.com'), findsOneWidget);
      expect(
        tester
            .widget<TextField>(find.widgetWithText(TextField, 'Password'))
            .controller!
            .text,
        'correct password',
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'login stays usable with a keyboard and large text on a narrow phone',
    (tester) async {
      tester.view.physicalSize = const Size(320, 740);
      tester.view.devicePixelRatio = 1;
      tester.view.viewInsets = const FakeViewPadding(bottom: 260);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetViewInsets);
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.dark(),
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.8)),
              child: child!,
            ),
            home: const LoginScreen(),
          ),
        ),
      );
      await tester.ensureVisible(find.widgetWithText(TextField, 'Password'));
      await tester.enterText(
        find.widgetWithText(TextField, 'Password'),
        'kept private',
      );
      await tester.ensureVisible(find.byType(EntrySignInButton));
      await tester.pumpAndSettle();
      expect(
        tester.getRect(find.byType(EntrySignInButton)).bottom,
        lessThanOrEqualTo(480),
      );
      expect(tester.takeException(), isNull);
    },
  );

  for (final reduced in [false, true]) {
    testWidgets(
      'participant selection reveals only related expenses, reduced=$reduced',
      (tester) async {
        final router = GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
              path: '/',
              builder: (_, _) => const Scaffold(
                body: SingleChildScrollView(child: SharedMoneyComposition()),
              ),
            ),
            GoRoute(
              path: '/settlements',
              builder: (_, state) => Scaffold(
                body: Text('Person ${state.uri.queryParameters['person']}'),
              ),
            ),
          ],
        );
        addTearDown(router.dispose);
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              settlementSummaryProvider.overrideWith(
                (_) async => const SettlementSummary(
                  totalOwedToMe: '20',
                  totalIOwe: '0',
                  owedToMe: [
                    CounterpartySummary(
                      userId: 'alice',
                      displayName: 'Alice',
                      netAmount: '20',
                      oldestUnpaidDays: 1,
                    ),
                  ],
                  iOwe: [],
                ),
              ),
              settlementListProvider.overrideWith(
                (_) async => [
                  for (final id in ['alice', 'bob'])
                    Settlement(
                      id: id,
                      fromUserId: id,
                      fromDisplayName: id == 'alice' ? 'Alice' : 'Bob',
                      toUserId: 'me',
                      toDisplayName: 'You',
                      amount: '20',
                      amountPaid: '0',
                      amountRemaining: '20',
                      status: SettlementStatus.UNPAID,
                      sourceType: SourceType.BILL,
                      sourceId: id,
                      createdAt: '2026-09-20',
                      handoff: const PaymentHandoffLink(
                        provider: 'manual',
                        instructions: 'Record payment',
                      ),
                    ),
                ],
              ),
            ],
            child: MaterialApp.router(
              theme: AppTheme.light(),
              routerConfig: router,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(disableAnimations: reduced),
                child: child!,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('Alice'));
        await tester.pumpAndSettle();
        expect(find.text('Alice → You'), findsOneWidget);
        expect(find.text('Bob → You'), findsNothing);
        final settle = find.text('Review & settle ↗');
        await tester.ensureVisible(settle);
        await tester.tap(settle);
        await tester.pumpAndSettle();
        expect(find.text('Person alice'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
  testWidgets('transaction details expand without changing the amount', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(
          body: TransactionRow(
            transaction: Transaction(
              id: 't',
              accountId: 'a',
              type: TransactionType.EXPENSE,
              direction: TransactionDirection.OUT,
              amount: '82.40',
              merchant: 'Village Grocer',
              notes: 'Shared groceries',
              occurredOn: '2026-09-20',
            ),
          ),
        ),
      ),
    );
    expect(find.text('Shared groceries'), findsNothing);
    await tester.tap(find.text('Village Grocer'));
    await tester.pumpAndSettle();
    expect(find.text('Shared groceries'), findsOneWidget);
    expect(find.text('− RM 82.40'), findsOneWidget);
    await tester.tap(find.text('Village Grocer'));
    await tester.pumpAndSettle();
    expect(find.text('Shared groceries'), findsNothing);
  });
  testWidgets('trajectory and reveal finish immediately under reduced motion', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: const Scaffold(
            body: DuitlahReveal(
              child: DuitlahTrajectory(progress: .61, label: '61 percent'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.binding.hasScheduledFrame, false);
    final animations = tester.widgetList<TweenAnimationBuilder<double>>(
      find.byType(TweenAnimationBuilder<double>),
    );
    expect(animations.every((a) => a.duration == Duration.zero), true);
  });
}
