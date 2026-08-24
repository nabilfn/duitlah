// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LineItem _$LineItemFromJson(Map<String, dynamic> json) => _LineItem(
  id: json['id'] as String,
  productId: json['productId'] as String?,
  description: json['description'] as String,
  quantity: const AmountConverter().fromJson(json['quantity']),
  unitPrice: const AmountConverter().fromJson(json['unitPrice']),
  lineTotal: const AmountConverter().fromJson(json['lineTotal']),
);

Map<String, dynamic> _$LineItemToJson(_LineItem instance) => <String, dynamic>{
  'id': instance.id,
  'productId': instance.productId,
  'description': instance.description,
  'quantity': const AmountConverter().toJson(instance.quantity),
  'unitPrice': const AmountConverter().toJson(instance.unitPrice),
  'lineTotal': const AmountConverter().toJson(instance.lineTotal),
};

_Quotation _$QuotationFromJson(Map<String, dynamic> json) => _Quotation(
  id: json['id'] as String,
  customerId: json['customerId'] as String,
  quoteNumber: json['quoteNumber'] as String,
  issueDate: json['issueDate'] as String,
  expiryDate: json['expiryDate'] as String?,
  status: $enumDecode(_$QuotationStatusEnumMap, json['status']),
  taxPercent: const AmountConverter().fromJson(json['taxPercent']),
  subtotal: const AmountConverter().fromJson(json['subtotal']),
  taxAmount: const AmountConverter().fromJson(json['taxAmount']),
  total: const AmountConverter().fromJson(json['total']),
  notes: json['notes'] as String?,
  lineItems: (json['lineItems'] as List<dynamic>)
      .map((e) => LineItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$QuotationToJson(_Quotation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'quoteNumber': instance.quoteNumber,
      'issueDate': instance.issueDate,
      'expiryDate': instance.expiryDate,
      'status': _$QuotationStatusEnumMap[instance.status]!,
      'taxPercent': const AmountConverter().toJson(instance.taxPercent),
      'subtotal': const AmountConverter().toJson(instance.subtotal),
      'taxAmount': const AmountConverter().toJson(instance.taxAmount),
      'total': const AmountConverter().toJson(instance.total),
      'notes': instance.notes,
      'lineItems': instance.lineItems,
    };

const _$QuotationStatusEnumMap = {
  QuotationStatus.DRAFT: 'DRAFT',
  QuotationStatus.SENT: 'SENT',
  QuotationStatus.ACCEPTED: 'ACCEPTED',
  QuotationStatus.DECLINED: 'DECLINED',
  QuotationStatus.EXPIRED: 'EXPIRED',
};

_Invoice _$InvoiceFromJson(Map<String, dynamic> json) => _Invoice(
  id: json['id'] as String,
  customerId: json['customerId'] as String,
  invoiceNumber: json['invoiceNumber'] as String,
  issueDate: json['issueDate'] as String,
  dueDate: json['dueDate'] as String,
  status: $enumDecode(_$InvoiceStatusEnumMap, json['status']),
  effectiveStatus: $enumDecode(
    _$InvoiceEffectiveStatusEnumMap,
    json['effectiveStatus'],
  ),
  taxPercent: const AmountConverter().fromJson(json['taxPercent']),
  subtotal: const AmountConverter().fromJson(json['subtotal']),
  taxAmount: const AmountConverter().fromJson(json['taxAmount']),
  total: const AmountConverter().fromJson(json['total']),
  amountPaid: const AmountConverter().fromJson(json['amountPaid']),
  amountCredited: const AmountConverter().fromJson(json['amountCredited']),
  amountOutstanding: const AmountConverter().fromJson(
    json['amountOutstanding'],
  ),
  convertedFromQuotationId: json['convertedFromQuotationId'] as String?,
  sourceRecurringInvoiceId: json['sourceRecurringInvoiceId'] as String?,
  notes: json['notes'] as String?,
  lineItems: (json['lineItems'] as List<dynamic>)
      .map((e) => LineItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$InvoiceToJson(_Invoice instance) => <String, dynamic>{
  'id': instance.id,
  'customerId': instance.customerId,
  'invoiceNumber': instance.invoiceNumber,
  'issueDate': instance.issueDate,
  'dueDate': instance.dueDate,
  'status': _$InvoiceStatusEnumMap[instance.status]!,
  'effectiveStatus': _$InvoiceEffectiveStatusEnumMap[instance.effectiveStatus]!,
  'taxPercent': const AmountConverter().toJson(instance.taxPercent),
  'subtotal': const AmountConverter().toJson(instance.subtotal),
  'taxAmount': const AmountConverter().toJson(instance.taxAmount),
  'total': const AmountConverter().toJson(instance.total),
  'amountPaid': const AmountConverter().toJson(instance.amountPaid),
  'amountCredited': const AmountConverter().toJson(instance.amountCredited),
  'amountOutstanding': const AmountConverter().toJson(
    instance.amountOutstanding,
  ),
  'convertedFromQuotationId': instance.convertedFromQuotationId,
  'sourceRecurringInvoiceId': instance.sourceRecurringInvoiceId,
  'notes': instance.notes,
  'lineItems': instance.lineItems,
};

const _$InvoiceStatusEnumMap = {
  InvoiceStatus.DRAFT: 'DRAFT',
  InvoiceStatus.SENT: 'SENT',
  InvoiceStatus.VOID: 'VOID',
};

const _$InvoiceEffectiveStatusEnumMap = {
  InvoiceEffectiveStatus.DRAFT: 'DRAFT',
  InvoiceEffectiveStatus.SENT: 'SENT',
  InvoiceEffectiveStatus.PARTIALLY_PAID: 'PARTIALLY_PAID',
  InvoiceEffectiveStatus.PAID: 'PAID',
  InvoiceEffectiveStatus.OVERDUE: 'OVERDUE',
  InvoiceEffectiveStatus.VOID: 'VOID',
};

_InvoicePayment _$InvoicePaymentFromJson(Map<String, dynamic> json) =>
    _InvoicePayment(
      id: json['id'] as String,
      businessAccountId: json['businessAccountId'] as String,
      amount: const AmountConverter().fromJson(json['amount']),
      paidOn: json['paidOn'] as String,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$InvoicePaymentToJson(_InvoicePayment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessAccountId': instance.businessAccountId,
      'amount': const AmountConverter().toJson(instance.amount),
      'paidOn': instance.paidOn,
      'notes': instance.notes,
    };

_CreditNote _$CreditNoteFromJson(Map<String, dynamic> json) => _CreditNote(
  id: json['id'] as String,
  customerId: json['customerId'] as String,
  invoiceId: json['invoiceId'] as String?,
  creditNoteNumber: json['creditNoteNumber'] as String,
  issueDate: json['issueDate'] as String,
  amount: const AmountConverter().fromJson(json['amount']),
  reason: json['reason'] as String?,
  status: $enumDecode(_$CreditNoteStatusEnumMap, json['status']),
);

Map<String, dynamic> _$CreditNoteToJson(_CreditNote instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'invoiceId': instance.invoiceId,
      'creditNoteNumber': instance.creditNoteNumber,
      'issueDate': instance.issueDate,
      'amount': const AmountConverter().toJson(instance.amount),
      'reason': instance.reason,
      'status': _$CreditNoteStatusEnumMap[instance.status]!,
    };

const _$CreditNoteStatusEnumMap = {
  CreditNoteStatus.ISSUED: 'ISSUED',
  CreditNoteStatus.VOID: 'VOID',
};

_EInvoiceDocument _$EInvoiceDocumentFromJson(Map<String, dynamic> json) =>
    _EInvoiceDocument(
      id: json['id'] as String,
      invoiceId: json['invoiceId'] as String,
      status: $enumDecode(_$EInvoiceStatusEnumMap, json['status']),
      submissionUid: json['submissionUid'] as String?,
      documentUuid: json['documentUuid'] as String?,
      longId: json['longId'] as String?,
      validatedAt: json['validatedAt'] as String?,
      invalidReason: json['invalidReason'] as String?,
      cancelledAt: json['cancelledAt'] as String?,
      cancellationReason: json['cancellationReason'] as String?,
      rejectedAt: json['rejectedAt'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$EInvoiceDocumentToJson(_EInvoiceDocument instance) =>
    <String, dynamic>{
      'id': instance.id,
      'invoiceId': instance.invoiceId,
      'status': _$EInvoiceStatusEnumMap[instance.status]!,
      'submissionUid': instance.submissionUid,
      'documentUuid': instance.documentUuid,
      'longId': instance.longId,
      'validatedAt': instance.validatedAt,
      'invalidReason': instance.invalidReason,
      'cancelledAt': instance.cancelledAt,
      'cancellationReason': instance.cancellationReason,
      'rejectedAt': instance.rejectedAt,
      'rejectionReason': instance.rejectionReason,
      'createdAt': instance.createdAt,
    };

const _$EInvoiceStatusEnumMap = {
  EInvoiceStatus.READY: 'READY',
  EInvoiceStatus.SUBMITTED: 'SUBMITTED',
  EInvoiceStatus.VALID: 'VALID',
  EInvoiceStatus.INVALID: 'INVALID',
  EInvoiceStatus.CANCELLED: 'CANCELLED',
  EInvoiceStatus.REJECTED: 'REJECTED',
};

_EInvoiceLogEntry _$EInvoiceLogEntryFromJson(Map<String, dynamic> json) =>
    _EInvoiceLogEntry(
      id: json['id'] as String,
      operation: $enumDecode(_$EInvoiceOperationEnumMap, json['operation']),
      providerName: json['providerName'] as String?,
      success: json['success'] as bool,
      detail: json['detail'] as String?,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$EInvoiceLogEntryToJson(_EInvoiceLogEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'operation': _$EInvoiceOperationEnumMap[instance.operation]!,
      'providerName': instance.providerName,
      'success': instance.success,
      'detail': instance.detail,
      'createdAt': instance.createdAt,
    };

const _$EInvoiceOperationEnumMap = {
  EInvoiceOperation.SUBMIT: 'SUBMIT',
  EInvoiceOperation.STATUS_CHECK: 'STATUS_CHECK',
  EInvoiceOperation.CANCEL: 'CANCEL',
  EInvoiceOperation.REJECT: 'REJECT',
};
