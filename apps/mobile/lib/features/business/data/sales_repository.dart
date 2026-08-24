import '../../../core/api/api_client.dart';
import '../../../core/errors/app_exception.dart';
import '../domain/sales.dart';

/// A single line-item input row, shared verbatim between a quotation and an
/// invoice create request.
class LineItemInput {
  const LineItemInput({
    this.productId,
    required this.description,
    required this.quantity,
    required this.unitPrice,
  });

  final String? productId;
  final String description;
  final String quantity;
  final String unitPrice;

  Map<String, dynamic> toJson() => {
        if (productId != null) 'productId': productId,
        'description': description,
        'quantity': quantity,
        'unitPrice': unitPrice,
      };
}

class SalesRepository {
  SalesRepository(this._client);

  final ApiClient _client;

  // ---- Quotations ----------------------------------------------------

  Future<List<Quotation>> listQuotations(String spaceId) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/quotations') as List;
    return data.map((e) => Quotation.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Quotation> getQuotation(String spaceId, String id) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/quotations/$id');
    return Quotation.fromJson(data as Map<String, dynamic>);
  }

  Future<Quotation> createQuotation(
    String spaceId, {
    required String customerId,
    required String issueDate,
    String? expiryDate,
    String? taxPercent,
    String? notes,
    required List<LineItemInput> lineItems,
  }) async {
    final data = await _client.post('/api/v1/spaces/$spaceId/quotations', data: {
      'customerId': customerId,
      'issueDate': issueDate,
      if (expiryDate != null) 'expiryDate': expiryDate,
      if (taxPercent != null) 'taxPercent': taxPercent,
      if (notes != null) 'notes': notes,
      'lineItems': lineItems.map((e) => e.toJson()).toList(),
    });
    return Quotation.fromJson(data as Map<String, dynamic>);
  }

  Future<Quotation> changeQuotationStatus(String spaceId, String id, QuotationStatus status) async {
    final data = await _client.patch('/api/v1/spaces/$spaceId/quotations/$id/status', data: {'status': status.name});
    return Quotation.fromJson(data as Map<String, dynamic>);
  }

  Future<Invoice> convertToInvoice(String spaceId, String quotationId, {required String dueDate}) async {
    final data = await _client.post(
      '/api/v1/spaces/$spaceId/quotations/$quotationId/convert-to-invoice',
      data: {'dueDate': dueDate},
    );
    return Invoice.fromJson(data as Map<String, dynamic>);
  }

  // ---- Invoices --------------------------------------------------------

  Future<List<Invoice>> listInvoices(String spaceId) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/invoices') as List;
    return data.map((e) => Invoice.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Invoice> getInvoice(String spaceId, String id) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/invoices/$id');
    return Invoice.fromJson(data as Map<String, dynamic>);
  }

  Future<Invoice> createInvoice(
    String spaceId, {
    required String customerId,
    required String issueDate,
    required String dueDate,
    String? taxPercent,
    String? notes,
    required List<LineItemInput> lineItems,
  }) async {
    final data = await _client.post('/api/v1/spaces/$spaceId/invoices', data: {
      'customerId': customerId,
      'issueDate': issueDate,
      'dueDate': dueDate,
      if (taxPercent != null) 'taxPercent': taxPercent,
      if (notes != null) 'notes': notes,
      'lineItems': lineItems.map((e) => e.toJson()).toList(),
    });
    return Invoice.fromJson(data as Map<String, dynamic>);
  }

  Future<Invoice> changeInvoiceStatus(String spaceId, String id, InvoiceStatus status) async {
    final data = await _client.patch('/api/v1/spaces/$spaceId/invoices/$id/status', data: {'status': status.name});
    return Invoice.fromJson(data as Map<String, dynamic>);
  }

