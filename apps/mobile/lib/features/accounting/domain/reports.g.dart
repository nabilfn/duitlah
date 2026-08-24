// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reports.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GeneralLedgerLine _$GeneralLedgerLineFromJson(Map<String, dynamic> json) =>
    _GeneralLedgerLine(
      entryDate: json['entryDate'] as String,
      journalEntryId: json['journalEntryId'] as String,
      description: json['description'] as String?,
      direction: $enumDecode(_$LedgerDirectionEnumMap, json['direction']),
      amount: const AmountConverter().fromJson(json['amount']),
      runningBalance: const AmountConverter().fromJson(json['runningBalance']),
    );

Map<String, dynamic> _$GeneralLedgerLineToJson(_GeneralLedgerLine instance) =>
    <String, dynamic>{
      'entryDate': instance.entryDate,
      'journalEntryId': instance.journalEntryId,
      'description': instance.description,
      'direction': _$LedgerDirectionEnumMap[instance.direction]!,
      'amount': const AmountConverter().toJson(instance.amount),
      'runningBalance': const AmountConverter().toJson(instance.runningBalance),
    };

const _$LedgerDirectionEnumMap = {
  LedgerDirection.DEBIT: 'DEBIT',
  LedgerDirection.CREDIT: 'CREDIT',
};

_GeneralLedgerReport _$GeneralLedgerReportFromJson(Map<String, dynamic> json) =>
    _GeneralLedgerReport(
      accountId: json['accountId'] as String,
      accountCode: json['accountCode'] as String,
      accountName: json['accountName'] as String,
      openingBalance: const AmountConverter().fromJson(json['openingBalance']),
      lines: (json['lines'] as List<dynamic>)
          .map((e) => GeneralLedgerLine.fromJson(e as Map<String, dynamic>))
          .toList(),
      closingBalance: const AmountConverter().fromJson(json['closingBalance']),
    );

Map<String, dynamic> _$GeneralLedgerReportToJson(
  _GeneralLedgerReport instance,
) => <String, dynamic>{
  'accountId': instance.accountId,
  'accountCode': instance.accountCode,
  'accountName': instance.accountName,
  'openingBalance': const AmountConverter().toJson(instance.openingBalance),
  'lines': instance.lines,
  'closingBalance': const AmountConverter().toJson(instance.closingBalance),
};

_TrialBalanceLine _$TrialBalanceLineFromJson(Map<String, dynamic> json) =>
    _TrialBalanceLine(
      accountId: json['accountId'] as String,
      accountCode: json['accountCode'] as String,
      accountName: json['accountName'] as String,
      type: $enumDecode(_$LedgerAccountTypeEnumMap, json['type']),
      debit: const AmountConverter().fromJson(json['debit']),
      credit: const AmountConverter().fromJson(json['credit']),
    );

Map<String, dynamic> _$TrialBalanceLineToJson(_TrialBalanceLine instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'accountCode': instance.accountCode,
      'accountName': instance.accountName,
      'type': _$LedgerAccountTypeEnumMap[instance.type]!,
      'debit': const AmountConverter().toJson(instance.debit),
      'credit': const AmountConverter().toJson(instance.credit),
    };

const _$LedgerAccountTypeEnumMap = {
  LedgerAccountType.ASSET: 'ASSET',
  LedgerAccountType.LIABILITY: 'LIABILITY',
  LedgerAccountType.EQUITY: 'EQUITY',
  LedgerAccountType.REVENUE: 'REVENUE',
  LedgerAccountType.EXPENSE: 'EXPENSE',
};

