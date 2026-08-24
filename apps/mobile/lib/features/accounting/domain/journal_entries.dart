// ignore_for_file: constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/amount_converter.dart';

part 'journal_entries.freezed.dart';
part 'journal_entries.g.dart';

enum LedgerDirection { DEBIT, CREDIT }

/// MANUAL is the only source type a user creates directly through this
/// module's "New manual entry" form; the other four are posted
/// automatically by the `business` feature's invoice/expense actions once a
/// `BusinessAccount`/`Expense` is mapped to a ledger account (see
/// `chartOfAccountsId` on those models) and are shown read-only here.
enum JournalSourceType { MANUAL, INVOICE_ISSUED, INVOICE_PAYMENT, EXPENSE_PAYMENT, CREDIT_NOTE }

@freezed
abstract class JournalEntryLine with _$JournalEntryLine {
  const factory JournalEntryLine({
    required String id,
    required String accountId,
    required String accountCode,
    required String accountName,
    required LedgerDirection direction,
    @AmountConverter() required String amount,
    String? description,
  }) = _JournalEntryLine;

  factory JournalEntryLine.fromJson(Map<String, dynamic> json) => _$JournalEntryLineFromJson(json);
}

@freezed
abstract class JournalEntry with _$JournalEntry {
  const factory JournalEntry({
    required String id,
    required String entryDate,
    required String description,
    required JournalSourceType sourceType,
    String? sourceId,
    required List<JournalEntryLine> lines,
  }) = _JournalEntry;

  factory JournalEntry.fromJson(Map<String, dynamic> json) => _$JournalEntryFromJson(json);
}

/// One line in the "New manual entry" form's request payload — kept
/// separate from [JournalEntryLine] (the server's response shape, which
/// echoes back resolved `accountCode`/`accountName`) since the request only
/// ever needs the account id.
class JournalEntryLineInput {
  JournalEntryLineInput({
    required this.accountId,
    required this.direction,
    required this.amount,
    this.description,
  });

  final String accountId;
  final LedgerDirection direction;
  final String amount;
  final String? description;

  Map<String, dynamic> toJson() => {
        'accountId': accountId,
        'direction': direction.name,
        'amount': amount,
        if (description != null) 'description': description,
      };
}
