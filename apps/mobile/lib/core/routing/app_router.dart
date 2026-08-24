import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/accounts/presentation/accounts_screen.dart';
import '../../features/assistant/presentation/assistant_screen.dart';
import '../../features/auth/application/auth_state.dart';
import '../../features/autotrack/presentation/autotrack_candidates_screen.dart';
import '../../features/autotrack/presentation/statement_import_screen.dart';
import '../../features/bills/presentation/bills_screen.dart';
import '../../features/business/presentation/business_account_detail_screen.dart';
import '../../features/business/presentation/business_accounts_screen.dart';
import '../../features/business/presentation/business_dashboard_screen.dart';
import '../../features/business/presentation/contacts_screen.dart';
import '../../features/business/presentation/credit_notes_screen.dart';
import '../../features/business/presentation/expense_detail_screen.dart';
import '../../features/business/presentation/expenses_screen.dart';
import '../../features/business/presentation/invoice_detail_screen.dart';
import '../../features/business/presentation/invoices_screen.dart';
import '../../features/business/presentation/products_screen.dart';
import '../../features/business/presentation/quotation_detail_screen.dart';
import '../../features/business/presentation/quotations_screen.dart';
import '../../features/business/presentation/recurring_invoices_screen.dart';
import '../../features/accounting/presentation/accounting_hub_screen.dart';
import '../../features/accounting/presentation/accounting_periods_screen.dart';
import '../../features/accounting/presentation/balance_sheet_screen.dart';
import '../../features/accounting/presentation/cash_flow_screen.dart';
import '../../features/accounting/presentation/chart_of_accounts_screen.dart';
import '../../features/accounting/presentation/general_ledger_screen.dart';
import '../../features/accounting/presentation/income_statement_screen.dart';
import '../../features/accounting/presentation/journal_entries_screen.dart';
import '../../features/accounting/presentation/reports_hub_screen.dart';
import '../../features/accounting/presentation/trial_balance_screen.dart';
import '../../features/exports/presentation/exports_screen.dart';
import '../../features/finhealth/presentation/financial_health_screen.dart';
import '../../features/liabilities/presentation/liabilities_screen.dart';
import '../../features/networth/presentation/net_worth_screen.dart';
import '../../features/personaltax/presentation/pcb_screen.dart';
import '../../features/personaltax/presentation/personal_income_screen.dart';
import '../../features/personaltax/presentation/personal_tax_screen.dart';
import '../../features/personaltax/presentation/tax_documents_screen.dart';
import '../../features/personaltax/presentation/tax_reliefs_screen.dart';
import '../../features/personaltax/presentation/zakat_screen.dart';
import '../../features/reconciliation/presentation/reconciliation_hub_screen.dart';
import '../../features/reconciliation/presentation/reconciliation_session_screen.dart';
import '../../features/inventory/presentation/inventory_hub_screen.dart';
import '../../features/inventory/presentation/product_inventory_screen.dart';
import '../../features/assets/presentation/assets_hub_screen.dart';
import '../../features/assets/presentation/asset_detail_screen.dart';
import '../../features/business_tax/presentation/business_tax_hub_screen.dart';
import '../../features/crossspace/presentation/combined_net_worth_screen.dart';
import '../../features/crossspace/presentation/cross_space_hub_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/bagilah/presentation/bagilah_join_screen.dart';
import '../../features/bagilah/presentation/bill_detail_screen.dart';
import '../../features/bagilah/presentation/bills_list_screen.dart';
import '../../features/bagilah/presentation/create_bill_screen.dart';
import '../../features/bagilah/presentation/guest_bill_screen.dart';
import '../../features/bagilah/presentation/qr_scan_screen.dart';
import '../../features/bagilah/presentation/receipt_capture_screen.dart';
import '../../features/bagilah/presentation/receipt_review_screen.dart';
import '../../features/budgets/presentation/budgets_screen.dart';
import '../../features/feedback/presentation/feedback_screen.dart';
import '../../features/feedback/presentation/help_support_screen.dart';
import '../../features/goals/presentation/goals_screen.dart';
import '../../features/groups/presentation/create_group_screen.dart';
import '../../features/groups/presentation/group_detail_screen.dart';
import '../../features/groups/presentation/groups_list_screen.dart';
import '../../features/groups/presentation/join_group_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/home/presentation/more_menu_screen.dart';
import '../../features/insights/presentation/calendar_screen.dart';
import '../../features/insights/presentation/insights_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/notificationrules/presentation/notification_rules_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/receipts/presentation/receipt_vault_screen.dart';
import '../../features/receipts/presentation/vault_receipt_detail_screen.dart';
import '../../features/recurring/presentation/recurring_transactions_screen.dart';
import '../../features/settlements/presentation/settlements_screen.dart';
import '../../features/spaces/presentation/business_profile_screen.dart';
import '../../features/spaces/presentation/create_business_space_screen.dart';
import '../../features/spaces/presentation/spaces_screen.dart';
import '../../features/spaces/presentation/team_screen.dart';
import '../../features/subscriptions/presentation/duitlah_plus_screen.dart';
import '../../features/transactionrules/presentation/transaction_rules_screen.dart';
import '../../features/transactions/presentation/transactions_screen.dart';
import '../api/providers.dart';
import 'app_routes.dart';
import 'main_shell.dart';

