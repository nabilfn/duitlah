package com.duitlah.api.bizexpenses;

import com.duitlah.api.accounting.AutomaticPostingService;
import com.duitlah.api.accounting.ChartOfAccountsService;
import com.duitlah.api.bizbanking.BusinessAccount;
import com.duitlah.api.bizbanking.BusinessAccountService;
import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.crm.SupplierService;
import com.duitlah.api.spaces.BusinessPermission;
import com.duitlah.api.spaces.SpaceService;
import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class BusinessExpenseService {

  private final BusinessExpenseRepository expenses;
  private final ExpensePaymentRepository payments;
  private final SpaceService spaceService;
  private final SupplierService supplierService;
  private final BusinessAccountService businessAccountService;
  private final ChartOfAccountsService chartOfAccounts;
  private final AutomaticPostingService automaticPostingService;

  public BusinessExpenseService(
      BusinessExpenseRepository expenses,
      ExpensePaymentRepository payments,
      SpaceService spaceService,
      SupplierService supplierService,
      BusinessAccountService businessAccountService,
      ChartOfAccountsService chartOfAccounts,
      AutomaticPostingService automaticPostingService) {
    this.expenses = expenses;
    this.payments = payments;
    this.spaceService = spaceService;
    this.supplierService = supplierService;
    this.businessAccountService = businessAccountService;
    this.chartOfAccounts = chartOfAccounts;
    this.automaticPostingService = automaticPostingService;
  }

  @Transactional
  public ExpenseResponse create(UUID userId, UUID spaceId, CreateExpenseRequest request) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.RECORD_EXPENSES);
    if (request.supplierId() != null) {
      supplierService.requireOwned(spaceId, request.supplierId());
    }
    BusinessExpense expense =
        new BusinessExpense(
            spaceId,
            request.supplierId(),
            request.category(),
            request.amount(),
            request.occurredOn());
    expense.setReceiptId(request.receiptId());
    expense.setNotes(request.notes());
    expenses.save(expense);
    return ExpenseResponse.of(expense, BigDecimal.ZERO);
  }

  public List<ExpenseResponse> list(UUID userId, UUID spaceId) {
    spaceService.requireMembership(userId, spaceId);
    return expenses.findBySpaceIdOrderByOccurredOnDesc(spaceId).stream()
        .map(e -> ExpenseResponse.of(e, amountPaidOf(e)))
        .toList();
  }

  public ExpenseResponse get(UUID userId, UUID spaceId, UUID expenseId) {
    spaceService.requireMembership(userId, spaceId);
    BusinessExpense expense = requireOwned(spaceId, expenseId);
    return ExpenseResponse.of(expense, amountPaidOf(expense));
  }

  public List<ExpensePaymentResponse> listPayments(UUID userId, UUID spaceId, UUID expenseId) {
    spaceService.requireMembership(userId, spaceId);
    requireOwned(spaceId, expenseId);
    return payments.findByBusinessExpenseIdOrderByPaidOnDesc(expenseId).stream()
        .map(ExpensePaymentResponse::of)
        .toList();
  }

  @Transactional
  public ExpensePaymentResponse recordPayment(
      UUID userId, UUID spaceId, UUID expenseId, RecordExpensePaymentRequest request) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.RECORD_PAYMENTS);
    BusinessExpense expense = requireOwned(spaceId, expenseId);
    BusinessAccount businessAccount =
        businessAccountService.requireOwned(spaceId, request.businessAccountId());

    ExpensePayment payment =
        new ExpensePayment(
            expenseId,
            request.businessAccountId(),
            request.amount(),
            request.paidOn(),
            request.notes());
    payments.save(payment);

    String description =
        "Expense payment: "
            + (expense.getCategory() != null ? expense.getCategory() : expense.getId());
    businessAccountService.recordExpensePayment(
        request.businessAccountId(),
        request.amount(),
        request.paidOn(),
        description,
        payment.getId());
    automaticPostingService.postExpensePayment(
        spaceId,
        userId,
        payment.getId(),
        request.paidOn(),
        request.amount(),
        description,
        expense.getChartOfAccountsId(),
        businessAccount.getChartOfAccountsId());

    BigDecimal totalPaid = amountPaidOf(expense);
    expense.setStatus(
        totalPaid.compareTo(expense.getAmount()) >= 0
            ? ExpenseStatus.PAID
            : totalPaid.signum() > 0 ? ExpenseStatus.PARTIALLY_PAID : ExpenseStatus.UNPAID);
    expenses.save(expense);

    return ExpensePaymentResponse.of(payment);
  }

  /**
   * V2 Phase 6 — which expense ledger account this bill posts to when paid; gated by {@code
   * MANAGE_BOOKS} since it's an accounting-classification decision.
   */
  @Transactional
  public ExpenseResponse mapToChartOfAccounts(
      UUID userId, UUID spaceId, UUID expenseId, UUID chartOfAccountsId) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_BOOKS);
    BusinessExpense expense = requireOwned(spaceId, expenseId);
    if (chartOfAccountsId != null) {
      chartOfAccounts.requireOwned(spaceId, chartOfAccountsId);
    }
    expense.setChartOfAccountsId(chartOfAccountsId);
    expenses.save(expense);
    return ExpenseResponse.of(expense, amountPaidOf(expense));
  }

  private BigDecimal amountPaidOf(BusinessExpense expense) {
    return payments.sumAmountByBusinessExpenseId(expense.getId());
  }

  public BusinessExpense requireOwned(UUID spaceId, UUID expenseId) {
    return expenses
        .findByIdAndSpaceId(expenseId, spaceId)
        .orElseThrow(
            () ->
                new NotFoundException("BUSINESS_EXPENSE_NOT_FOUND", "Business expense not found."));
  }
}
