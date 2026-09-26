import 'package:duitlah_mobile/core/api/api_client.dart';
import 'package:duitlah_mobile/core/api/providers.dart';
import 'package:duitlah_mobile/core/storage/secure_storage.dart';
// Synthetic display fixtures only. No production repositories or calculations are changed.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:duitlah_mobile/core/errors/app_exception.dart';
import 'package:duitlah_mobile/features/accounting/domain/chart_of_accounts.dart'
    as d0;
import 'package:duitlah_mobile/features/accounting/domain/journal_entries.dart'
    as d3;
import 'package:duitlah_mobile/features/accounting/domain/periods.dart' as d6;
import 'package:duitlah_mobile/features/accounting/domain/reports.dart' as d9;
import 'package:duitlah_mobile/features/accounts/domain/finance.dart' as d12;
import 'package:duitlah_mobile/features/assets/domain/fixed_assets.dart' as d15;
import 'package:duitlah_mobile/features/autotrack/domain/transaction_candidate.dart'
    as d24;
import 'package:duitlah_mobile/features/bagilah/domain/bagilah_enums.dart'
    as d27;
import 'package:duitlah_mobile/features/bagilah/domain/bill.dart' as d28;
import 'package:duitlah_mobile/features/bills/domain/personal_bill.dart' as d31;
import 'package:duitlah_mobile/features/budgets/domain/budget.dart' as d34;
import 'package:duitlah_mobile/features/business/domain/banking.dart' as d37;
import 'package:duitlah_mobile/features/business/domain/catalog.dart' as d40;
import 'package:duitlah_mobile/features/business/domain/contacts.dart' as d43;
import 'package:duitlah_mobile/features/business/domain/dashboard.dart' as d46;
import 'package:duitlah_mobile/features/business/domain/expenses.dart' as d49;
import 'package:duitlah_mobile/features/business/domain/recurring_invoice.dart'
    as d52;
import 'package:duitlah_mobile/features/business/domain/sales.dart' as d55;
import 'package:duitlah_mobile/features/business_tax/domain/business_tax.dart'
    as d58;
import 'package:duitlah_mobile/features/crossspace/domain/cross_space.dart'
    as d61;
import 'package:duitlah_mobile/features/finhealth/domain/financial_health.dart'
    as d67;
import 'package:duitlah_mobile/features/groups/domain/group.dart' as d70;
import 'package:duitlah_mobile/features/insights/domain/insights.dart' as d73;
import 'package:duitlah_mobile/features/inventory/domain/inventory.dart' as d76;
import 'package:duitlah_mobile/features/liabilities/domain/liability.dart'
    as d79;
import 'package:duitlah_mobile/features/networth/domain/net_worth.dart' as d82;
import 'package:duitlah_mobile/features/notificationrules/domain/notification_rule.dart'
    as d85;
import 'package:duitlah_mobile/features/notifications/domain/app_notification.dart'
    as d88;
import 'package:duitlah_mobile/features/personaltax/domain/personal_tax.dart'
    as d91;
import 'package:duitlah_mobile/features/receipts/domain/receipt_scan.dart'
    as d94;
import 'package:duitlah_mobile/features/receipts/domain/vault_receipt.dart'
    as d97;
import 'package:duitlah_mobile/features/reconciliation/domain/reconciliation.dart'
    as d100;
import 'package:duitlah_mobile/features/recurring/domain/recurring_transaction.dart'
    as d103;
import 'package:duitlah_mobile/features/settlements/domain/settlement.dart'
    as d106;
import 'package:duitlah_mobile/features/spaces/domain/financial_space.dart'
    as d109;
import 'package:duitlah_mobile/features/spaces/domain/space_member.dart'
    as d112;
import 'package:duitlah_mobile/features/subscriptions/domain/entitlement.dart'
    as d115;
import 'package:duitlah_mobile/features/transactionrules/domain/transaction_rule.dart'
    as d118;
import 'package:duitlah_mobile/features/wrapped/domain/wrapped.dart' as d121;
import 'package:duitlah_mobile/features/accounting/application/accounting_providers.dart'
    as p0;
import 'package:duitlah_mobile/features/accounts/application/finance_providers.dart'
    as p1;
import 'package:duitlah_mobile/features/assets/application/fixed_assets_providers.dart'
    as p2;
import 'package:duitlah_mobile/features/autotrack/application/autotrack_providers.dart'
    as p4;
import 'package:duitlah_mobile/features/bagilah/application/bagilah_providers.dart'
    as p5;
import 'package:duitlah_mobile/features/bills/application/bills_providers.dart'
    as p6;
import 'package:duitlah_mobile/features/budgets/application/budgets_providers.dart'
    as p7;
import 'package:duitlah_mobile/features/business/application/business_providers.dart'
    as p8;
import 'package:duitlah_mobile/features/business_tax/application/business_tax_providers.dart'
    as p9;
import 'package:duitlah_mobile/features/crossspace/application/cross_space_providers.dart'
    as p10;
import 'package:duitlah_mobile/features/finhealth/application/financial_health_providers.dart'
    as p13;
import 'package:duitlah_mobile/features/groups/application/groups_providers.dart'
    as p14;
import 'package:duitlah_mobile/features/insights/application/insights_providers.dart'
    as p15;
import 'package:duitlah_mobile/features/inventory/application/inventory_providers.dart'
    as p16;
import 'package:duitlah_mobile/features/liabilities/application/liabilities_providers.dart'
    as p17;
import 'package:duitlah_mobile/features/networth/application/net_worth_providers.dart'
    as p18;
import 'package:duitlah_mobile/features/notificationrules/application/notification_rule_providers.dart'
    as p19;
import 'package:duitlah_mobile/features/notifications/application/notifications_providers.dart'
    as p20;
import 'package:duitlah_mobile/features/personaltax/application/personal_tax_providers.dart'
    as p21;
import 'package:duitlah_mobile/features/receipts/application/receipt_vault_providers.dart'
    as p22;
import 'package:duitlah_mobile/features/receipts/application/receipts_providers.dart'
    as p23;
import 'package:duitlah_mobile/features/reconciliation/application/reconciliation_providers.dart'
    as p24;
