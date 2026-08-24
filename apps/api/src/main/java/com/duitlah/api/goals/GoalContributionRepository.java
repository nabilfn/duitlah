package com.duitlah.api.goals;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface GoalContributionRepository extends JpaRepository<GoalContribution, UUID> {

  List<GoalContribution> findByGoalIdOrderByOccurredOnDescCreatedAtDesc(UUID goalId);

  Optional<GoalContribution> findByIdAndGoalId(UUID id, UUID goalId);

  @Query("SELECT COALESCE(SUM(c.amount), 0) FROM GoalContribution c WHERE c.goalId = :goalId")
  BigDecimal sumAmountByGoalId(@Param("goalId") UUID goalId);
}
