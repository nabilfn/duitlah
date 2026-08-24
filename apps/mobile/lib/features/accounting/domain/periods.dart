// ignore_for_file: constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';

part 'periods.freezed.dart';
part 'periods.g.dart';

/// Server-computed and one-directional — there is no "reopen" endpoint, so
/// once a period is CLOSED the only way forward is a new period.
enum AccountingPeriodStatus { OPEN, CLOSED }

@freezed
abstract class AccountingPeriod with _$AccountingPeriod {
  const factory AccountingPeriod({
    required String id,
    required String periodStart,
    required String periodEnd,
    required AccountingPeriodStatus status,
  }) = _AccountingPeriod;

  factory AccountingPeriod.fromJson(Map<String, dynamic> json) => _$AccountingPeriodFromJson(json);
}
