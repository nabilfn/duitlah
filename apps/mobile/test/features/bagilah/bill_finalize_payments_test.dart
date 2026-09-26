import 'package:duitlah_mobile/core/api/api_client.dart';
import 'package:duitlah_mobile/core/errors/app_exception.dart';
import 'package:duitlah_mobile/core/storage/secure_storage.dart';
import 'package:duitlah_mobile/core/theme/app_theme.dart';
import 'package:duitlah_mobile/core/widgets/app_button.dart';
import 'package:duitlah_mobile/features/bagilah/application/bagilah_providers.dart';
import 'package:duitlah_mobile/features/bagilah/data/bagilah_repository.dart';
import 'package:duitlah_mobile/features/bagilah/domain/bagilah_enums.dart';
import 'package:duitlah_mobile/features/bagilah/domain/bill.dart';
import 'package:duitlah_mobile/features/bagilah/presentation/bill_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// `BillService.finalizeBill` refuses a draft with no recorded payments
/// (`NO_PAYMENTS_RECORDED`) or with payments that don't add up to the total
/// (`PAYMENTS_DONT_MATCH_TOTAL`). The mobile app had the repository methods
/// but no way to reach them, so finalize always dead-ended. These cover the
/// capture path, not the split maths — that stays entirely in the backend.
class _FakeRepository extends BagilahRepository {
  _FakeRepository() : super(ApiClient(SecureStorage()));

  final recorded = <String, String>{};
  final removed = <String>[];
  Object? finalizeError;
  int finalizeCalls = 0;

  @override
  Future<List<BillPayment>> getPayments(String billId) async => [
    for (final entry in recorded.entries)
      BillPayment(
        participantId: entry.key,
        displayName: entry.key,
        amountPaid: entry.value,
      ),
  ];

  @override
  Future<void> recordPayment(
    String billId, {
    required String participantId,
    required String amountPaid,
  }) async => recorded[participantId] = amountPaid;

  @override
  Future<void> removePayment(String billId, String participantId) async {
    removed.add(participantId);
    recorded.remove(participantId);
  }

  @override
  Future<Bill> finalizeBill(
    String billId, {
    required String idempotencyKey,
  }) async {
    finalizeCalls++;
    if (finalizeError != null) throw finalizeError!;
    return _bill(BillStatus.FINALIZED);
  }
}

Bill _bill(BillStatus status) => Bill(
  id: 'bill-1',
  ownerUserId: 'owner-1',
  merchant: 'Kopitiam',
  receiptDate: '2026-09-20',
  currency: 'MYR',
  tax: '0.00',
  taxStrategy: AllocationStrategy.PROPORTIONAL,
  serviceCharge: '0.00',
  serviceStrategy: AllocationStrategy.PROPORTIONAL,
  discount: '0.00',
  declaredTotal: '40.00',
  status: status,
);

const _participants = [
  Participant(id: 'p1', displayName: 'Nabil', guest: false),
  Participant(id: 'p2', displayName: 'Aisyah', guest: true),
];

Widget _app(_FakeRepository repository) => ProviderScope(
  overrides: [
    bagilahRepositoryProvider.overrideWithValue(repository),
    billDetailProvider.overrideWith((ref, id) async => _bill(BillStatus.DRAFT)),
    billItemsProvider.overrideWith(
      (ref, id) async => const [
        ReceiptItem(
          id: 'i1',
          name: 'Nasi lemak',
          quantity: '2',
          unitPrice: '20.00',
          itemDiscount: '0.00',
          totalPrice: '40.00',
        ),
      ],
    ),
    billParticipantsProvider.overrideWith((ref, id) async => _participants),
    billBreakdownProvider.overrideWith(
      (ref, id) async => const Breakdown(
        valid: true,
        issues: [],
        subtotal: '40.00',
        computedTotal: '40.00',
        roundingAdjustment: '0.00',
        participants: [
          ParticipantBreakdown(
            participantId: 'p1',
            displayName: 'Nabil',
            subtotal: '20.00',
            taxShare: '0.00',
            serviceShare: '0.00',
            discountShare: '0.00',
            roundingShare: '0.00',
            finalAmount: '20.00',
          ),
          ParticipantBreakdown(
            participantId: 'p2',
            displayName: 'Aisyah',
            subtotal: '20.00',
            taxShare: '0.00',
            serviceShare: '0.00',
            discountShare: '0.00',
            roundingShare: '0.00',
            finalAmount: '20.00',
          ),
        ],
      ),
    ),
    billBalancesProvider.overrideWith((ref, id) async => const <BillBalance>[]),
    billPaymentsProvider.overrideWith(
      (ref, id) => ref.watch(bagilahRepositoryProvider).getPayments(id),
    ),
  ],
  // Skeleton loaders shimmer on a repeating controller, which never lets
  // pumpAndSettle finish; disabling animations parks them.
  child: MaterialApp(
    theme: AppTheme.light(),
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(disableAnimations: true),
      child: child!,
    ),
    home: const BillDetailScreen(billId: 'bill-1'),
  ),
);

