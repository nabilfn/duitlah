import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duitlah_mobile/core/theme/app_theme.dart';
import 'package:duitlah_mobile/core/widgets/app_field_group.dart';
import 'package:duitlah_mobile/core/widgets/app_search_field.dart';
import 'package:duitlah_mobile/core/widgets/app_text_field.dart';
import 'package:duitlah_mobile/features/accounts/domain/finance.dart';
import 'package:duitlah_mobile/features/transactions/presentation/transaction_form_sheet.dart';
import 'whole_app_fixtures.dart';
import 'whole_app_screens.dart';

Widget _app(Widget screen, {bool dark=false}) => ProviderScope(
  overrides: wholeAppOverrides(),
  child: MaterialApp(theme: dark ? AppTheme.dark() : AppTheme.light(),
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.3),
        disableAnimations: true), child: child!),
    home: screen),
);
void main() {
  testWidgets('text fields and selectors share a stable label edge', (tester) async {
    await tester.pumpWidget(MaterialApp(theme: AppTheme.light(), home: Scaffold(
      body: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
        const AppTextField(label: 'Merchant'),
        const SizedBox(height: 20),
        AppFieldGroup(label: 'Account', child: DropdownButtonFormField<String>(
          initialValue: 'a', isExpanded: true,
          items: const [DropdownMenuItem(value:'a',child:Text('Everyday account'))],
          onChanged: (_) {})),
      ])),
    )));
    expect(tester.getTopLeft(find.text('Merchant')).dx, 20);
    expect(tester.getTopLeft(find.text('Account')).dx, 20);
    final before = tester.getTopLeft(find.text('Merchant'));
    await tester.enterText(find.byType(TextField), 'Coffee');
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.text('Merchant')), before);
    expect(tester.takeException(), isNull);
  });
  testWidgets('search clear restores both local and submitted queries', (tester) async {
    String? local, submitted;
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: AppSearchField(
      hint: 'Search receipts', onChanged: (v)=>local=v, onSubmitted: (v)=>submitted=v,
    ))));
    await tester.enterText(find.byType(TextField), 'Coffee');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();
    expect(local, 'Coffee'); expect(submitted, 'Coffee');
    await tester.tap(find.byTooltip('Clear search'));
    await tester.pump();
    expect(local, ''); expect(submitted, '');
    expect(tester.widget<TextField>(find.byType(TextField)).focusNode!.hasFocus, true);
  });
  for(final type in TransactionType.values) {
    testWidgets('$type transaction labels and save stay reachable above keyboard', (tester) async {
      tester.view.physicalSize=const Size(320,740); tester.view.devicePixelRatio=1;
      addTearDown(tester.view.resetPhysicalSize); addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(_app(Scaffold(body: Builder(builder:(context)=>TextButton(
        onPressed:()=>showTransactionForm(context,initialType:type),child:const Text('Open'))))));
      await tester.tap(find.text('Open')); await tester.pumpAndSettle();
      final label=find.text(type==TransactionType.TRANSFER?'From account':'Account');
      expect(label, findsOneWidget);
      expect(tester.getTopLeft(label).dx, 20);
      await tester.enterText(find.byType(TextFormField).first, '1234567.89');
      tester.view.viewInsets=const FakeViewPadding(bottom:280);
      addTearDown(tester.view.resetViewInsets);
      await tester.pumpAndSettle();
      final save=find.text(type==TransactionType.TRANSFER?'Save transfer':'Save transaction');
      await tester.ensureVisible(save); await tester.pumpAndSettle();
      expect(tester.getBottomRight(save).dy, lessThan(460));
      expect(tester.takeException(), isNull);
    });
  }
  // Screens whose floating action opens a form sheet directly. Excluded:
  // NetWorthScreen has no floating action at all; ExpensesScreen,
  // JournalEntriesScreen and CreditNotesScreen await a repository (suppliers /
  // customers / chart of accounts) before presenting, and these fixtures are
  // display-only by contract, so no sheet can appear for them here.
  for(final name in ['AccountsScreen','BudgetsScreen','GoalsScreen','BillsScreen',
    'LiabilitiesScreen','BusinessAccountsScreen','CustomersScreen',
    'SuppliersScreen','ProductsScreen','InvoicesScreen','QuotationsScreen',
    'RecurringInvoicesScreen','TeamScreen','ChartOfAccountsScreen',
    'TransactionRulesScreen','RecurringTransactionsScreen']) {
    for(final dark in [false,true]) {
      testWidgets('$name form keyboard dark=$dark', (tester) async {
        tester.view.physicalSize=const Size(320,740); tester.view.devicePixelRatio=1;
        addTearDown(tester.view.resetPhysicalSize); addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(_app(wholeAppScreens[name]!,dark:dark));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(FloatingActionButton).first);
        await tester.pumpAndSettle();
        tester.view.viewInsets=const FakeViewPadding(bottom:280);
        addTearDown(tester.view.resetViewInsets);
        await tester.pumpAndSettle();
        expect(find.byType(BottomSheet),findsOneWidget);
        expect(tester.takeException(),isNull);
        final scroll=find.descendant(of:find.byType(BottomSheet),matching:find.byType(Scrollable));
        if(scroll.evaluate().isNotEmpty) {
          final state=tester.state<ScrollableState>(scroll.first);
          state.position.jumpTo(state.position.maxScrollExtent);
          await tester.pump();
          expect(tester.takeException(),isNull);
        }
        await tester.pumpWidget(const SizedBox.shrink()); await tester.pump();
      });
    }
  }
}
