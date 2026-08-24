import 'package:flutter_test/flutter_test.dart';

import 'package:duitlah_mobile/features/recurring/domain/recurring_transaction.dart';

void main() {
  test('RecurringTransaction.fromJson parses a live backend response', () {
    // Captured from `POST /api/v1/recurring-transactions` against a live
    // docker-compose backend.
    final json = {
      'id': 'df2fab81-1641-477b-8631-b4fa89121f83',
      'accountId': 'f38cd2df-68df-4f0c-9297-7e38c999cb0a',
      'type': 'EXPENSE',
      'direction': 'OUT',
      'categoryId': null,
      'amount': 54.90,
      'merchant': 'Netflix',
      'description': null,
      'notes': null,
      'frequency': 'MONTHLY',
      'intervalCount': 1,
      'startDate': '2026-08-01',
      'endDate': null,
      'nextOccurrenceDate': '2026-08-01',
      'isSubscription': true,
      'active': true,
    };

    final rule = RecurringTransaction.fromJson(json);

    expect(rule.merchant, 'Netflix');
    expect(rule.amount, '54.9');
    expect(rule.frequency, RecurrenceFrequency.MONTHLY);
    expect(rule.isSubscription, isTrue);
    expect(rule.active, isTrue);
  });

  test('SubscriptionsSummary.fromJson parses a live backend response', () {
    // Captured from `GET /api/v1/recurring-transactions/subscriptions/summary`.
    final json = {
      'estimatedMonthlyTotal': 54.90,
      'subscriptions': [
        {
          'id': 'df2fab81-1641-477b-8631-b4fa89121f83',
          'accountId': 'f38cd2df-68df-4f0c-9297-7e38c999cb0a',
          'type': 'EXPENSE',
          'direction': 'OUT',
          'categoryId': null,
          'amount': 54.90,
          'merchant': 'Netflix',
          'description': null,
          'notes': null,
          'frequency': 'MONTHLY',
          'intervalCount': 1,
          'startDate': '2026-08-01',
          'endDate': null,
          'nextOccurrenceDate': '2026-08-01',
          'isSubscription': true,
          'active': true,
        },
      ],
    };

    final summary = SubscriptionsSummary.fromJson(json);

    expect(summary.estimatedMonthlyTotal, '54.9');
    expect(summary.subscriptions, hasLength(1));
    expect(summary.subscriptions.single.merchant, 'Netflix');
  });
}
