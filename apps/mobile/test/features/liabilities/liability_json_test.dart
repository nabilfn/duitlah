import 'package:flutter_test/flutter_test.dart';

import 'package:duitlah_mobile/features/liabilities/domain/liability.dart';

void main() {
  test('Liability.fromJson parses a live backend response', () {
    final json = {
      'id': '9b1c1e3a-7f2a-4e9b-8a1b-2c3d4e5f6a7b',
      'type': 'CAR_LOAN',
      'name': 'Myvi loan',
      'lender': 'Maybank',
      'originalAmount': 30000.00,
      'outstandingPrincipal': 29500.00,
      'interestRatePercent': null,
      'instalmentAmount': null,
      'nextDueDate': null,
      'maturityDate': null,
      'status': 'ACTIVE',
    };

    final liability = Liability.fromJson(json);

    expect(liability.type, LiabilityType.CAR_LOAN);
    expect(liability.originalAmount, '30000.0');
    expect(liability.outstandingPrincipal, '29500.0');
    expect(liability.status, LiabilityStatus.ACTIVE);
  });

  test('CreditCardDetails.fromJson parses a live backend response', () {
    final json = {
      'accountId': '9b1c1e3a-7f2a-4e9b-8a1b-2c3d4e5f6a7b',
      'creditLimit': 5000.00,
      'statementDay': 1,
      'paymentDueDay': 20,
      'minimumPaymentPercent': 5.00,
      'currentOutstanding': 1000.00,
      'availableCredit': 4000.00,
      'utilization': 0.2,
      'statementBalance': 1000.00,
      'minimumPaymentDue': 50.00,
    };

    final details = CreditCardDetails.fromJson(json);

    expect(details.currentOutstanding, '1000.0');
    expect(details.availableCredit, '4000.0');
    expect(details.utilization, '0.2');
  });
}
