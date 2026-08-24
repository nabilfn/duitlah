// ignore_for_file: constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/amount_converter.dart';

part 'assistant.freezed.dart';
part 'assistant.g.dart';

enum ChatMessageRole { USER, ASSISTANT }

/// One turn of a chat, held only in memory on the client -- the backend is stateless per request
/// (see AiRepository.chat), so the full history is resent on every message.
@freezed
abstract class ChatTurn with _$ChatTurn {
  const factory ChatTurn({required ChatMessageRole role, required String content}) = _ChatTurn;

  factory ChatTurn.fromJson(Map<String, dynamic> json) => _$ChatTurnFromJson(json);
}

@freezed
abstract class ChatResult with _$ChatResult {
  const factory ChatResult({required String reply, required bool available}) = _ChatResult;

  factory ChatResult.fromJson(Map<String, dynamic> json) => _$ChatResultFromJson(json);
}

@freezed
abstract class AffordabilityResult with _$AffordabilityResult {
  const factory AffordabilityResult({
    @AmountConverter() required String amount,
    @AmountConverter() required String currentBalance,
    @AmountConverter() required String projectedBalanceIfWaited,
    @AmountConverter() required String projectedBalanceIfPurchased,
    @AmountConverter() required String totalOwedToOthers,
    required bool canAfford,
    required String narrative,
    required String disclaimer,
    // V2 Phase 12: obligations widened beyond just totalOwedToOthers -- these three fold into
    // the deterministic canAfford check (see docs/ai-assistant-v2.md).
    @AmountConverter() required String upcomingBillsTotal,
    @AmountConverter() required String debtRepaymentsTotal,
    @AmountConverter() required String totalObligations,
    // Informational only -- surfaced alongside the verdict, never mixed into canAfford.
    @NullableAmountConverter() String? averageCreditUtilization,
    @AmountConverter() required String totalSavingsGoalsRemaining,
    @AmountConverter() required String budgetRemainingThisPeriod,
  }) = _AffordabilityResult;

  factory AffordabilityResult.fromJson(Map<String, dynamic> json) =>
      _$AffordabilityResultFromJson(json);
}
