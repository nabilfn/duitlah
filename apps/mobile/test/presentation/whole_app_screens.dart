import 'package:flutter/material.dart';
import 'package:duitlah_mobile/features/accounting/presentation/accounting_hub_screen.dart';
import 'package:duitlah_mobile/features/accounting/presentation/accounting_periods_screen.dart';
import 'package:duitlah_mobile/features/accounting/presentation/balance_sheet_screen.dart';
import 'package:duitlah_mobile/features/accounting/presentation/cash_flow_screen.dart';
import 'package:duitlah_mobile/features/accounting/presentation/chart_of_accounts_screen.dart';
import 'package:duitlah_mobile/features/accounting/presentation/general_ledger_screen.dart';
import 'package:duitlah_mobile/features/accounting/presentation/income_statement_screen.dart';
import 'package:duitlah_mobile/features/accounting/presentation/journal_entries_screen.dart';
import 'package:duitlah_mobile/features/accounting/presentation/reports_hub_screen.dart';
import 'package:duitlah_mobile/features/accounting/presentation/trial_balance_screen.dart';
import 'package:duitlah_mobile/features/accounts/presentation/accounts_screen.dart';
import 'package:duitlah_mobile/features/accounts/presentation/categories_screen.dart';
import 'package:duitlah_mobile/features/assets/presentation/asset_detail_screen.dart';
import 'package:duitlah_mobile/features/assets/presentation/assets_hub_screen.dart';
import 'package:duitlah_mobile/features/assistant/presentation/assistant_screen.dart';
import 'package:duitlah_mobile/features/auth/presentation/login_screen.dart';
import 'package:duitlah_mobile/features/auth/presentation/register_screen.dart';
import 'package:duitlah_mobile/features/autotrack/presentation/autotrack_candidates_screen.dart';
import 'package:duitlah_mobile/features/autotrack/presentation/statement_import_screen.dart';
import 'package:duitlah_mobile/features/bagilah/presentation/bill_detail_screen.dart';
import 'package:duitlah_mobile/features/bagilah/presentation/bills_list_screen.dart';
import 'package:duitlah_mobile/features/bagilah/presentation/create_bill_screen.dart';
import 'package:duitlah_mobile/features/bagilah/presentation/receipt_capture_screen.dart';
import 'package:duitlah_mobile/features/bagilah/presentation/receipt_review_screen.dart';
import 'package:duitlah_mobile/features/bills/presentation/bills_screen.dart';
import 'package:duitlah_mobile/features/budgets/presentation/budgets_screen.dart';
import 'package:duitlah_mobile/features/business/presentation/business_account_detail_screen.dart';
import 'package:duitlah_mobile/features/business/presentation/business_accounts_screen.dart';
import 'package:duitlah_mobile/features/business/presentation/business_dashboard_screen.dart';
import 'package:duitlah_mobile/features/business/presentation/contacts_screen.dart';
import 'package:duitlah_mobile/features/business/presentation/credit_notes_screen.dart';
import 'package:duitlah_mobile/features/business/presentation/expense_detail_screen.dart';
import 'package:duitlah_mobile/features/business/presentation/expenses_screen.dart';
import 'package:duitlah_mobile/features/business/presentation/invoice_detail_screen.dart';
import 'package:duitlah_mobile/features/business/presentation/invoices_screen.dart';
import 'package:duitlah_mobile/features/business/presentation/products_screen.dart';
import 'package:duitlah_mobile/features/business/presentation/quotation_detail_screen.dart';
import 'package:duitlah_mobile/features/business/presentation/quotations_screen.dart';
import 'package:duitlah_mobile/features/business/presentation/recurring_invoices_screen.dart';
import 'package:duitlah_mobile/features/business_tax/presentation/business_tax_hub_screen.dart';
import 'package:duitlah_mobile/features/crossspace/presentation/combined_net_worth_screen.dart';
import 'package:duitlah_mobile/features/crossspace/presentation/cross_space_hub_screen.dart';
import 'package:duitlah_mobile/features/exports/presentation/exports_screen.dart';
import 'package:duitlah_mobile/features/feedback/presentation/feedback_screen.dart';
import 'package:duitlah_mobile/features/feedback/presentation/help_support_screen.dart';
import 'package:duitlah_mobile/features/finhealth/presentation/financial_health_screen.dart';
import 'package:duitlah_mobile/features/goals/presentation/goals_screen.dart';
import 'package:duitlah_mobile/features/groups/presentation/create_group_screen.dart';
import 'package:duitlah_mobile/features/groups/presentation/group_detail_screen.dart';
import 'package:duitlah_mobile/features/groups/presentation/groups_list_screen.dart';
import 'package:duitlah_mobile/features/groups/presentation/join_group_screen.dart';
import 'package:duitlah_mobile/features/home/presentation/home_screen.dart';
import 'package:duitlah_mobile/features/home/presentation/more_menu_screen.dart';
import 'package:duitlah_mobile/features/insights/presentation/calendar_screen.dart';
import 'package:duitlah_mobile/features/insights/presentation/insights_screen.dart';
import 'package:duitlah_mobile/features/inventory/presentation/inventory_hub_screen.dart';
import 'package:duitlah_mobile/features/inventory/presentation/product_inventory_screen.dart';
import 'package:duitlah_mobile/features/liabilities/presentation/credit_card_details_screen.dart';
import 'package:duitlah_mobile/features/liabilities/presentation/liabilities_screen.dart';
import 'package:duitlah_mobile/features/networth/presentation/net_worth_screen.dart';
import 'package:duitlah_mobile/features/notificationrules/presentation/notification_rules_screen.dart';
import 'package:duitlah_mobile/features/notifications/presentation/notifications_screen.dart';
import 'package:duitlah_mobile/features/personaltax/presentation/pcb_screen.dart';
import 'package:duitlah_mobile/features/personaltax/presentation/personal_income_screen.dart';
import 'package:duitlah_mobile/features/personaltax/presentation/personal_tax_screen.dart';
import 'package:duitlah_mobile/features/personaltax/presentation/tax_documents_screen.dart';
import 'package:duitlah_mobile/features/personaltax/presentation/tax_reliefs_screen.dart';
import 'package:duitlah_mobile/features/personaltax/presentation/zakat_screen.dart';
import 'package:duitlah_mobile/features/profile/presentation/profile_screen.dart';
import 'package:duitlah_mobile/features/receipts/presentation/receipt_vault_screen.dart';
import 'package:duitlah_mobile/features/receipts/presentation/vault_receipt_detail_screen.dart';
import 'package:duitlah_mobile/features/reconciliation/presentation/reconciliation_hub_screen.dart';
import 'package:duitlah_mobile/features/reconciliation/presentation/reconciliation_session_screen.dart';
import 'package:duitlah_mobile/features/recurring/presentation/recurring_transactions_screen.dart';
import 'package:duitlah_mobile/features/settlements/presentation/settlements_screen.dart';
import 'package:duitlah_mobile/features/spaces/presentation/business_profile_screen.dart';
import 'package:duitlah_mobile/features/spaces/presentation/create_business_space_screen.dart';
import 'package:duitlah_mobile/features/spaces/presentation/spaces_screen.dart';
import 'package:duitlah_mobile/features/spaces/presentation/team_screen.dart';
import 'package:duitlah_mobile/features/subscriptions/presentation/duitlah_plus_screen.dart';
import 'package:duitlah_mobile/features/transactionrules/presentation/transaction_rules_screen.dart';
import 'package:duitlah_mobile/features/transactions/presentation/transactions_screen.dart';