import 'package:duitlah_mobile/features/recurring/application/recurring_providers.dart'
    as p25;
import 'package:duitlah_mobile/features/settlements/application/settlements_providers.dart'
    as p26;
import 'package:duitlah_mobile/features/spaces/application/spaces_providers.dart'
    as p27;
import 'package:duitlah_mobile/features/subscriptions/application/subscriptions_providers.dart'
    as p28;
import 'package:duitlah_mobile/features/transactionrules/application/transaction_rule_providers.dart'
    as p29;
import 'package:duitlah_mobile/features/wrapped/application/wrapped_providers.dart'
    as p30;

List<Override> wholeAppOverrides({bool failed = false}) => [
  apiClientProvider.overrideWith((ref) => _PreviewApi(failed)),
  p0.chartOfAccountsListProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d0.LedgerAccount(
              id: 'fixture',
              code: 'Monthly record',
              name: 'September essentials',
              type: d0.LedgerAccountType.ASSET,
              systemDefault: false,
              cashEquivalent: false,
              archived: false,
            ),
          ],
  ),
  p0.accountingPeriodListProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d6.AccountingPeriod(
              id: 'fixture',
              periodStart: '2026-09-10',
              periodEnd: '2026-09-10',
              status: d6.AccountingPeriodStatus.OPEN,
            ),
          ],
  ),
  p0.journalEntryListProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d3.JournalEntry(
              id: 'fixture',
              entryDate: '2026-09-10',
              description: 'Monthly record',
              sourceType: d3.JournalSourceType.MANUAL,
              lines: [
                d3.JournalEntryLine(
                  id: 'fixture',
                  accountId: 'fixture',
                  accountCode: 'Monthly record',
                  accountName: 'September essentials',
                  direction: d3.LedgerDirection.DEBIT,
                  amount: '1250.50',
                ),
              ],
            ),
          ],
  ),
  p0.generalLedgerReportProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d9.GeneralLedgerReport(
            accountId: 'fixture',
            accountCode: 'Monthly record',
            accountName: 'September essentials',
            openingBalance: '1250.50',
            lines: [
              d9.GeneralLedgerLine(
                entryDate: '2026-09-10',
                journalEntryId: 'fixture',
                direction: d3.LedgerDirection.DEBIT,
                amount: '1250.50',
                runningBalance: '1250.50',
              ),
            ],
            closingBalance: '1250.50',
          ),
  ),
  p0.trialBalanceReportProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d9.TrialBalanceReport(
            asOf: 'Monthly record',
            lines: [
              d9.TrialBalanceLine(
                accountId: 'fixture',
                accountCode: 'Monthly record',
                accountName: 'September essentials',
                type: d0.LedgerAccountType.ASSET,
                debit: '1250.50',
                credit: '1250.50',
              ),
            ],
            totalDebit: '1250.50',
            totalCredit: '1250.50',
          ),
  ),
  p0.balanceSheetReportProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d9.BalanceSheetReport(
            asOf: 'Monthly record',
            assets: [
              d9.AccountAmountLine(
                accountId: 'fixture',
                accountCode: 'Monthly record',
                accountName: 'September essentials',
                amount: '1250.50',
              ),
            ],
            totalAssets: '1250.50',
            liabilities: [
              d9.AccountAmountLine(
                accountId: 'fixture',
                accountCode: 'Monthly record',
                accountName: 'September essentials',
                amount: '1250.50',
              ),
            ],
            totalLiabilities: '1250.50',
            equity: [
              d9.AccountAmountLine(
                accountId: 'fixture',
                accountCode: 'Monthly record',
                accountName: 'September essentials',
                amount: '1250.50',
              ),
            ],
            totalEquity: '1250.50',
            currentEarnings: 'Monthly record',
            totalLiabilitiesAndEquity: '1250.50',
          ),
  ),
  p0.incomeStatementReportProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d9.IncomeStatementReport(
            from: 'Monthly record',
            to: 'Monthly record',
            revenueLines: [
              d9.AccountAmountLine(
                accountId: 'fixture',
                accountCode: 'Monthly record',
                accountName: 'September essentials',
                amount: '1250.50',
              ),
            ],
            totalRevenue: '1250.50',
            expenseLines: [
              d9.AccountAmountLine(
                accountId: 'fixture',
                accountCode: 'Monthly record',
                accountName: 'September essentials',
                amount: '1250.50',
              ),
            ],
            totalExpenses: '1250.50',
            netIncome: '1250.50',
          ),
  ),
  p0.cashFlowReportProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d9.CashFlowReport(
            from: 'Monthly record',
            to: 'Monthly record',
            openingCash: 'Monthly record',
            totalCashIn: '1250.50',
            totalCashOut: '1250.50',
            netChange: 'Monthly record',
            closingCash: 'Monthly record',
          ),
  ),
  p1.dashboardProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d12.DashboardSummary(
            availableBalance: '1250.50',
            monthIncome: '1250.50',
            monthExpense: '1250.50',
            recentTransactions: [
              d12.Transaction(
                id: 'fixture',
                accountId: 'fixture',
                type: d12.TransactionType.INCOME,
                direction: d12.TransactionDirection.IN,
                amount: '1250.50',
                occurredOn: '2026-09-10',
              ),
            ],
          ),
  ),
  p1.accountListProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d12.Account(
              id: 'fixture',
              name: 'September essentials',
              type: d12.AccountType.CASH,
              currency: 'MYR',
              openingBalance: '1250.50',
              balance: '1250.50',
              archived: false,
            ),
          ],
  ),
  p1.categoryListProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d12.Category(
              id: 'fixture',
              type: d12.CategoryType.INCOME,
              name: 'September essentials',
              custom: false,
            ),
          ],
  ),
  p1.transactionsProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d12.TransactionPage(
            content: [
              d12.Transaction(
                id: 'fixture',
                accountId: 'fixture',
                type: d12.TransactionType.INCOME,
                direction: d12.TransactionDirection.IN,
                amount: '1250.50',
                occurredOn: '2026-09-10',
              ),
            ],
            totalElements: 1,
            totalPages: 1,
            number: 1,
            size: 1,
          ),
  ),
  p2.assetListProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d15.FixedAssetResponse(
              id: 'fixture',
              name: 'September essentials',
              acquisitionDate: '2026-09-10',
              cost: '1250.50',
              salvageValue: '1250.50',
              usefulLifeMonths: 9,
              depreciationMethod: d15.DepreciationMethod.STRAIGHT_LINE,
              status: d15.FixedAssetStatus.ACTIVE,
              accumulatedDepreciation: 'Monthly record',
              netBookValue: '1250.50',
            ),
          ],
  ),
  p2.assetDetailProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d15.FixedAssetResponse(
            id: 'fixture',
            name: 'September essentials',
            acquisitionDate: '2026-09-10',
            cost: '1250.50',
            salvageValue: '1250.50',
            usefulLifeMonths: 9,
            depreciationMethod: d15.DepreciationMethod.STRAIGHT_LINE,
            status: d15.FixedAssetStatus.ACTIVE,
            accumulatedDepreciation: 'Monthly record',
            netBookValue: '1250.50',
          ),
  ),
  p2.depreciationEntryListProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d15.DepreciationEntryResponse(
              id: 'fixture',
              assetId: 'fixture',
              period: 'Monthly record',
              amount: '1250.50',
              createdAt: '2026-09-10',
            ),
          ],
  ),
  p4.pendingCandidatesProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d24.TransactionCandidate(
              id: 'fixture',
              sourceType: d24.CandidateSourceType.RECEIPT_OCR,
              detectedAmount: '1250.50',
              detectedCurrency: 'MYR',
              detectedDate: '2026-09-10',
              detectedDirection: d12.TransactionDirection.IN,
              confidence: 'Monthly record',
              status: d24.CandidateStatus.PENDING,
            ),
          ],
  ),
  p4.statementImportsProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d24.StatementImport(
              id: 'fixture',
              accountId: 'fixture',
              provider: d24.StatementProvider.GENERIC_CSV,
              originalFilename: 'September essentials',
              status: d24.StatementImportStatus.UPLOADED,
              rowCount: 1,
            ),
          ],
  ),
  p5.billListProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d28.Bill(
              id: 'fixture',
              ownerUserId: 'fixture',
              receiptDate: '2026-09-10',
              currency: 'MYR',
              tax: '1250.50',
              taxStrategy: d27.AllocationStrategy.PROPORTIONAL,
              serviceCharge: 'Monthly record',
              serviceStrategy: d27.AllocationStrategy.PROPORTIONAL,
              discount: 'Monthly record',
              status: d27.BillStatus.DRAFT,
            ),
          ],
  ),
  p5.billDetailProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d28.Bill(
            id: 'fixture',
            ownerUserId: 'fixture',
            receiptDate: '2026-09-10',
            currency: 'MYR',
            tax: '1250.50',
            taxStrategy: d27.AllocationStrategy.PROPORTIONAL,
            serviceCharge: 'Monthly record',
            serviceStrategy: d27.AllocationStrategy.PROPORTIONAL,
            discount: 'Monthly record',
            status: d27.BillStatus.DRAFT,
          ),
  ),
  p5.billItemsProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d28.ReceiptItem(
              id: 'fixture',
              name: 'September essentials',
              quantity: '25',
              unitPrice: '1250.50',
              itemDiscount: 'Monthly record',
              totalPrice: '1250.50',
            ),
          ],
  ),
  p5.billParticipantsProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d28.Participant(
              id: 'fixture',
              displayName: 'September essentials',
              guest: false,
            ),
          ],
  ),
  p5.billItemClaimsProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d28.Claim(
              id: 'fixture',
              participantId: 'fixture',
              displayName: 'September essentials',
              claimType: d27.ClaimType.QUANTITY,
              value: '1250.50',
            ),
          ],
  ),
  p5.billBreakdownProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d28.Breakdown(
            valid: false,
            issues: [
              d28.ItemIssue(
                itemId: 'fixture',
                itemName: 'September essentials',
                type: d27.IssueType.UNCLAIMED,
              ),
            ],
            subtotal: '1250.50',
            computedTotal: '1250.50',
            roundingAdjustment: 'Monthly record',
            participants: [
              d28.ParticipantBreakdown(
                participantId: 'fixture',
                displayName: 'September essentials',
                subtotal: '1250.50',
                taxShare: '1250.50',
                serviceShare: 'Monthly record',
                discountShare: 'Monthly record',
                roundingShare: 'Monthly record',
                finalAmount: '1250.50',
              ),
            ],
          ),
  ),
  p5.billBalancesProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d28.BillBalance(
              participantId: 'fixture',
              displayName: 'September essentials',
              paid: 'fixture',
              owed: 'Monthly record',
              net: 'Monthly record',
            ),
          ],
  ),
  p5.guestBillDetailProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d28.Bill(
            id: 'fixture',
            ownerUserId: 'fixture',
            receiptDate: '2026-09-10',
            currency: 'MYR',
            tax: '1250.50',
            taxStrategy: d27.AllocationStrategy.PROPORTIONAL,
            serviceCharge: 'Monthly record',
            serviceStrategy: d27.AllocationStrategy.PROPORTIONAL,
            discount: 'Monthly record',
            status: d27.BillStatus.DRAFT,
          ),
  ),
  p5.guestBillItemsProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d28.ReceiptItem(
              id: 'fixture',
              name: 'September essentials',
              quantity: '25',
              unitPrice: '1250.50',
              itemDiscount: 'Monthly record',
              totalPrice: '1250.50',
            ),
          ],
  ),
  p5.guestBillParticipantsProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d28.Participant(
              id: 'fixture',
              displayName: 'September essentials',
              guest: false,
            ),
          ],
  ),
  p5.guestBillItemClaimsProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d28.Claim(
              id: 'fixture',
              participantId: 'fixture',
              displayName: 'September essentials',
              claimType: d27.ClaimType.QUANTITY,
              value: '1250.50',
            ),
          ],
  ),
  p5.guestBreakdownProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d28.Breakdown(
            valid: false,
            issues: [
              d28.ItemIssue(
                itemId: 'fixture',
                itemName: 'September essentials',
                type: d27.IssueType.UNCLAIMED,
              ),
            ],
            subtotal: '1250.50',
            computedTotal: '1250.50',
            roundingAdjustment: 'Monthly record',
            participants: [
              d28.ParticipantBreakdown(
                participantId: 'fixture',
                displayName: 'September essentials',
                subtotal: '1250.50',
                taxShare: '1250.50',
                serviceShare: 'Monthly record',
                discountShare: 'Monthly record',
                roundingShare: 'Monthly record',
                finalAmount: '1250.50',
              ),
            ],
          ),
  ),
  p6.personalBillListProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d31.PersonalBill(
              id: 'fixture',
              name: 'September essentials',
              dueDate: '2026-09-10',
              expectedAmount: '1250.50',
              recurrence: d31.BillRecurrence.NONE,
              status: d31.BillStatus.UPCOMING,
            ),
          ],
  ),
  p7.budgetListProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d34.Budget(
              id: 'fixture',
              categoryName: 'September essentials',
              periodYear: 2026,
              periodMonth: 9,
              cycleType: d34.BudgetCycleType.CALENDAR_MONTH,
              limit: '1250.50',
              spent: '1250.50',
              remaining: '1250.50',
              status: d34.BudgetStatus.OK,
            ),
          ],
  ),
  p7.goalListProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d34.Goal(
              id: 'fixture',
              name: 'September essentials',
              type: d34.GoalType.EMERGENCY_FUND,
              targetAmount: '1250.50',
              currentAmount: '1250.50',
              remaining: '1250.50',
              percentage: '25',
              archived: false,
            ),
          ],
  ),
  p8.businessDashboardProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d46.BusinessDashboard(
            cashPosition: '1250.50',
            totalReceivables: '1250.50',
            totalPayables: '1250.50',
            customerCount: 1,
            supplierCount: 1,
            productCount: 1,
            openInvoiceCount: 1,
            unpaidExpenseCount: 1,
          ),
  ),
  p8.customerListProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d43.Customer(
              id: 'fixture',
              name: 'September essentials',
              paymentTermsDays: 1,
              status: d43.ContactStatus.ACTIVE,
            ),
          ],
  ),
  p8.customerDetailProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d43.Customer(
            id: 'fixture',
            name: 'September essentials',
            paymentTermsDays: 1,
            status: d43.ContactStatus.ACTIVE,
          ),
  ),
  p8.supplierListProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d43.Supplier(
              id: 'fixture',
              name: 'September essentials',
              paymentTermsDays: 1,
              status: d43.ContactStatus.ACTIVE,
            ),
          ],
  ),
  p8.supplierDetailProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d43.Supplier(
            id: 'fixture',
            name: 'September essentials',
            paymentTermsDays: 1,
            status: d43.ContactStatus.ACTIVE,
          ),
  ),
  p8.productListProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d40.Product(
              id: 'fixture',
              name: 'September essentials',
              type: d40.ProductType.GOODS,
              unitPrice: '1250.50',
              active: false,
              taxClassification: d40.TaxClassification.STANDARD_RATED,
              trackInventory: false,
            ),
          ],
  ),
  p8.productDetailProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d40.Product(
            id: 'fixture',
            name: 'September essentials',
            type: d40.ProductType.GOODS,
            unitPrice: '1250.50',
            active: false,
            taxClassification: d40.TaxClassification.STANDARD_RATED,
            trackInventory: false,
          ),
  ),
  p8.businessAccountListProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d37.BusinessAccount(
              id: 'fixture',
              name: 'September essentials',
              type: d37.BusinessAccountType.BANK,
              currency: 'MYR',
              openingBalance: '1250.50',
              balance: '1250.50',
              archived: false,
            ),
          ],
  ),
  p8.businessAccountDetailProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d37.BusinessAccount(
            id: 'fixture',
            name: 'September essentials',
            type: d37.BusinessAccountType.BANK,
            currency: 'MYR',
            openingBalance: '1250.50',
            balance: '1250.50',
            archived: false,
          ),
  ),
  p8.accountEntriesProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d37.AccountEntry(
              id: 'fixture',
              direction: d37.EntryDirection.IN,
              amount: '1250.50',
              occurredOn: '2026-09-10',
            ),
          ],
  ),
  p8.expenseListProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d49.Expense(
              id: 'fixture',
              amount: '1250.50',
              amountPaid: 'fixture',
              amountRemaining: '1250.50',
              occurredOn: '2026-09-10',
              status: d49.ExpenseStatus.UNPAID,
            ),
          ],
  ),
  p8.expenseDetailProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d49.Expense(
            id: 'fixture',
            amount: '1250.50',
            amountPaid: 'fixture',
            amountRemaining: '1250.50',
            occurredOn: '2026-09-10',
            status: d49.ExpenseStatus.UNPAID,
          ),
  ),
  p8.expensePaymentsProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d49.ExpensePayment(
              id: 'fixture',
              businessAccountId: 'fixture',
              amount: '1250.50',
              paidOn: '2026-09-10',
            ),
          ],
  ),
  p8.quotationListProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d55.Quotation(
              id: 'fixture',
              customerId: 'fixture',
              quoteNumber: 'Monthly record',
              issueDate: '2026-09-10',
              status: d55.QuotationStatus.DRAFT,
              taxPercent: '1250.50',
              subtotal: '1250.50',
              taxAmount: '1250.50',
              total: '1250.50',
              lineItems: [
                d55.LineItem(
                  id: 'fixture',
                  description: 'Monthly record',
                  quantity: '25',
                  unitPrice: '1250.50',
                  lineTotal: '1250.50',
                ),
              ],
            ),
          ],
  ),
  p8.quotationDetailProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d55.Quotation(
            id: 'fixture',
            customerId: 'fixture',
            quoteNumber: 'Monthly record',
            issueDate: '2026-09-10',
            status: d55.QuotationStatus.DRAFT,
            taxPercent: '1250.50',
            subtotal: '1250.50',
            taxAmount: '1250.50',
            total: '1250.50',
            lineItems: [
              d55.LineItem(
                id: 'fixture',
                description: 'Monthly record',
                quantity: '25',
                unitPrice: '1250.50',
                lineTotal: '1250.50',
              ),
            ],
          ),
  ),
  p8.invoiceListProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d55.Invoice(
              id: 'fixture',
              customerId: 'fixture',
              invoiceNumber: 'Monthly record',
              issueDate: '2026-09-10',
              dueDate: '2026-09-10',
              status: d55.InvoiceStatus.DRAFT,
              effectiveStatus: d55.InvoiceEffectiveStatus.DRAFT,
              taxPercent: '1250.50',
              subtotal: '1250.50',
              taxAmount: '1250.50',
              total: '1250.50',
              amountPaid: 'fixture',
              amountCredited: '1250.50',
              amountOutstanding: '1250.50',
              lineItems: [
                d55.LineItem(
                  id: 'fixture',
                  description: 'Monthly record',
                  quantity: '25',
                  unitPrice: '1250.50',
                  lineTotal: '1250.50',
                ),
              ],
            ),
          ],
  ),
  p8.invoiceDetailProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d55.Invoice(
            id: 'fixture',
            customerId: 'fixture',
            invoiceNumber: 'Monthly record',
            issueDate: '2026-09-10',
            dueDate: '2026-09-10',
            status: d55.InvoiceStatus.DRAFT,
            effectiveStatus: d55.InvoiceEffectiveStatus.DRAFT,
            taxPercent: '1250.50',
            subtotal: '1250.50',
            taxAmount: '1250.50',
            total: '1250.50',
            amountPaid: 'fixture',
            amountCredited: '1250.50',
            amountOutstanding: '1250.50',
            lineItems: [
              d55.LineItem(
                id: 'fixture',
                description: 'Monthly record',
                quantity: '25',
                unitPrice: '1250.50',
                lineTotal: '1250.50',
              ),
            ],
          ),
  ),
  p8.invoicePaymentsProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d55.InvoicePayment(
              id: 'fixture',
              businessAccountId: 'fixture',
              amount: '1250.50',
              paidOn: '2026-09-10',
            ),
          ],
  ),
  p8.recurringInvoiceListProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d52.RecurringInvoice(
              id: 'fixture',
              customerId: 'fixture',
              frequency: d103.RecurrenceFrequency.DAILY,
              intervalCount: 1,
              startDate: '2026-09-10',
              nextOccurrenceDate: '2026-09-10',
              active: false,
              lineItems: [
                d52.RecurringInvoiceLineItem(
                  id: 'fixture',
                  description: 'Monthly record',
                  quantity: '25',
                  unitPrice: '1250.50',
                ),
              ],
            ),
          ],
  ),
  p8.creditNoteListProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d55.CreditNote(
              id: 'fixture',
              customerId: 'fixture',
              creditNoteNumber: '1250.50',
              issueDate: '2026-09-10',
              amount: '1250.50',
              status: d55.CreditNoteStatus.ISSUED,
            ),
          ],
  ),
  p8.einvoiceProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : null,
  ),
  p8.einvoiceLogsProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d55.EInvoiceLogEntry(
              id: 'fixture',
              operation: d55.EInvoiceOperation.SUBMIT,
              success: false,
              createdAt: '2026-09-10',
            ),
          ],
  ),
  p9.sstRateListProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d58.SstRate(
              taxType: d58.TaxType.SALES,
              ratePercent: '25',
              effectiveFrom: 'Monthly record',
            ),
          ],
  ),
  p9.sstReportProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d58.SstReport(
            from: 'Monthly record',
            to: 'Monthly record',
            collectedTax: '1250.50',
            payableTax: '1250.50',
          ),
  ),
  p9.einvoiceReadinessProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d58.EInvoiceReadiness(
            mandated: false,
            missingFields: ['Monthly record'],
            ready: false,
          ),
  ),
  p10.crossSpaceLinkListProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d61.CrossSpaceLinkResponse(
              id: 'fixture',
              businessSpaceId: 'fixture',
              linkType: d61.CrossSpaceLinkType.BUSINESS_ADVANCE,
              personalTransactionId: 'fixture',
              amount: '1250.50',
              createdAt: '2026-09-10',
            ),
          ],
  ),
  p10.myCrossSpaceLinkListProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d61.CrossSpaceLinkResponse(
              id: 'fixture',
              businessSpaceId: 'fixture',
              linkType: d61.CrossSpaceLinkType.BUSINESS_ADVANCE,
              personalTransactionId: 'fixture',
              amount: '1250.50',
              createdAt: '2026-09-10',
            ),
          ],
  ),
  p10.combinedNetWorthProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d61.CombinedNetWorth(
            personalNetWorth: '75',
            businessOwnership: [
              d61.BusinessOwnershipLine(
                spaceId: 'fixture',
                spaceName: 'September essentials',
                equityValue: '1250.50',
              ),
            ],
            totalBusinessOwnershipValue: '1250.50',
            estimatedTotalNetWorth: '1250.50',
          ),
  ),
  p13.financialHealthProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d67.FinancialHealth(
            score: '75',
            components: [
              d67.HealthComponent(
                key: 'Monthly record',
                label: 'Monthly record',
                score: '75',
                weight: '75',
                explanation: 'Monthly record',
              ),
            ],
            recommendations: ['Monthly record'],
          ),
  ),
  p14.groupListProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d70.Group(
              id: 'fixture',
              name: 'September essentials',
              type: d70.GroupType.GENERAL,
              yourRole: d70.GroupMemberRole.OWNER,
              memberCount: 1,
              archived: false,
            ),
          ],
  ),
  p14.groupDetailProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d70.Group(
            id: 'fixture',
            name: 'September essentials',
            type: d70.GroupType.GENERAL,
            yourRole: d70.GroupMemberRole.OWNER,
            memberCount: 1,
            archived: false,
          ),
  ),
  p14.groupMembersProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d70.GroupMember(
              userId: 'fixture',
              displayName: 'September essentials',
              email: 'nabil@example.com',
              role: d70.GroupMemberRole.OWNER,
              joinedAt: 'Monthly record',
            ),
          ],
  ),
  p14.groupExpensesProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d70.GroupExpense(
              id: 'fixture',
              description: 'Monthly record',
              amount: '1250.50',
              occurredOn: '2026-09-10',
              paidByUserId: 'fixture',
              paidByName: 'September essentials',
              shares: [
                d70.GroupExpenseShare(
                  userId: 'fixture',
                  displayName: 'September essentials',
                  amount: '1250.50',
                ),
              ],
            ),
          ],
  ),
  p14.groupBalancesProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d70.GroupBalance(
              userId: 'fixture',
              displayName: 'September essentials',
              totalPaid: 'fixture',
              totalShare: '1250.50',
              net: 'Monthly record',
            ),
          ],
  ),
  p14.groupGoalsProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d70.GroupGoal(
              id: 'fixture',
              name: 'September essentials',
              targetAmount: '1250.50',
              currentAmount: '1250.50',
              remaining: '1250.50',
              percentage: '25',
              archived: false,
              byMember: [
                d70.GroupGoalMemberContribution(
                  userId: 'fixture',
                  displayName: 'September essentials',
                  totalContributed: '1250.50',
                ),
              ],
            ),
          ],
  ),
  p14.groupGoalContributionsProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d70.GroupGoalContribution(
              id: 'fixture',
              userId: 'fixture',
              userDisplayName: 'September essentials',
              amount: '1250.50',
              occurredOn: '2026-09-10',
            ),
          ],
  ),
  p14.groupBudgetProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : null,
  ),
  p14.tripSummaryProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d70.TripSummary(
            spent: '1250.50',
            spendingByCategory: [
              d70.TripCategorySpending(
                category: d70.GroupExpenseCategory.RENT,
                amount: '1250.50',
              ),
            ],
          ),
  ),
  p14.housemateDashboardProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d70.HousemateDashboard(
            year: 2026,
            month: 9,
            categories: [
              d70.HousemateCategoryStatus(
                category: d70.GroupExpenseCategory.RENT,
                paid: false,
              ),
            ],
          ),
  ),
  p15.spendingByCategoryProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d73.CategorySpending(
              categoryId: 'fixture',
              categoryName: 'September essentials',
              amount: '1250.50',
            ),
          ],
  ),
  p15.monthlyTrendProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d73.MonthlyTrend(
              year: 2026,
              month: 9,
              income: '1250.50',
              expense: '1250.50',
              savings: 'Monthly record',
            ),
          ],
  ),
  p15.topMerchantsProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d73.MerchantSpending(
              merchant: 'Monthly record',
              amount: '1250.50',
              transactionCount: 1,
            ),
          ],
  ),
  p15.calendarProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d73.CalendarEntry(
              date: '2026-09-10',
              confirmed: false,
              type: d12.TransactionType.INCOME,
              direction: d12.TransactionDirection.IN,
              amount: '1250.50',
            ),
          ],
  ),
  p15.forecastProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d73.Forecast(
            currentBalance: '1250.50',
            asOfDate: '2026-09-10',
            targetDate: '2026-09-10',
            scheduledIncome: '1250.50',
            scheduledExpense: '1250.50',
            predictedVariableExpense: '1250.50',
            projectedBalance: '1250.50',
            disclaimer: 'Monthly record',
          ),
  ),
  p16.productValuationProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d76.ProductValuationResponse(
            productId: 'fixture',
            quantityOnHand: '25',
            weightedAverageCost: '1250.50',
            totalValue: '1250.50',
          ),
  ),
  p16.movementListProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d76.MovementResponse(
              id: 'fixture',
              productId: 'fixture',
              type: d76.MovementType.PURCHASE,
              quantity: '25',
              unitCost: '1250.50',
              value: '1250.50',
              occurredOn: '2026-09-10',
              createdByUserId: '2026-09-10',
              createdAt: '2026-09-10',
            ),
          ],
  ),
  p16.recipeItemsProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d76.RecipeItemResponse(
              id: 'fixture',
              ingredientProductId: 'fixture',
              ingredientName: 'September essentials',
              quantityPerUnit: '25',
              ingredientUnitCost: '1250.50',
              lineCost: '1250.50',
            ),
          ],
  ),
  p16.recipeCostProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d76.RecipeCostResponse(
            productId: 'fixture',
            items: [
              d76.RecipeItemResponse(
                id: 'fixture',
                ingredientProductId: 'fixture',
                ingredientName: 'September essentials',
                quantityPerUnit: '25',
                ingredientUnitCost: '1250.50',
                lineCost: '1250.50',
              ),
            ],
            unitCost: '1250.50',
            sellingPrice: '1250.50',
            grossMargin: 'Monthly record',
            grossMarginPercent: 'Monthly record',
          ),
  ),
  p16.stockValuationListProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d76.StockValuationRow(
              productId: 'fixture',
              productName: 'September essentials',
              quantityOnHand: '25',
              weightedAverageCost: '1250.50',
              totalValue: '1250.50',
            ),
          ],
  ),
  p16.cogsReportProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d76.CogsReport(
            from: 'Monthly record',
            to: 'Monthly record',
            totalCogs: '1250.50',
          ),
  ),
  p17.liabilityListProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d79.Liability(
              id: 'fixture',
              type: d79.LiabilityType.PERSONAL_LOAN,
              name: 'September essentials',
              originalAmount: '1250.50',
              outstandingPrincipal: '1250.50',
              status: d79.LiabilityStatus.ACTIVE,
            ),
          ],
  ),
  p17.creditCardDetailsProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : null,
  ),
  p18.netWorthProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d82.NetWorth(
            totalAssets: '1250.50',
            totalLiabilities: '1250.50',
            netWorth: '75',
            assetsBreakdown: [
              d82.BreakdownLine(label: 'Monthly record', amount: '1250.50'),
            ],
            liabilitiesBreakdown: [
              d82.BreakdownLine(label: 'Monthly record', amount: '1250.50'),
            ],
          ),
  ),
  p18.otherAssetListProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d82.OtherAsset(
              id: 'fixture',
              type: d82.AssetType.PROPERTY,
              name: 'September essentials',
              estimatedValue: '1250.50',
            ),
          ],
  ),
  p19.notificationRuleListProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d85.NotificationRule(
              type: d85.NotificationRuleType.BILL_DUE_SOON,
              enabled: false,
            ),
          ],
  ),
  p20.notificationListProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d88.AppNotification(
              id: 'fixture',
              type: 'Monthly record',
              title: 'September essentials',
              body: 'Monthly record',
              read: false,
              createdAt: '2026-09-10',
            ),
          ],
  ),
  p20.unreadNotificationCountProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : 1,
  ),
  p21.personalTaxCalculationProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d91.PersonalTaxCalculation(
            yearOfAssessment: 2026,
            totalIncome: '1250.50',
            residentIndividualRelief: 'Monthly record',
            reliefs: [
              d91.TaxReliefLine(
                label: 'Monthly record',
                claimedAmount: '1250.50',
                maxAmount: '1250.50',
              ),
            ],
            totalReliefs: '1250.50',
            chargeableIncome: '1250.50',
            grossTaxPayable: '1250.50',
            rebate: 'Monthly record',
            zakatPaid: 'fixture',
            zakatRebate: 'Monthly record',
            taxAfterRebatesAndZakat: '1250.50',
            pcbPaid: 'fixture',
            estimatedPayableOrRefund: '1250.50',
            disclaimer: 'Monthly record',
          ),
  ),
  p21.filingReadinessProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d91.FilingReadiness(
            yearOfAssessment: 2026,
            readyPercent: 'Monthly record',
            items: [
              d91.FilingReadinessItem(
                key: 'Monthly record',
                label: 'Monthly record',
                ready: false,
                explanation: 'Monthly record',
              ),
            ],
          ),
  ),
  p21.personalIncomeListProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d91.PersonalIncomeRecord(
              id: 'fixture',
              yearOfAssessment: 2026,
              incomeType: d91.IncomeType.EMPLOYMENT,
              amount: '1250.50',
            ),
          ],
  ),
  p21.pcbListProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d91.PcbPayment(
              id: 'fixture',
              yearOfAssessment: 2026,
              month: 9,
              amount: '1250.50',
            ),
          ],
  ),
  p21.zakatListProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d91.ZakatPayment(
              id: 'fixture',
              yearOfAssessment: 2026,
              amount: '1250.50',
              paidOn: '2026-09-10',
            ),
          ],
  ),
  p21.taxDocumentListProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d91.PersonalTaxDocument(
              id: 'fixture',
              yearOfAssessment: 2026,
              type: d91.TaxDocumentType.EA,
              hasFile: false,
            ),
          ],
  ),
  p21.reliefCandidateListProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d91.TaxReliefCandidate(
              id: 'fixture',
              yearOfAssessment: 2026,
              suggestedAmount: '1250.50',
              status: d91.TaxReliefCandidateStatus.POTENTIALLY_ELIGIBLE,
            ),
          ],
  ),
  p21.confirmedReliefListProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d91.ConfirmedTaxRelief(
              id: 'fixture',
              yearOfAssessment: 2026,
              category: d91.PersonalTaxReliefCategory.SPOUSE,
              confirmedAmount: '1250.50',
            ),
          ],
  ),
  p22.receiptVaultListProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d97.VaultReceipt(
              id: 'fixture',
              purpose: d97.ReceiptPurpose.PERSONAL_EXPENSE,
              ocrStatus: d97.VaultOcrStatus.UNPROCESSED,
              tags: ['Monthly record'],
              imageUrl: 'https://example.invalid/receipt.png',
            ),
          ],
  ),
  p22.receiptMatchSuggestionsProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d97.ReceiptMatchSuggestion(
              transactionId: 'fixture',
              occurredOn: '2026-09-10',
              amount: '1250.50',
              confidence: d97.ReceiptMatchConfidence.EXACT,
            ),
          ],
  ),
  p23.receiptScanForReviewProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d94.ReceiptScan(
            id: 'fixture',
            status: d94.ScanStatus.PARSED,
            provider: 'Monthly record',
            parsedReceipt: d94.ParsedReceipt(
              merchantConfidence: 1.0,
              receiptDateConfidence: 1.0,
              items: [d94.ParsedReceiptItem(confidence: 1.0)],
              taxConfidence: 1.0,
              serviceConfidence: 1.0,
              discountConfidence: 1.0,
              totalConfidence: 1.0,
              overallConfidence: 1.0,
            ),
            imageUrl: 'https://example.invalid/receipt.png',
          ),
  ),
  p24.statementImportListProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d100.BusinessStatementImportResponse(
              id: 'fixture',
              businessAccountId: 'fixture',
              provider: d100.StatementProvider.GENERIC_CSV,
              originalFilename: 'September essentials',
              status: d100.BusinessStatementImportStatus.PARSED,
              rowCount: 1,
            ),
          ],
  ),
  p24.statementLinesProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d100.StatementLineResponse(
              id: 'fixture',
              occurredOn: '2026-09-10',
              amount: '1250.50',
              status: d100.StatementLineStatus.UNMATCHED,
            ),
          ],
  ),
  p24.matchSuggestionsProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d100.MatchSuggestionResponse(
              businessAccountEntryId: 'fixture',
              occurredOn: '2026-09-10',
              signedAmount: '1250.50',
              confidence: d100.MatchConfidence.EXACT,
            ),
          ],
  ),
  p24.reconciliationSessionListProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d100.ReconciliationSessionResponse(
              id: 'fixture',
              businessAccountId: 'fixture',
              businessStatementImportId: 'fixture',
              status: d100.ReconciliationSessionStatus.IN_PROGRESS,
              startedAt: 'Monthly record',
            ),
          ],
  ),
  p24.reconciliationSessionProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d100.ReconciliationSessionResponse(
            id: 'fixture',
            businessAccountId: 'fixture',
            businessStatementImportId: 'fixture',
            status: d100.ReconciliationSessionStatus.IN_PROGRESS,
            startedAt: 'Monthly record',
          ),
  ),
  p24.reconciliationSummaryProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d100.ReconciliationSummaryResponse(
            unmatchedCount: 1,
            matchedCount: 1,
            createdCount: 1,
            ignoredCount: 1,
            splitCount: 1,
            ledgerBalance: '1250.50',
          ),
  ),
  p25.recurringTransactionListProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d103.RecurringTransaction(
              id: 'fixture',
              accountId: 'fixture',
              type: d12.TransactionType.INCOME,
              direction: d12.TransactionDirection.IN,
              amount: '1250.50',
              frequency: d103.RecurrenceFrequency.DAILY,
              intervalCount: 1,
              startDate: '2026-09-10',
              nextOccurrenceDate: '2026-09-10',
              isSubscription: false,
              active: false,
            ),
          ],
  ),
  p25.subscriptionsSummaryProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d103.SubscriptionsSummary(
            estimatedMonthlyTotal: '1250.50',
            subscriptions: [
              d103.RecurringTransaction(
                id: 'fixture',
                accountId: 'fixture',
                type: d12.TransactionType.INCOME,
                direction: d12.TransactionDirection.IN,
                amount: '1250.50',
                frequency: d103.RecurrenceFrequency.DAILY,
                intervalCount: 1,
                startDate: '2026-09-10',
                nextOccurrenceDate: '2026-09-10',
                isSubscription: false,
                active: false,
              ),
            ],
          ),
  ),
  p26.settlementListProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d106.Settlement(
              id: 'fixture',
              fromUserId: 'fixture',
              fromDisplayName: 'September essentials',
              toUserId: 'fixture',
              toDisplayName: 'September essentials',
              amount: '1250.50',
              amountPaid: 'fixture',
              amountRemaining: '1250.50',
              status: d106.SettlementStatus.UNPAID,
              sourceType: d106.SourceType.BILL,
              sourceId: 'fixture',
              createdAt: '2026-09-10',
              handoff: d106.PaymentHandoffLink(
                provider: 'Monthly record',
                instructions: 'Monthly record',
              ),
            ),
          ],
  ),
  p26.settlementSummaryProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d106.SettlementSummary(
            totalOwedToMe: '1250.50',
            totalIOwe: '1250.50',
            owedToMe: [
              d106.CounterpartySummary(
                userId: 'fixture',
                displayName: 'September essentials',
                netAmount: '1250.50',
                oldestUnpaidDays: 1,
              ),
            ],
            iOwe: [
              d106.CounterpartySummary(
                userId: 'fixture',
                displayName: 'September essentials',
                netAmount: '1250.50',
                oldestUnpaidDays: 1,
              ),
            ],
          ),
  ),
  p27.spaceListProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d109.FinancialSpace(
              id: 'fixture',
              type: d109.SpaceType.PERSONAL,
              name: 'September essentials',
              yourRole: d109.SpaceRole.OWNER,
              status: d109.SpaceStatus.ACTIVE,
            ),
          ],
  ),
  p27.spaceMembersProvider.overrideWith(
    (ref, key) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d112.SpaceMember(
              id: 'fixture',
              userId: 'fixture',
              role: d109.SpaceRole.OWNER,
              status: d112.MemberStatus.ACTIVE,
            ),
          ],
  ),
  p28.entitlementProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d115.Entitlement(
            tier: d115.SubscriptionTier.FREE,
            activeGroupCount: 1,
            receiptScansThisMonth: 9,
          ),
  ),
  p29.transactionRuleListProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [
            d118.TransactionRule(
              id: 'fixture',
              matchType: d118.MatchType.MERCHANT_EQUALS,
              matchValue: '1250.50',
              categoryId: 'fixture',
              priority: 1,
              active: false,
              learned: false,
            ),
          ],
  ),
  p30.wrappedPromoProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : d121.WrappedPromo(available: false),
  ),
  p30.wrappedHistoryProvider.overrideWith(
    (ref) async => failed
        ? throw const AppException(
            statusCode: 0,
            code: 'OFFLINE',
            message: 'Check your connection and try again.',
          )
        : [d121.WrappedHistoryItem(year: 2026, month: 9, viewed: false)],
  ),
];

