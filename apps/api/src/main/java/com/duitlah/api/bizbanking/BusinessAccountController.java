package com.duitlah.api.bizbanking;

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
public class BusinessAccountController {

  private final BusinessAccountService accounts;

  public BusinessAccountController(BusinessAccountService accounts) {
    this.accounts = accounts;
  }

  @PostMapping("/api/v1/spaces/{spaceId}/business-accounts")
  @ResponseStatus(HttpStatus.CREATED)
  public BusinessAccountResponse create(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @Valid @RequestBody CreateBusinessAccountRequest request) {
    return accounts.create(userId, spaceId, request);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/business-accounts")
  public List<BusinessAccountResponse> list(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID spaceId) {
    return accounts.list(userId, spaceId);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/business-accounts/{accountId}")
  public BusinessAccountResponse get(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID accountId) {
    return accounts.get(userId, spaceId, accountId);
  }

  @PatchMapping("/api/v1/spaces/{spaceId}/business-accounts/{accountId}")
  public BusinessAccountResponse update(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID accountId,
      @Valid @RequestBody UpdateBusinessAccountRequest request) {
    return accounts.update(userId, spaceId, accountId, request);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/business-accounts/{accountId}/entries")
  public List<EntryResponse> listEntries(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID accountId) {
    return accounts.listEntries(userId, spaceId, accountId);
  }

  @PostMapping("/api/v1/spaces/{spaceId}/business-accounts/{accountId}/entries")
  @ResponseStatus(HttpStatus.CREATED)
  public EntryResponse addEntry(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID accountId,
      @Valid @RequestBody CreateEntryRequest request) {
    return accounts.addEntry(userId, spaceId, accountId, request);
  }

  @PostMapping("/api/v1/spaces/{spaceId}/business-accounts/{accountId}/transfer")
  @ResponseStatus(HttpStatus.CREATED)
  public void transfer(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID accountId,
      @Valid @RequestBody TransferRequest request) {
    accounts.transfer(userId, spaceId, accountId, request);
  }

  @PatchMapping("/api/v1/spaces/{spaceId}/business-accounts/{accountId}/chart-of-accounts-mapping")
  public BusinessAccountResponse mapToChartOfAccounts(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID accountId,
      @Valid @RequestBody ChartOfAccountsMappingRequest request) {
    return accounts.mapToChartOfAccounts(userId, spaceId, accountId, request.chartOfAccountsId());
  }
}
