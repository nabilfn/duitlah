package com.duitlah.api.finance;

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
public class AccountController {

  private final AccountService accountService;

  public AccountController(AccountService accountService) {
    this.accountService = accountService;
  }

  @GetMapping("/api/v1/accounts")
  public List<AccountResponse> list(@AuthenticationPrincipal UUID userId) {
    return accountService.listForUser(userId);
  }

  @GetMapping("/api/v1/accounts/{accountId}")
  public AccountResponse get(@AuthenticationPrincipal UUID userId, @PathVariable UUID accountId) {
    return accountService.getForUser(userId, accountId);
  }

  @PostMapping("/api/v1/accounts")
  @ResponseStatus(HttpStatus.CREATED)
  public AccountResponse create(
      @AuthenticationPrincipal UUID userId, @Valid @RequestBody CreateAccountRequest request) {
    return accountService.create(userId, request);
  }

  @PatchMapping("/api/v1/accounts/{accountId}")
  public AccountResponse update(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID accountId,
      @Valid @RequestBody UpdateAccountRequest request) {
    return accountService.update(userId, accountId, request);
  }
}