// Private screen providers and read-only detail requests use this boundary.
// An unexpected endpoint fails immediately; previews never start HTTP retries.
class _PreviewApi extends ApiClient {
  _PreviewApi(this.failed) : super(SecureStorage());
  final bool failed;
  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? query,
    bool skipAuth = false,
  }) async {
    if (failed) {
      throw const AppException(
        statusCode: 0,
        code: 'OFFLINE',
        message: 'Check your connection and try again.',
      );
    }
    if (path.endsWith('/business-profile')) {
      return const d109.BusinessProfile(
        spaceId: 'fixture',
        legalName: 'Duitlah Studio',
        currency: 'MYR',
        industry: 'Design services',
        annualRevenue: '125000.00',
      ).toJson();
    }
    if (path == '/api/v1/receipts/vault/fixture') {
      return const d97.VaultReceipt(
        id: 'fixture',
        purpose: d97.ReceiptPurpose.PERSONAL_EXPENSE,
        ocrStatus: d97.VaultOcrStatus.PARSED,
        tags: ['September'],
        merchant: 'Everyday groceries',
        receiptDate: '2026-09-10',
        totalAmount: '125.50',
        imageUrl: 'https://example.invalid/receipt.png',
      ).toJson();
    }
    if (path.endsWith('/customers')) {
      return [const d43.Customer(id: 'fixture', name: 'Duitlah Studio', paymentTermsDays: 30, status: d43.ContactStatus.ACTIVE).toJson()];
    }
    if (path.endsWith('/products')) {
      return [const d40.Product(id: 'fixture', name: 'Design services', type: d40.ProductType.SERVICE,
        unitPrice: '125.50', active: true, taxClassification: d40.TaxClassification.NOT_APPLICABLE,
        trackInventory: false).toJson()];
    }
    if (path.endsWith('/payments')) return <dynamic>[];
    if (path.endsWith('/spending-by-category')) {
      return [
        const d73.CategorySpending(
          categoryId: 'fixture',
          categoryName: 'Food & groceries',
          amount: '450.50',
        ).toJson(),
      ];
    }
    throw StateError('Unstubbed preview endpoint: $path');
  }
}
