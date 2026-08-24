package com.duitlah.api.ai;

import com.duitlah.api.bills.PersonalBillService;
import com.duitlah.api.liabilities.LiabilityService;
import com.duitlah.api.networth.NetWorthService;
import com.duitlah.api.personaltax.PersonalTaxCalculationService;
import com.duitlah.api.personaltax.TaxReliefCandidateService;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import org.springframework.stereotype.Component;

/**
 * V2 Phase 12 — spec section 66's Personal tool list ({@code get_dashboard}, {@code get_spending},
 * {@code get_budget}, {@code get_forecast}, {@code get_net_worth}, {@code get_loans}, {@code
 * get_bills}, {@code get_tax_summary}, {@code get_tax_reliefs} — a suggested minimum ("might
 * include"), not exhaustive; the original V1 assistant's own extra tools ({@code
 * get_dashboard_summary}, {@code get_monthly_trend}, {@code get_top_merchants}, {@code
 * get_settlements_summary}, {@code check_affordability}) stay exactly as they were rather than
 * being renamed or removed, so nothing that already worked regresses.
 */
@Component
public class PersonalAiToolProvider implements AiToolProvider {

  private final FinanceQueryService financeQueryService;
  private final AffordabilityService affordabilityService;
  private final NetWorthService netWorthService;
  private final LiabilityService liabilityService;
  private final PersonalBillService personalBillService;
  private final PersonalTaxCalculationService personalTaxCalculationService;
  private final TaxReliefCandidateService taxReliefCandidateService;

  public PersonalAiToolProvider(
      FinanceQueryService financeQueryService,
      AffordabilityService affordabilityService,
      NetWorthService netWorthService,
      LiabilityService liabilityService,
      PersonalBillService personalBillService,
      PersonalTaxCalculationService personalTaxCalculationService,
      TaxReliefCandidateService taxReliefCandidateService) {
    this.financeQueryService = financeQueryService;
    this.affordabilityService = affordabilityService;
    this.netWorthService = netWorthService;
    this.liabilityService = liabilityService;
    this.personalBillService = personalBillService;
    this.personalTaxCalculationService = personalTaxCalculationService;
    this.taxReliefCandidateService = taxReliefCandidateService;
  }

  @Override
  public AiToolContext context() {
    return AiToolContext.PERSONAL;
  }

  @Override
  public List<AiToolDefinition> definitions() {
    return List.of(
        AiSchemas.definition(
            "get_dashboard_summary",
            "The user's current available balance, this month's income/expense totals, and recent transactions.",
            AiSchemas.emptyObject()),
        AiSchemas.definition(
            "get_spending_by_category",
            "Spending grouped by category for a given month. Defaults to the current month if year/month are omitted.",
            AiSchemas.yearMonthSchema()),
        AiSchemas.definition(
            "get_monthly_trend",
            "Income, expense, and savings totals per month for the last N months.",
            monthsSchema()),
        AiSchemas.definition(
            "get_top_merchants",
            "The merchants the user spent the most at in a given month. Defaults to the current month.",
            AiSchemas.yearMonthSchema()),
        AiSchemas.definition(
            "get_forecast",
            "A cash-flow forecast to the end of the current month: current balance, scheduled income/expense "
                + "from recurring rules, predicted variable spending, and the resulting projected balance.",
            AiSchemas.emptyObject()),
        AiSchemas.definition(
            "get_budgets",
            "The user's budgets and how much of each has been spent, for a given month. Defaults to the current month.",
            AiSchemas.yearMonthSchema()),
        AiSchemas.definition(
            "get_goals",
            "The user's savings goals, target amounts, and current progress.",
            AiSchemas.emptyObject()),
        AiSchemas.definition(
            "get_settlements_summary",
            "Who owes the user money and who the user owes money to, across bills and groups.",
            AiSchemas.emptyObject()),
        AiSchemas.definition(
            "check_affordability",
            "Computes whether a purchase of a given amount is affordable, based on the user's projected balance, "
                + "upcoming bills, debt repayments, and existing settlements. Always use this instead of estimating "
                + "affordability yourself.",
            affordabilitySchema()),
        AiSchemas.definition(
            "get_net_worth",
            "The user's total assets, total liabilities, and net worth, broken down by category.",
            AiSchemas.emptyObject()),
        AiSchemas.definition(
            "get_loans",
            "The user's personal loans, BNPL, and other liabilities: outstanding principal, instalment amount, "
                + "interest rate, and next due date.",
            AiSchemas.emptyObject()),
        AiSchemas.definition(
            "get_bills",
            "The user's personal recurring bills and their status (upcoming, due, paid, overdue).",
            AiSchemas.emptyObject()),
        AiSchemas.definition(
            "get_tax_summary",
            "The user's estimated personal income tax for a year of assessment: chargeable income, tax payable, "
                + "rebates, and estimated payable/refund. Defaults to the current year.",
            yearOfAssessmentSchema()),
        AiSchemas.definition(
            "get_tax_reliefs",
            "The user's personal tax relief candidates (potentially eligible, needs review, missing evidence) and "
                + "already-confirmed reliefs for a year of assessment. Defaults to the current year. Never state a "
                + "candidate is definitely eligible yourself -- relay its actual status.",
            yearOfAssessmentSchema()));
  }

