package com.duitlah.api.accounting;

import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ChartOfAccountsController {

  private final ChartOfAccountsService chartOfAccounts;

  public ChartOfAccountsController(ChartOfAccountsService chartOfAccounts) {
    this.chartOfAccounts = chartOfAccounts;
  }

  @PostMapping("/api/v1/spaces/{spaceId}/accounting/chart-of-accounts/seed-defaults")
  @ResponseStatus(HttpStatus.CREATED)
  public List<LedgerAccountResponse> seedDefaults(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID spaceId) {
    return chartOfAccounts.seedDefaults(userId, spaceId);
  }

  @PostMapping("/api/v1/spaces/{spaceId}/accounting/chart-of-accounts")
  @ResponseStatus(HttpStatus.CREATED)
  public LedgerAccountResponse create(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @Valid @RequestBody CreateLedgerAccountRequest request) {
    return chartOfAccounts.create(userId, spaceId, request);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/accounting/chart-of-accounts")
  public List<LedgerAccountResponse> list(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID spaceId) {
    return chartOfAccounts.list(userId, spaceId);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/accounting/chart-of-accounts/{accountId}")
  public LedgerAccountResponse get(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID accountId) {
    return chartOfAccounts.get(userId, spaceId, accountId);
  }

  @PutMapping("/api/v1/spaces/{spaceId}/accounting/chart-of-accounts/{accountId}")
  public LedgerAccountResponse update(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID accountId,
      @Valid @RequestBody CreateLedgerAccountRequest request) {
    return chartOfAccounts.update(userId, spaceId, accountId, request);
  }

  @DeleteMapping("/api/v1/spaces/{spaceId}/accounting/chart-of-accounts/{accountId}")
  public void archive(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID accountId) {
    chartOfAccounts.archive(userId, spaceId, accountId);
  }
}
