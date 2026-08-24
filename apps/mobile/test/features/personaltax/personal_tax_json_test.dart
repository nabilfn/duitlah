import 'package:flutter_test/flutter_test.dart';

import 'package:duitlah_mobile/features/personaltax/domain/personal_tax.dart';

void main() {
  test('PersonalTaxCalculation.fromJson parses a live backend response', () {
    final json = {
      'yearOfAssessment': 2026,
      'totalIncome': 39000.00,
      'residentIndividualRelief': 9000.00,
      'reliefs': [
        {'label': 'LIFESTYLE', 'claimedAmount': 2500.00, 'maxAmount': 2500.00},
      ],
      'totalReliefs': 2500.00,
      'chargeableIncome': 27500.00,
      'grossTaxPayable': 375.00,
      'rebate': 400.00,
      'zakatPaid': 0,
      'zakatRebate': 0,
      'taxAfterRebatesAndZakat': 0,
      'pcbPaid': 0,
      'estimatedPayableOrRefund': 0,
      'disclaimer': 'This is an estimate for planning purposes only.',
    };

    final calculation = PersonalTaxCalculation.fromJson(json);

    expect(calculation.yearOfAssessment, 2026);
    expect(calculation.totalIncome, '39000.0');
    expect(calculation.reliefs.single.label, 'LIFESTYLE');
    expect(calculation.disclaimer, isNotEmpty);
  });

  test('FilingReadiness.fromJson parses a live backend response', () {
    final json = {
      'yearOfAssessment': 2026,
      'readyPercent': 57,
      'items': [
        {'key': 'INCOME', 'label': 'Income', 'ready': true, 'explanation': 'Income recorded.'},
        {'key': 'ZAKAT', 'label': 'Zakat', 'ready': true, 'explanation': 'Optional.'},
      ],
    };

    final readiness = FilingReadiness.fromJson(json);

    expect(readiness.items, hasLength(2));
    expect(readiness.items.first.ready, isTrue);
  });

  test('TaxReliefCandidate.fromJson parses an uncategorized candidate', () {
    final json = {
      'id': '9b1c1e3a-7f2a-4e9b-8a1b-2c3d4e5f6a7b',
      'yearOfAssessment': 2026,
      'category': null,
      'sourceReceiptId': null,
      'suggestedAmount': 150.00,
      'status': 'NEEDS_REVIEW',
      'notes': null,
    };

    final candidate = TaxReliefCandidate.fromJson(json);

    expect(candidate.category, isNull);
    expect(candidate.status, TaxReliefCandidateStatus.NEEDS_REVIEW);
    expect(candidate.suggestedAmount, '150.0');
  });

  test('PersonalTaxDocument.fromJson parses a live backend response', () {
    final json = {
      'id': '9b1c1e3a-7f2a-4e9b-8a1b-2c3d4e5f6a7b',
      'yearOfAssessment': 2026,
      'type': 'EA',
      'receiptId': null,
      'hasFile': true,
      'notes': null,
    };

    final document = PersonalTaxDocument.fromJson(json);

    expect(document.type, TaxDocumentType.EA);
    expect(document.hasFile, isTrue);
  });
}
