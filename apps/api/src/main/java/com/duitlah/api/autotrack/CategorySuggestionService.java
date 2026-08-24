package com.duitlah.api.autotrack;

import com.duitlah.api.transactionrules.TransactionRuleService;
import com.duitlah.api.transactions.Transaction;
import com.duitlah.api.transactions.TransactionRepository;
import java.util.Optional;
import java.util.UUID;
import org.springframework.stereotype.Service;

/**
 * "Detect merchant, suggest category" (spec section 10). V2 Phase 13 layered a first-line source on
 * top of the original heuristic: {@link TransactionRuleService#suggestCategory} (the user's own
 * explicit or auto-learned merchant rules) is consulted first; only when no rule matches does this
 * fall back to the original, simplest-possible heuristic — whatever category this user chose last
 * time they logged a transaction at the same merchant. No machine learning, no cross-user data — a
 * suggestion that's wrong is just a pre-filled dropdown the user changes, not a claim of
 * intelligence this codebase can't back up.
 */
@Service
public class CategorySuggestionService {

  private final TransactionRepository transactions;
  private final TransactionRuleService transactionRuleService;

  public CategorySuggestionService(
      TransactionRepository transactions, TransactionRuleService transactionRuleService) {
    this.transactions = transactions;
    this.transactionRuleService = transactionRuleService;
  }

  public Optional<UUID> suggest(UUID userId, String merchant) {
    if (merchant == null || merchant.isBlank()) {
      return Optional.empty();
    }
    Optional<UUID> fromRule = transactionRuleService.suggestCategory(userId, merchant);
    if (fromRule.isPresent()) {
      return fromRule;
    }
    return transactions
        .findFirstByUserIdAndMerchantIgnoreCaseAndCategoryIdIsNotNullOrderByOccurredOnDesc(
            userId, merchant.trim())
        .map(Transaction::getCategoryId);
  }
}
