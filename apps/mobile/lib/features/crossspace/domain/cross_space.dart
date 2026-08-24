// ignore_for_file: constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/amount_converter.dart';

part 'cross_space.freezed.dart';
part 'cross_space.g.dart';

/// Phase 11 — Cross-Space Accounting. Which of the four link actions in
/// `cross_space_repository.dart` produced a [CrossSpaceLinkResponse] — see
/// that file's doc comments for what each one means and which accounts
/// move on the business side. None of the four ever modifies the Personal
/// transaction they reference; they only ever link to it.
enum CrossSpaceLinkType { BUSINESS_ADVANCE, REIMBURSEMENT, OWNER_CONTRIBUTION, OWNER_DRAWING }

/// One recorded link between an existing Personal transaction
/// ([personalTransactionId]) and a business action. [businessJournalEntryId]
/// is the real double-entry journal entry the link produced on the business
/// side — nullable defensively, though every successful link response
/// carries one in practice since all four actions always post an entry.
/// [relatedLinkId] is only ever populated on a REIMBURSEMENT that named the
/// BUSINESS_ADVANCE link it settles.
@freezed
abstract class CrossSpaceLinkResponse with _$CrossSpaceLinkResponse {
  const factory CrossSpaceLinkResponse({
    required String id,
    required String businessSpaceId,
    required CrossSpaceLinkType linkType,
    required String personalTransactionId,
    String? businessJournalEntryId,
    String? relatedLinkId,
    @AmountConverter() required String amount,
    String? description,
    required String createdAt,
  }) = _CrossSpaceLinkResponse;

  factory CrossSpaceLinkResponse.fromJson(Map<String, dynamic> json) => _$CrossSpaceLinkResponseFromJson(json);
}

/// One business's contribution to [CombinedNetWorth.estimatedTotalNetWorth]
/// — [equityValue] is the server's own computed ownership value for that
/// business; the client never derives it.
@freezed
abstract class BusinessOwnershipLine with _$BusinessOwnershipLine {
  const factory BusinessOwnershipLine({
    required String spaceId,
    required String spaceName,
    @AmountConverter() required String equityValue,
  }) = _BusinessOwnershipLine;

  factory BusinessOwnershipLine.fromJson(Map<String, dynamic> json) => _$BusinessOwnershipLineFromJson(json);
}

/// Read-only, informational aggregate of the user's Personal net worth plus
/// every Business they own's [BusinessOwnershipLine.equityValue], summed
/// into [estimatedTotalNetWorth] — explicitly labeled "estimated" by the
/// backend's own field name, never authoritative bookkeeping. There are no
/// write actions against this shape anywhere in the app.
@freezed
abstract class CombinedNetWorth with _$CombinedNetWorth {
  const factory CombinedNetWorth({
    @AmountConverter() required String personalNetWorth,
    required List<BusinessOwnershipLine> businessOwnership,
    @AmountConverter() required String totalBusinessOwnershipValue,
    @AmountConverter() required String estimatedTotalNetWorth,
  }) = _CombinedNetWorth;

  factory CombinedNetWorth.fromJson(Map<String, dynamic> json) => _$CombinedNetWorthFromJson(json);
}
