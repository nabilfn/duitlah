import 'package:flutter_test/flutter_test.dart';

import 'package:duitlah_mobile/features/receipts/domain/vault_receipt.dart';

void main() {
  test('VaultReceipt.fromJson parses a live backend response', () {
    final json = {
      'id': '9b1c1e3a-7f2a-4e9b-8a1b-2c3d4e5f6a7b',
      'purpose': 'PERSONAL_EXPENSE',
      'ocrStatus': 'PARSED',
      'merchant': 'ZUS Coffee',
      'receiptDate': '2026-08-20',
      'totalAmount': 18.90,
      'folder': 'Groceries',
      'tags': ['urgent', 'review'],
      'linkedTransactionId': null,
      'linkedBillId': null,
      'imageUrl': 'https://minio.example.com/receipts-vault/abc.jpg?X-Amz-Signature=xyz',
    };

    final receipt = VaultReceipt.fromJson(json);

    expect(receipt.purpose, ReceiptPurpose.PERSONAL_EXPENSE);
    expect(receipt.ocrStatus, VaultOcrStatus.PARSED);
    expect(receipt.merchant, 'ZUS Coffee');
    expect(receipt.totalAmount, '18.9');
    expect(receipt.folder, 'Groceries');
    expect(receipt.tags, ['urgent', 'review']);
    expect(receipt.linkedTransactionId, isNull);
  });
}
