import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duitlah_mobile/core/api/api_client.dart';
import 'package:duitlah_mobile/core/api/providers.dart';
import 'package:duitlah_mobile/core/auth/biometric_lock_service.dart';
import 'package:duitlah_mobile/core/storage/secure_storage.dart';
import 'package:duitlah_mobile/core/routing/main_shell.dart';
import 'package:duitlah_mobile/core/widgets/dock_insets.dart';
import 'package:duitlah_mobile/core/routing/app_router.dart';
import 'package:duitlah_mobile/core/routing/app_routes.dart';
import 'package:duitlah_mobile/features/accounts/data/finance_repository.dart';
import 'package:duitlah_mobile/core/theme/app_theme.dart';
import 'package:duitlah_mobile/features/accounts/application/finance_providers.dart';
import 'package:duitlah_mobile/features/accounts/domain/finance.dart';
import 'package:duitlah_mobile/features/auth/application/auth_notifier.dart';
import 'package:duitlah_mobile/features/auth/application/auth_state.dart';
import 'package:duitlah_mobile/features/auth/data/auth_repository.dart';
import 'package:duitlah_mobile/features/auth/domain/user.dart';
import 'package:duitlah_mobile/features/home/presentation/home_screen.dart';
import 'package:duitlah_mobile/features/auth/presentation/login_screen.dart';
import 'package:duitlah_mobile/features/budgets/application/budgets_providers.dart';
import 'package:duitlah_mobile/features/budgets/domain/budget.dart';
import 'package:duitlah_mobile/features/transactions/presentation/transactions_screen.dart';
import 'package:duitlah_mobile/features/transactions/presentation/transaction_form_sheet.dart';
import 'package:duitlah_mobile/features/bagilah/presentation/bills_list_screen.dart';
import 'package:duitlah_mobile/features/bagilah/application/bagilah_providers.dart';
import 'package:duitlah_mobile/features/bagilah/domain/bill.dart';
import 'package:duitlah_mobile/features/bagilah/domain/bagilah_enums.dart';
import 'package:duitlah_mobile/features/insights/presentation/insights_screen.dart';
import 'package:duitlah_mobile/features/insights/application/insights_providers.dart';
import 'package:duitlah_mobile/features/insights/domain/insights.dart';
import 'package:duitlah_mobile/features/networth/application/net_worth_providers.dart';
import 'package:duitlah_mobile/features/networth/domain/net_worth.dart';
import 'package:duitlah_mobile/features/profile/presentation/profile_screen.dart';
import 'package:duitlah_mobile/features/settlements/application/settlements_providers.dart';
import 'package:duitlah_mobile/features/settlements/domain/settlement.dart';
import 'package:duitlah_mobile/features/wrapped/application/wrapped_providers.dart';
import 'package:duitlah_mobile/features/wrapped/domain/wrapped.dart';

