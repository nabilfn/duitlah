/// Central path registry — screens navigate via these constants rather
/// than hand-typed strings scattered across the app.
class AppRoutes {
  AppRoutes._();

  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';

  static const home = '/home';
  static const transactions = '/transactions';
  static const bagilah = '/bagilah';
  static const groups = '/groups';
  static const more = '/more';

  static const bagilahCreate = '/bagilah/create';
  static const bagilahScan = '/bagilah/scan';
  static const bagilahQrScan = '/bagilah/scan-qr';
  static String bagilahDetail(String id) => '/bagilah/$id';
  static String bagilahReview(String scanId) => '/bagilah/review/$scanId';

  /// The universal-link path itself (matches
  /// `apps/web/src/lib/bagilah-invite.ts`'s `buildBagilahInviteUrl`) —
  /// resolves to the guest flow for an unauthenticated user, or joins
  /// directly for an authenticated one.
  static const bagilahJoin = '/bagilah/join';
  static String bagilahGuest(String billId) => '/bagilah/guest/$billId';

  static String groupDetail(String id) => '/groups/$id';
  static const groupCreate = '/groups/create';
  static const groupJoin = '/groups/join';

  static const settlements = '/settlements';
  static const accounts = '/accounts';
  static const budgets = '/budgets';
  static const goals = '/goals';
  static const profile = '/profile';
  static const notifications = '/notifications';

  static const recurring = '/recurring';
  static const calendar = '/calendar';
  static const insights = '/insights';
  static const assistant = '/assistant';
  static const duitlahPlus = '/duitlah-plus';
  static const helpSupport = '/help-support';
  static const feedback = '/feedback';

  static const spaces = '/spaces';
  static const createBusinessSpace = '/spaces/create-business';
  static String businessProfile(String spaceId) => '/spaces/$spaceId/business-profile';
  static String businessTeam(String spaceId) => '/spaces/$spaceId/team';

  // Phase 5 — Business Core. Every one of these is scoped by the business
  // space id (a [FinancialSpace.id] of type BUSINESS), reached by tapping
  // into a business space from the Workspaces screen — never from the flat
  // More menu, since none of this makes sense outside a specific business.
  static String businessDashboard(String spaceId) => '/spaces/$spaceId/business';
  static String businessCustomers(String spaceId) => '/spaces/$spaceId/business/customers';
  static String businessSuppliers(String spaceId) => '/spaces/$spaceId/business/suppliers';
  static String businessProducts(String spaceId) => '/spaces/$spaceId/business/products';
  static String businessAccounts(String spaceId) => '/spaces/$spaceId/business/accounts';
  static String businessAccountDetail(String spaceId, String accountId) =>
      '/spaces/$spaceId/business/accounts/$accountId';
  static String businessExpenses(String spaceId) => '/spaces/$spaceId/business/expenses';
  static String businessExpenseDetail(String spaceId, String expenseId) =>
      '/spaces/$spaceId/business/expenses/$expenseId';
  static String businessQuotations(String spaceId) => '/spaces/$spaceId/business/quotations';
  static String businessQuotationDetail(String spaceId, String quotationId) =>
      '/spaces/$spaceId/business/quotations/$quotationId';
  static String businessInvoices(String spaceId) => '/spaces/$spaceId/business/invoices';
  static String businessInvoiceDetail(String spaceId, String invoiceId) =>
      '/spaces/$spaceId/business/invoices/$invoiceId';
  static String businessCreditNotes(String spaceId) => '/spaces/$spaceId/business/credit-notes';
  static String businessRecurringInvoices(String spaceId) => '/spaces/$spaceId/business/recurring-invoices';

