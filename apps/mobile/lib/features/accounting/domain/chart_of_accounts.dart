// ignore_for_file: constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chart_of_accounts.freezed.dart';
part 'chart_of_accounts.g.dart';

/// Named distinctly from the existing `finance.AccountType` /
/// `bizbanking.BusinessAccountType` enums already in this codebase — this
/// one classifies a *ledger* account in the double-entry Chart of Accounts
/// (Phase 6), not a personal or business bank/cash account.
enum LedgerAccountType { ASSET, LIABILITY, EQUITY, REVENUE, EXPENSE }

/// A single line in a space's Chart of Accounts. [systemDefault] just flags
/// an account that was created by `seed-defaults` — it stays fully editable
/// and archivable like any other account; the backend doesn't lock it.
/// [cashEquivalent] only means anything for an ASSET account: it marks it
/// as cash/bank-like so the Cash Flow report can find it.
@freezed
abstract class LedgerAccount with _$LedgerAccount {
  const factory LedgerAccount({
    required String id,
    required String code,
    required String name,
    required LedgerAccountType type,
    required bool systemDefault,
    required bool cashEquivalent,
    required bool archived,
  }) = _LedgerAccount;

  factory LedgerAccount.fromJson(Map<String, dynamic> json) => _$LedgerAccountFromJson(json);
}
