import 'package:flutter_test/flutter_test.dart';

import 'package:duitlah_mobile/features/budgets/domain/budget.dart';

void main() {
  test('Budget.fromJson parses a CALENDAR_MONTH response (pre-Phase-3 shape)', () {
    final json = {
      'id': '9b1c1e3a-7f2a-4e9b-8a1b-2c3d4e5f6a7b',
      'categoryId': null,
      'categoryName': 'Overall',
      'periodYear': 2026,
      'periodMonth': 8,
      'cycleType': 'CALENDAR_MONTH',
      'periodStartDate': null,
      'periodEndDate': null,
      'limit': 1000.00,
      'spent': 400.00,
      'remaining': 600.00,
      'status': 'OK',
    };

    final budget = Budget.fromJson(json);

    expect(budget.cycleType, BudgetCycleType.CALENDAR_MONTH);
    expect(budget.periodStartDate, isNull);
  });

  test('Budget.fromJson parses a PAYDAY cycle response with explicit dates', () {
    final json = {
      'id': '9b1c1e3a-7f2a-4e9b-8a1b-2c3d4e5f6a7b',
      'categoryId': null,
      'categoryName': 'Overall',
      'periodYear': 2026,
      'periodMonth': 8,
      'cycleType': 'PAYDAY',
      'periodStartDate': '2026-08-25',
      'periodEndDate': '2026-09-24',
      'limit': 1000.00,
      'spent': 150.00,
      'remaining': 850.00,
      'status': 'OK',
    };

    final budget = Budget.fromJson(json);

    expect(budget.cycleType, BudgetCycleType.PAYDAY);
    expect(budget.periodStartDate, '2026-08-25');
    expect(budget.periodEndDate, '2026-09-24');
  });
}
