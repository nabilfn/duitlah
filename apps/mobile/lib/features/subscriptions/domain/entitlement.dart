// ignore_for_file: constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';

part 'entitlement.freezed.dart';
part 'entitlement.g.dart';

enum SubscriptionTier { FREE, PLUS }

enum SubscriptionStatus { ACTIVE, EXPIRED, CANCELED, GRACE_PERIOD }

/// `maxActiveGroups`/`maxReceiptScansPerMonth` are null for PLUS (unlimited).
@freezed
abstract class Entitlement with _$Entitlement {
  const factory Entitlement({
    required SubscriptionTier tier,
    SubscriptionStatus? status,
    String? expiresAt,
    int? maxActiveGroups,
    required int activeGroupCount,
    int? maxReceiptScansPerMonth,
    required int receiptScansThisMonth,
  }) = _Entitlement;

  factory Entitlement.fromJson(Map<String, dynamic> json) => _$EntitlementFromJson(json);
}
