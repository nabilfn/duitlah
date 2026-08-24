import 'package:flutter_test/flutter_test.dart';

import 'package:duitlah_mobile/features/networth/domain/net_worth.dart';

void main() {
  test('NetWorth.fromJson parses a live backend response', () {
    final json = {
      'totalAssets': 35000.00,
      'totalLiabilities': 15000.00,
      'netWorth': 20000.00,
      'assetsBreakdown': [
        {'label': 'Bank', 'amount': 10000.00},
        {'label': 'Myvi', 'amount': 25000.00},
      ],
      'liabilitiesBreakdown': [
        {'label': 'Myvi loan', 'amount': 15000.00},
      ],
    };

    final netWorth = NetWorth.fromJson(json);

    expect(netWorth.netWorth, '20000.0');
    expect(netWorth.assetsBreakdown.length, 2);
    expect(netWorth.assetsBreakdown.first.label, 'Bank');
    expect(netWorth.liabilitiesBreakdown.single.amount, '15000.0');
  });

  test('OtherAsset.fromJson parses a live backend response', () {
    final json = {
      'id': '9b1c1e3a-7f2a-4e9b-8a1b-2c3d4e5f6a7b',
      'type': 'VEHICLE',
      'name': 'Myvi',
      'estimatedValue': 25000.00,
      'notes': null,
    };

    final asset = OtherAsset.fromJson(json);

    expect(asset.type, AssetType.VEHICLE);
    expect(asset.estimatedValue, '25000.0');
  });
}
