package com.duitlah.api.transactionrules;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TransactionRuleRepository extends JpaRepository<TransactionRule, UUID> {

  List<TransactionRule> findByUserIdOrderByPriorityDescCreatedAtAsc(UUID userId);

  List<TransactionRule> findByUserIdAndActiveTrueOrderByPriorityDesc(UUID userId);

  Optional<TransactionRule> findByIdAndUserId(UUID id, UUID userId);

  Optional<TransactionRule> findByUserIdAndMatchTypeAndMatchValueIgnoreCaseAndLearnedTrue(
      UUID userId, TransactionRuleMatchType matchType, String matchValue);
}
