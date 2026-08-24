package com.duitlah.api.ai;

import com.duitlah.api.accounting.BalanceSheetService;
import com.duitlah.api.accounting.CashFlowService;
import com.duitlah.api.accounting.IncomeStatementService;
import com.duitlah.api.bizdashboard.BusinessDashboardService;
import com.duitlah.api.bizexpenses.BusinessExpenseService;
import com.duitlah.api.bizexpenses.ExpenseResponse;
import com.duitlah.api.bizexpenses.ExpenseStatus;
import com.duitlah.api.businesstax.EInvoiceReadinessService;
import com.duitlah.api.businesstax.SstReportService;
import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.inventory.InventoryReportService;
import com.duitlah.api.reconciliation.ReconciliationSessionResponse;
import com.duitlah.api.reconciliation.ReconciliationSessionService;
import com.duitlah.api.sales.InvoiceEffectiveStatus;
import com.duitlah.api.sales.InvoiceResponse;
import com.duitlah.api.sales.InvoiceService;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import java.time.LocalDate;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import org.springframework.stereotype.Component;

/**
 * V2 Phase 12 — spec section 66's Business tool list plus section 69's own worked example questions
 * ("How profitable was this quarter?", "Which customers haven't paid?", "What is my current cash
 * runway?", "Which invoices are overdue?", "How much inventory is tied up in stock?"). Every tool
 * here needs an active {@code spaceId} — {@link ClaudeAiChatService} only activates this provider
 * once a chat's {@code activeSpaceId} resolves to a real BUSINESS space the user belongs to; every
 * downstream service call still enforces its own {@code VIEW_REPORTS}/membership check
 * independently (defense in depth, the same posture every other report endpoint in this codebase
 * already has).
 */
@Component
public class BusinessAiToolProvider implements AiToolProvider {

  private final BusinessDashboardService businessDashboardService;
  private final IncomeStatementService incomeStatementService;
  private final BalanceSheetService balanceSheetService;
  private final CashFlowService cashFlowService;
  private final InvoiceService invoiceService;
  private final BusinessExpenseService businessExpenseService;
  private final InventoryReportService inventoryReportService;
  private final SstReportService sstReportService;
  private final EInvoiceReadinessService einvoiceReadinessService;
  private final ReconciliationSessionService reconciliationSessionService;

  public BusinessAiToolProvider(
      BusinessDashboardService businessDashboardService,
      IncomeStatementService incomeStatementService,
      BalanceSheetService balanceSheetService,
      CashFlowService cashFlowService,
      InvoiceService invoiceService,
      BusinessExpenseService businessExpenseService,
      InventoryReportService inventoryReportService,
      SstReportService sstReportService,
      EInvoiceReadinessService einvoiceReadinessService,
      ReconciliationSessionService reconciliationSessionService) {
    this.businessDashboardService = businessDashboardService;
    this.incomeStatementService = incomeStatementService;
    this.balanceSheetService = balanceSheetService;
    this.cashFlowService = cashFlowService;
    this.invoiceService = invoiceService;
    this.businessExpenseService = businessExpenseService;
    this.inventoryReportService = inventoryReportService;
    this.sstReportService = sstReportService;
    this.einvoiceReadinessService = einvoiceReadinessService;
    this.reconciliationSessionService = reconciliationSessionService;
  }

  @Override
  public AiToolContext context() {
    return AiToolContext.BUSINESS;
  }

  @Override
  public List<AiToolDefinition> definitions() {
    return List.of(
        AiSchemas.definition(
            "get_business_dashboard",
            "Cash position, total receivables, total payables, and counts of customers/suppliers/products/open "
                + "invoices/unpaid expenses for the active business.",
            AiSchemas.emptyObject()),
        AiSchemas.definition(
            "get_profit_and_loss",
            "Revenue, expenses, and net profit for a date range. Defaults to year-to-date.",
            dateRangeSchema()),
        AiSchemas.definition(
            "get_balance_sheet",
            "Assets, liabilities, and equity as of a date. Defaults to today.",
            asOfSchema()),
        AiSchemas.definition(
            "get_cash_flow",
            "Cash in and out for a date range (direct method). Defaults to year-to-date.",
            dateRangeSchema()),
        AiSchemas.definition(
            "get_receivables",
            "Invoices with an outstanding amount still owed by customers, i.e. money the business is owed.",
            AiSchemas.emptyObject()),
        AiSchemas.definition(
            "get_payables",
            "Business expenses that haven't been fully paid yet, i.e. money the business still owes.",
            AiSchemas.emptyObject()),
        AiSchemas.definition(
            "get_overdue_invoices",
            "Invoices past their due date that still have an outstanding balance.",
            AiSchemas.emptyObject()),
        AiSchemas.definition(
            "get_inventory",
            "Current stock valuation for every tracked product (quantity on hand, weighted average cost, total "
                + "value), and Cost of Goods Sold for a date range if given. Defaults COGS to year-to-date.",
            dateRangeSchema()),
        AiSchemas.definition(
            "get_tax_summary",
            "The business's SST collected/payable for a date range (defaults to year-to-date) and its e-Invoice "
                + "mandate readiness.",
            dateRangeSchema()),
        AiSchemas.definition(
            "get_reconciliation_status",
            "The most recent bank reconciliation session's match counts and any unresolved difference against "
                + "the ledger balance.",
            AiSchemas.emptyObject()));
  }

