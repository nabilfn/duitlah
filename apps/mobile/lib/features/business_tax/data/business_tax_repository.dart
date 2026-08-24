import '../../../core/api/api_client.dart';
import '../domain/business_tax.dart';

/// Phase 10 — LHDN / MyInvois / SST. All three endpoints are reads: the SST
/// rate table is global reference data, the SST report is a server-computed
/// summary over a date range, and e-Invoice readiness is a derived
/// checklist against the (now-editable, see `spaces_repository.dart`)
/// business profile. Every call here needs at least space membership; the
/// server enforces anything stricter (e.g. `VIEW_REPORTS`) — callers handle
/// a real 403 the normal way rather than guessing permissions client-side.
class BusinessTaxRepository {
  BusinessTaxRepository(this._client);

  final ApiClient _client;

  Future<List<SstRate>> listSstRates(String spaceId) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/business-tax/sst-rates') as List;
    return data.map((e) => SstRate.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<SstReport> getSstReport(String spaceId, {required String from, required String to}) async {
    final data = await _client.get(
      '/api/v1/spaces/$spaceId/business-tax/sst-report',
      query: {'from': from, 'to': to},
    );
    return SstReport.fromJson(data as Map<String, dynamic>);
  }

  Future<EInvoiceReadiness> getEInvoiceReadiness(String spaceId) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/business-tax/einvoice-readiness');
    return EInvoiceReadiness.fromJson(data as Map<String, dynamic>);
  }
}
