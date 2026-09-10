import 'package:flutter_test/flutter_test.dart';

import 'package:duitlah_mobile/features/wrapped/domain/wrapped.dart';

void main() {
  test(
    'WrappedResult.fromJson parses a live backend response (sufficient data)',
    () {
      // Captured from `GET /api/v1/wrapped/{year}/{month}` against a live docker-compose
      // backend, after posting 15 RM30.00 "Cafe" expenses to "ZUS Coffee" across a month.
      final json = {
        'year': 2026,
        'month': 8,
        'version': 1,
        'generatedAt': '2026-09-08T10:15:32.123456Z',
        'sufficientData': true,
        'overview': {
          'year': 2026,
          'month': 8,
          'totalIncome': 0.0,
          'totalExpense': 450.0,
          'netAmount': -450.0,
          'totalSavingsContribution': 0.0,
          'transactionCount': 15,
          'spendingChangePercentage': null,
          'incomeChangePercentage': null,
        },
        'persona': {
          'id': 'CAFE_HUNTER',
          'name': 'Cafe Hunter',
          'tagline': 'You know every barista by name.',
          'visualTheme': 'cafe_hunter',
          'amount': 450.0,
          'percentage': 100,
          'denominatorLabel': 'of your spending',
          'score': 1.0,
          'evidence': [
            '15 transactions at Cafe & Beverages',
            'RM450.00 total this month',
          ],
        },
        'insights': [
          {
            'type': 'FAVOURITE_MERCHANT',
            'title': 'Your favourite spot',
            'primaryValue': 'ZUS Coffee',
            'secondaryValue': 'RM450.00',
            'comparison': null,
          },
          {
            'type': 'TOP_CATEGORY',
            'title': 'Where it went',
            'primaryValue': 'Cafe & Beverages',
            'secondaryValue': '100%',
            'comparison': null,
          },
        ],
        'recommendedGoal': {
          'message': 'Try a no-spend cafe day next week and see how it feels.',
        },
      };

      final result = WrappedResult.fromJson(json);

      expect(result.year, 2026);
      expect(result.month, 8);
      expect(result.sufficientData, isTrue);
      expect(result.overview.totalExpense, '450.0');
      expect(result.overview.spendingChangePercentage, isNull);
      expect(result.persona, isNotNull);
      expect(result.persona!.id, 'CAFE_HUNTER');
      expect(result.persona!.percentage, 100.0);
      expect(result.insights, hasLength(2));
      expect(result.recommendedGoal.message, contains('no-spend'));
    },
  );

  test('WrappedResult.fromJson parses an insufficient-data month with a null persona', () {
    final json = {
      'year': 2026,
      'month': 6,
      'version': 1,
      'generatedAt': '2026-07-01T01:30:00Z',
      'sufficientData': false,
      'overview': {
        'year': 2026,
        'month': 6,
        'totalIncome': 100.0,
        'totalExpense': 20.0,
        'netAmount': 80.0,
        'totalSavingsContribution': 0.0,
        'transactionCount': 2,
        'spendingChangePercentage': null,
        'incomeChangePercentage': null,
      },
      'persona': null,
      'insights': [],
      'recommendedGoal': {
        'message':
            'Add a few more transactions next month for a fuller picture.',
      },
    };

    final result = WrappedResult.fromJson(json);

    expect(result.sufficientData, isFalse);
    expect(result.persona, isNull);
    expect(result.insights, isEmpty);
  });

  test('WrappedPromo.fromJson parses an available promo', () {
    final json = {
      'available': true,
      'year': 2026,
      'month': 8,
      'personaName': 'Cafe Hunter',
    };
    final promo = WrappedPromo.fromJson(json);
    expect(promo.available, isTrue);
    expect(promo.year, 2026);
    expect(promo.personaName, 'Cafe Hunter');
  });

  test('WrappedPromo.fromJson parses no promo available', () {
    final json = {
      'available': false,
      'year': null,
      'month': null,
      'personaName': null,
    };
    final promo = WrappedPromo.fromJson(json);
    expect(promo.available, isFalse);
    expect(promo.year, isNull);
  });

  test('WrappedHistoryItem.fromJson parses a month with no persona (insufficient data)', () {
    final json = {
      'year': 2026,
      'month': 5,
      'personaId': null,
      'personaName': null,
      'viewed': true,
    };
    final item = WrappedHistoryItem.fromJson(json);
    expect(item.personaId, isNull);
    expect(item.viewed, isTrue);
  });
}
