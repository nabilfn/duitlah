package com.duitlah.api.transactionrules;

import java.util.UUID;

public record TransactionRuleResponse(
    UUID id,
    TransactionRuleMatchType matchType,
    String matchValue,
    UUID categoryId,
    int priority,
    boolean active,
    boolean learned) {

  public static TransactionRuleResponse from(TransactionRule rule) {
    return new TransactionRuleResponse(
        rule.getId(),
        rule.getMatchType(),
        rule.getMatchValue(),
        rule.getCategoryId(),
        rule.getPriority(),
        rule.isActive(),
        rule.isLearned());
  }
}
