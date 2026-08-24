import '../../../core/api/api_client.dart';
import '../domain/vault_receipt.dart';

/// The Receipt Vault (spec section 15) — independent of Bagilah's own
/// scan-and-confirm flow ([ReceiptScanRepository]), which is untouched by
/// this feature.
class ReceiptVaultRepository {
  ReceiptVaultRepository(this._client);

  final ApiClient _client;

  Future<List<VaultReceipt>> upload({
    required List<String> filePaths,
    required ReceiptPurpose purpose,
    String? folder,
    List<String>? tags,
  }) async {
    final data = await _client.uploadFiles(
      '/api/v1/receipts/vault',
      fieldName: 'files',
      filePaths: filePaths,
      query: {
        'purpose': purpose.name,
        if (folder != null && folder.isNotEmpty) 'folder': folder,
        if (tags != null && tags.isNotEmpty) 'tags': tags,
      },
    ) as List;
    return data.map((e) => VaultReceipt.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<VaultReceipt>> search({String? folder, String? merchant}) async {
    final data = await _client.get('/api/v1/receipts/vault', query: {
      if (folder != null) 'folder': folder,
      if (merchant != null) 'merchant': merchant,
    }) as List;
    return data.map((e) => VaultReceipt.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<VaultReceipt> get(String receiptId) async {
    final data = await _client.get('/api/v1/receipts/vault/$receiptId');
    return VaultReceipt.fromJson(data as Map<String, dynamic>);
  }

  Future<VaultReceipt> attachToTransaction(String receiptId, String transactionId) async {
    final data = await _client.post(
      '/api/v1/receipts/vault/$receiptId/attach?transactionId=$transactionId',
    );
    return VaultReceipt.fromJson(data as Map<String, dynamic>);
  }

  /// Advisory only — never auto-links. Attaching still requires
  /// [attachToTransaction]; this only narrows down what a human picks from.
  Future<List<ReceiptMatchSuggestion>> suggestTransactionMatches(String receiptId) async {
    final data = await _client.get('/api/v1/receipts/vault/$receiptId/match-suggestions') as List;
    return data.map((e) => ReceiptMatchSuggestion.fromJson(e as Map<String, dynamic>)).toList();
  }
}
