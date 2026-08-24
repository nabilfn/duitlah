import 'package:flutter_test/flutter_test.dart';

import 'package:duitlah_mobile/features/accounts/domain/finance.dart' show TransactionDirection;
import 'package:duitlah_mobile/features/autotrack/domain/transaction_candidate.dart';

void main() {
  test('TransactionCandidate.fromJson parses a live backend response', () {
    final json = {
      'id': '9b1c1e3a-7f2a-4e9b-8a1b-2c3d4e5f6a7b',
      'sourceType': 'STATEMENT_CSV',
      'detectedAmount': 18.90,
      'detectedCurrency': 'MYR',
      'detectedMerchant': 'ZUS Coffee',
      'detectedDate': '2026-08-20',
      'detectedDirection': 'OUT',
      'suggestedAccountId': 'a1b2c3d4-0000-0000-0000-000000000000',
      'suggestedCategoryId': null,
      'confidence': 0.70,
      'status': 'PENDING',
      'duplicateOfTransactionId': null,
      'duplicateConfidence': null,
      'resultingTransactionId': null,
    };

    final candidate = TransactionCandidate.fromJson(json);

    expect(candidate.sourceType, CandidateSourceType.STATEMENT_CSV);
    expect(candidate.detectedAmount, '18.9');
    expect(candidate.detectedMerchant, 'ZUS Coffee');
    expect(candidate.detectedDirection, TransactionDirection.OUT);
    expect(candidate.status, CandidateStatus.PENDING);
    expect(candidate.duplicateOfTransactionId, isNull);
  });

  test('StatementImport.fromJson parses a live backend response', () {
    final json = {
      'id': '9b1c1e3a-7f2a-4e9b-8a1b-2c3d4e5f6a7b',
      'accountId': 'a1b2c3d4-0000-0000-0000-000000000000',
      'provider': 'GENERIC_CSV',
      'originalFilename': 'statement.csv',
      'status': 'PARSED',
      'rowCount': 2,
      'errorMessage': null,
    };

    final statementImport = StatementImport.fromJson(json);

    expect(statementImport.provider, StatementProvider.GENERIC_CSV);
    expect(statementImport.status, StatementImportStatus.PARSED);
    expect(statementImport.rowCount, 2);
  });
}