// Fixtures are confined to tests. Production screens continue to read their repositories.
class _Auth extends AuthNotifier {
  _Auth() : super(AuthRepository(ApiClient(SecureStorage()))) {
    state = const AuthState.authenticated(
      User(
        id: 'u',
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
  Future<bool> isDeviceSupported() async => true;
  @override
  Future<bool> isEnabled() async => false;
}

final _transactions = [
  const Transaction(
    id: '1',
    accountId: 'a',
    type: TransactionType.EXPENSE,
    direction: TransactionDirection.OUT,
    amount: '12.50',
    merchant: 'ZUS Coffee',
    occurredOn: '2026-09-08',
  ),
  const Transaction(
    id: '2',
    accountId: 'a',
    type: TransactionType.EXPENSE,
    direction: TransactionDirection.OUT,
    amount: '18.20',
    merchant: 'Grab',
    occurredOn: '2026-09-08',
  ),
  const Transaction(
    id: '3',
    accountId: 'a',
    type: TransactionType.INCOME,
    direction: TransactionDirection.IN,
    amount: '6200',
    merchant: 'Salary',
    occurredOn: '2026-09-08',
  ),
  const Transaction(
    id: '4',
    accountId: 'a',
    type: TransactionType.EXPENSE,
    direction: TransactionDirection.OUT,
    amount: '134.20',
    merchant: 'Jaya Grocer',
    occurredOn: '2026-09-07',
  ),
  const Transaction(
    id: '5',
    accountId: 'a',
    type: TransactionType.EXPENSE,
    direction: TransactionDirection.OUT,
    amount: '15.90',
    merchant: 'Spotify',
    occurredOn: '2026-09-07',
  ),
];
final _accounts = [
  const Account(
    id: 'a',
    name: 'Maybank',
    type: AccountType.BANK,
    currency: 'MYR',
    openingBalance: '0',
    balance: '4850.75',
    archived: false,
  ),
  const Account(
    id: 'b',
    name: 'Savings',
    type: AccountType.SAVINGS,
    currency: 'MYR',
    openingBalance: '0',
    balance: '100',
    archived: false,
  ),
];
List<Override> _overrides() => [
  authProvider.overrideWith((ref) => _Auth()),
  biometricLockServiceProvider.overrideWith((ref) => _Biometric()),
  dashboardProvider.overrideWith(
    (ref) async => DashboardSummary(
      availableBalance: '4850.75',
      monthIncome: '6200',
      monthExpense: '3420.75',
      recentTransactions: _transactions,
    ),
  ),
  homeSpendingProvider.overrideWith((ref) async => const [CategorySpending(categoryId: 'food', categoryName: 'Food', amount: '430')]),
  budgetListProvider.overrideWith((ref) async => [Budget(id: 'b', categoryName: 'Food', periodYear: DateTime.now().year, periodMonth: DateTime.now().month, cycleType: BudgetCycleType.CALENDAR_MONTH, limit: '3000', spent: '1840', remaining: '1160', status: BudgetStatus.OK)]),
  accountListProvider.overrideWith((ref) async => _accounts),
  categoryListProvider.overrideWith(
    (ref) async => [
      const Category(
        id: 'food',
        type: CategoryType.EXPENSE,
        name: 'Food & Beverages',
        custom: false,
      ),
    ],
  ),
  transactionsProvider.overrideWith(
    (ref) async => TransactionPage(
      content: _transactions,
      totalElements: 5,
      totalPages: 1,
      number: 0,
      size: 20,
    ),
  ),
  settlementSummaryProvider.overrideWith(
    (ref) async => const SettlementSummary(
      totalOwedToMe: '320',
      totalIOwe: '86.50',
      owedToMe: [
        CounterpartySummary(userId: 'a', displayName: 'Aisyah', netAmount: '200', oldestUnpaidDays: 1),
        CounterpartySummary(userId: 'c', displayName: 'Daniel', netAmount: '120', oldestUnpaidDays: 2),
      ],
      iOwe: [
        CounterpartySummary(userId: 'b', displayName: 'Hana', netAmount: '-60', oldestUnpaidDays: 1),
        CounterpartySummary(userId: 'd', displayName: 'Farid', netAmount: '-26.50', oldestUnpaidDays: 3),
      ],
    ),
  ),
  billListProvider.overrideWith(
    (ref) async => [
      for (var i = 0; i < 4; i++)
        Bill(
          id: '$i',
          ownerUserId: 'u',
          merchant: ['Dinner', 'Trip', 'House', 'Events'][i],
          receiptDate: '2026-09-08',
          currency: 'MYR',
          tax: '0',
          taxStrategy: AllocationStrategy.PROPORTIONAL,
          serviceCharge: '0',
          serviceStrategy: AllocationStrategy.PROPORTIONAL,
          discount: '0',
          total: ['86.50', '1240', '320', '250'][i],
          status: BillStatus.DRAFT,
        ),
    ],
  ),
  billParticipantsProvider.overrideWith(
    (ref, id) async => [
      for (var i = 0; i < 4; i++)
        Participant(
          id: '$i',
          displayName: ['Nabil', 'Aisyah', 'Daniel', 'Hana'][i],
          guest: false,
        ),
    ],
  ),
  selectedInsightsMonthProvider.overrideWith((ref) => DateTime(2026, 8)),
  spendingByCategoryProvider.overrideWith(
    (ref) async => [
      for (var i = 0; i < 6; i++)
        CategorySpending(
          categoryId: '$i',
          categoryName: [
            'Food & Beverages',
            'Transport',
            'Shopping',
            'Bills & Utilities',
            'Health',
            'Others',
          ][i],
          amount: ['1197', '684', '513', '410', '273', '343.75'][i],
        ),
    ],
  ),
  monthlyTrendProvider.overrideWith(
    (ref) async => [
      for (var i = 3; i < 9; i++)
        MonthlyTrend(
          year: 2026,
          month: i,
          income: '6200',
          expense: '3420.75',
          savings: '2779.25',
        ),
    ],
  ),
  topMerchantsProvider.overrideWith((ref) async => []),
  forecastProvider.overrideWith(
    (ref) async => const Forecast(
      currentBalance: '4850.75',
      asOfDate: '2026-09-08',
      targetDate: '2026-09-30',
      scheduledIncome: '0',
      scheduledExpense: '240',
      predictedVariableExpense: '500',
      projectedBalance: '4110.75',
      disclaimer:
          'An estimate based on your scheduled transactions, not a guarantee.',
    ),
  ),
  netWorthProvider.overrideWith(
    (ref) async => const NetWorth(
      totalAssets: '12000',
      totalLiabilities: '2000',
      netWorth: '10000',
      assetsBreakdown: [],
      liabilitiesBreakdown: [],
    ),
  ),
  wrappedPromoProvider.overrideWith(
    (ref) async => const WrappedPromo(available: true, year: 2026, month: 8, personaName: 'Cafe Hunter'),
  ),
  wrappedHistoryProvider.overrideWith(
    (ref) async => const [
      WrappedHistoryItem(year: 2026, month: 8, personaId: 'CAFE_HUNTER', personaName: 'Cafe Hunter', viewed: false),
      WrappedHistoryItem(year: 2026, month: 7, personaId: null, personaName: null, viewed: true),
    ],
  ),
];

class _RecordingFinance extends FinanceRepository {
  _RecordingFinance() : super(ApiClient(SecureStorage()));
  int writes = 0;
  String? from, to, amount, key;
  TransactionType? type;
  @override
  Future<Transaction> createTransaction({
    required String accountId,
    required TransactionType type,
    String? categoryId,
    required String amount,
    String? merchant,
    String? description,
    String? notes,
    required String occurredOn,
    required String idempotencyKey,
  }) async {
    writes++;
    from = accountId;
    this.type = type;
    this.amount = amount;
    key = idempotencyKey;
    return _transactions.first;
  }

  @override
  Future<void> transfer({
    required String fromAccountId,
    required String toAccountId,
    required String amount,
    required String occurredOn,
    required String idempotencyKey,
  }) async {
    writes++;
    from = fromAccountId;
    to = toAccountId;
    this.amount = amount;
    key = idempotencyKey;
  }
}

void main() {
  testWidgets('Primary navigation keeps every destination reachable', (
    tester,
  ) async {
    final container = ProviderContainer(overrides: _overrides());
    addTearDown(container.dispose);
    final router = container.read(routerProvider);
    addTearDown(router.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    for (final route in [
      AppRoutes.transactions,
      AppRoutes.insights,
      AppRoutes.bagilah,
      AppRoutes.profile,
      AppRoutes.home,
    ]) {
      router.go(route);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(DuitlahBottomNavigation), findsOneWidget);
    }
  });
  testWidgets('balance visibility hides the canvas amounts and restores them', (tester) async {
    await tester.pumpWidget(ProviderScope(overrides: _overrides(), child: MaterialApp(theme: AppTheme.light(), home: const HomeScreen())));
    await tester.pumpAndSettle();
    final toggle = find.byTooltip('Hide balance');
    await tester.ensureVisible(toggle);
    await tester.tap(toggle);
    await tester.pumpAndSettle();
    expect(find.text('RM •••••'), findsOneWidget);
    expect(find.text('RM 4,850.75'), findsNothing);
    expect(find.text('RM 6,200.00 income this month'), findsNothing);
    await tester.tap(find.byTooltip('Show balance'));
    await tester.pumpAndSettle();
    expect(find.text('RM 4,850.75'), findsOneWidget);
  });

  for (final type in [TransactionType.EXPENSE, TransactionType.TRANSFER]) {
    testWidgets('$type validates and calls the existing repository', (
      tester,
    ) async {
      final repo = _RecordingFinance();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            ..._overrides(),
            financeRepositoryProvider.overrideWith((ref) => repo),
          ],
          child: MaterialApp(
            theme: AppTheme.light(),
            home: Scaffold(
              body: Builder(
                builder: (context) => TextButton(
                  onPressed: () =>
                      showTransactionForm(context, initialType: type),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      final save = find.text(
        type == TransactionType.TRANSFER ? 'Save transfer' : 'Save transaction',
      );
      await tester.ensureVisible(save);
      await tester.tap(save);
      await tester.pumpAndSettle();
      expect(repo.writes, 0);
      await tester.enterText(find.byType(TextFormField).first, '25.00');
      if (type == TransactionType.TRANSFER) {
        final destination = find.byType(DropdownButtonFormField<String>).at(1);
        await tester.ensureVisible(destination);
        await tester.tap(destination);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Savings').last);
        await tester.pumpAndSettle();
      }
      await tester.ensureVisible(save);
      await tester.tap(save);
      await tester.pumpAndSettle();
      expect(repo.writes, 1);
      expect(repo.amount, '25.00');
      expect(repo.from, 'a');
      expect(repo.key, isNotEmpty);
      if (type == TransactionType.TRANSFER) {
        expect(repo.to, 'b');
      } else {
        expect(repo.type, TransactionType.EXPENSE);
      }
      expect(find.text('Open'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  final screens = <String, Widget>{
    'home': const HomeScreen(),
    'transactions': const TransactionsScreen(),
    'bagilah': const BillsListScreen(),
    'analytics': const InsightsScreen(),
    'profile': const ProfileScreen(),
    'add_transaction': const TransactionFormSheet(),
    'login': const LoginScreen(),
  };
  for (final scenario in [
    (const Size(390, 844), false),
    (const Size(320, 740), false),
    (const Size(390, 844), true),
  ]) {
    final size = scenario.$1;
    final dark = scenario.$2;
    for (final entry in screens.entries) {
      testWidgets('${entry.key} fits ${size.width}, dark=$dark', (
        tester,
      ) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final font = FontLoader('Plus Jakarta Sans')
          ..addFont(
            rootBundle.load('assets/fonts/PlusJakartaSans-Variable.ttf'),
          );
        await font.load();
        await tester.pumpWidget(
          ProviderScope(
            overrides: _overrides(),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: dark ? AppTheme.dark() : AppTheme.light(),
              home: MediaQuery(
                data: MediaQueryData(
                  size: size,
                  viewInsets: EdgeInsets.only(
                    bottom: size.width == 320 && entry.key == "add_transaction"
                        ? 260
                        : 0,
                  ),
                  padding: const EdgeInsets.only(top: 32, bottom: 20),
                  textScaler: TextScaler.linear(size.width == 320 ? 1.3 : 1),
                ),
                child: Scaffold(
                  extendBody: entry.key != 'login' && entry.key != 'add_transaction',
                  body: DuitlahDockBody(child: entry.value),
                  bottomNavigationBar: (entry.key == 'add_transaction' || entry.key == 'login')
                      ? null
                      : DuitlahNavigationDock(
                          currentBranch: {
                            'home': 0,
                            'transactions': 1,
                            'analytics': 2,
                            'bagilah': 3,
                            'profile': 4,
                          }[entry.key]!,
                          onSelect: (_) {},
                        ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        const capture = String.fromEnvironment('CAPTURE_LAYOUT');
        if (capture.isNotEmpty && entry.key != 'profile') {
          final geometry = <Map<String, dynamic>>[];
          for (final element in find.byWidgetPredicate((widget) => widget is Text || widget is Card || widget is CustomPaint).evaluate()) {
            final box = element.findRenderObject();
            if (box is! RenderBox || !box.hasSize || !box.attached) continue;
            final widget = element.widget;
            final origin = box.localToGlobal(Offset.zero);
            geometry.add({'widget': widget.runtimeType.toString(), 'text': widget is Text ? widget.data : null,
              'x': origin.dx, 'y': origin.dy, 'width': box.size.width, 'height': box.size.height});
          }
          final file = File('$capture/${entry.key}_${size.width}_$dark.json');
          file.parent.createSync(recursive: true);
          file.writeAsStringSync(jsonEncode(geometry));
        }
        if (const bool.fromEnvironment('RENDER_UI') && size.width == 390) {
          await expectLater(
            find.byType(MaterialApp),
            matchesGoldenFile(
              '${const String.fromEnvironment('UI_PREVIEW_DIR', defaultValue: '../../../../docs/mobile-redesign')}/${entry.key}${dark ? '_dark' : ''}.png',
            ),
          );
        }
        // Exercise lower content too, where long money rows and forecast wraps live.
        final scroll = find.byType(Scrollable).first;
        await tester.drag(scroll, const Offset(0, -500));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
}
