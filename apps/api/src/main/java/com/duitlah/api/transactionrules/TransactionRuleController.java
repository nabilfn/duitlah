package com.duitlah.api.transactionrules;

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
public class TransactionRuleController {

  private final TransactionRuleService rules;

  public TransactionRuleController(TransactionRuleService rules) {
    this.rules = rules;
  }

  @PostMapping("/api/v1/transaction-rules")
  @ResponseStatus(HttpStatus.CREATED)
  public TransactionRuleResponse create(
      @AuthenticationPrincipal UUID userId,
      @Valid @RequestBody CreateTransactionRuleRequest request) {
    return rules.create(userId, request);
  }

  @GetMapping("/api/v1/transaction-rules")
  public List<TransactionRuleResponse> list(@AuthenticationPrincipal UUID userId) {
    return rules.list(userId);
  }

  @PutMapping("/api/v1/transaction-rules/{ruleId}")
  public TransactionRuleResponse update(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID ruleId,
      @Valid @RequestBody UpdateTransactionRuleRequest request) {
    return rules.update(userId, ruleId, request);
  }

  @DeleteMapping("/api/v1/transaction-rules/{ruleId}")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  public void delete(@AuthenticationPrincipal UUID userId, @PathVariable UUID ruleId) {
    rules.delete(userId, ruleId);
  }
}
