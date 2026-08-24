// ignore_for_file: constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/amount_converter.dart';
import '../../recurring/domain/recurring_transaction.dart' show RecurrenceFrequency;

part 'recurring_invoice.freezed.dart';
part 'recurring_invoice.g.dart';

/// Output shape of one line-item template on a [RecurringInvoice] — adds
/// [id] on top of the input fields, same relationship [LineItem] (in
/// `sales.dart`) has to a one-off quotation/invoice line.
@freezed
abstract class RecurringInvoiceLineItem with _$RecurringInvoiceLineItem {
  const factory RecurringInvoiceLineItem({
    required String id,
    String? productId,
    required String description,
    @AmountConverter() required String quantity,
    @AmountConverter() required String unitPrice,
  }) = _RecurringInvoiceLineItem;

  factory RecurringInvoiceLineItem.fromJson(Map<String, dynamic> json) =>
      _$RecurringInvoiceLineItemFromJson(json);
}

/// A schedule that materializes an ordinary `DRAFT` invoice (visible at the
/// existing invoice list/detail screens via `Invoice.sourceRecurringInvoiceId`)
/// every time it's due — structurally identical to
/// `recurring.RecurringTransaction`'s own schedule shape, reusing
/// [RecurrenceFrequency] directly rather than duplicating it.
@freezed
abstract class RecurringInvoice with _$RecurringInvoice {
  const factory RecurringInvoice({
    required String id,
    required String customerId,
    @NullableAmountConverter() String? taxPercent,
    String? notes,
    int? paymentTermDays,
    required RecurrenceFrequency frequency,
    required int intervalCount,
    required String startDate,
    String? endDate,
    required String nextOccurrenceDate,
    required bool active,
    required List<RecurringInvoiceLineItem> lineItems,
  }) = _RecurringInvoice;

  factory RecurringInvoice.fromJson(Map<String, dynamic> json) => _$RecurringInvoiceFromJson(json);
}
