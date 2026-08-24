import 'package:flutter_test/flutter_test.dart';

import 'package:duitlah_mobile/features/business/domain/banking.dart';
import 'package:duitlah_mobile/features/business/domain/catalog.dart';
import 'package:duitlah_mobile/features/business/domain/contacts.dart';
import 'package:duitlah_mobile/features/business/domain/dashboard.dart';
import 'package:duitlah_mobile/features/business/domain/expenses.dart';
import 'package:duitlah_mobile/features/business/domain/sales.dart';
import 'package:duitlah_mobile/features/spaces/domain/financial_space.dart';
import 'package:duitlah_mobile/features/spaces/domain/space_member.dart';

void main() {
  test('SpaceMember.fromJson parses a live backend response', () {
    final json = {
      'id': '9b1c1e3a-7f2a-4e9b-8a1b-2c3d4e5f6a7b',
      'userId': '1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d',
      'displayName': 'Aisyah Rahman',
      'email': 'aisyah@example.com',
      'role': 'FINANCE',
      'status': 'ACTIVE',
    };

    final member = SpaceMember.fromJson(json);

    expect(member.displayName, 'Aisyah Rahman');
    expect(member.role, SpaceRole.FINANCE);
    expect(member.status, MemberStatus.ACTIVE);
  });

  test('Customer.fromJson parses a live backend response', () {
    final json = {
      'id': '9b1c1e3a-7f2a-4e9b-8a1b-2c3d4e5f6a7b',
      'name': 'Warisan Sdn Bhd',
      'contactPerson': 'Ravi Kumar',
      'phone': '+60123456789',
      'email': 'ravi@warisan.example',
      'billingAddress': '1 Jalan Bukit Bintang, KL',
      'registrationNumber': '201901234567',
      'tin': 'C1234567890',
      'sstNumber': null,
      'paymentTermsDays': 30,
      'notes': null,
      'status': 'ACTIVE',
    };

    final customer = Customer.fromJson(json);

    expect(customer.name, 'Warisan Sdn Bhd');
    expect(customer.paymentTermsDays, 30);
    expect(customer.status, ContactStatus.ACTIVE);
  });

  test('Product.fromJson parses a live backend response with a bare-number unitPrice', () {
    final json = {
      'id': '9b1c1e3a-7f2a-4e9b-8a1b-2c3d4e5f6a7b',
      'name': 'Consulting hour',
      'sku': 'SVC-001',
      'type': 'SERVICE',
      'unit': 'hour',
      'unitPrice': 250.00,
      'active': true,
      'description': null,
      'cost': null,
      'taxClassification': 'NOT_APPLICABLE',
      'trackInventory': false,
      'reorderPoint': null,
    };

    final product = Product.fromJson(json);

    expect(product.type, ProductType.SERVICE);
    expect(product.unitPrice, '250.0');
    expect(product.active, isTrue);
    expect(product.taxClassification, TaxClassification.NOT_APPLICABLE);
    expect(product.trackInventory, isFalse);
  });

  test('Product.fromJson parses Phase 8\'s inventory/costing fields when a tracked, taxed product', () {
    final json = {
      'id': '9b1c1e3a-7f2a-4e9b-8a1b-2c3d4e5f6a7b',
      'name': 'Roasted coffee beans (1kg)',
      'sku': 'GOOD-001',
      'type': 'GOODS',
      'unit': 'bag',
      'unitPrice': 45.00,
      'active': true,
      'description': 'Single-origin arabica, medium roast',
      'cost': 28.50,
      'taxClassification': 'STANDARD_RATED',
      'trackInventory': true,
      'reorderPoint': 10.00,
    };

    final product = Product.fromJson(json);

    expect(product.description, 'Single-origin arabica, medium roast');
    expect(product.cost, '28.5');
    expect(product.taxClassification, TaxClassification.STANDARD_RATED);
    expect(product.trackInventory, isTrue);
    expect(product.reorderPoint, '10.0');
  });

  test('BusinessAccount.fromJson parses a live backend response with computed balance', () {
    final json = {
      'id': '9b1c1e3a-7f2a-4e9b-8a1b-2c3d4e5f6a7b',
      'name': 'Maybank Current Account',
      'type': 'BANK',
      'currency': 'MYR',
      'openingBalance': 1000.00,
      'balance': 4250.75,
      'archived': false,
    };

    final account = BusinessAccount.fromJson(json);

    expect(account.type, BusinessAccountType.BANK);
    expect(account.balance, '4250.75');
    expect(account.archived, isFalse);
  });

  test('BusinessAccount.fromJson parses Phase 6\'s chartOfAccountsId when present', () {
    final json = {
      'id': '9b1c1e3a-7f2a-4e9b-8a1b-2c3d4e5f6a7b',
      'name': 'Maybank Current Account',
      'type': 'BANK',
      'currency': 'MYR',
      'openingBalance': 1000.00,
      'balance': 4250.75,
      'chartOfAccountsId': '1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d',
      'archived': false,
    };

    final account = BusinessAccount.fromJson(json);

    expect(account.chartOfAccountsId, '1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d');
  });

  test('BusinessAccount.fromJson still parses a pre-Phase-6 response with no chartOfAccountsId field', () {
    final json = {
      'id': '9b1c1e3a-7f2a-4e9b-8a1b-2c3d4e5f6a7b',
      'name': 'Maybank Current Account',
      'type': 'BANK',
      'currency': 'MYR',
      'openingBalance': 1000.00,
      'balance': 4250.75,
      'archived': false,
    };

    final account = BusinessAccount.fromJson(json);

    expect(account.chartOfAccountsId, isNull);
  });

  test('Expense.fromJson parses Phase 6\'s chartOfAccountsId when present and when absent', () {
    final withMapping = {
      'id': '9b1c1e3a-7f2a-4e9b-8a1b-2c3d4e5f6a7b',
      'supplierId': null,
      'category': 'Utilities',
      'amount': 250.00,
      'amountPaid': 250.00,
      'amountRemaining': 0,
      'occurredOn': '2026-08-10',
      'status': 'PAID',
      'receiptId': null,
      'chartOfAccountsId': '1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d',
      'notes': null,
    };
    final withoutMapping = Map<String, dynamic>.from(withMapping)..remove('chartOfAccountsId');

    expect(Expense.fromJson(withMapping).chartOfAccountsId, '1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d');
    expect(Expense.fromJson(withoutMapping).chartOfAccountsId, isNull);
  });

  test('Invoice.fromJson parses a live backend response with a line item and effectiveStatus', () {
    final json = {
      'id': '9b1c1e3a-7f2a-4e9b-8a1b-2c3d4e5f6a7b',
      'customerId': '1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d',
      'invoiceNumber': 'INV-00001',
      'issueDate': '2026-08-01',
      'dueDate': '2026-08-31',
      'status': 'SENT',
      'effectiveStatus': 'PARTIALLY_PAID',
      'taxPercent': 6.00,
      'subtotal': 1500.00,
      'taxAmount': 90.00,
      'total': 1590.00,
      'amountPaid': 500.00,
      'amountCredited': 0,
      'amountOutstanding': 1090.00,
      'convertedFromQuotationId': null,
      'notes': null,
      'lineItems': [
        {
          'id': 'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d',
          'productId': null,
          'description': 'Consulting services',
          'quantity': 6.00,
          'unitPrice': 250.00,
          'lineTotal': 1500.00,
        },
      ],
    };

    final invoice = Invoice.fromJson(json);

    expect(invoice.invoiceNumber, 'INV-00001');
    expect(invoice.status, InvoiceStatus.SENT);
    expect(invoice.effectiveStatus, InvoiceEffectiveStatus.PARTIALLY_PAID);
    expect(invoice.amountOutstanding, '1090.0');
    expect(invoice.lineItems, hasLength(1));
    expect(invoice.lineItems.single.lineTotal, '1500.0');
  });

  test('EInvoiceDocument.fromJson parses a VALID document with the QR-relevant longId', () {
    final json = {
      'id': 'd1e2f3a4-b5c6-7d8e-9f0a-1b2c3d4e5f6a',
      'invoiceId': '9b1c1e3a-7f2a-4e9b-8a1b-2c3d4e5f6a7b',
      'status': 'VALID',
      'submissionUid': 'SUB-2026-0001',
      'documentUuid': 'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d',
      'longId': 'LONGID-ABCDEF123456',
      'validatedAt': '2026-08-10T09:30:00Z',
      'invalidReason': null,
      'cancelledAt': null,
      'cancellationReason': null,
      'rejectedAt': null,
      'rejectionReason': null,
      'createdAt': '2026-08-10T09:00:00Z',
    };

    final doc = EInvoiceDocument.fromJson(json);

    expect(doc.status, EInvoiceStatus.VALID);
    expect(doc.longId, 'LONGID-ABCDEF123456');
    expect(doc.validatedAt, '2026-08-10T09:30:00Z');
    expect(doc.invalidReason, isNull);
  });

  test('EInvoiceDocument.fromJson parses a freshly-prepared READY document with mostly-null fields', () {
    final json = {
      'id': 'd1e2f3a4-b5c6-7d8e-9f0a-1b2c3d4e5f6a',
      'invoiceId': '9b1c1e3a-7f2a-4e9b-8a1b-2c3d4e5f6a7b',
      'status': 'READY',
      'submissionUid': null,
      'documentUuid': null,
      'longId': null,
      'validatedAt': null,
      'invalidReason': null,
      'cancelledAt': null,
      'cancellationReason': null,
      'rejectedAt': null,
      'rejectionReason': null,
      'createdAt': '2026-08-10T09:00:00Z',
    };

    final doc = EInvoiceDocument.fromJson(json);

    expect(doc.status, EInvoiceStatus.READY);
    expect(doc.submissionUid, isNull);
    expect(doc.longId, isNull);
  });

  test('EInvoiceLogEntry.fromJson parses a failed submission log entry', () {
    final json = {
      'id': 'e2f3a4b5-c6d7-8e9f-0a1b-2c3d4e5f6a7b',
      'operation': 'SUBMIT',
      'providerName': 'MyInvois',
      'success': false,
      'detail': 'Provider unavailable — no sandbox credentials configured',
      'createdAt': '2026-08-10T09:05:00Z',
    };

    final entry = EInvoiceLogEntry.fromJson(json);

    expect(entry.operation, EInvoiceOperation.SUBMIT);
    expect(entry.providerName, 'MyInvois');
    expect(entry.success, isFalse);
    expect(entry.detail, contains('Provider unavailable'));
  });

  test('BusinessDashboard.fromJson parses a live backend response with money fields and plain counts', () {
    final json = {
      'cashPosition': 15230.50,
      'totalReceivables': 4200.00,
      'totalPayables': 1800.00,
      'customerCount': 12,
      'supplierCount': 5,
      'productCount': 34,
      'openInvoiceCount': 7,
      'unpaidExpenseCount': 3,
    };

    final dashboard = BusinessDashboard.fromJson(json);

    expect(dashboard.cashPosition, '15230.5');
    expect(dashboard.customerCount, 12);
    expect(dashboard.openInvoiceCount, 7);
    expect(dashboard.unpaidExpenseCount, 3);
  });
}
