// ignore_for_file: constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/amount_converter.dart';

part 'banking.freezed.dart';
part 'banking.g.dart';

enum BusinessAccountType { BANK, CASH, E_WALLET, CREDIT_CARD }

enum EntryDirection { IN, OUT }

/// The business's own bank/cash/e-wallet/credit-card accounts — structurally
/// separate from the personal `Account` model. [balance] is always
/// server-computed (`openingBalance` plus the signed sum of entries) and is
/// never sent back on an update.
@freezed
abstract class BusinessAccount with _$BusinessAccount {
  const factory BusinessAccount({
    required String id,
    required String name,
    required BusinessAccountType type,
    required String currency,
    @AmountConverter() required String openingBalance,
    @AmountConverter() required String balance,
    /// Phase 6 — the Chart of Accounts ledger account this business account
    /// posts to automatically (e.g. when an expense payment is recorded from
    /// it). Null means unmapped: Phase 5's payment actions still work, they
    /// just don't produce a double-entry journal yet.
    String? chartOfAccountsId,
    required bool archived,
  }) = _BusinessAccount;

  factory BusinessAccount.fromJson(Map<String, dynamic> json) => _$BusinessAccountFromJson(json);
}

@freezed
abstract class AccountEntry with _$AccountEntry {
  const factory AccountEntry({
    required String id,
    required EntryDirection direction,
    @AmountConverter() required String amount,
    required String occurredOn,
    String? description,
    String? transferGroupId,
  }) = _AccountEntry;

  factory AccountEntry.fromJson(Map<String, dynamic> json) => _$AccountEntryFromJson(json);
}
