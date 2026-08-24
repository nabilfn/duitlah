import 'package:flutter_test/flutter_test.dart';

import 'package:duitlah_mobile/features/inventory/domain/inventory.dart';

void main() {
  test('MovementResponse.fromJson parses a PURCHASE with a bare-number unitCost', () {
    final json = {
      'id': '9b1c1e3a-7f2a-4e9b-8a1b-2c3d4e5f6a7b',
      'productId': '1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d',
      'type': 'PURCHASE',
      'quantity': 50.00,
      'unitCost': 12.50,
      'value': 625.00,
      'occurredOn': '2026-08-01',
      'notes': 'Initial stock-up',
      'sourceInvoiceLineItemId': null,
      'createdByUserId': 'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d',
      'createdAt': '2026-08-01T09:00:00Z',
    };

    final movement = MovementResponse.fromJson(json);

    expect(movement.type, MovementType.PURCHASE);
    expect(movement.quantity, '50.0');
    expect(movement.unitCost, '12.5');
    expect(movement.value, '625.0');
    expect(movement.notes, 'Initial stock-up');
  });

  test('MovementResponse.fromJson parses a SALE where the server computed unitCost from WAC', () {
    final json = {
      'id': 'b2c3d4e5-f6a7-8b9c-0d1e-2f3a4b5c6d7e',
      'productId': '1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d',
      'type': 'SALE',
      'quantity': -10.00,
      'unitCost': 12.50,
      'value': -125.00,
      'occurredOn': '2026-08-05',
      'notes': null,
      'sourceInvoiceLineItemId': 'c3d4e5f6-a7b8-9c0d-1e2f-3a4b5c6d7e8f',
      'createdByUserId': 'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d',
      'createdAt': '2026-08-05T14:00:00Z',
    };

    final movement = MovementResponse.fromJson(json);

    expect(movement.type, MovementType.SALE);
    expect(movement.quantity, '-10.0');
    expect(movement.sourceInvoiceLineItemId, 'c3d4e5f6-a7b8-9c0d-1e2f-3a4b5c6d7e8f');
  });

  test('ProductValuationResponse.fromJson parses a live backend response', () {
    final json = {
      'productId': '1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d',
      'quantityOnHand': 40.00,
      'weightedAverageCost': 12.50,
      'totalValue': 500.00,
    };

    final valuation = ProductValuationResponse.fromJson(json);

    expect(valuation.quantityOnHand, '40.0');
    expect(valuation.weightedAverageCost, '12.5');
    expect(valuation.totalValue, '500.0');
  });

  test('RecipeCostResponse.fromJson parses a recipe with items and a computed margin', () {
    final json = {
      'productId': '1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d',
      'items': [
        {
          'id': 'd4e5f6a7-b8c9-0d1e-2f3a-4b5c6d7e8f9a',
          'ingredientProductId': 'e5f6a7b8-c9d0-1e2f-3a4b-5c6d7e8f9a0b',
          'ingredientName': 'Espresso shot',
          'quantityPerUnit': 2.00,
          'ingredientUnitCost': 1.20,
          'lineCost': 2.40,
        },
      ],
      'unitCost': 2.40,
      'sellingPrice': 12.00,
      'grossMargin': 9.60,
      'grossMarginPercent': 80.00,
    };

    final cost = RecipeCostResponse.fromJson(json);

    expect(cost.items, hasLength(1));
    expect(cost.items.single.ingredientName, 'Espresso shot');
    expect(cost.items.single.lineCost, '2.4');
    expect(cost.unitCost, '2.4');
    expect(cost.grossMarginPercent, '80.0');
  });

  test('StockValuationRow.fromJson parses a row with a null sku', () {
    final json = {
      'productId': '1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d',
      'productName': 'Roasted coffee beans (1kg)',
      'sku': null,
      'quantityOnHand': 40.00,
      'weightedAverageCost': 12.50,
      'totalValue': 500.00,
    };

    final row = StockValuationRow.fromJson(json);

    expect(row.productName, 'Roasted coffee beans (1kg)');
    expect(row.sku, isNull);
    expect(row.totalValue, '500.0');
  });

  test('CogsReport.fromJson parses a date-range total', () {
    final json = {
      'from': '2026-08-01',
      'to': '2026-08-31',
      'totalCogs': 3120.75,
    };

    final report = CogsReport.fromJson(json);

    expect(report.from, '2026-08-01');
    expect(report.to, '2026-08-31');
    expect(report.totalCogs, '3120.75');
  });
}
