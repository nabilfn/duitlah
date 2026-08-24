import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/providers.dart';
import '../data/accounting_export_repository.dart';
import '../data/chart_of_accounts_repository.dart';
import '../data/journal_entries_repository.dart';
import '../data/periods_repository.dart';
import '../data/reports_repository.dart';
import '../domain/chart_of_accounts.dart';
import '../domain/journal_entries.dart';
import '../domain/periods.dart';
import '../domain/reports.dart';

// ---- Repositories ---------------------------------------------------------

final chartOfAccountsRepositoryProvider = Provider((ref) => ChartOfAccountsRepository(ref.watch(apiClientProvider)));
final accountingPeriodsRepositoryProvider =
    Provider((ref) => AccountingPeriodsRepository(ref.watch(apiClientProvider)));
final journalEntriesRepositoryProvider = Provider((ref) => JournalEntriesRepository(ref.watch(apiClientProvider)));
final accountingReportsRepositoryProvider =
    Provider((ref) => AccountingReportsRepository(ref.watch(apiClientProvider)));
final accountingExportRepositoryProvider =
    Provider((ref) => AccountingExportRepository(ref.watch(apiClientProvider)));

// ---- Chart of Accounts ------------------------------------------------

final chartOfAccountsListProvider = FutureProvider.autoDispose.family<List<LedgerAccount>, String>(
  (ref, spaceId) => ref.watch(chartOfAccountsRepositoryProvider).listAccounts(spaceId),
);

// ---- Accounting periods -------------------------------------------------

final accountingPeriodListProvider = FutureProvider.autoDispose.family<List<AccountingPeriod>, String>(
  (ref, spaceId) => ref.watch(accountingPeriodsRepositoryProvider).list(spaceId),
);

// ---- Journal entries --------------------------------------------------

/// The resolved (never-null) date range a journal-entry list is filtered
/// by — the screen defaults this to the current month before it ever reads
/// the provider.
typedef JournalEntriesFilter = ({String spaceId, String from, String to});

final journalEntryListProvider = FutureProvider.autoDispose.family<List<JournalEntry>, JournalEntriesFilter>(
  (ref, filter) => ref.watch(journalEntriesRepositoryProvider).list(filter.spaceId, from: filter.from, to: filter.to),
);

// ---- Reports ------------------------------------------------------------

typedef GeneralLedgerFilter = ({String spaceId, String accountId, String from, String to});

final generalLedgerReportProvider = FutureProvider.autoDispose.family<GeneralLedgerReport, GeneralLedgerFilter>(
  (ref, f) => ref
      .watch(accountingReportsRepositoryProvider)
      .generalLedger(f.spaceId, accountId: f.accountId, from: f.from, to: f.to),
);

typedef AsOfFilter = ({String spaceId, String asOf});

final trialBalanceReportProvider = FutureProvider.autoDispose.family<TrialBalanceReport, AsOfFilter>(
  (ref, f) => ref.watch(accountingReportsRepositoryProvider).trialBalance(f.spaceId, asOf: f.asOf),
);

final balanceSheetReportProvider = FutureProvider.autoDispose.family<BalanceSheetReport, AsOfFilter>(
  (ref, f) => ref.watch(accountingReportsRepositoryProvider).balanceSheet(f.spaceId, asOf: f.asOf),
);

typedef DateRangeFilter = ({String spaceId, String from, String to});

final incomeStatementReportProvider = FutureProvider.autoDispose.family<IncomeStatementReport, DateRangeFilter>(
  (ref, f) => ref.watch(accountingReportsRepositoryProvider).incomeStatement(f.spaceId, from: f.from, to: f.to),
);

final cashFlowReportProvider = FutureProvider.autoDispose.family<CashFlowReport, DateRangeFilter>(
  (ref, f) => ref.watch(accountingReportsRepositoryProvider).cashFlow(f.spaceId, from: f.from, to: f.to),
);
