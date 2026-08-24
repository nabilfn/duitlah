// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecurringInvoiceLineItem _$RecurringInvoiceLineItemFromJson(
  Map<String, dynamic> json,
) => _RecurringInvoiceLineItem(
  id: json['id'] as String,
  productId: json['productId'] as String?,
  description: json['description'] as String,
  quantity: const AmountConverter().fromJson(json['quantity']),
  unitPrice: const AmountConverter().fromJson(json['unitPrice']),
);

Map<String, dynamic> _$RecurringInvoiceLineItemToJson(
  _RecurringInvoiceLineItem instance,
) => <String, dynamic>{
  'id': instance.id,
  'productId': instance.productId,
  'description': instance.description,
  'quantity': const AmountConverter().toJson(instance.quantity),
  'unitPrice': const AmountConverter().toJson(instance.unitPrice),
};

_RecurringInvoice _$RecurringInvoiceFromJson(Map<String, dynamic> json) =>
    _RecurringInvoice(
      id: json['id'] as String,
      customerId: json['customerId'] as String,
      taxPercent: const NullableAmountConverter().fromJson(json['taxPercent']),
      notes: json['notes'] as String?,
      paymentTermDays: (json['paymentTermDays'] as num?)?.toInt(),
      frequency: $enumDecode(_$RecurrenceFrequencyEnumMap, json['frequency']),
      intervalCount: (json['intervalCount'] as num).toInt(),
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String?,
      nextOccurrenceDate: json['nextOccurrenceDate'] as String,
      active: json['active'] as bool,
      lineItems: (json['lineItems'] as List<dynamic>)
          .map(
            (e) => RecurringInvoiceLineItem.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$RecurringInvoiceToJson(_RecurringInvoice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'taxPercent': const NullableAmountConverter().toJson(instance.taxPercent),
      'notes': instance.notes,
      'paymentTermDays': instance.paymentTermDays,
      'frequency': _$RecurrenceFrequencyEnumMap[instance.frequency]!,
      'intervalCount': instance.intervalCount,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'nextOccurrenceDate': instance.nextOccurrenceDate,
      'active': instance.active,
      'lineItems': instance.lineItems,
    };

const _$RecurrenceFrequencyEnumMap = {
  RecurrenceFrequency.DAILY: 'DAILY',
  RecurrenceFrequency.WEEKLY: 'WEEKLY',
  RecurrenceFrequency.MONTHLY: 'MONTHLY',
  RecurrenceFrequency.YEARLY: 'YEARLY',
};
