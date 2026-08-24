import 'package:flutter_test/flutter_test.dart';

import 'package:duitlah_mobile/features/crossspace/domain/cross_space.dart';

void main() {
  test('CrossSpaceLinkResponse.fromJson parses a BUSINESS_ADVANCE with bare-number amount', () {
    final json = {
      'id': '9b1c1e3a-7f2a-4e9b-8a1b-2c3d4e5f6a7b',
      'businessSpaceId': 'b2c3d4e5-f6a7-8b9c-0d1e-2f3a4b5c6d7e',
      'linkType': 'BUSINESS_ADVANCE',
      'personalTransactionId': 'c3d4e5f6-a7b8-9c0d-1e2f-3a4b5c6d7e8f',
      'businessJournalEntryId': 'd4e5f6a7-b8c9-0d1e-2f3a-4b5c6d7e8f9a',
      'relatedLinkId': null,
      'amount': 1299.00,
      'description': 'Business software paid for personally',
      'createdAt': '2026-08-20T02:00:00Z',
    };

    final link = CrossSpaceLinkResponse.fromJson(json);

    expect(link.linkType, CrossSpaceLinkType.BUSINESS_ADVANCE);
    expect(link.personalTransactionId, 'c3d4e5f6-a7b8-9c0d-1e2f-3a4b5c6d7e8f');
    expect(link.businessJournalEntryId, isNotNull);
    expect(link.relatedLinkId, isNull);
    expect(link.amount, '1299.0');
    expect(link.description, 'Business software paid for personally');
  });

  test('CrossSpaceLinkResponse.fromJson parses a REIMBURSEMENT that names its related advance link', () {
    final json = {
      'id': 'e5f6a7b8-c9d0-1e2f-3a4b-5c6d7e8f9a0b',
      'businessSpaceId': 'b2c3d4e5-f6a7-8b9c-0d1e-2f3a4b5c6d7e',
      'linkType': 'REIMBURSEMENT',
      'personalTransactionId': 'f6a7b8c9-d0e1-2f3a-4b5c-6d7e8f9a0b1c',
      'businessJournalEntryId': 'a7b8c9d0-e1f2-3a4b-5c6d-7e8f9a0b1c2d',
      'relatedLinkId': '9b1c1e3a-7f2a-4e9b-8a1b-2c3d4e5f6a7b',
      'amount': 1299.00,
      'description': null,
      'createdAt': '2026-08-21T02:00:00Z',
    };

    final link = CrossSpaceLinkResponse.fromJson(json);

    expect(link.linkType, CrossSpaceLinkType.REIMBURSEMENT);
    expect(link.relatedLinkId, '9b1c1e3a-7f2a-4e9b-8a1b-2c3d4e5f6a7b');
    expect(link.description, isNull);
    expect(link.amount, '1299.0');
  });

  test('CrossSpaceLinkResponse.fromJson parses OWNER_CONTRIBUTION and OWNER_DRAWING link types', () {
    final contribution = CrossSpaceLinkResponse.fromJson({
      'id': 'b8c9d0e1-f2a3-4b5c-6d7e-8f9a0b1c2d3e',
      'businessSpaceId': 'b2c3d4e5-f6a7-8b9c-0d1e-2f3a4b5c6d7e',
      'linkType': 'OWNER_CONTRIBUTION',
      'personalTransactionId': 'c9d0e1f2-a3b4-5c6d-7e8f-9a0b1c2d3e4f',
      'businessJournalEntryId': null,
      'relatedLinkId': null,
      'amount': 5000.00,
      'description': 'Capitalizing the business',
      'createdAt': '2026-08-22T02:00:00Z',
    });
    final drawing = CrossSpaceLinkResponse.fromJson({
      'id': 'd0e1f2a3-b4c5-6d7e-8f9a-0b1c2d3e4f5a',
      'businessSpaceId': 'b2c3d4e5-f6a7-8b9c-0d1e-2f3a4b5c6d7e',
      'linkType': 'OWNER_DRAWING',
      'personalTransactionId': 'e1f2a3b4-c5d6-7e8f-9a0b-1c2d3e4f5a6b',
      'businessJournalEntryId': null,
      'relatedLinkId': null,
      'amount': 800.00,
      'description': null,
      'createdAt': '2026-08-23T02:00:00Z',
    });

    expect(contribution.linkType, CrossSpaceLinkType.OWNER_CONTRIBUTION);
    expect(contribution.amount, '5000.0');
    expect(drawing.linkType, CrossSpaceLinkType.OWNER_DRAWING);
    expect(drawing.amount, '800.0');
  });

  test('CombinedNetWorth.fromJson parses personal plus per-business ownership breakdown', () {
    final json = {
      'personalNetWorth': 42000.50,
      'businessOwnership': [
        {'spaceId': 'aa11', 'spaceName': 'Nabil Coffee Sdn Bhd', 'equityValue': 18500.00},
        {'spaceId': 'bb22', 'spaceName': 'Side Hustle Bakery', 'equityValue': 3200.75},
      ],
      'totalBusinessOwnershipValue': 21700.75,
      'estimatedTotalNetWorth': 63701.25,
    };

    final nw = CombinedNetWorth.fromJson(json);

    expect(nw.personalNetWorth, '42000.5');
    expect(nw.businessOwnership, hasLength(2));
    expect(nw.businessOwnership.first.spaceName, 'Nabil Coffee Sdn Bhd');
    expect(nw.businessOwnership.first.equityValue, '18500.0');
    expect(nw.totalBusinessOwnershipValue, '21700.75');
    expect(nw.estimatedTotalNetWorth, '63701.25');
  });

  test('CombinedNetWorth.fromJson parses an empty businessOwnership list for a user who owns no businesses', () {
    final json = {
      'personalNetWorth': 1000.00,
      'businessOwnership': [],
      'totalBusinessOwnershipValue': 0.00,
      'estimatedTotalNetWorth': 1000.00,
    };

    final nw = CombinedNetWorth.fromJson(json);

    expect(nw.businessOwnership, isEmpty);
    expect(nw.estimatedTotalNetWorth, '1000.0');
  });
}
