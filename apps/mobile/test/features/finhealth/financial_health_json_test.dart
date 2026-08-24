import 'package:flutter_test/flutter_test.dart';

import 'package:duitlah_mobile/features/finhealth/domain/financial_health.dart';

void main() {
  test('FinancialHealth.fromJson parses a live backend response', () {
    final json = {
      'score': 72.50,
      'components': [
        {
          'key': 'SAVINGS_RATE',
          'label': 'Savings rate',
          'score': 80.00,
          'weight': 20,
          'explanation': 'Saved 20.0% of income over the last 3 months.',
        },
      ],
      'recommendations': ['Build up liquid savings toward 6 months of expenses.'],
    };

    final health = FinancialHealth.fromJson(json);

    expect(health.score, '72.5');
    expect(health.components.single.key, 'SAVINGS_RATE');
    expect(health.components.single.score, '80.0');
    expect(health.recommendations, hasLength(1));
  });
}
