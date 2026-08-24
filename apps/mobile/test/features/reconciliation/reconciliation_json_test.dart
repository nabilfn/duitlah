import 'package:flutter_test/flutter_test.dart';

import 'package:duitlah_mobile/features/reconciliation/domain/reconciliation.dart';

void main() {
  test('BusinessStatementImportResponse.fromJson parses a PARSED import with an open session', () {
    final json = {
      'id': '9b1c1e3a-7f2a-4e9b-8a1b-2c3d4e5f6a7b',
      'businessAccountId': '1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d',
      'provider': 'GENERIC_CSV',
      'originalFilename': 'maybank-august.csv',
      'status': 'PARSED',
      'rowCount': 42,
      'errorMessage': null,
      'reconciliationSessionId': 'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d',
    };

    final import = BusinessStatementImportResponse.fromJson(json);

    expect(import.provider, StatementProvider.GENERIC_CSV);
    expect(import.status, BusinessStatementImportStatus.PARSED);
    expect(import.rowCount, 42);
    expect(import.reconciliationSessionId, 'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d');
  });

  test('BusinessStatementImportResponse.fromJson parses a FAILED import with a null session', () {
    final json = {
      'id': 'b2c3d4e5-f6a7-8b9c-0d1e-2f3a4b5c6d7e',
      'businessAccountId': '1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d',
      'provider': 'PDF',
      'originalFilename': 'unreadable-scan.pdf',
      'status': 'FAILED',
      'rowCount': 0,
      'errorMessage': 'Could not detect any transaction rows in this file.',
      'reconciliationSessionId': null,
    };

    final import = BusinessStatementImportResponse.fromJson(json);

    expect(import.status, BusinessStatementImportStatus.FAILED);
    expect(import.reconciliationSessionId, isNull);
    expect(import.errorMessage, 'Could not detect any transaction rows in this file.');
  });

  test('StatementLineResponse.fromJson parses a negative (outflow) bare-number amount', () {
    final json = {
      'id': 'c3d4e5f6-a7b8-9c0d-1e2f-3a4b5c6d7e8f',
      'occurredOn': '2026-08-05',
      'description': 'Supplier payment - Warisan Sdn Bhd',
      'amount': -1250.75,
      'status': 'UNMATCHED',
    };

    final line = StatementLineResponse.fromJson(json);

    expect(line.amount, '-1250.75');
    expect(line.status, StatementLineStatus.UNMATCHED);
  });

  test('StatementLineResponse.fromJson parses a positive (inflow) bare-number amount', () {
    final json = {
      'id': 'd4e5f6a7-b8c9-0d1e-2f3a-4b5c6d7e8f9a',
      'occurredOn': '2026-08-06',
      'description': 'Invoice payment received',
      'amount': 3000.00,
      'status': 'MATCHED',
    };

    final line = StatementLineResponse.fromJson(json);

    expect(line.amount, '3000.0');
    expect(line.status, StatementLineStatus.MATCHED);
  });

  test('MatchSuggestionResponse.fromJson parses an EXACT suggestion', () {
    final json = {
      'businessAccountEntryId': 'e5f6a7b8-c9d0-1e2f-3a4b-5c6d7e8f9a0b',
      'occurredOn': '2026-08-05',
      'description': 'Supplier payment',
      'signedAmount': -1250.75,
      'confidence': 'EXACT',
    };

    final suggestion = MatchSuggestionResponse.fromJson(json);

    expect(suggestion.signedAmount, '-1250.75');
    expect(suggestion.confidence, MatchConfidence.EXACT);
  });

  test('ReconciliationSessionResponse.fromJson parses an IN_PROGRESS session with a null statement balance', () {
    final json = {
      'id': 'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d',
      'businessAccountId': '1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d',
      'businessStatementImportId': '9b1c1e3a-7f2a-4e9b-8a1b-2c3d4e5f6a7b',
      'statementEndingBalance': null,
      'status': 'IN_PROGRESS',
      'startedAt': '2026-08-20T09:15:30Z',
      'completedAt': null,
    };

    final session = ReconciliationSessionResponse.fromJson(json);

    expect(session.status, ReconciliationSessionStatus.IN_PROGRESS);
    expect(session.statementEndingBalance, isNull);
    expect(session.completedAt, isNull);
  });

  test('ReconciliationSummaryResponse.fromJson parses a summary with statement balance and difference set', () {
    final json = {
      'unmatchedCount': 2,
      'matchedCount': 10,
      'createdCount': 3,
      'ignoredCount': 1,
      'splitCount': 1,
      'statementEndingBalance': 15230.50,
      'ledgerBalance': 15180.00,
      'difference': 50.50,
    };

    final summary = ReconciliationSummaryResponse.fromJson(json);

    expect(summary.unmatchedCount, 2);
    expect(summary.matchedCount, 10);
    expect(summary.splitCount, 1);
    expect(summary.statementEndingBalance, '15230.5');
    expect(summary.ledgerBalance, '15180.0');
    expect(summary.difference, '50.5');
  });

  test('ReconciliationSummaryResponse.fromJson parses a summary with both statement balance and difference null', () {
    final json = {
      'unmatchedCount': 5,
      'matchedCount': 0,
      'createdCount': 0,
      'ignoredCount': 0,
      'splitCount': 0,
      'statementEndingBalance': null,
      'ledgerBalance': 0,
      'difference': null,
    };

    final summary = ReconciliationSummaryResponse.fromJson(json);

    expect(summary.unmatchedCount, 5);
    expect(summary.statementEndingBalance, isNull);
    expect(summary.ledgerBalance, '0');
    expect(summary.difference, isNull);
  });
}