  // Phase 6 — Business Accounting Engine. Scoped by the same business space
  // id as the Phase 5 routes above, reached via the Business Dashboard's
  // "Accounting" tile.
  static String accountingHub(String spaceId) => '/spaces/$spaceId/accounting';
  static String accountingChartOfAccounts(String spaceId) => '/spaces/$spaceId/accounting/chart-of-accounts';
  static String accountingPeriods(String spaceId) => '/spaces/$spaceId/accounting/periods';
  static String accountingJournalEntries(String spaceId) => '/spaces/$spaceId/accounting/journal-entries';
  static String accountingReports(String spaceId) => '/spaces/$spaceId/accounting/reports';
  static String accountingGeneralLedger(String spaceId) => '/spaces/$spaceId/accounting/reports/general-ledger';
  static String accountingTrialBalance(String spaceId) => '/spaces/$spaceId/accounting/reports/trial-balance';
  static String accountingIncomeStatement(String spaceId) => '/spaces/$spaceId/accounting/reports/income-statement';
  static String accountingBalanceSheet(String spaceId) => '/spaces/$spaceId/accounting/reports/balance-sheet';
  static String accountingCashFlow(String spaceId) => '/spaces/$spaceId/accounting/reports/cash-flow';

  // Phase 7 — Reconciliation. Scoped by the same business space id as
  // Phase 5/6's routes above, reached via the Business Dashboard's
  // "Reconciliation" tile.
  static String reconciliationHub(String spaceId) => '/spaces/$spaceId/reconciliation';
  static String reconciliationSession(String spaceId, String sessionId) =>
      '/spaces/$spaceId/reconciliation/sessions/$sessionId';

  // Phase 8 — Inventory & Costing. Scoped by the same business space id as
  // Phase 5/6/7's routes above, reached via the Business Dashboard's
  // "Inventory" tile.
  static String inventoryHub(String spaceId) => '/spaces/$spaceId/inventory';
  static String inventoryProductDetail(String spaceId, String productId) =>
      '/spaces/$spaceId/inventory/products/$productId';

  // Phase 9 — Fixed Assets. Scoped by the same business space id as
  // Phase 5/6/7/8's routes above, reached via the Business Dashboard's
  // "Fixed Assets" tile.
  static String assetsHub(String spaceId) => '/spaces/$spaceId/assets';
  static String assetDetail(String spaceId, String assetId) => '/spaces/$spaceId/assets/$assetId';

  // Phase 10 — LHDN / MyInvois / SST (Business Tax). Scoped by the same
  // business space id as Phase 5/6/7/8/9's routes above, reached via the
  // Business Dashboard's "Business Tax" tile. The e-Invoice workflow itself
  // has no separate route — it's a section on the existing invoice detail
  // screen (`businessInvoiceDetail` above).
  static String businessTaxHub(String spaceId) => '/spaces/$spaceId/business-tax';

  // Phase 11 — Cross-Space Accounting. Scoped by the same business space id
  // as Phase 5/6/7/8/9/10's routes above, reached via the Business
  // Dashboard's "Owner Transactions" tile. Links an already-existing
  // Personal transaction to a business action without merging the two
  // ledgers.
  static String crossSpaceHub(String spaceId) => '/spaces/$spaceId/crossspace';

  // Combined Net Worth (Phase 11) is deliberately NOT space-specific — it
  // aggregates the user's Personal net worth plus every business they own
  // at once, so it's reached from the More menu rather than any one
  // space's context (unlike every route above it).
  static const combinedNetWorth = '/crossspace/net-worth';

  static const autoTrackReview = '/autotrack/review';
  static const statementImport = '/autotrack/import-statement';
  static const receiptVault = '/receipts/vault';
  static const transactionRules = '/transaction-rules';
  static const notificationRules = '/notification-rules';

  static const bills = '/bills';
  static const liabilities = '/liabilities';
  static const netWorth = '/net-worth';
  static const financialHealth = '/financial-health';
  static const exports = '/exports';

  static const personalTax = '/personal-tax';
  static const personalTaxIncome = '/personal-tax/income';
  static const personalTaxPcb = '/personal-tax/pcb';
  static const personalTaxZakat = '/personal-tax/zakat';
  static const personalTaxReliefs = '/personal-tax/reliefs';
  static const personalTaxDocuments = '/personal-tax/documents';
  static String receiptVaultDetail(String receiptId) => '/receipts/vault/$receiptId';
}
