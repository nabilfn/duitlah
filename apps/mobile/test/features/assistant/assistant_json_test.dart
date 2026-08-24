import 'package:flutter_test/flutter_test.dart';

import 'package:duitlah_mobile/features/assistant/domain/assistant.dart';

void main() {
  test('AffordabilityResult.fromJson parses a live backend response', () {
    // Captured from `POST /api/v1/ai/affordability` against a live docker-compose backend.
    final json = {
      'amount': 300.00,
      'currentBalance': 1000.00,
      'projectedBalanceIfWaited': 1000.00,
      'projectedBalanceIfPurchased': 700.00,
      'totalOwedToOthers': 0.00,
      'canAfford': true,
      'narrative':
          'You can afford the RM300.00 purchase (Shoes), but it would reduce your projected '
              'balance on 2026-08-31 from RM1000.00 to RM700.00.',
      'disclaimer':
          'This is an estimate based on your recurring transactions, forecasted spending, and '
              'existing debts -- not professional financial advice.',
      'upcomingBillsTotal': 150.00,
      'debtRepaymentsTotal': 200.00,
      'totalObligations': 350.00,
      'averageCreditUtilization': 0.42,
      'totalSavingsGoalsRemaining': 1200.00,
      'budgetRemainingThisPeriod': 400.00,
    };

    final result = AffordabilityResult.fromJson(json);

    expect(result.amount, '300.0');
    expect(result.canAfford, isTrue);
    expect(result.narrative, isNotEmpty);
    expect(result.disclaimer, isNotEmpty);
    expect(result.upcomingBillsTotal, '150.0');
    expect(result.debtRepaymentsTotal, '200.0');
    expect(result.totalObligations, '350.0');
    expect(result.averageCreditUtilization, '0.42');
    expect(result.totalSavingsGoalsRemaining, '1200.0');
    expect(result.budgetRemainingThisPeriod, '400.0');
  });

  test('AffordabilityResult.fromJson parses a cannot-afford response', () {
    final json = {
      'amount': 5000.00,
      'currentBalance': 1000.00,
      'projectedBalanceIfWaited': 1000.00,
      'projectedBalanceIfPurchased': -4000.00,
      'totalOwedToOthers': 0,
      'canAfford': false,
      'narrative': "You probably can't afford this RM5000.00 purchase right now.",
      'disclaimer': 'This is an estimate -- not professional financial advice.',
      'upcomingBillsTotal': 0,
      'debtRepaymentsTotal': 0,
      'totalObligations': 0,
      'averageCreditUtilization': null,
      'totalSavingsGoalsRemaining': 0,
      'budgetRemainingThisPeriod': 0,
    };

    final result = AffordabilityResult.fromJson(json);

    expect(result.canAfford, isFalse);
    expect(result.projectedBalanceIfPurchased, '-4000.0');
    expect(result.averageCreditUtilization, isNull);
  });

  test('ChatResult.fromJson parses the unavailable-provider response', () {
    // Captured from `POST /api/v1/ai/chat` with no ANTHROPIC_API_KEY configured.
    final json = {
      'reply': "The AI assistant isn't set up on this server yet. Ask whoever runs this "
          'Duitlah instance to configure an AI provider to enable it.',
      'available': false,
    };

    final result = ChatResult.fromJson(json);

    expect(result.available, isFalse);
    expect(result.reply, isNotEmpty);
  });
}
