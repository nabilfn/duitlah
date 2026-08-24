import 'package:flutter_test/flutter_test.dart';

import 'package:duitlah_mobile/features/assets/domain/fixed_assets.dart';

void main() {
  test('FixedAssetResponse.fromJson parses an ACTIVE asset with bare-number amounts', () {
    final json = {
      'id': '9b1c1e3a-7f2a-4e9b-8a1b-2c3d4e5f6a7b',
      'name': 'Delivery van',
      'category': 'Vehicles',
      'acquisitionDate': '2025-01-15',
      'cost': 80000.00,
      'salvageValue': 5000.00,
      'usefulLifeMonths': 60,
      'depreciationMethod': 'STRAIGHT_LINE',
      'status': 'ACTIVE',
      'disposedOn': null,
      'disposalProceeds': null,
      'accumulatedDepreciation': 2500.00,
      'netBookValue': 77500.00,
    };

    final asset = FixedAssetResponse.fromJson(json);

    expect(asset.name, 'Delivery van');
    expect(asset.status, FixedAssetStatus.ACTIVE);
    expect(asset.depreciationMethod, DepreciationMethod.STRAIGHT_LINE);
    expect(asset.cost, '80000.0');
    expect(asset.salvageValue, '5000.0');
    expect(asset.accumulatedDepreciation, '2500.0');
    expect(asset.netBookValue, '77500.0');
    expect(asset.disposedOn, isNull);
    expect(asset.disposalProceeds, isNull);
  });

  test('FixedAssetResponse.fromJson parses a DISPOSED asset with populated disposal fields', () {
    final json = {
      'id': 'b2c3d4e5-f6a7-8b9c-0d1e-2f3a4b5c6d7e',
      'name': 'Old espresso machine',
      'category': null,
      'acquisitionDate': '2022-06-01',
      'cost': 15000.00,
      'salvageValue': 0.00,
      'usefulLifeMonths': 36,
      'depreciationMethod': 'DOUBLE_DECLINING_BALANCE',
      'status': 'DISPOSED',
      'disposedOn': '2026-07-01',
      'disposalProceeds': 500.00,
      'accumulatedDepreciation': 15000.00,
      'netBookValue': 0.00,
    };

    final asset = FixedAssetResponse.fromJson(json);

    expect(asset.category, isNull);
    expect(asset.status, FixedAssetStatus.DISPOSED);
    expect(asset.depreciationMethod, DepreciationMethod.DOUBLE_DECLINING_BALANCE);
    expect(asset.disposedOn, '2026-07-01');
    expect(asset.disposalProceeds, '500.0');
    expect(asset.netBookValue, '0.0');
  });

  test('DepreciationEntryResponse.fromJson parses a posted entry with a period normalized to the 1st', () {
    final json = {
      'id': 'c3d4e5f6-a7b8-9c0d-1e2f-3a4b5c6d7e8f',
      'assetId': '9b1c1e3a-7f2a-4e9b-8a1b-2c3d4e5f6a7b',
      'period': '2026-08-01',
      'amount': 1250.00,
      'createdAt': '2026-08-01T02:00:00Z',
    };

    final entry = DepreciationEntryResponse.fromJson(json);

    expect(entry.period, '2026-08-01');
    expect(entry.amount, '1250.0');
  });
}
