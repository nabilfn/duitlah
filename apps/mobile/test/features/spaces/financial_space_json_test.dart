import 'package:flutter_test/flutter_test.dart';

import 'package:duitlah_mobile/features/spaces/domain/financial_space.dart';

void main() {
  test('FinancialSpace.fromJson parses a live backend response', () {
    // Captured from `GET /api/v1/spaces` against a live docker-compose backend.
    final json = {
      'id': '9b1c1e3a-7f2a-4e9b-8a1b-2c3d4e5f6a7b',
      'type': 'BUSINESS',
      'name': 'TechKita',
      'yourRole': 'OWNER',
      'status': 'ACTIVE',
    };

    final space = FinancialSpace.fromJson(json);

    expect(space.type, SpaceType.BUSINESS);
    expect(space.name, 'TechKita');
    expect(space.yourRole, SpaceRole.OWNER);
    expect(space.status, SpaceStatus.ACTIVE);
  });

  test('BusinessProfile.fromJson parses a live backend response with optional fields', () {
    // Captured from `GET /api/v1/spaces/{id}/business-profile`.
    final json = {
      'spaceId': '9b1c1e3a-7f2a-4e9b-8a1b-2c3d4e5f6a7b',
      'legalName': 'TechKita Sdn Bhd',
      'tradeName': null,
      'registrationNumber': '202601012345',
      'tin': null,
      'businessType': null,
      'industry': 'Software',
      'sstNumber': null,
      'financialYearStart': null,
      'financialYearEnd': null,
      'address': null,
      'phone': null,
      'email': null,
      'currency': 'MYR',
    };

    final profile = BusinessProfile.fromJson(json);

    expect(profile.legalName, 'TechKita Sdn Bhd');
    expect(profile.registrationNumber, '202601012345');
    expect(profile.industry, 'Software');
    expect(profile.currency, 'MYR');
    expect(profile.tin, isNull);
    expect(profile.annualRevenue, isNull);
  });

  test('BusinessProfile.fromJson parses Phase 10\'s annualRevenue as a bare-number amount when present', () {
    final json = {
      'spaceId': '9b1c1e3a-7f2a-4e9b-8a1b-2c3d4e5f6a7b',
      'legalName': 'TechKita Sdn Bhd',
      'tradeName': 'TechKita',
      'registrationNumber': '202601012345',
      'tin': 'C1234567890',
      'businessType': 'SDN_BHD',
      'industry': 'Software',
      'sstNumber': 'W10-1234-56789012',
      'financialYearStart': '2026-01-01',
      'financialYearEnd': '2026-12-31',
      'address': '1 Jalan Bukit Bintang, KL',
      'phone': '+60123456789',
      'email': 'finance@techkita.example',
      'currency': 'MYR',
      'annualRevenue': 750000.00,
    };

    final profile = BusinessProfile.fromJson(json);

    expect(profile.annualRevenue, '750000.0');
    expect(profile.financialYearStart, '2026-01-01');
    expect(profile.financialYearEnd, '2026-12-31');
    expect(profile.sstNumber, 'W10-1234-56789012');
  });
}
