import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/providers.dart';
import '../data/banking_repository.dart';
import '../data/catalog_repository.dart';
import '../data/contacts_repository.dart';
import '../data/dashboard_repository.dart';
import '../data/expenses_repository.dart';
import '../data/recurring_invoice_repository.dart';
import '../data/sales_repository.dart';
import '../domain/banking.dart';
import '../domain/catalog.dart';
import '../domain/contacts.dart';
import '../domain/dashboard.dart';
import '../domain/expenses.dart';
import '../domain/recurring_invoice.dart';
import '../domain/sales.dart';

/// Composite key for anything scoped to both a space and a resource inside
/// it (an account's entries, an expense's payments, an invoice's payments).
typedef SpaceResourceKey = ({String spaceId, String resourceId});

// ---- Repositories ---------------------------------------------------------

final contactsRepositoryProvider = Provider((ref) => ContactsRepository(ref.watch(apiClientProvider)));
final catalogRepositoryProvider = Provider((ref) => CatalogRepository(ref.watch(apiClientProvider)));
final bankingRepositoryProvider = Provider((ref) => BankingRepository(ref.watch(apiClientProvider)));
final expensesRepositoryProvider = Provider((ref) => ExpensesRepository(ref.watch(apiClientProvider)));
final salesRepositoryProvider = Provider((ref) => SalesRepository(ref.watch(apiClientProvider)));
final businessDashboardRepositoryProvider =
    Provider((ref) => BusinessDashboardRepository(ref.watch(apiClientProvider)));
final recurringInvoiceRepositoryProvider =
    Provider((ref) => RecurringInvoiceRepository(ref.watch(apiClientProvider)));

// ---- Dashboard --------------------------------------------------------

final businessDashboardProvider = FutureProvider.autoDispose.family<BusinessDashboard, String>(
  (ref, spaceId) => ref.watch(businessDashboardRepositoryProvider).getDashboard(spaceId),
);

// ---- Contacts (customers & suppliers) ----------------------------------

final customerListProvider = FutureProvider.autoDispose.family<List<Customer>, String>(
  (ref, spaceId) => ref.watch(contactsRepositoryProvider).listCustomers(spaceId),
);

final customerDetailProvider = FutureProvider.autoDispose.family<Customer, SpaceResourceKey>(
  (ref, key) => ref.watch(contactsRepositoryProvider).getCustomer(key.spaceId, key.resourceId),
);

final supplierListProvider = FutureProvider.autoDispose.family<List<Supplier>, String>(
  (ref, spaceId) => ref.watch(contactsRepositoryProvider).listSuppliers(spaceId),
);

final supplierDetailProvider = FutureProvider.autoDispose.family<Supplier, SpaceResourceKey>(
  (ref, key) => ref.watch(contactsRepositoryProvider).getSupplier(key.spaceId, key.resourceId),
);

// ---- Products -----------------------------------------------------------

final productListProvider = FutureProvider.autoDispose.family<List<Product>, String>(
  (ref, spaceId) => ref.watch(catalogRepositoryProvider).listProducts(spaceId),
);

final productDetailProvider = FutureProvider.autoDispose.family<Product, SpaceResourceKey>(
  (ref, key) => ref.watch(catalogRepositoryProvider).getProduct(key.spaceId, key.resourceId),
);

// ---- Business accounts --------------------------------------------------

final businessAccountListProvider = FutureProvider.autoDispose.family<List<BusinessAccount>, String>(
  (ref, spaceId) => ref.watch(bankingRepositoryProvider).listAccounts(spaceId),
);

final businessAccountDetailProvider = FutureProvider.autoDispose.family<BusinessAccount, SpaceResourceKey>(
  (ref, key) => ref.watch(bankingRepositoryProvider).getAccount(key.spaceId, key.resourceId),
);

final accountEntriesProvider = FutureProvider.autoDispose.family<List<AccountEntry>, SpaceResourceKey>(
  (ref, key) => ref.watch(bankingRepositoryProvider).listEntries(key.spaceId, key.resourceId),
);

// ---- Expenses -------------------------------------------------------------

final expenseListProvider = FutureProvider.autoDispose.family<List<Expense>, String>(
  (ref, spaceId) => ref.watch(expensesRepositoryProvider).listExpenses(spaceId),
);

final expenseDetailProvider = FutureProvider.autoDispose.family<Expense, SpaceResourceKey>(
  (ref, key) => ref.watch(expensesRepositoryProvider).getExpense(key.spaceId, key.resourceId),
);

final expensePaymentsProvider = FutureProvider.autoDispose.family<List<ExpensePayment>, SpaceResourceKey>(
  (ref, key) => ref.watch(expensesRepositoryProvider).listPayments(key.spaceId, key.resourceId),
);

// ---- Quotations -----------------------------------------------------------

final quotationListProvider = FutureProvider.autoDispose.family<List<Quotation>, String>(
  (ref, spaceId) => ref.watch(salesRepositoryProvider).listQuotations(spaceId),
);

final quotationDetailProvider = FutureProvider.autoDispose.family<Quotation, SpaceResourceKey>(
  (ref, key) => ref.watch(salesRepositoryProvider).getQuotation(key.spaceId, key.resourceId),
);

// ---- Invoices ---------------------------------------------------------

final invoiceListProvider = FutureProvider.autoDispose.family<List<Invoice>, String>(
  (ref, spaceId) => ref.watch(salesRepositoryProvider).listInvoices(spaceId),
);

final invoiceDetailProvider = FutureProvider.autoDispose.family<Invoice, SpaceResourceKey>(
  (ref, key) => ref.watch(salesRepositoryProvider).getInvoice(key.spaceId, key.resourceId),
);

final invoicePaymentsProvider = FutureProvider.autoDispose.family<List<InvoicePayment>, SpaceResourceKey>(
  (ref, key) => ref.watch(salesRepositoryProvider).listInvoicePayments(key.spaceId, key.resourceId),
);

// ---- Recurring invoices -------------------------------------------------

final recurringInvoiceListProvider = FutureProvider.autoDispose.family<List<RecurringInvoice>, String>(
  (ref, spaceId) => ref.watch(recurringInvoiceRepositoryProvider).list(spaceId),
);

// ---- Credit notes -----------------------------------------------------

final creditNoteListProvider = FutureProvider.autoDispose.family<List<CreditNote>, String>(
  (ref, spaceId) => ref.watch(salesRepositoryProvider).listCreditNotes(spaceId),
);

// ---- e-Invoice (Phase 10 — LHDN / MyInvois) ----------------------------

/// Null when no e-Invoice document exists yet for this invoice — a normal
/// "not started" state (see `SalesRepository.getEInvoice`), not a loading
/// or error condition.
final einvoiceProvider = FutureProvider.autoDispose.family<EInvoiceDocument?, SpaceResourceKey>(
  (ref, key) => ref.watch(salesRepositoryProvider).getEInvoice(key.spaceId, key.resourceId),
);

final einvoiceLogsProvider = FutureProvider.autoDispose.family<List<EInvoiceLogEntry>, SpaceResourceKey>(
  (ref, key) => ref.watch(salesRepositoryProvider).listEInvoiceLogs(key.spaceId, key.resourceId),
);
