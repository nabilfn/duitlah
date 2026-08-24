// ignore_for_file: constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/amount_converter.dart';

part 'sales.freezed.dart';
part 'sales.g.dart';

enum QuotationStatus { DRAFT, SENT, ACCEPTED, DECLINED, EXPIRED }

/// An explicit user action only — never PARTIALLY_PAID/PAID/OVERDUE, which
/// only ever appear on [InvoiceEffectiveStatus].
enum InvoiceStatus { DRAFT, SENT, VOID }

/// Server-computed, this is the status to show prominently in the UI (not
/// [InvoiceStatus]).
enum InvoiceEffectiveStatus { DRAFT, SENT, PARTIALLY_PAID, PAID, OVERDUE, VOID }

enum CreditNoteStatus { ISSUED, VOID }

/// Output shape of a line item on a quotation or invoice — adds [id] and the
/// server-computed [lineTotal] on top of the input fields.
@freezed
abstract class LineItem with _$LineItem {
  const factory LineItem({
    required String id,
    String? productId,
    required String description,
    @AmountConverter() required String quantity,
    @AmountConverter() required String unitPrice,
    @AmountConverter() required String lineTotal,
  }) = _LineItem;

  factory LineItem.fromJson(Map<String, dynamic> json) => _$LineItemFromJson(json);
}

@freezed
abstract class Quotation with _$Quotation {
  const factory Quotation({
    required String id,
    required String customerId,
    required String quoteNumber,
    required String issueDate,
    String? expiryDate,
    required QuotationStatus status,
    @AmountConverter() required String taxPercent,
    @AmountConverter() required String subtotal,
    @AmountConverter() required String taxAmount,
    @AmountConverter() required String total,
    String? notes,
    required List<LineItem> lineItems,
  }) = _Quotation;

  factory Quotation.fromJson(Map<String, dynamic> json) => _$QuotationFromJson(json);
}

@freezed
abstract class Invoice with _$Invoice {
  const factory Invoice({
    required String id,
    required String customerId,
    required String invoiceNumber,
    required String issueDate,
    required String dueDate,
    required InvoiceStatus status,
    required InvoiceEffectiveStatus effectiveStatus,
    @AmountConverter() required String taxPercent,
    @AmountConverter() required String subtotal,
    @AmountConverter() required String taxAmount,
    @AmountConverter() required String total,
    @AmountConverter() required String amountPaid,
    @AmountConverter() required String amountCredited,
    @AmountConverter() required String amountOutstanding,
    String? convertedFromQuotationId,
    /// Set when this invoice was auto-materialized by a
    /// [RecurringInvoice]'s daily scheduler rather than created directly —
    /// always `DRAFT` on creation either way (see `RecurringInvoiceService`
    /// docs), so this is purely provenance, never a different lifecycle.
    String? sourceRecurringInvoiceId,
    String? notes,
    required List<LineItem> lineItems,
  }) = _Invoice;

  factory Invoice.fromJson(Map<String, dynamic> json) => _$InvoiceFromJson(json);
}

@freezed
abstract class InvoicePayment with _$InvoicePayment {
  const factory InvoicePayment({
    required String id,
    required String businessAccountId,
    @AmountConverter() required String amount,
    required String paidOn,
    String? notes,
  }) = _InvoicePayment;

  factory InvoicePayment.fromJson(Map<String, dynamic> json) => _$InvoicePaymentFromJson(json);
}

@freezed
abstract class CreditNote with _$CreditNote {
  const factory CreditNote({
    required String id,
    required String customerId,
    String? invoiceId,
    required String creditNoteNumber,
    required String issueDate,
    @AmountConverter() required String amount,
    String? reason,
    required CreditNoteStatus status,
  }) = _CreditNote;

  factory CreditNote.fromJson(Map<String, dynamic> json) => _$CreditNoteFromJson(json);
}

// ---- Phase 10 — LHDN / MyInvois e-Invoice workflow -------------------------

/// READY/SUBMITTED are in-progress; VALID is the success end state (shows
/// [EInvoiceDocument.longId], the QR-relevant field); INVALID/CANCELLED/
/// REJECTED are distinct terminal states. Never client-computed — always
/// read straight off the server response.
enum EInvoiceStatus { READY, SUBMITTED, VALID, INVALID, CANCELLED, REJECTED }

/// One row of `.../einvoice/logs` — an interaction-history entry for
/// troubleshooting, newest first per the server's contract.
enum EInvoiceOperation { SUBMIT, STATUS_CHECK, CANCEL, REJECT }

/// The e-Invoice document attached to one invoice. A 404
/// `EINVOICE_DOCUMENT_NOT_FOUND` on the `GET` (no document created yet, a
/// normal "not started" state) is handled by `SalesRepository.getEInvoice`
/// returning `null` instead of throwing — this type itself always
/// represents a document that exists.
@freezed
abstract class EInvoiceDocument with _$EInvoiceDocument {
  const factory EInvoiceDocument({
    required String id,
    required String invoiceId,
    required EInvoiceStatus status,
    String? submissionUid,
    String? documentUuid,
    String? longId,
    String? validatedAt,
    String? invalidReason,
    String? cancelledAt,
    String? cancellationReason,
    String? rejectedAt,
    String? rejectionReason,
    required String createdAt,
  }) = _EInvoiceDocument;

  factory EInvoiceDocument.fromJson(Map<String, dynamic> json) => _$EInvoiceDocumentFromJson(json);
}

@freezed
abstract class EInvoiceLogEntry with _$EInvoiceLogEntry {
  const factory EInvoiceLogEntry({
    required String id,
    required EInvoiceOperation operation,
    String? providerName,
    required bool success,
    String? detail,
    required String createdAt,
  }) = _EInvoiceLogEntry;

  factory EInvoiceLogEntry.fromJson(Map<String, dynamic> json) => _$EInvoiceLogEntryFromJson(json);
}
