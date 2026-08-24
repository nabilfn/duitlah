import 'package:flutter_test/flutter_test.dart';

import 'package:duitlah_mobile/features/bagilah/domain/bagilah_enums.dart';
import 'package:duitlah_mobile/features/bagilah/domain/bill.dart';

void main() {
  test(
    'Bill.fromJson parses a real backend response where BigDecimal fields '
    'are bare JSON numbers, not quoted strings',
    () {
      // Captured directly from `GET /api/v1/bills` against a live
      // docker-compose backend — Jackson serializes BigDecimal as a plain
      // JSON number (`"tax":0.0`), not `"tax":"0.0"`. A naive `as String`
      // cast on this shape throws; AmountConverter/NullableAmountConverter
      // normalize either shape to a Dart String, since every amount here
      // is display-only (docs/bagilah-engine.md) and never used for
      // arithmetic client-side.
      final json = {
        'id': 'b2f096f4-1a92-4975-98a1-185632b61071',
        'ownerUserId': 'fa88446f-43e6-49a0-9cd3-ce723dfe0a5e',
        'groupId': null,
        'merchant': 'Test Cafe',
        'receiptDate': '2026-08-20',
        'currency': 'MYR',
        'tax': 0.0,
        'taxStrategy': 'PROPORTIONAL',
        'serviceCharge': 0.0,
        'serviceStrategy': 'PROPORTIONAL',
        'discount': 0.0,
        'discountLabel': null,
        'declaredTotal': null,
        'total': null,
        'roundingAdjustment': null,
        'status': 'DRAFT',
        'finalizedAt': null,
      };

      final bill = Bill.fromJson(json);

      expect(bill.merchant, 'Test Cafe');
      expect(bill.tax, '0.0');
      expect(bill.serviceCharge, '0.0');
      expect(bill.discount, '0.0');
      expect(bill.declaredTotal, isNull);
      expect(bill.status, BillStatus.DRAFT);
    },
  );

  test('ReceiptItem.fromJson parses numeric quantity/price fields', () {
    // Captured from `POST /api/v1/bills/{id}/items`.
    final json = {
      'id': 'aa317677-75e1-49f5-b9a8-af21d9648e23',
      'name': 'Latte',
      'quantity': 2,
      'unitPrice': 9.90,
      'itemDiscount': 0,
      'totalPrice': 19.80,
    };

    final item = ReceiptItem.fromJson(json);

    expect(item.name, 'Latte');
    expect(item.quantity, '2');
    expect(item.unitPrice, '9.9');
    expect(item.totalPrice, '19.8');
  });

  test('Breakdown.fromJson parses a live /breakdown response', () {
    // Captured from `GET /api/v1/bills/{id}/breakdown`.
    final json = {
      'valid': false,
      'issues': [
        {'itemId': 'aa317677-75e1-49f5-b9a8-af21d9648e23', 'itemName': 'Latte', 'type': 'UNCLAIMED'},
      ],
      'subtotal': 19.80,
      'computedTotal': 19.80,
      'roundingAdjustment': 0.00,
      'participants': [
        {
          'participantId': '5f34b07d-af04-4b57-9bae-5282477ee3a4',
          'displayName': 'Mobile Tester',
          'subtotal': 0.00,
          'taxShare': 0.00,
          'serviceShare': 0.00,
          'discountShare': 0.00,
          'roundingShare': 0.00,
          'finalAmount': 0.00,
        },
      ],
    };

    final breakdown = Breakdown.fromJson(json);

    expect(breakdown.valid, isFalse);
    expect(breakdown.issues.single.type, IssueType.UNCLAIMED);
    expect(breakdown.subtotal, '19.8');
    expect(breakdown.participants.single.displayName, 'Mobile Tester');
  });
}
