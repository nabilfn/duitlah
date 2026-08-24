import 'dart:io';

import '../../../core/api/api_client.dart';
import '../../exports/data/export_repository.dart' show ExportFormat;

/// Downloads an accounting report export and writes it to a temp file for
/// [share_plus] to hand off to the OS share sheet — reuses the exact
/// "download bytes then share" pattern already established by
/// `features/exports/data/export_repository.dart` for the same reason: the
/// simplest "get this file off the phone" flow without a dedicated
/// Downloads-folder integration.
class AccountingExportRepository {
  AccountingExportRepository(this._client);

  final ApiClient _client;

  Future<File> _saveBytes(List<int> bytes, String filename) async {
    final file = File('${Directory.systemTemp.path}/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<File> trialBalance(String spaceId, {required String asOf, required ExportFormat format}) async {
    final bytes = await _client.downloadBytes('/api/v1/spaces/$spaceId/accounting/exports/trial-balance', query: {
      'asOf': asOf,
      'format': format.name,
    });
    return _saveBytes(bytes, 'trial-balance.${format.name.toLowerCase()}');
  }

  Future<File> incomeStatement(
    String spaceId, {
    required String from,
    required String to,
    required ExportFormat format,
  }) async {
    final bytes = await _client.downloadBytes('/api/v1/spaces/$spaceId/accounting/exports/income-statement', query: {
      'from': from,
      'to': to,
      'format': format.name,
    });
    return _saveBytes(bytes, 'income-statement.${format.name.toLowerCase()}');
  }

  Future<File> balanceSheet(String spaceId, {required String asOf, required ExportFormat format}) async {
    final bytes = await _client.downloadBytes('/api/v1/spaces/$spaceId/accounting/exports/balance-sheet', query: {
      'asOf': asOf,
      'format': format.name,
    });
    return _saveBytes(bytes, 'balance-sheet.${format.name.toLowerCase()}');
  }
}
