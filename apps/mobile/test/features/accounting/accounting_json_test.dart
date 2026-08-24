import 'package:flutter_test/flutter_test.dart';

import 'package:duitlah_mobile/features/accounting/domain/chart_of_accounts.dart';
import 'package:duitlah_mobile/features/accounting/domain/journal_entries.dart';
import 'package:duitlah_mobile/features/accounting/domain/periods.dart';
import 'package:duitlah_mobile/features/accounting/domain/reports.dart';

void main() {
  test('LedgerAccount.fromJson parses a live backend response', () {
    final json = {
      'id': '9b1c1e3a-7f2a-4e9b-8a1b-2c3d4e5f6a7b',
      'code': '1000',
      'name': 'Cash at Bank',
      'type': 'ASSET',
      'systemDefault': true,
      'cashEquivalent': true,
      'archived': false,
    };

    final account = LedgerAccount.fromJson(json);

    expect(account.code, '1000');
    expect(account.type, LedgerAccountType.ASSET);
    expect(account.systemDefault, isTrue);
    expect(account.cashEquivalent, isTrue);
    expect(account.archived, isFalse);
  });

  test('AccountingPeriod.fromJson parses a live backend response', () {
    final json = {
      'id': '1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d',
      'periodStart': '2026-08-01',
      'periodEnd': '2026-08-31',
      'status': 'OPEN',
    };

    final period = AccountingPeriod.fromJson(json);

    expect(period.periodStart, '2026-08-01');
    expect(period.periodEnd, '2026-08-31');
    expect(period.status, AccountingPeriodStatus.OPEN);
  });

  test('JournalEntry.fromJson parses a live backend response with a balanced DEBIT/CREDIT pair', () {
    final json = {
      'id': 'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d',
      'entryDate': '2026-08-15',
      'description': 'Office rent for August',
      'sourceType': 'MANUAL',
      'sourceId': null,
      'lines': [
        {
          'id': 'b2c3d4e5-f6a7-8b9c-0d1e-2f3a4b5c6d7e',
          'accountId': '9b1c1e3a-7f2a-4e9b-8a1b-2c3d4e5f6a7b',
          'accountCode': '5100',
          'accountName': 'Rent Expense',
          'direction': 'DEBIT',
          'amount': 2500.00,
          'description': null,
        },
        {
          'id': 'c3d4e5f6-a7b8-9c0d-1e2f-3a4b5c6d7e8f',
          'accountId': '1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d',
          'accountCode': '1000',
          'accountName': 'Cash at Bank',
          'direction': 'CREDIT',
          'amount': 2500.00,
          'description': null,
        },
      ],
    };

    final entry = JournalEntry.fromJson(json);

    expect(entry.sourceType, JournalSourceType.MANUAL);
    expect(entry.lines, hasLength(2));
    expect(entry.lines[0].direction, LedgerDirection.DEBIT);
    expect(entry.lines[0].amount, '2500.0');
    expect(entry.lines[1].direction, LedgerDirection.CREDIT);
    expect(entry.lines[1].amount, '2500.0');
  });

  test('TrialBalanceReport.fromJson parses a live backend response with matching totals', () {
    final json = {
      'asOf': '2026-08-31',
      'lines': [
        {
          'accountId': '9b1c1e3a-7f2a-4e9b-8a1b-2c3d4e5f6a7b',
          'accountCode': '1000',
          'accountName': 'Cash at Bank',
          'type': 'ASSET',
          'debit': 15230.50,
          'credit': 0,
        },
        {
          'accountId': '1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d',
          'accountCode': '3000',
          'accountName': "Owner's Equity",
          'type': 'EQUITY',
          'debit': 0,
          'credit': 15230.50,
        },
      ],
      'totalDebit': 15230.50,
      'totalCredit': 15230.50,
    };

    final report = TrialBalanceReport.fromJson(json);

    expect(report.lines, hasLength(2));
    expect(report.lines.first.type, LedgerAccountType.ASSET);
    expect(report.totalDebit, report.totalCredit);
  });

  test('BalanceSheetReport.fromJson parses a live backend response including currentEarnings', () {
    final json = {
      'asOf': '2026-08-31',
      'assets': [
        {
          'accountId': '9b1c1e3a-7f2a-4e9b-8a1b-2c3d4e5f6a7b',
          'accountCode': '1000',
          'accountName': 'Cash at Bank',
          'amount': 15230.50,
        },
      ],
      'totalAssets': 15230.50,
      'liabilities': <Map<String, dynamic>>[],
      'totalLiabilities': 0,
      'equity': [
        {
          'accountId': '1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d',
          'accountCode': '3000',
          'accountName': "Owner's Equity",
          'amount': 10000.00,
        },
      ],
      'totalEquity': 15230.50,
      'currentEarnings': 5230.50,
      'totalLiabilitiesAndEquity': 15230.50,
    };

    final report = BalanceSheetReport.fromJson(json);

    expect(report.assets, hasLength(1));
    expect(report.totalAssets, report.totalLiabilitiesAndEquity);
    expect(report.currentEarnings, '5230.5');
  });

  test('CashFlowReport.fromJson parses a live backend response', () {
    final json = {
      'from': '2026-08-01',
      'to': '2026-08-31',
      'openingCash': 10000.00,
      'totalCashIn': 8230.50,
      'totalCashOut': 3000.00,
      'netChange': 5230.50,
      'closingCash': 15230.50,
    };

    final report = CashFlowReport.fromJson(json);

    expect(report.openingCash, '10000.0');
    expect(report.closingCash, '15230.5');
    expect(report.netChange, '5230.5');
  });
}