  Future<List<InvoicePayment>> listInvoicePayments(String spaceId, String invoiceId) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/invoices/$invoiceId/payments') as List;
    return data.map((e) => InvoicePayment.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<InvoicePayment> recordInvoicePayment(
    String spaceId,
    String invoiceId, {
    required String businessAccountId,
    required String amount,
    required String paidOn,
    String? notes,
  }) async {
    final data = await _client.post('/api/v1/spaces/$spaceId/invoices/$invoiceId/payments', data: {
      'businessAccountId': businessAccountId,
      'amount': amount,
      'paidOn': paidOn,
      if (notes != null) 'notes': notes,
    });
    return InvoicePayment.fromJson(data as Map<String, dynamic>);
  }

  // ---- Credit notes -----------------------------------------------------

  Future<List<CreditNote>> listCreditNotes(String spaceId) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/credit-notes') as List;
    return data.map((e) => CreditNote.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<CreditNote> getCreditNote(String spaceId, String id) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/credit-notes/$id');
    return CreditNote.fromJson(data as Map<String, dynamic>);
  }

  Future<CreditNote> createCreditNote(
    String spaceId, {
    required String customerId,
    String? invoiceId,
    required String issueDate,
    required String amount,
    String? reason,
  }) async {
    final data = await _client.post('/api/v1/spaces/$spaceId/credit-notes', data: {
      'customerId': customerId,
      if (invoiceId != null) 'invoiceId': invoiceId,
      'issueDate': issueDate,
      'amount': amount,
      if (reason != null) 'reason': reason,
    });
    return CreditNote.fromJson(data as Map<String, dynamic>);
  }

  Future<CreditNote> voidCreditNote(String spaceId, String id) async {
    final data = await _client.post('/api/v1/spaces/$spaceId/credit-notes/$id/void');
    return CreditNote.fromJson(data as Map<String, dynamic>);
  }

  // ---- e-Invoice (Phase 10 — LHDN / MyInvois) ----------------------------
  //
  // Every call below requires the server-enforced `MANAGE_SALES_DOCUMENTS`
  // permission — a real 403, never guessed client-side.

  /// Null if no e-Invoice document has been created for this invoice yet
  /// (404 `EINVOICE_DOCUMENT_NOT_FOUND`) — a normal "not started" state, not
  /// an error; the caller shows a "Submit as e-Invoice" CTA for this rather
  /// than an error view.
  Future<EInvoiceDocument?> getEInvoice(String spaceId, String invoiceId) async {
    try {
      final data = await _client.get('/api/v1/spaces/$spaceId/invoices/$invoiceId/einvoice');
      return EInvoiceDocument.fromJson(data as Map<String, dynamic>);
    } on AppException catch (e) {
      if (e.code == 'EINVOICE_DOCUMENT_NOT_FOUND') return null;
      rethrow;
    }
  }

  /// Eligibility + TIN validation only — no external LHDN call. Moves the
  /// document to READY. Throws 400 `INVOICE_NOT_ISSUED` (the invoice must be
  /// SENT first), 400 `EINVOICE_SELLER_TIN_MISSING`, 400
  /// `EINVOICE_BUYER_TIN_MISSING`, or 409 `EINVOICE_ALREADY_IN_PROGRESS`.
  Future<EInvoiceDocument> prepareEInvoice(String spaceId, String invoiceId) async {
    final data = await _client.post('/api/v1/spaces/$spaceId/invoices/$invoiceId/einvoice/prepare');
    return EInvoiceDocument.fromJson(data as Map<String, dynamic>);
  }

  /// The real, consequential submission to LHDN. Throws 409
  /// `EINVOICE_NOT_READY` (must [prepareEInvoice] first) or 503
  /// `EINVOICE_PROVIDER_UNAVAILABLE` — the latter is the expected, common
  /// case wherever no real MyInvois credentials are configured yet, not a
  /// bug; callers should show it as an honest "not connected" message
  /// rather than a generic error.
  Future<EInvoiceDocument> submitEInvoice(String spaceId, String invoiceId) async {
    final data = await _client.post('/api/v1/spaces/$spaceId/invoices/$invoiceId/einvoice/submit');
    return EInvoiceDocument.fromJson(data as Map<String, dynamic>);
  }

  /// Pull-based status refresh (LHDN has no webhook) — moves SUBMITTED to
  /// either VALID or INVALID. The caller surfaces this as a "Check status" /
  /// "Refresh" action rather than polling automatically.
  Future<EInvoiceDocument> syncEInvoiceStatus(String spaceId, String invoiceId) async {
    final data = await _client.post('/api/v1/spaces/$spaceId/invoices/$invoiceId/einvoice/sync-status');
    return EInvoiceDocument.fromJson(data as Map<String, dynamic>);
  }

  /// Only valid from VALID status, and only within 72 hours of
  /// [EInvoiceDocument.validatedAt]. Throws 409 `EINVOICE_NOT_VALID` or 409
  /// `EINVOICE_WINDOW_EXPIRED` (past that point, issuing a credit note is
  /// the real correction path — the caller's error message should say so).
  Future<EInvoiceDocument> cancelEInvoice(String spaceId, String invoiceId, {required String reason}) async {
    final data = await _client.post(
      '/api/v1/spaces/$spaceId/invoices/$invoiceId/einvoice/cancel',
      data: {'reason': reason},
    );
    return EInvoiceDocument.fromJson(data as Map<String, dynamic>);
  }

  /// Same shape and error contract as [cancelEInvoice]. In real LHDN usage
  /// rejection is normally buyer-initiated, so callers should present this
  /// as a secondary, less prominent action than cancel.
  Future<EInvoiceDocument> rejectEInvoice(String spaceId, String invoiceId, {required String reason}) async {
    final data = await _client.post(
      '/api/v1/spaces/$spaceId/invoices/$invoiceId/einvoice/reject',
      data: {'reason': reason},
    );
    return EInvoiceDocument.fromJson(data as Map<String, dynamic>);
  }

  /// Newest first, per the server's contract.
  Future<List<EInvoiceLogEntry>> listEInvoiceLogs(String spaceId, String invoiceId) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/invoices/$invoiceId/einvoice/logs') as List;
    return data.map((e) => EInvoiceLogEntry.fromJson(e as Map<String, dynamic>)).toList();
  }
}
