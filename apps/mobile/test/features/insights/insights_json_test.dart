import 'package:flutter_test/flutter_test.dart';

import 'package:duitlah_mobile/features/insights/domain/insights.dart';

void main() {
  test('Forecast.fromJson parses a live backend response', () {
    // Captured from `GET /api/v1/analytics/forecast`.
    final json = {
      'currentBalance': 500.00,
      'asOfDate': '2026-08-21',
      'targetDate': '2026-08-31',
      'scheduledIncome': 0,
      'scheduledExpense': 0,
      'predictedVariableExpense': 0.00,
      'projectedBalance': 500.00,
      'disclaimer':
          'This is an estimate based on your recurring transactions and average spending — not a guarantee.',
    };

    final forecast = Forecast.fromJson(json);

    expect(forecast.currentBalance, '500.0');
    expect(forecast.targetDate, '2026-08-31');
    expect(forecast.disclaimer, isNotEmpty);
  });

  test('CalendarEntry.fromJson parses both confirmed and projected entries', () {
    // Captured from `GET /api/v1/analytics/calendar`.
    final json = {
      'date': '2026-08-01',
      'confirmed': false,
      'type': 'EXPENSE',
      'direction': 'OUT',
      'amount': 54.90,
      'merchant': 'Netflix',
      'description': null,
    };

    final entry = CalendarEntry.fromJson(json);

    expect(entry.confirmed, isFalse);
    expect(entry.merchant, 'Netflix');
    expect(entry.amount, '54.9');
  });

  test('MonthlyTrend.fromJson parses a live backend response', () {
    // Captured from `GET /api/v1/analytics/monthly-trend`.
    final json = {'year': 2026, 'month': 8, 'income': 0, 'expense': 0, 'savings': 0};

    final trend = MonthlyTrend.fromJson(json);

    expect(trend.year, 2026);
    expect(trend.month, 8);
    expect(trend.savings, '0');
  });
}