_TrialBalanceReport _$TrialBalanceReportFromJson(Map<String, dynamic> json) =>
    _TrialBalanceReport(
      asOf: json['asOf'] as String,
      lines: (json['lines'] as List<dynamic>)
          .map((e) => TrialBalanceLine.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalDebit: const AmountConverter().fromJson(json['totalDebit']),
      totalCredit: const AmountConverter().fromJson(json['totalCredit']),
    );

Map<String, dynamic> _$TrialBalanceReportToJson(_TrialBalanceReport instance) =>
    <String, dynamic>{
      'asOf': instance.asOf,
      'lines': instance.lines,
      'totalDebit': const AmountConverter().toJson(instance.totalDebit),
      'totalCredit': const AmountConverter().toJson(instance.totalCredit),
    };

_AccountAmountLine _$AccountAmountLineFromJson(Map<String, dynamic> json) =>
    _AccountAmountLine(
      accountId: json['accountId'] as String,
      accountCode: json['accountCode'] as String,
      accountName: json['accountName'] as String,
      amount: const AmountConverter().fromJson(json['amount']),
    );

Map<String, dynamic> _$AccountAmountLineToJson(_AccountAmountLine instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'accountCode': instance.accountCode,
      'accountName': instance.accountName,
      'amount': const AmountConverter().toJson(instance.amount),
    };

_IncomeStatementReport _$IncomeStatementReportFromJson(
  Map<String, dynamic> json,
) => _IncomeStatementReport(
  from: json['from'] as String,
  to: json['to'] as String,
  revenueLines: (json['revenueLines'] as List<dynamic>)
      .map((e) => AccountAmountLine.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalRevenue: const AmountConverter().fromJson(json['totalRevenue']),
  expenseLines: (json['expenseLines'] as List<dynamic>)
      .map((e) => AccountAmountLine.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalExpenses: const AmountConverter().fromJson(json['totalExpenses']),
  netIncome: const AmountConverter().fromJson(json['netIncome']),
);

Map<String, dynamic> _$IncomeStatementReportToJson(
  _IncomeStatementReport instance,
) => <String, dynamic>{
  'from': instance.from,
  'to': instance.to,
  'revenueLines': instance.revenueLines,
  'totalRevenue': const AmountConverter().toJson(instance.totalRevenue),
  'expenseLines': instance.expenseLines,
  'totalExpenses': const AmountConverter().toJson(instance.totalExpenses),
  'netIncome': const AmountConverter().toJson(instance.netIncome),
};

_BalanceSheetReport _$BalanceSheetReportFromJson(
  Map<String, dynamic> json,
) => _BalanceSheetReport(
  asOf: json['asOf'] as String,
  assets: (json['assets'] as List<dynamic>)
      .map((e) => AccountAmountLine.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalAssets: const AmountConverter().fromJson(json['totalAssets']),
  liabilities: (json['liabilities'] as List<dynamic>)
      .map((e) => AccountAmountLine.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalLiabilities: const AmountConverter().fromJson(json['totalLiabilities']),
  equity: (json['equity'] as List<dynamic>)
      .map((e) => AccountAmountLine.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalEquity: const AmountConverter().fromJson(json['totalEquity']),
  currentEarnings: const AmountConverter().fromJson(json['currentEarnings']),
  totalLiabilitiesAndEquity: const AmountConverter().fromJson(
    json['totalLiabilitiesAndEquity'],
  ),
);

Map<String, dynamic> _$BalanceSheetReportToJson(
  _BalanceSheetReport instance,
) => <String, dynamic>{
  'asOf': instance.asOf,
  'assets': instance.assets,
  'totalAssets': const AmountConverter().toJson(instance.totalAssets),
  'liabilities': instance.liabilities,
  'totalLiabilities': const AmountConverter().toJson(instance.totalLiabilities),
  'equity': instance.equity,
  'totalEquity': const AmountConverter().toJson(instance.totalEquity),
  'currentEarnings': const AmountConverter().toJson(instance.currentEarnings),
  'totalLiabilitiesAndEquity': const AmountConverter().toJson(
    instance.totalLiabilitiesAndEquity,
  ),
};

_CashFlowReport _$CashFlowReportFromJson(Map<String, dynamic> json) =>
    _CashFlowReport(
      from: json['from'] as String,
      to: json['to'] as String,
      openingCash: const AmountConverter().fromJson(json['openingCash']),
      totalCashIn: const AmountConverter().fromJson(json['totalCashIn']),
      totalCashOut: const AmountConverter().fromJson(json['totalCashOut']),
      netChange: const AmountConverter().fromJson(json['netChange']),
      closingCash: const AmountConverter().fromJson(json['closingCash']),
    );

Map<String, dynamic> _$CashFlowReportToJson(_CashFlowReport instance) =>
    <String, dynamic>{
      'from': instance.from,
      'to': instance.to,
      'openingCash': const AmountConverter().toJson(instance.openingCash),
      'totalCashIn': const AmountConverter().toJson(instance.totalCashIn),
      'totalCashOut': const AmountConverter().toJson(instance.totalCashOut),
      'netChange': const AmountConverter().toJson(instance.netChange),
      'closingCash': const AmountConverter().toJson(instance.closingCash),
    };
