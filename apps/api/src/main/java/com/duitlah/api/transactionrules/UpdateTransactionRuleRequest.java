package com.duitlah.api.transactionrules;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.util.UUID;

public record UpdateTransactionRuleRequest(
    @NotNull TransactionRuleMatchType matchType,
    @NotBlank @Size(max = 255) String matchValue,
    @NotNull UUID categoryId,
    int priority,
    boolean active) {}
