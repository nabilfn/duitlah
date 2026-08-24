package com.duitlah.api.recurring;

import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class RecurringTransactionController {

  private final RecurringTransactionService recurringTransactionService;

  public RecurringTransactionController(RecurringTransactionService recurringTransactionService) {
    this.recurringTransactionService = recurringTransactionService;
  }

  @PostMapping("/api/v1/recurring-transactions")
  @ResponseStatus(HttpStatus.CREATED)
  public RecurringTransactionResponse create(
      @AuthenticationPrincipal UUID userId,
      @Valid @RequestBody CreateRecurringTransactionRequest request) {
    return recurringTransactionService.create(userId, request);
  }

  @GetMapping("/api/v1/recurring-transactions")
  public List<RecurringTransactionResponse> list(@AuthenticationPrincipal UUID userId) {
    return recurringTransactionService.list(userId);
  }

  @GetMapping("/api/v1/recurring-transactions/subscriptions/summary")
  public SubscriptionsSummaryResponse subscriptionsSummary(@AuthenticationPrincipal UUID userId) {
    return recurringTransactionService.subscriptionsSummary(userId);
  }

  @GetMapping("/api/v1/recurring-transactions/{id}")
  public RecurringTransactionResponse get(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID id) {
    return recurringTransactionService.get(userId, id);
  }

  @PatchMapping("/api/v1/recurring-transactions/{id}")
  public RecurringTransactionResponse update(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID id,
      @Valid @RequestBody UpdateRecurringTransactionRequest request) {
    return recurringTransactionService.update(userId, id, request);
  }

  @DeleteMapping("/api/v1/recurring-transactions/{id}")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  public void delete(@AuthenticationPrincipal UUID userId, @PathVariable UUID id) {
    recurringTransactionService.delete(userId, id);
  }
}
