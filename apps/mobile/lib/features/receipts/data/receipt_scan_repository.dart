import '../../../core/api/api_client.dart';
import '../domain/receipt_scan.dart';

/// Upload -> OCR -> structured items -> user verification -> Bagilah
/// (docs/bagilah-engine.md's Phase 8 pipeline). OCR itself only ever runs
/// in Spring Boot (`ReceiptOcrService`); this repository just uploads the
/// photo and later posts back whatever the review screen holds.
class ReceiptScanRepository {
  ReceiptScanRepository(this._client);

  final ApiClient _client;

  Future<ReceiptScan> upload(
    String filePath, {
    void Function(int sent, int total)? onProgress,
  }) async {
    final data = await _client.uploadFile(
      '/api/v1/receipts/scans',
      fieldName: 'image',
      filePath: filePath,
      fileName: filePath.split('/').last,
      onProgress: onProgress,
    );
    return ReceiptScan.fromJson(data as Map<String, dynamic>);
  }

  Future<ReceiptScan> getScan(String scanId) async {
    final data = await _client.get('/api/v1/receipts/scans/$scanId');
    return ReceiptScan.fromJson(data as Map<String, dynamic>);
  }

  /// Confirms a scan into a real Bagilah bill. Sends a fully independent
  /// payload built from the review form's current values — the original
  /// OCR output is never re-read or merged in here, matching the backend's
  /// own "confirm never trusts the original scan" contract.
  Future<Map<String, dynamic>> confirm(
    String scanId, {
    required String merchant,
    required String receiptDate,
    required List<Map<String, dynamic>> items,
    required String tax,
    String taxStrategy = 'PROPORTIONAL',
    required String serviceCharge,
    String serviceStrategy = 'PROPORTIONAL',
    required String discount,
    String? discountLabel,
    String? declaredTotal,
  }) async {
    final data = await _client.post('/api/v1/receipts/scans/$scanId/confirm', data: {
      'merchant': merchant,
      'receiptDate': receiptDate,
      'items': items,
      'tax': tax,
      'taxStrategy': taxStrategy,
      'serviceCharge': serviceCharge,
      'serviceStrategy': serviceStrategy,
      'discount': discount,
      if (discountLabel != null) 'discountLabel': discountLabel,
      if (declaredTotal != null) 'declaredTotal': declaredTotal,
    });
    return data as Map<String, dynamic>;
  }
}
