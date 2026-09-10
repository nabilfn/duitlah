import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duitlah_mobile/core/theme/app_theme.dart';
import 'package:duitlah_mobile/features/budgets/application/budgets_providers.dart';
import 'package:duitlah_mobile/features/budgets/data/budgets_repository.dart';
import 'package:duitlah_mobile/features/budgets/domain/budget.dart';
import 'package:duitlah_mobile/features/goals/presentation/goals_screen.dart';

class _Goals implements GoalsRepository {
  final calls = <String>[];
  final pending = Completer<Goal>();
  @override
  Future<List<Goal>> listGoals() async => [];
  @override
  Future<Goal> createGoal({
    required String name,
    required GoalType type,
    required String targetAmount,
    String? targetDate,
  }) {
    calls.add(targetAmount);
    return pending.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets(
    'recommendation prefills existing goal form without a write until confirmation',
    (t) async {
      final repo = _Goals();
      await t.pumpWidget(
        ProviderScope(
          overrides: [goalsRepositoryProvider.overrideWithValue(repo)],
          child: MaterialApp(
            theme: AppTheme.light(),
            home: const GoalsScreen(
              wrappedAmount: '420.00',
              wrappedMonth: '2026-08',
            ),
          ),
        ),
      );
      await t.pumpAndSettle();
      expect(find.text('420.00'), findsOneWidget);
      expect(find.text('Suggested frequency: Monthly'), findsOneWidget);
      expect(repo.calls, isEmpty);
      await t.ensureVisible(find.text('Create goal'));
      await t.tap(find.text('Create goal'));
      await t.pump();
      expect(repo.calls, ['420.00']);
      await t.tap(find.byType(ElevatedButton).last);
      await t.pump();
      expect(repo.calls.length, 1);
      repo.pending.complete(
        const Goal(
          id: 'g1',
          name: 'Future You',
          type: GoalType.CUSTOM,
          targetAmount: '420.00',
          currentAmount: '0',
          remaining: '420',
          percentage: '0',
          archived: false,
        ),
      );
      await t.pumpAndSettle();
      expect(t.takeException(), isNull);
    },
  );
  testWidgets('dismissing the recommendation creates nothing', (t) async {
    final repo = _Goals();
    await t.pumpWidget(
      ProviderScope(
        overrides: [goalsRepositoryProvider.overrideWithValue(repo)],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const GoalsScreen(wrappedAmount: '420.00'),
        ),
      ),
    );
    await t.pumpAndSettle();
    Navigator.of(t.element(find.text('Create goal'))).pop();
    await t.pumpAndSettle();
    expect(repo.calls, isEmpty);
    expect(t.takeException(), isNull);
  });
}
