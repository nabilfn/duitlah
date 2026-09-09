import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duitlah_mobile/core/theme/app_theme.dart';
import 'package:duitlah_mobile/core/theme/duitlah_colors.dart';
import 'package:duitlah_mobile/core/widgets/balance_card.dart';
import 'package:duitlah_mobile/core/widgets/list_rows.dart';
import 'package:duitlah_mobile/core/widgets/app_state_views.dart';
import 'package:duitlah_mobile/features/home/presentation/more_menu_screen.dart';

void main() {
  for (final dark in [false, true]) {
    testWidgets('Financial components fit small phones, dark=$dark', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 720);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final theme = dark ? AppTheme.dark() : AppTheme.light();
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(
            body: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
              child: ListView(
                children: const [
                  BalanceCard(
                    label: 'Available balance',
                    amount: '9999999999.99',
                  ),
                  MoneyRow(
                    title: 'A long merchant description',
                    amount: '-9999999999.99',
                    subtitle: 'Expense',
                    leadingIcon: Icons.receipt,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      final money = tester
          .widgetList<Text>(find.byType(Text))
          .where((t) => t.data?.contains('9,999,999,999.99') ?? false);
      expect(money.first.style?.color, theme.extension<DuitlahColors>()!.balanceText);
    });
  }
  testWidgets('Loading respects reduced motion', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: const Scaffold(body: LoadingView()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(SkeletonBlock), findsNWidgets(3));
  });
  testWidgets('More keeps all 27 destinations', (tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light(), home: const MoreMenuScreen()),
    );
    final list = tester.widget<ListView>(find.byType(ListView));
    final delegate = list.childrenDelegate as SliverChildListDelegate;
    final cards = delegate.children.whereType<Card>();
    final tiles = cards
        .expand((c) => (c.child! as Column).children)
        .whereType<ListTile>();
    expect(tiles.length, 27);
    expect(tester.takeException(), isNull);
  });
}
