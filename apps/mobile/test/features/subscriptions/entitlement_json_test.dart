import 'package:flutter_test/flutter_test.dart';

import 'package:duitlah_mobile/features/subscriptions/domain/entitlement.dart';

void main() {
  test('Entitlement.fromJson parses a fresh FREE user with no subscription row', () {
    // Captured from `GET /api/v1/subscriptions/me` against a live docker-compose backend.
    final json = {
      'tier': 'FREE',
      'status': null,
      'expiresAt': null,
      'maxActiveGroups': 3,
      'activeGroupCount': 0,
      'maxReceiptScansPerMonth': 5,
      'receiptScansThisMonth': 0,
    };

    final entitlement = Entitlement.fromJson(json);

    expect(entitlement.tier, SubscriptionTier.FREE);
    expect(entitlement.status, isNull);
    expect(entitlement.maxActiveGroups, 3);
    expect(entitlement.maxReceiptScansPerMonth, 5);
  });

  test('Entitlement.fromJson parses a user at the group limit', () {
    final json = {
      'tier': 'FREE',
      'status': null,
      'expiresAt': null,
      'maxActiveGroups': 3,
      'activeGroupCount': 3,
      'maxReceiptScansPerMonth': 5,
      'receiptScansThisMonth': 0,
    };

    final entitlement = Entitlement.fromJson(json);

    expect(entitlement.activeGroupCount, entitlement.maxActiveGroups);
  });

  test('Entitlement.fromJson parses a PLUS user with unlimited limits', () {
    final json = {
      'tier': 'PLUS',
      'status': 'ACTIVE',
      'expiresAt': '2027-01-01T00:00:00Z',
      'maxActiveGroups': null,
      'activeGroupCount': 5,
      'maxReceiptScansPerMonth': null,
      'receiptScansThisMonth': 12,
    };

    final entitlement = Entitlement.fromJson(json);

    expect(entitlement.tier, SubscriptionTier.PLUS);
    expect(entitlement.status, SubscriptionStatus.ACTIVE);
    expect(entitlement.maxActiveGroups, isNull);
    expect(entitlement.maxReceiptScansPerMonth, isNull);
  });
}
