package com.duitlah.api.transactionrules;

import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.finance.CategoryService;
import com.duitlah.api.finance.CategoryType;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * CRUD for user-authored rules, plus the two methods that make this package the real implementation
 * behind "transaction rules" + "automatic categorization" + "statement-learning" (see
 * package-info): {@link #suggestCategory} (consulted by {@code autotrack.CategorySuggestionService}
 * ahead of its own last-merchant lookup) and {@link #learnFromConfirmation} (called by {@code
 * autotrack.TransactionCandidateService#confirm} every time a candidate is confirmed with a
 * category).
 */
@Service
public class TransactionRuleService {

  private final TransactionRuleRepository rules;
  private final CategoryService categoryService;

  public TransactionRuleService(TransactionRuleRepository rules, CategoryService categoryService) {
    this.rules = rules;
    this.categoryService = categoryService;
  }

  @Transactional
  public TransactionRuleResponse create(UUID userId, CreateTransactionRuleRequest request) {
    categoryService.requireUsable(userId, request.categoryId(), CategoryType.EXPENSE);
    TransactionRule rule =
        new TransactionRule(
            userId,
            request.matchType(),
            request.matchValue().trim(),
            request.categoryId(),
            request.priorityOrDefault(),
            false);
    rules.save(rule);
    return TransactionRuleResponse.from(rule);
  }

  public List<TransactionRuleResponse> list(UUID userId) {
    return rules.findByUserIdOrderByPriorityDescCreatedAtAsc(userId).stream()
        .map(TransactionRuleResponse::from)
        .toList();
  }

  @Transactional
  public TransactionRuleResponse update(
      UUID userId, UUID ruleId, UpdateTransactionRuleRequest request) {
    categoryService.requireUsable(userId, request.categoryId(), CategoryType.EXPENSE);
    TransactionRule rule = requireOwned(userId, ruleId);
    rule.setMatchType(request.matchType());
    rule.setMatchValue(request.matchValue().trim());
    rule.setCategoryId(request.categoryId());
    rule.setPriority(request.priority());
    rule.setActive(request.active());
    rules.save(rule);
    return TransactionRuleResponse.from(rule);
  }

  @Transactional
  public void delete(UUID userId, UUID ruleId) {
    rules.delete(requireOwned(userId, ruleId));
  }

  /**
   * Highest-priority active rule wins; an exact {@code MERCHANT_EQUALS} match beats a {@code
   * MERCHANT_CONTAINS} match at the same priority, since it's the more specific signal.
   */
  public Optional<UUID> suggestCategory(UUID userId, String merchant) {
    if (merchant == null || merchant.isBlank()) {
      return Optional.empty();
    }
    return rules.findByUserIdAndActiveTrueOrderByPriorityDesc(userId).stream()
        .filter(rule -> rule.matches(merchant))
        .min(
            Comparator.comparing(
                (TransactionRule rule) ->
                    rule.getMatchType() == TransactionRuleMatchType.MERCHANT_EQUALS ? 0 : 1))
        .map(TransactionRule::getCategoryId);
  }

  /**
   * Upserts a {@code MERCHANT_EQUALS} rule for this exact merchant string, keyed on {@code (userId,
   * matchValue)} — reinforcing an existing learned rule rather than accumulating duplicates every
   * time the user confirms another transaction at the same merchant. A user-authored rule for the
   * same merchant is left untouched (never silently overwritten by something the user didn't
   * create).
   */
  @Transactional
  public void learnFromConfirmation(UUID userId, String merchant, UUID categoryId) {
    if (merchant == null || merchant.isBlank() || categoryId == null) {
      return;
    }
    String trimmed = merchant.trim();
    Optional<TransactionRule> existing =
        rules.findByUserIdAndMatchTypeAndMatchValueIgnoreCaseAndLearnedTrue(
            userId, TransactionRuleMatchType.MERCHANT_EQUALS, trimmed);
    if (existing.isPresent()) {
      TransactionRule rule = existing.get();
      rule.setCategoryId(categoryId);
      rule.setActive(true);
      rules.save(rule);
      return;
    }
    rules.save(
        new TransactionRule(
            userId, TransactionRuleMatchType.MERCHANT_EQUALS, trimmed, categoryId, 0, true));
  }

  private TransactionRule requireOwned(UUID userId, UUID ruleId) {
    return rules
        .findByIdAndUserId(ruleId, userId)
        .orElseThrow(() -> new NotFoundException("TRANSACTION_RULE_NOT_FOUND", "Rule not found."));
  }
}