  @Override
  public Object execute(UUID userId, UUID spaceId, String toolName, JsonNode input) {
    return switch (toolName) {
      case "get_business_dashboard" -> businessDashboardService.get(userId, spaceId);
      case "get_profit_and_loss" ->
          incomeStatementService.generate(userId, spaceId, fromArg(input), toArg(input));
      case "get_balance_sheet" -> balanceSheetService.generate(userId, spaceId, asOfArg(input));
      case "get_cash_flow" ->
          cashFlowService.generate(userId, spaceId, fromArg(input), toArg(input));
      case "get_receivables" -> receivables(userId, spaceId);
      case "get_payables" -> payables(userId, spaceId);
      case "get_overdue_invoices" -> overdueInvoices(userId, spaceId);
      case "get_inventory" ->
          Map.of(
              "stockValuation", inventoryReportService.stockValuation(userId, spaceId),
              "cogsForPeriod",
                  inventoryReportService.cogsForPeriod(
                      userId, spaceId, fromArg(input), toArg(input)));
      case "get_tax_summary" ->
          Map.of(
              "sstReport",
                  sstReportService.reportForPeriod(userId, spaceId, fromArg(input), toArg(input)),
              "einvoiceReadiness", einvoiceReadinessService.evaluate(userId, spaceId));
      case "get_reconciliation_status" -> reconciliationStatus(userId, spaceId);
      default -> throw new IllegalArgumentException("Unknown business tool: " + toolName);
    };
  }

  private List<InvoiceResponse> receivables(UUID userId, UUID spaceId) {
    return invoiceService.list(userId, spaceId).stream()
        .filter(i -> i.amountOutstanding().signum() > 0)
        .toList();
  }

  private List<ExpenseResponse> payables(UUID userId, UUID spaceId) {
    return businessExpenseService.list(userId, spaceId).stream()
        .filter(e -> e.status() != ExpenseStatus.PAID)
        .toList();
  }

  private List<InvoiceResponse> overdueInvoices(UUID userId, UUID spaceId) {
    return invoiceService.list(userId, spaceId).stream()
        .filter(i -> i.effectiveStatus() == InvoiceEffectiveStatus.OVERDUE)
        .toList();
  }

  private Object reconciliationStatus(UUID userId, UUID spaceId) {
    List<ReconciliationSessionResponse> sessions =
        reconciliationSessionService.list(userId, spaceId);
    if (sessions.isEmpty()) {
      return Map.of(
          "message", "No reconciliation sessions have been started for this business yet.");
    }
    ReconciliationSessionResponse latest =
        sessions.stream()
            .max(Comparator.comparing(ReconciliationSessionResponse::startedAt))
            .orElseThrow();
    try {
      return reconciliationSessionService.summary(userId, spaceId, latest.id());
    } catch (NotFoundException e) {
      return Map.of(
          "message", "No reconciliation sessions have been started for this business yet.");
    }
  }

  private LocalDate fromArg(JsonNode input) {
    if (input != null && input.has("from")) {
      return LocalDate.parse(input.get("from").asText());
    }
    return LocalDate.now().withDayOfYear(1);
  }

  private LocalDate toArg(JsonNode input) {
    if (input != null && input.has("to")) {
      return LocalDate.parse(input.get("to").asText());
    }
    return LocalDate.now();
  }

  private LocalDate asOfArg(JsonNode input) {
    if (input != null && input.has("asOf")) {
      return LocalDate.parse(input.get("asOf").asText());
    }
    return LocalDate.now();
  }

  private ObjectNode dateRangeSchema() {
    ObjectNode schema = AiSchemas.object();
    ObjectNode properties = schema.putObject("properties");
    properties.set(
        "from",
        AiSchemas.stringProperty(
            "Start date, ISO format (YYYY-MM-DD). Defaults to Jan 1 of the current year."));
    properties.set(
        "to", AiSchemas.stringProperty("End date, ISO format (YYYY-MM-DD). Defaults to today."));
    return schema;
  }

  private ObjectNode asOfSchema() {
    ObjectNode schema = AiSchemas.object();
    schema
        .putObject("properties")
        .set("asOf", AiSchemas.stringProperty("Date, ISO format (YYYY-MM-DD). Defaults to today."));
    return schema;
  }
}