final wholeAppScreens = <String, Widget>{
  'AccountingHubScreen': const AccountingHubScreen(spaceId: 'fixture'),
  'AccountingPeriodsScreen': const AccountingPeriodsScreen(spaceId: 'fixture'),
  'BalanceSheetScreen': const BalanceSheetScreen(spaceId: 'fixture'),
  'CashFlowScreen': const CashFlowScreen(spaceId: 'fixture'),
  'ChartOfAccountsScreen': const ChartOfAccountsScreen(spaceId: 'fixture'),
  'GeneralLedgerScreen': const GeneralLedgerScreen(spaceId: 'fixture'),
  'IncomeStatementScreen': const IncomeStatementScreen(spaceId: 'fixture'),
  'JournalEntriesScreen': const JournalEntriesScreen(spaceId: 'fixture'),
  'ReportsHubScreen': const ReportsHubScreen(spaceId: 'fixture'),
  'TrialBalanceScreen': const TrialBalanceScreen(spaceId: 'fixture'),
  'AccountsScreen': const AccountsScreen(),
  'CategoriesScreen': const CategoriesScreen(),
  'AssetDetailScreen': const AssetDetailScreen(
    spaceId: 'fixture',
    assetId: 'fixture',
  ),
  'AssetsHubScreen': const AssetsHubScreen(spaceId: 'fixture'),
  'AssistantScreen': const AssistantScreen(),
  'LoginScreen': const LoginScreen(),
  'RegisterScreen': const RegisterScreen(),
  'AutoTrackCandidatesScreen': const AutoTrackCandidatesScreen(),
  'StatementImportScreen': const StatementImportScreen(),
  'BillDetailScreen': const BillDetailScreen(billId: 'fixture'),
  'BillsListScreen': const BillsListScreen(),
  'CreateBillScreen': const CreateBillScreen(),
  'ReceiptCaptureScreen': const ReceiptCaptureScreen(),
  'ReceiptReviewScreen': const ReceiptReviewScreen(scanId: 'fixture'),
  'BillsScreen': const BillsScreen(),
  'BudgetsScreen': const BudgetsScreen(),
  'BusinessAccountDetailScreen': const BusinessAccountDetailScreen(
    spaceId: 'fixture',
    accountId: 'fixture',
  ),
  'BusinessAccountsScreen': const BusinessAccountsScreen(spaceId: 'fixture'),
  'BusinessDashboardScreen': const BusinessDashboardScreen(spaceId: 'fixture'),
  'CustomersScreen': const CustomersScreen(spaceId: 'fixture'),
  'SuppliersScreen': const SuppliersScreen(spaceId: 'fixture'),
  'CreditNotesScreen': const CreditNotesScreen(spaceId: 'fixture'),
  'ExpenseDetailScreen': const ExpenseDetailScreen(
    spaceId: 'fixture',
    expenseId: 'fixture',
  ),
  'ExpensesScreen': const ExpensesScreen(spaceId: 'fixture'),
  'InvoiceDetailScreen': const InvoiceDetailScreen(
    spaceId: 'fixture',
    invoiceId: 'fixture',
  ),
  'InvoicesScreen': const InvoicesScreen(spaceId: 'fixture'),
  'ProductsScreen': const ProductsScreen(spaceId: 'fixture'),
  'QuotationDetailScreen': const QuotationDetailScreen(
    spaceId: 'fixture',
    quotationId: 'fixture',
  ),
  'QuotationsScreen': const QuotationsScreen(spaceId: 'fixture'),
  'RecurringInvoicesScreen': const RecurringInvoicesScreen(spaceId: 'fixture'),
  'BusinessTaxHubScreen': const BusinessTaxHubScreen(spaceId: 'fixture'),
  'CombinedNetWorthScreen': const CombinedNetWorthScreen(),
  'CrossSpaceHubScreen': const CrossSpaceHubScreen(spaceId: 'fixture'),
  'ExportsScreen': const ExportsScreen(),
  'FeedbackScreen': const FeedbackScreen(),
  'HelpSupportScreen': const HelpSupportScreen(),
  'FinancialHealthScreen': const FinancialHealthScreen(),
  'GoalsScreen': const GoalsScreen(),
  'CreateGroupScreen': const CreateGroupScreen(),
  'GroupDetailScreen': const GroupDetailScreen(groupId: 'fixture'),
  'GroupsListScreen': const GroupsListScreen(),
  'JoinGroupScreen': const JoinGroupScreen(),
  'HomeScreen': const HomeScreen(),
  'MoreMenuScreen': const MoreMenuScreen(),
  'CalendarScreen': const CalendarScreen(),
  'InsightsScreen': const InsightsScreen(),
  'InventoryHubScreen': const InventoryHubScreen(spaceId: 'fixture'),
  'ProductInventoryScreen': const ProductInventoryScreen(
    spaceId: 'fixture',
    productId: 'fixture',
  ),
  'CreditCardDetailsScreen': const CreditCardDetailsScreen(
    accountId: 'fixture',
    accountName: 'fixture',
  ),
  'LiabilitiesScreen': const LiabilitiesScreen(),
  'NetWorthScreen': const NetWorthScreen(),
  'NotificationRulesScreen': const NotificationRulesScreen(),
  'NotificationsScreen': const NotificationsScreen(),
  'PcbScreen': const PcbScreen(),
  'PersonalIncomeScreen': const PersonalIncomeScreen(),
  'PersonalTaxScreen': const PersonalTaxScreen(),
  'TaxDocumentsScreen': const TaxDocumentsScreen(),
  'TaxReliefsScreen': const TaxReliefsScreen(),
  'ZakatScreen': const ZakatScreen(),
  'ProfileScreen': const ProfileScreen(),
  'ReceiptVaultScreen': const ReceiptVaultScreen(),
  'VaultReceiptDetailScreen': const VaultReceiptDetailScreen(
    receiptId: 'fixture',
  ),
  'ReconciliationHubScreen': const ReconciliationHubScreen(spaceId: 'fixture'),
  'ReconciliationSessionScreen': const ReconciliationSessionScreen(
    spaceId: 'fixture',
    sessionId: 'fixture',
  ),
  'RecurringTransactionsScreen': const RecurringTransactionsScreen(),
  'SettlementsScreen': const SettlementsScreen(),
  'BusinessProfileScreen': const BusinessProfileScreen(spaceId: 'fixture'),
  'CreateBusinessSpaceScreen': const CreateBusinessSpaceScreen(),
  'SpacesScreen': const SpacesScreen(),
  'TeamScreen': const TeamScreen(spaceId: 'fixture'),
  'DuitlahPlusScreen': const DuitlahPlusScreen(),
  'TransactionRulesScreen': const TransactionRulesScreen(),
  'TransactionsScreen': const TransactionsScreen(),
};
