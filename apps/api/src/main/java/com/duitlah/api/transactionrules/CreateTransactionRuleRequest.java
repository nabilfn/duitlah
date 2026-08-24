package com.duitlah.api.transactionrules;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.util.UUID;

public record CreateTransactionRuleRequest(
    @NotNull TransactionRuleMatchType matchType,
    @NotBlank @Size(max = 255) String matchValue,
    @NotNull UUID categoryId,
    Integer priority) {

  public int priorityOrDefault() {
    return priority == null ? 0 : priority;
  }
}
