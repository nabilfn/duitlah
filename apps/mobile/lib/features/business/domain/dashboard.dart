import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/amount_converter.dart';

part 'dashboard.freezed.dart';
part 'dashboard.g.dart';

@freezed
abstract class BusinessDashboard with _$BusinessDashboard {
  const factory BusinessDashboard({
    @AmountConverter() required String cashPosition,
    @AmountConverter() required String totalReceivables,
    @AmountConverter() required String totalPayables,
    required int customerCount,
    required int supplierCount,
    required int productCount,
    required int openInvoiceCount,
    required int unpaidExpenseCount,
  }) = _BusinessDashboard;

  factory BusinessDashboard.fromJson(Map<String, dynamic> json) => _$BusinessDashboardFromJson(json);
}