  @Override
  public Object execute(UUID userId, UUID spaceId, String toolName, JsonNode input) {
    return switch (toolName) {
      case "get_dashboard_summary" -> financeQueryService.dashboardSummary(userId);
      case "get_spending_by_category" ->
          financeQueryService.spendingByCategory(
              userId, intArg(input, "year"), intArg(input, "month"));
      case "get_monthly_trend" -> financeQueryService.monthlyTrend(userId, intArg(input, "months"));
      case "get_top_merchants" ->
          financeQueryService.topMerchants(userId, intArg(input, "year"), intArg(input, "month"));
      case "get_forecast" -> financeQueryService.forecast(userId);
      case "get_budgets" ->
          financeQueryService.budgets(userId, intArg(input, "year"), intArg(input, "month"));
      case "get_goals" -> financeQueryService.goals(userId);
      case "get_settlements_summary" -> financeQueryService.settlementsSummary(userId);
      case "check_affordability" ->
          affordabilityService.check(
              userId,
              new AffordabilityRequest(
                  new BigDecimal(input.get("amount").asText()),
                  input != null && input.has("description")
                      ? input.get("description").asText()
                      : null));
      case "get_net_worth" -> netWorthService.compute(userId);
      case "get_loans" -> liabilityService.list(userId);
      case "get_bills" -> personalBillService.list(userId, null);
      case "get_tax_summary" ->
          personalTaxCalculationService.calculate(userId, intArg(input, "yearOfAssessment"));
      case "get_tax_reliefs" ->
          Map.of(
              "candidates",
                  taxReliefCandidateService.list(userId, intArg(input, "yearOfAssessment"), null),
              "confirmed",
                  taxReliefCandidateService.listConfirmed(
                      userId, intArg(input, "yearOfAssessment")));
      default -> throw new IllegalArgumentException("Unknown personal tool: " + toolName);
    };
  }

  private ObjectNode monthsSchema() {
    ObjectNode schema = AiSchemas.object();
    schema
        .putObject("properties")
        .set("months", AiSchemas.intProperty("How many recent months to include (default 6)."));
    return schema;
  }

  private ObjectNode affordabilitySchema() {
    ObjectNode schema = AiSchemas.object();
    ObjectNode properties = schema.putObject("properties");
    properties.set(
        "amount", AiSchemas.stringProperty("The purchase amount in MYR, e.g. \"250.00\"."));
    properties.set(
        "description",
        AiSchemas.stringProperty("A short label for what's being bought, e.g. 'AirPods'."));
    schema.putArray("required").add("amount");
    return schema;
  }

  private ObjectNode yearOfAssessmentSchema() {
    ObjectNode schema = AiSchemas.object();
    schema
        .putObject("properties")
        .set(
            "yearOfAssessment",
            AiSchemas.intProperty(
                "The year of assessment, e.g. 2026. Defaults to the current year."));
    return schema;
  }

  private int intArg(JsonNode input, String field) {
    if (input != null && input.has(field)) {
      return input.get(field).asInt();
    }
    LocalDate today = LocalDate.now();
    return switch (field) {
      case "year", "yearOfAssessment" -> today.getYear();
      case "month" -> today.getMonthValue();
      case "months" -> 6;
      default -> 0;
    };
  }
}