class _RouterRefreshNotifier extends ChangeNotifier {
  void notify() => notifyListeners();
}

final _routerRefreshProvider = Provider<_RouterRefreshNotifier>((ref) {
  final notifier = _RouterRefreshNotifier();
  ref.listen(authProvider, (_, _) => notifier.notify());
  return notifier;
});

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ref.watch(_routerRefreshProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refresh,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final atSplash = state.matchedLocation == AppRoutes.splash;
      final loggingIn = state.matchedLocation == AppRoutes.login || state.matchedLocation == AppRoutes.register;
      final isGuestOrJoinRoute = state.matchedLocation.startsWith('/bagilah/guest') ||
          state.matchedLocation.startsWith(AppRoutes.bagilahJoin);

      // While auth is still bootstrapping (trading the persisted refresh
      // cookie for a fresh access token), every other route gets parked on
      // a splash screen instead of building real, data-fetching widgets —
      // otherwise Home would render immediately at `initialLocation` and
      // fire live API calls with no access token yet, flashing a raw
      // "Authentication required" error before either succeeding or
      // redirecting to login.
      return authState.when(
        loading: () => atSplash ? null : AppRoutes.splash,
        unauthenticated: () => (loggingIn || isGuestOrJoinRoute) ? null : AppRoutes.login,
        authenticated: (_) => (loggingIn || atSplash) ? AppRoutes.home : null,
      );
    },
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (context, state) => const SplashScreen()),
      GoRoute(path: AppRoutes.login, builder: (context, state) => const LoginScreen()),
      GoRoute(path: AppRoutes.register, builder: (context, state) => const RegisterScreen()),
      GoRoute(
        path: AppRoutes.bagilahJoin,
        builder: (context, state) => BagilahJoinScreen(token: state.uri.queryParameters['token'] ?? ''),
      ),
      GoRoute(
        path: '/bagilah/guest/:billId',
        builder: (context, state) => GuestBillScreen(billId: state.pathParameters['billId']!),
      ),
      GoRoute(path: AppRoutes.bagilahQrScan, builder: (context, state) => const QrScanScreen()),
      GoRoute(path: AppRoutes.bagilahCreate, builder: (context, state) => const CreateBillScreen()),
      GoRoute(path: AppRoutes.bagilahScan, builder: (context, state) => const ReceiptCaptureScreen()),
      GoRoute(
        path: '/bagilah/review/:scanId',
        builder: (context, state) => ReceiptReviewScreen(scanId: state.pathParameters['scanId']!),
      ),
      GoRoute(
        path: '/bagilah/:id',
        builder: (context, state) => BillDetailScreen(billId: state.pathParameters['id']!),
      ),
      GoRoute(path: AppRoutes.groupCreate, builder: (context, state) => const CreateGroupScreen()),
      GoRoute(path: AppRoutes.groupJoin, builder: (context, state) => const JoinGroupScreen()),
      GoRoute(
        path: '/groups/:id',
        builder: (context, state) => GroupDetailScreen(groupId: state.pathParameters['id']!),
      ),
      GoRoute(path: AppRoutes.settlements, builder: (context, state) => const SettlementsScreen()),
      GoRoute(path: AppRoutes.accounts, builder: (context, state) => const AccountsScreen()),
      GoRoute(path: AppRoutes.budgets, builder: (context, state) => const BudgetsScreen()),
      GoRoute(path: AppRoutes.goals, builder: (context, state) => const GoalsScreen()),
      GoRoute(path: AppRoutes.profile, builder: (context, state) => const ProfileScreen()),
      GoRoute(path: AppRoutes.notifications, builder: (context, state) => const NotificationsScreen()),
      GoRoute(path: AppRoutes.recurring, builder: (context, state) => const RecurringTransactionsScreen()),
      GoRoute(path: AppRoutes.calendar, builder: (context, state) => const CalendarScreen()),
      GoRoute(path: AppRoutes.insights, builder: (context, state) => const InsightsScreen()),
      GoRoute(path: AppRoutes.assistant, builder: (context, state) => const AssistantScreen()),
      GoRoute(path: AppRoutes.duitlahPlus, builder: (context, state) => const DuitlahPlusScreen()),
      GoRoute(path: AppRoutes.helpSupport, builder: (context, state) => const HelpSupportScreen()),
      GoRoute(path: AppRoutes.feedback, builder: (context, state) => const FeedbackScreen()),
      GoRoute(path: AppRoutes.spaces, builder: (context, state) => const SpacesScreen()),
      GoRoute(
        path: AppRoutes.createBusinessSpace,
        builder: (context, state) => const CreateBusinessSpaceScreen(),
      ),
      GoRoute(
        path: '/spaces/:spaceId/business-profile',
        builder: (context, state) =>
            BusinessProfileScreen(spaceId: state.pathParameters['spaceId']!),
      ),
      GoRoute(
        path: '/spaces/:spaceId/team',
        builder: (context, state) => TeamScreen(spaceId: state.pathParameters['spaceId']!),
      ),
      // Phase 5 — Business Core. Every route below is scoped by :spaceId (a
      // business space's FinancialSpace.id).
      GoRoute(
        path: '/spaces/:spaceId/business',
        builder: (context, state) => BusinessDashboardScreen(spaceId: state.pathParameters['spaceId']!),
      ),
      GoRoute(
        path: '/spaces/:spaceId/business/customers',
        builder: (context, state) => CustomersScreen(spaceId: state.pathParameters['spaceId']!),
      ),
      GoRoute(
        path: '/spaces/:spaceId/business/suppliers',
        builder: (context, state) => SuppliersScreen(spaceId: state.pathParameters['spaceId']!),
      ),
      GoRoute(
        path: '/spaces/:spaceId/business/products',
        builder: (context, state) => ProductsScreen(spaceId: state.pathParameters['spaceId']!),
      ),
      GoRoute(
        path: '/spaces/:spaceId/business/accounts',
        builder: (context, state) => BusinessAccountsScreen(spaceId: state.pathParameters['spaceId']!),
      ),
      GoRoute(
        path: '/spaces/:spaceId/business/accounts/:accountId',
        builder: (context, state) => BusinessAccountDetailScreen(
          spaceId: state.pathParameters['spaceId']!,
          accountId: state.pathParameters['accountId']!,
        ),
      ),
      GoRoute(
        path: '/spaces/:spaceId/business/expenses',
        builder: (context, state) => ExpensesScreen(spaceId: state.pathParameters['spaceId']!),
      ),
      GoRoute(
        path: '/spaces/:spaceId/business/expenses/:expenseId',
        builder: (context, state) => ExpenseDetailScreen(
          spaceId: state.pathParameters['spaceId']!,
          expenseId: state.pathParameters['expenseId']!,
        ),
      ),
      GoRoute(
        path: '/spaces/:spaceId/business/quotations',
        builder: (context, state) => QuotationsScreen(spaceId: state.pathParameters['spaceId']!),
      ),
      GoRoute(
        path: '/spaces/:spaceId/business/quotations/:quotationId',
        builder: (context, state) => QuotationDetailScreen(
          spaceId: state.pathParameters['spaceId']!,
          quotationId: state.pathParameters['quotationId']!,
        ),
      ),
      GoRoute(
        path: '/spaces/:spaceId/business/invoices',
        builder: (context, state) => InvoicesScreen(spaceId: state.pathParameters['spaceId']!),
      ),
      GoRoute(
        path: '/spaces/:spaceId/business/invoices/:invoiceId',
        builder: (context, state) => InvoiceDetailScreen(
          spaceId: state.pathParameters['spaceId']!,
          invoiceId: state.pathParameters['invoiceId']!,
        ),
      ),
      GoRoute(
        path: '/spaces/:spaceId/business/recurring-invoices',
        builder: (context, state) => RecurringInvoicesScreen(spaceId: state.pathParameters['spaceId']!),
      ),
      GoRoute(
        path: '/spaces/:spaceId/business/credit-notes',
        builder: (context, state) {
          // Launched with `extra: {'customerId': ..., 'invoiceId': ...}`
          // from an invoice's detail screen ("Issue credit note") to
          // pre-fill the create form; standalone navigation (from the
          // dashboard) omits `extra` entirely.
          final extra = state.extra as Map<String, dynamic>?;
          return CreditNotesScreen(
            spaceId: state.pathParameters['spaceId']!,
            prefillCustomerId: extra?['customerId'] as String?,
            prefillInvoiceId: extra?['invoiceId'] as String?,
          );
        },
      ),
      // Phase 6 — Business Accounting Engine. Every route below is scoped
      // by :spaceId (the same business space id as Phase 5's routes above).
      GoRoute(
        path: '/spaces/:spaceId/accounting',
        builder: (context, state) => AccountingHubScreen(spaceId: state.pathParameters['spaceId']!),
      ),
      GoRoute(
        path: '/spaces/:spaceId/accounting/chart-of-accounts',
        builder: (context, state) => ChartOfAccountsScreen(spaceId: state.pathParameters['spaceId']!),
      ),
      GoRoute(
        path: '/spaces/:spaceId/accounting/periods',
        builder: (context, state) => AccountingPeriodsScreen(spaceId: state.pathParameters['spaceId']!),
      ),
      GoRoute(
        path: '/spaces/:spaceId/accounting/journal-entries',
        builder: (context, state) => JournalEntriesScreen(spaceId: state.pathParameters['spaceId']!),
      ),
      GoRoute(
        path: '/spaces/:spaceId/accounting/reports',
        builder: (context, state) => ReportsHubScreen(spaceId: state.pathParameters['spaceId']!),
      ),
      GoRoute(
        path: '/spaces/:spaceId/accounting/reports/general-ledger',
        builder: (context, state) => GeneralLedgerScreen(spaceId: state.pathParameters['spaceId']!),
      ),
      GoRoute(
        path: '/spaces/:spaceId/accounting/reports/trial-balance',
        builder: (context, state) => TrialBalanceScreen(spaceId: state.pathParameters['spaceId']!),
      ),
      GoRoute(
        path: '/spaces/:spaceId/accounting/reports/income-statement',
        builder: (context, state) => IncomeStatementScreen(spaceId: state.pathParameters['spaceId']!),
      ),
      GoRoute(
        path: '/spaces/:spaceId/accounting/reports/balance-sheet',
        builder: (context, state) => BalanceSheetScreen(spaceId: state.pathParameters['spaceId']!),
      ),
      GoRoute(
        path: '/spaces/:spaceId/accounting/reports/cash-flow',
        builder: (context, state) => CashFlowScreen(spaceId: state.pathParameters['spaceId']!),
      ),
      // Phase 7 — Reconciliation. Scoped by the same business space id as
      // Phase 5/6's routes above.
      GoRoute(
        path: '/spaces/:spaceId/reconciliation',
        builder: (context, state) => ReconciliationHubScreen(spaceId: state.pathParameters['spaceId']!),
      ),
      GoRoute(
        path: '/spaces/:spaceId/reconciliation/sessions/:sessionId',
        builder: (context, state) => ReconciliationSessionScreen(
          spaceId: state.pathParameters['spaceId']!,
          sessionId: state.pathParameters['sessionId']!,
        ),
      ),
      // Phase 8 — Inventory & Costing. Scoped by the same business space id
      // as Phase 5/6/7's routes above.
      GoRoute(
        path: '/spaces/:spaceId/inventory',
        builder: (context, state) => InventoryHubScreen(spaceId: state.pathParameters['spaceId']!),
      ),
      GoRoute(
        path: '/spaces/:spaceId/inventory/products/:productId',
        builder: (context, state) => ProductInventoryScreen(
          spaceId: state.pathParameters['spaceId']!,
          productId: state.pathParameters['productId']!,
        ),
      ),
      // Phase 9 — Fixed Assets. Scoped by the same business space id as
      // Phase 5/6/7/8's routes above.
      GoRoute(
        path: '/spaces/:spaceId/assets',
        builder: (context, state) => AssetsHubScreen(spaceId: state.pathParameters['spaceId']!),
      ),
      GoRoute(
        path: '/spaces/:spaceId/assets/:assetId',
        builder: (context, state) => AssetDetailScreen(
          spaceId: state.pathParameters['spaceId']!,
          assetId: state.pathParameters['assetId']!,
        ),
      ),
      // Phase 10 — LHDN / MyInvois / SST (Business Tax). Scoped by the same
      // business space id as Phase 5/6/7/8/9's routes above.
      GoRoute(
        path: '/spaces/:spaceId/business-tax',
        builder: (context, state) => BusinessTaxHubScreen(spaceId: state.pathParameters['spaceId']!),
      ),
      // Phase 11 — Cross-Space Accounting. Scoped by the same business
      // space id as Phase 5/6/7/8/9/10's routes above.
      GoRoute(
        path: '/spaces/:spaceId/crossspace',
        builder: (context, state) => CrossSpaceHubScreen(spaceId: state.pathParameters['spaceId']!),
      ),
      GoRoute(
        path: AppRoutes.autoTrackReview,
        builder: (context, state) => const AutoTrackCandidatesScreen(),
      ),
      GoRoute(
        path: AppRoutes.statementImport,
        builder: (context, state) => const StatementImportScreen(),
      ),
      GoRoute(path: AppRoutes.receiptVault, builder: (context, state) => const ReceiptVaultScreen()),
      GoRoute(path: AppRoutes.transactionRules, builder: (context, state) => const TransactionRulesScreen()),
      GoRoute(path: AppRoutes.notificationRules, builder: (context, state) => const NotificationRulesScreen()),
      GoRoute(path: AppRoutes.bills, builder: (context, state) => const BillsScreen()),
      GoRoute(path: AppRoutes.liabilities, builder: (context, state) => const LiabilitiesScreen()),
      GoRoute(path: AppRoutes.netWorth, builder: (context, state) => const NetWorthScreen()),
      GoRoute(path: AppRoutes.combinedNetWorth, builder: (context, state) => const CombinedNetWorthScreen()),
      GoRoute(path: AppRoutes.financialHealth, builder: (context, state) => const FinancialHealthScreen()),
      GoRoute(path: AppRoutes.exports, builder: (context, state) => const ExportsScreen()),
      GoRoute(path: AppRoutes.personalTax, builder: (context, state) => const PersonalTaxScreen()),
      GoRoute(path: AppRoutes.personalTaxIncome, builder: (context, state) => const PersonalIncomeScreen()),
      GoRoute(path: AppRoutes.personalTaxPcb, builder: (context, state) => const PcbScreen()),
      GoRoute(path: AppRoutes.personalTaxZakat, builder: (context, state) => const ZakatScreen()),
      GoRoute(path: AppRoutes.personalTaxReliefs, builder: (context, state) => const TaxReliefsScreen()),
      GoRoute(path: AppRoutes.personalTaxDocuments, builder: (context, state) => const TaxDocumentsScreen()),
      GoRoute(
        path: '/receipts/vault/:receiptId',
        builder: (context, state) =>
            VaultReceiptDetailScreen(receiptId: state.pathParameters['receiptId']!),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: AppRoutes.home, builder: (context, state) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: AppRoutes.transactions, builder: (context, state) => const TransactionsScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: AppRoutes.bagilah, builder: (context, state) => const BillsListScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: AppRoutes.groups, builder: (context, state) => const GroupsListScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: AppRoutes.more, builder: (context, state) => const MoreMenuScreen()),
          ]),
        ],
      ),
    ],
  );
});
