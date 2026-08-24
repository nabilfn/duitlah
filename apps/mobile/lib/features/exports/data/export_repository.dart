// ignore_for_file: constant_identifier_names
import 'dart:io';

import '../../../core/api/api_client.dart';

enum ExportFormat { CSV, XLSX, PDF }

/// Downloads an export and writes it to a temp file for [share_plus] to hand off to the OS share
/// sheet — the simplest "get this file off the phone" flow without a dedicated Downloads-folder
/// integration. Uses [Directory.systemTemp] directly rather than adding a `path_provider`
/// dependency just for this one call.
class ExportRepository {
  ExportRepository(this._client);

  final ApiClient _client;

  Future<File> _saveBytes(List<int> bytes, String filename) async {
    final file = File('${Directory.systemTemp.path}/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<File> transactions({required String from, required String to, ExportFormat format = ExportFormat.CSV}) async {
    final bytes = await _client.downloadBytes('/api/v1/exports/transactions', query: {
      'from': from,
      'to': to,
      'format': format.name,
    });
    return _saveBytes(bytes, 'transactions.${format.name.toLowerCase()}');
  }

  Future<File> bills({ExportFormat format = ExportFormat.CSV}) async {
    final bytes = await _client.downloadBytes('/api/v1/exports/bills', query: {'format': format.name});
    return _saveBytes(bytes, 'bills.${format.name.toLowerCase()}');
  }

  Future<File> loans({ExportFormat format = ExportFormat.CSV}) async {
    final bytes = await _client.downloadBytes('/api/v1/exports/loans', query: {'format': format.name});
    return _saveBytes(bytes, 'loans.${format.name.toLowerCase()}');
  }

  Future<File> netWorth({ExportFormat format = ExportFormat.CSV}) async {
    final bytes = await _client.downloadBytes('/api/v1/exports/net-worth', query: {'format': format.name});
    return _saveBytes(bytes, 'net-worth.${format.name.toLowerCase()}');
  }

  Future<File> budgets({required int year, required int month, ExportFormat format = ExportFormat.CSV}) async {
    final bytes = await _client.downloadBytes('/api/v1/exports/budgets', query: {
      'year': year,
      'month': month,
      'format': format.name,
    });
    return _saveBytes(bytes, 'budgets.${format.name.toLowerCase()}');
  }

  Future<File> fullArchive() async {
    final bytes = await _client.downloadBytes('/api/v1/exports/archive');
    return _saveBytes(bytes, 'duitlah-export.zip');
  }
}
