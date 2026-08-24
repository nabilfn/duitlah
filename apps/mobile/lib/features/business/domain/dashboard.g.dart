// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BusinessDashboard _$BusinessDashboardFromJson(Map<String, dynamic> json) =>
    _BusinessDashboard(
      cashPosition: const AmountConverter().fromJson(json['cashPosition']),
      totalReceivables: const AmountConverter().fromJson(
        json['totalReceivables'],
      ),
      totalPayables: const AmountConverter().fromJson(json['totalPayables']),
      customerCount: (json['customerCount'] as num).toInt(),
      supplierCount: (json['supplierCount'] as num).toInt(),
      productCount: (json['productCount'] as num).toInt(),
      openInvoiceCount: (json['openInvoiceCount'] as num).toInt(),
      unpaidExpenseCount: (json['unpaidExpenseCount'] as num).toInt(),
    );

Map<String, dynamic> _$BusinessDashboardToJson(
  _BusinessDashboard instance,
) => <String, dynamic>{
  'cashPosition': const AmountConverter().toJson(instance.cashPosition),
  'totalReceivables': const AmountConverter().toJson(instance.totalReceivables),
  'totalPayables': const AmountConverter().toJson(instance.totalPayables),
  'customerCount': instance.customerCount,
  'supplierCount': instance.supplierCount,
  'productCount': instance.productCount,
  'openInvoiceCount': instance.openInvoiceCount,
  'unpaidExpenseCount': instance.unpaidExpenseCount,
};
