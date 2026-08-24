package com.duitlah.api.accounting;

import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class AccountingPeriodController {

  private final AccountingPeriodService periods;

  public AccountingPeriodController(AccountingPeriodService periods) {
    this.periods = periods;
  }

  @PostMapping("/api/v1/spaces/{spaceId}/accounting/periods")
  @ResponseStatus(HttpStatus.CREATED)
  public AccountingPeriodResponse create(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @Valid @RequestBody CreateAccountingPeriodRequest request) {
    return periods.create(userId, spaceId, request);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/accounting/periods")
  public List<AccountingPeriodResponse> list(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID spaceId) {
    return periods.list(userId, spaceId);
  }

  @PostMapping("/api/v1/spaces/{spaceId}/accounting/periods/{periodId}/close")
  public AccountingPeriodResponse close(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID periodId) {
    return periods.close(userId, spaceId, periodId);
  }
}