void main() {
  /// Bounded pumps rather than pumpAndSettle: the page's skeleton loaders
  /// shimmer on a repeating controller, so the tree never reaches a quiet
  /// frame while one is on screen.
  Future<void> settle(WidgetTester t) async {
    for (var i = 0; i < 40; i++) {
      await t.pump(const Duration(milliseconds: 32));
    }
  }

  PrimaryButton finalizeButton(WidgetTester t) => t.widget<PrimaryButton>(
    find.widgetWithText(PrimaryButton, 'Finalize bill'),
  );

  /// The page builds lazily, so give it a surface tall enough to reach the
  /// payment section and the finalize action in one pass.
  Future<void> open(WidgetTester t, _FakeRepository repository) async {
    t.view.physicalSize = const Size(390, 2600);
    t.view.devicePixelRatio = 1;
    addTearDown(() {
      t.view.resetPhysicalSize();
      t.view.resetDevicePixelRatio();
    });
    await t.pumpWidget(_app(repository));
    await settle(t);
  }

  testWidgets('a fully claimed draft cannot be finalized until a payment is '
      'recorded', (t) async {
    final repository = _FakeRepository();
    await open(t, repository);

    expect(find.text('Who paid'), findsOneWidget);
    expect(find.text('Nothing recorded'), findsNWidgets(2));
    // The split is valid, so only the missing payments hold finalize back.
    expect(finalizeButton(t).onPressed, isNull);
    expect(repository.finalizeCalls, 0);
  });

  testWidgets(
    'recording a payment reaches the repository and unlocks finalize',
    (t) async {
      final repository = _FakeRepository();
      await open(t, repository);

      await t.tap(find.text('Nabil').last);
      await settle(t);
      expect(find.text('What did Nabil pay?'), findsOneWidget);
      await t.enterText(find.byType(TextField).last, '40.00');
      await t.tap(find.widgetWithText(PrimaryButton, 'Save payment'));
      await settle(t);

      expect(repository.recorded, {'p1': '40.00'});
      expect(find.text('Paid RM 40.00'), findsOneWidget);
      expect(finalizeButton(t).onPressed, isNotNull);
    },
  );

  testWidgets('a backend payment mismatch stays on screen instead of a toast', (
    t,
  ) async {
    final repository = _FakeRepository()
      ..recorded['p1'] = '10.00'
      ..finalizeError = const AppException(
        statusCode: 400,
        code: 'PAYMENTS_DONT_MATCH_TOTAL',
        message:
            'Recorded payments (10.00) must add up to the bill total (40.00).',
      );
    await open(t, repository);

    await t.tap(find.widgetWithText(PrimaryButton, 'Finalize bill'));
    await settle(t);
    await t.tap(find.text('Finalize'));
    await settle(t);

    expect(repository.finalizeCalls, 1);
    // Both figures the owner needs while correcting the amounts stay visible.
    expect(
      find.text(
        'Recorded payments (10.00) must add up to the bill total (40.00).',
      ),
      findsOneWidget,
    );
  });

  testWidgets('an existing payment can be corrected or removed', (t) async {
    final repository = _FakeRepository()..recorded['p2'] = '15.00';
    await open(t, repository);

    expect(find.text('Paid RM 15.00'), findsOneWidget);
    await t.tap(find.text('Aisyah').last);
    await settle(t);
    await t.tap(find.text('Remove this payment'));
    await settle(t);

    expect(repository.removed, ['p2']);
    expect(find.text('Nothing recorded'), findsNWidgets(2));
    expect(finalizeButton(t).onPressed, isNull);
  });
}
