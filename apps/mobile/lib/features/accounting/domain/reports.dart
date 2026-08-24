import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/amount_converter.dart';
import 'chart_of_accounts.dart';
import 'journal_entries.dart';

part 'reports.freezed.dart';
part 'reports.g.dart';

@freezed
abstract class GeneralLedgerLine with _$GeneralLedgerLine {
  const factory GeneralLedgerLine({
    required String entryDate,
    required String journalEntryId,
    String? description,
    required LedgerDirection direction,
    @AmountConverter() required String amount,
    @AmountConverter() required String runningBalance,
  }) = _GeneralLedgerLine;

  factory GeneralLedgerLine.fromJson(Map<String, dynamic> json) => _$GeneralLedgerLineFromJson(json);
}

@freezed
abstract class GeneralLedgerReport with _$GeneralLedgerReport {
  const factory GeneralLedgerReport({
    required String accountId,
    required String accountCode,
    required String accountName,
    @AmountConverter() required String openingBalance,
    required List<GeneralLedgerLine> lines,
    @AmountConverter() required String closingBalance,
  }) = _GeneralLedgerReport;

  factory GeneralLedgerReport.fromJson(Map<String, dynamic> json) => _$GeneralLedgerReportFromJson(json);
}

@freezed
abstract class TrialBalanceLine with _$TrialBalanceLine {
  const factory TrialBalanceLine({
    required String accountId,
    required String accountCode,
    required String accountName,
    required LedgerAccountType type,
    @AmountConverter() required String debit,
    @AmountConverter() required String credit,
  }) = _TrialBalanceLine;

  factory TrialBalanceLine.fromJson(Map<String, dynamic> json) => _$TrialBalanceLineFromJson(json);
}

@freezed
abstract class TrialBalanceReport with _$TrialBalanceReport {
  const factory TrialBalanceReport({
    required String asOf,
    required List<TrialBalanceLine> lines,
    @AmountConverter() required String totalDebit,
    @AmountConverter() required String totalCredit,
  }) = _TrialBalanceReport;

  factory TrialBalanceReport.fromJson(Map<String, dynamic> json) => _$TrialBalanceReportFromJson(json);
}

/// Shared line shape for both the Income Statement's revenue/expense
/// sections and the Balance Sheet's assets/liabilities/equity sections.
@freezed
abstract class AccountAmountLine with _$AccountAmountLine {
  const factory AccountAmountLine({
    required String accountId,
    required String accountCode,
    required String accountName,
    @AmountConverter() required String amount,
  }) = _AccountAmountLine;

  factory AccountAmountLine.fromJson(Map<String, dynamic> json) => _$AccountAmountLineFromJson(json);
}

@freezed
abstract class IncomeStatementReport with _$IncomeStatementReport {
  const factory IncomeStatementReport({
    required String from,
    required String to,
    required List<AccountAmountLine> revenueLines,
    @AmountConverter() required String totalRevenue,
    required List<AccountAmountLine> expenseLines,
    @AmountConverter() required String totalExpenses,
    @AmountConverter() required String netIncome,
  }) = _IncomeStatementReport;

  factory IncomeStatementReport.fromJson(Map<String, dynamic> json) => _$IncomeStatementReportFromJson(json);
}

/// [currentEarnings] is real cumulative net income not yet formally closed
/// to Retained Earnings — a documented simplification of this phase, not a
/// bug — surfaced as its own equity line.
@freezed
abstract class BalanceSheetReport with _$BalanceSheetReport {
  const factory BalanceSheetReport({
    required String asOf,
    required List<AccountAmountLine> assets,
    @AmountConverter() required String totalAssets,
    required List<AccountAmountLine> liabilities,
    @AmountConverter() required String totalLiabilities,
    required List<AccountAmountLine> equity,
    @AmountConverter() required String totalEquity,
    @AmountConverter() required String currentEarnings,
    @AmountConverter() required String totalLiabilitiesAndEquity,
  }) = _BalanceSheetReport;

  factory BalanceSheetReport.fromJson(Map<String, dynamic> json) => _$BalanceSheetReportFromJson(json);
}

/// A direct-method summary over accounts flagged `cashEquivalent`, not a
/// full Operating/Investing/Financing categorization — a documented
/// simplification of this phase, not a bug.
@freezed
abstract class CashFlowReport with _$CashFlowReport {
  const factory CashFlowReport({
    required String from,
    required String to,
    @AmountConverter() required String openingCash,
    @AmountConverter() required String totalCashIn,
    @AmountConverter() required String totalCashOut,
    @AmountConverter() required String netChange,
    @AmountConverter() required String closingCash,
  }) = _CashFlowReport;

  factory CashFlowReport.fromJson(Map<String, dynamic> json) => _$CashFlowReportFromJson(json);
}
