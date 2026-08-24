package com.duitlah.api.bizexpenses;

import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class BusinessExpenseController {

  private final BusinessExpenseService expenseService;

  public BusinessExpenseController(BusinessExpenseService expenseService) {
    this.expenseService = expenseService;
  }

  @PostMapping("/api/v1/spaces/{spaceId}/expenses")
  @ResponseStatus(HttpStatus.CREATED)
  public ExpenseResponse create(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @Valid @RequestBody CreateExpenseRequest request) {
    return expenseService.create(userId, spaceId, request);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/expenses")
  public List<ExpenseResponse> list(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID spaceId) {
    return expenseService.list(userId, spaceId);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/expenses/{expenseId}")
  public ExpenseResponse get(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID expenseId) {
    return expenseService.get(userId, spaceId, expenseId);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/expenses/{expenseId}/payments")
  public List<ExpensePaymentResponse> listPayments(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID expenseId) {
    return expenseService.listPayments(userId, spaceId, expenseId);
  }

  @PostMapping("/api/v1/spaces/{spaceId}/expenses/{expenseId}/payments")
  @ResponseStatus(HttpStatus.CREATED)
  public ExpensePaymentResponse recordPayment(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID expenseId,
      @Valid @RequestBody RecordExpensePaymentRequest request) {
    return expenseService.recordPayment(userId, spaceId, expenseId, request);
  }

  @PatchMapping("/api/v1/spaces/{spaceId}/expenses/{expenseId}/chart-of-accounts-mapping")
  public ExpenseResponse mapToChartOfAccounts(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID expenseId,
      @Valid @RequestBody ChartOfAccountsMappingRequest request) {
    return expenseService.mapToChartOfAccounts(
        userId, spaceId, expenseId, request.chartOfAccountsId());
  }
}
