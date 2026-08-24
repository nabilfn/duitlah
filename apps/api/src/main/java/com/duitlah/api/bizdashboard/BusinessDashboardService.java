package com.duitlah.api.bizdashboard;

import com.duitlah.api.bizbanking.BusinessAccountResponse;
import com.duitlah.api.bizbanking.BusinessAccountService;
import com.duitlah.api.bizexpenses.BusinessExpenseService;
import com.duitlah.api.bizexpenses.ExpenseResponse;
import com.duitlah.api.bizexpenses.ExpenseStatus;
import com.duitlah.api.catalog.ProductRepository;
import com.duitlah.api.crm.CustomerRepository;
import com.duitlah.api.crm.SupplierRepository;
import com.duitlah.api.sales.InvoiceEffectiveStatus;
import com.duitlah.api.sales.InvoiceResponse;
import com.duitlah.api.sales.InvoiceService;
import com.duitlah.api.spaces.SpaceService;
import java.math.BigDecimal;
import java.util.EnumSet;
import java.util.Set;
import java.util.UUID;
import org.springframework.stereotype.Service;

@Service
public class BusinessDashboardService {

  private static final Set<InvoiceEffectiveStatus> OPEN_RECEIVABLE_STATUSES =
      EnumSet.of(
          InvoiceEffectiveStatus.SENT,
          InvoiceEffectiveStatus.PARTIALLY_PAID,
          InvoiceEffectiveStatus.OVERDUE);

  private final SpaceService spaceService;
  private final BusinessAccountService businessAccountService;
  private final InvoiceService invoiceService;
  private final BusinessExpenseService expenseService;
  private final CustomerRepository customers;
  private final SupplierRepository suppliers;
  private final ProductRepository products;

  public BusinessDashboardService(
      SpaceService spaceService,
      BusinessAccountService businessAccountService,
      InvoiceService invoiceService,
      BusinessExpenseService expenseService,
      CustomerRepository customers,
      SupplierRepository suppliers,
      ProductRepository products) {
    this.spaceService = spaceService;
    this.businessAccountService = businessAccountService;
    this.invoiceService = invoiceService;
    this.expenseService = expenseService;
    this.customers = customers;
    this.suppliers = suppliers;
    this.products = products;
  }

  public BusinessDashboardResponse get(UUID userId, UUID spaceId) {
    spaceService.requireMembership(userId, spaceId);

    BigDecimal cashPosition =
        businessAccountService.list(userId, spaceId).stream()
            .filter(a -> !a.archived() && "MYR".equals(a.currency()))
            .map(BusinessAccountResponse::balance)
            .reduce(BigDecimal.ZERO, BigDecimal::add);

    var openInvoices =
        invoiceService.list(userId, spaceId).stream()
            .filter(i -> OPEN_RECEIVABLE_STATUSES.contains(i.effectiveStatus()))
            .toList();
    BigDecimal totalReceivables =
        openInvoices.stream()
            .map(InvoiceResponse::amountOutstanding)
            .reduce(BigDecimal.ZERO, BigDecimal::add);

    var unpaidExpenses =
        expenseService.list(userId, spaceId).stream()
            .filter(e -> e.status() != ExpenseStatus.PAID)
            .toList();
    BigDecimal totalPayables =
        unpaidExpenses.stream()
            .map(ExpenseResponse::amountRemaining)
            .reduce(BigDecimal.ZERO, BigDecimal::add);

    return new BusinessDashboardResponse(
        cashPosition,
        totalReceivables,
        totalPayables,
        customers.countBySpaceId(spaceId),
        suppliers.countBySpaceId(spaceId),
        products.countBySpaceId(spaceId),
        openInvoices.size(),
        unpaidExpenses.size());
  }
}
