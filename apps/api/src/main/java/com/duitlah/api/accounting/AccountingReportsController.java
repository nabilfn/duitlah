package com.duitlah.api.accounting;

import java.time.LocalDate;
import java.util.UUID;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class AccountingReportsController {

  private final GeneralLedgerService generalLedgerService;
  private final TrialBalanceService trialBalanceService;
  private final IncomeStatementService incomeStatementService;
  private final BalanceSheetService balanceSheetService;
  private final CashFlowService cashFlowService;

  public AccountingReportsController(
      GeneralLedgerService generalLedgerService,
      TrialBalanceService trialBalanceService,
      IncomeStatementService incomeStatementService,
      BalanceSheetService balanceSheetService,
      CashFlowService cashFlowService) {
    this.generalLedgerService = generalLedgerService;
    this.trialBalanceService = trialBalanceService;
    this.incomeStatementService = incomeStatementService;
    this.balanceSheetService = balanceSheetService;
    this.cashFlowService = cashFlowService;
  }

  @GetMapping("/api/v1/spaces/{spaceId}/accounting/reports/general-ledger")
  public GeneralLedgerResponse generalLedger(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @RequestParam UUID accountId,
      @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
      @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to) {
    return generalLedgerService.forAccount(userId, spaceId, accountId, from, to);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/accounting/reports/trial-balance")
  public TrialBalanceResponse trialBalance(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate asOf) {
    return trialBalanceService.generate(userId, spaceId, asOf);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/accounting/reports/income-statement")
  public IncomeStatementResponse incomeStatement(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
      @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to) {
    return incomeStatementService.generate(userId, spaceId, from, to);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/accounting/reports/balance-sheet")
  public BalanceSheetResponse balanceSheet(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate asOf) {
    return balanceSheetService.generate(userId, spaceId, asOf);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/accounting/reports/cash-flow")
  public CashFlowResponse cashFlow(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
      @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to) {
    return cashFlowService.generate(userId, spaceId, from, to);
  }
}
