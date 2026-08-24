import '../../../core/api/api_client.dart';
import '../../recurring/domain/recurring_transaction.dart' show RecurrenceFrequency;
import '../domain/recurring_invoice.dart';
import 'sales_repository.dart' show LineItemInput;

/// Recurring invoices (Phase 13) — a schedule that materializes an ordinary
/// `DRAFT` invoice (never auto-`SENT`) every time it's due, via a daily
/// background scheduler. Every materialized invoice shows up at the existing
/// `SalesRepository.listInvoices`/`getInvoice` endpoints, so this repository
/// only owns the schedule itself, not the invoices it produces.
class RecurringInvoiceRepository {
  RecurringInvoiceRepository(this._client);

  final ApiClient _client;

  Future<List<RecurringInvoice>> list(String spaceId) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/recurring-invoices') as List;
    return data.map((e) => RecurringInvoice.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<RecurringInvoice> get(String spaceId, String id) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/recurring-invoices/$id');
    return RecurringInvoice.fromJson(data as Map<String, dynamic>);
  }

  Future<RecurringInvoice> create(
    String spaceId, {
    required String customerId,
    String? taxPercent,
    String? notes,
    int? paymentTermDays,
    required RecurrenceFrequency frequency,
    int? intervalCount,
    required String startDate,
    String? endDate,
    required List<LineItemInput> lineItems,
  }) async {
    final data = await _client.post('/api/v1/spaces/$spaceId/recurring-invoices', data: {
      'customerId': customerId,
      if (taxPercent != null) 'taxPercent': taxPercent,
      if (notes != null) 'notes': notes,
      if (paymentTermDays != null) 'paymentTermDays': paymentTermDays,
      'frequency': frequency.name,
      if (intervalCount != null) 'intervalCount': intervalCount,
      'startDate': startDate,
      if (endDate != null) 'endDate': endDate,
      'lineItems': lineItems.map((e) => e.toJson()).toList(),
    });
    return RecurringInvoice.fromJson(data as Map<String, dynamic>);
  }

  Future<RecurringInvoice> setActive(String spaceId, String id, bool active) async {
    final data = await _client.patch('/api/v1/spaces/$spaceId/recurring-invoices/$id/active', data: {
      'active': active,
    });
    return RecurringInvoice.fromJson(data as Map<String, dynamic>);
  }

  Future<void> delete(String spaceId, String id) =>
      _client.delete('/api/v1/spaces/$spaceId/recurring-invoices/$id');
}
