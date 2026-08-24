import 'package:flutter_test/flutter_test.dart';

import 'package:duitlah_mobile/features/bills/domain/personal_bill.dart';

void main() {
  test('PersonalBill.fromJson parses a live backend response', () {
    final json = {
      'id': '9b1c1e3a-7f2a-4e9b-8a1b-2c3d4e5f6a7b',
      'name': 'Astro',
      'provider': 'Astro Malaysia',
      'dueDate': '2026-09-15',
      'expectedAmount': 99.90,
      'recurrence': 'MONTHLY',
      'status': 'UPCOMING',
      'linkedTransactionId': null,
      'receiptId': null,
      'notes': null,
    };

    final bill = PersonalBill.fromJson(json);

    expect(bill.name, 'Astro');
    expect(bill.expectedAmount, '99.9');
    expect(bill.recurrence, BillRecurrence.MONTHLY);
    expect(bill.status, BillStatus.UPCOMING);
    expect(bill.linkedTransactionId, isNull);
  });
}
