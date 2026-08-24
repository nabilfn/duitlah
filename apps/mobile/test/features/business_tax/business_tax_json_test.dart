import 'package:flutter_test/flutter_test.dart';

import 'package:duitlah_mobile/features/business_tax/domain/business_tax.dart';

void main() {
  test('SstRate.fromJson parses a still-current rate (null effectiveTo)', () {
    final json = {
      'taxType': 'SALES',
      'ratePercent': 10.00,
      'effectiveFrom': '2018-09-01',
      'effectiveTo': null,
      'description': 'Standard sales tax rate',
    };

    final rate = SstRate.fromJson(json);

    expect(rate.taxType, TaxType.SALES);
    expect(rate.ratePercent, '10.0');
    expect(rate.effectiveTo, isNull);
  });

  test('SstRate.fromJson parses a superseded SERVICE rate with a closed effectiveTo', () {
    final json = {
      'taxType': 'SERVICE',
      'ratePercent': 6.00,
      'effectiveFrom': '2018-09-01',
      'effectiveTo': '2024-02-29',
      'description': 'Pre-2024 service tax rate',
    };

    final rate = SstRate.fromJson(json);

    expect(rate.taxType, TaxType.SERVICE);
    expect(rate.ratePercent, '6.0');
    expect(rate.effectiveTo, '2024-02-29');
  });

  test('SstReport.fromJson parses a live backend response over a date range', () {
    final json = {
      'from': '2026-08-01',
      'to': '2026-08-31',
      'collectedTax': 4500.00,
      'payableTax': 4200.50,
    };

    final report = SstReport.fromJson(json);

    expect(report.from, '2026-08-01');
    expect(report.to, '2026-08-31');
    expect(report.collectedTax, '4500.0');
    expect(report.payableTax, '4200.5');
  });

  test('EInvoiceReadiness.fromJson parses a mandated-but-not-ready business with missing fields', () {
    final json = {
      'mandated': true,
      'currentRuleEffectiveDate': '2025-01-01',
      'currentRuleThreshold': 500000.00,
      'missingFields': ['tin', 'financialYear'],
      'ready': false,
    };

    final readiness = EInvoiceReadiness.fromJson(json);

    expect(readiness.mandated, isTrue);
    expect(readiness.currentRuleThreshold, '500000.0');
    expect(readiness.missingFields, ['tin', 'financialYear']);
    expect(readiness.ready, isFalse);
  });

  test('EInvoiceReadiness.fromJson parses a not-yet-mandated, fully-ready business', () {
    final json = {
      'mandated': false,
      'currentRuleEffectiveDate': null,
      'currentRuleThreshold': null,
      'missingFields': <String>[],
      'ready': true,
    };

    final readiness = EInvoiceReadiness.fromJson(json);

    expect(readiness.mandated, isFalse);
    expect(readiness.currentRuleThreshold, isNull);
    expect(readiness.missingFields, isEmpty);
    expect(readiness.ready, isTrue);
  });
}
