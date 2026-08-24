// ignore_for_file: constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/amount_converter.dart';

part 'financial_space.freezed.dart';
part 'financial_space.g.dart';

enum SpaceType { PERSONAL, BUSINESS }

enum SpaceRole { OWNER, ADMIN, FINANCE, ACCOUNTANT, SALES, STAFF, VIEWER }

enum SpaceStatus { ACTIVE, ARCHIVED }

@freezed
abstract class FinancialSpace with _$FinancialSpace {
  const factory FinancialSpace({
    required String id,
    required SpaceType type,
    required String name,
    required SpaceRole yourRole,
    required SpaceStatus status,
  }) = _FinancialSpace;

  factory FinancialSpace.fromJson(Map<String, dynamic> json) => _$FinancialSpaceFromJson(json);
}

/// Was read-only through Phase 9 — Phase 10 (LHDN / MyInvois / SST) adds the
/// first `PUT` for this resource (requires `MANAGE_BOOKS`, a real
/// server-enforced 403 `INSUFFICIENT_PERMISSION`) plus [annualRevenue],
/// which the Business Tax e-Invoice-readiness check reads to determine the
/// applicable mandate threshold.
@freezed
abstract class BusinessProfile with _$BusinessProfile {
  const factory BusinessProfile({
    required String spaceId,
    required String legalName,
    String? tradeName,
    String? registrationNumber,
    String? tin,
    String? businessType,
    String? industry,
    String? sstNumber,
    String? financialYearStart,
    String? financialYearEnd,
    String? address,
    String? phone,
    String? email,
    required String currency,
    @NullableAmountConverter() String? annualRevenue,
  }) = _BusinessProfile;

  factory BusinessProfile.fromJson(Map<String, dynamic> json) => _$BusinessProfileFromJson(json);
}
