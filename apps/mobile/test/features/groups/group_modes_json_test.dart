import 'package:flutter_test/flutter_test.dart';

import 'package:duitlah_mobile/features/groups/domain/group.dart';

void main() {
  test('GroupExpense.fromJson parses a category and currency snapshot', () {
    // Captured from `POST /api/v1/groups/{id}/expenses` against a live docker-compose backend.
    final json = {
      'id': 'de386b96-4a46-4b01-86d4-0878d7ec12ba',
      'description': 'Ramen dinner',
      'amount': 54.90,
      'occurredOn': '2027-03-02',
      'paidByUserId': '63fb06d6-64cc-4eff-9623-16b0c2b6b6c9',
      'paidByName': 'Phase11 Tester',
      'shares': [
        {
          'userId': '63fb06d6-64cc-4eff-9623-16b0c2b6b6c9',
          'displayName': 'Phase11 Tester',
          'amount': 54.90,
        },
      ],
      'category': 'FOOD',
      'originalCurrency': 'JPY',
      'originalAmount': 1800.00,
      'exchangeRate': 0.0305,
    };

    final expense = GroupExpense.fromJson(json);

    expect(expense.category, GroupExpenseCategory.FOOD);
    expect(expense.originalCurrency, 'JPY');
    expect(expense.originalAmount, '1800.0');
    expect(expense.amount, '54.9');
  });

  test('GroupGoal.fromJson parses a per-member contribution breakdown', () {
    // Captured from `POST /api/v1/groups/{id}/goals/{goalId}/contributions`.
    final json = {
      'id': '28a22a13-304c-4b1c-958b-f33958066b4a',
      'name': 'Japan Trip',
      'targetAmount': 8000.00,
      'targetDate': '2027-03-01',
      'currentAmount': 2500.00,
      'remaining': 5500.00,
      'percentage': 31.2500,
      'archived': false,
      'byMember': [
        {
          'userId': '63fb06d6-64cc-4eff-9623-16b0c2b6b6c9',
          'displayName': 'Phase11 Tester',
          'totalContributed': 2500.00,
        },
      ],
    };

    final goal = GroupGoal.fromJson(json);

    expect(goal.name, 'Japan Trip');
    expect(goal.currentAmount, '2500.0');
    expect(goal.byMember, hasLength(1));
    expect(goal.byMember.single.totalContributed, '2500.0');
  });

  test('GroupBudget.fromJson parses spent/remaining', () {
    // Captured from `PUT /api/v1/groups/{id}/budget`.
    final json = {'amount': 12000.00, 'spent': 0, 'remaining': 12000.00};

    final budget = GroupBudget.fromJson(json);

    expect(budget.amount, '12000.0');
    expect(budget.spent, '0');
  });

  test('TripSummary.fromJson parses a category breakdown', () {
    // Captured from `GET /api/v1/groups/{id}/trip-summary`.
    final json = {
      'budgetAmount': 12000.00,
      'spent': 54.90,
      'remaining': 11945.10,
      'spendingByCategory': [
        {'category': 'FOOD', 'amount': 54.90},
      ],
    };

    final summary = TripSummary.fromJson(json);

    expect(summary.budgetAmount, '12000.0');
    expect(summary.spendingByCategory.single.category, GroupExpenseCategory.FOOD);
  });

  test('HousemateDashboard.fromJson parses paid/unpaid categories', () {
    // Captured from `GET /api/v1/groups/{id}/housemate-dashboard`.
    final json = {
      'year': 2026,
      'month': 8,
      'categories': [
        {'category': 'RENT', 'paid': true},
        {'category': 'ELECTRICITY', 'paid': false},
      ],
    };

    final dashboard = HousemateDashboard.fromJson(json);

    expect(dashboard.categories.first.paid, isTrue);
    expect(dashboard.categories.last.paid, isFalse);
  });
}
