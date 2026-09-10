package com.duitlah.api.goals;

import java.math.BigDecimal;
import java.time.LocalDate;
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

  /**
   * Total saved across every one of a user's goals within a date range — Monthly Wrapped's "savings
   * contribution" figure (spec section 8), reusing the denormalized {@code userId} on each
   * contribution row rather than joining back to {@code goals}.
   */
  @Query(
      "SELECT COALESCE(SUM(c.amount), 0) FROM GoalContribution c "
          + "WHERE c.userId = :userId AND c.occurredOn BETWEEN :from AND :to")
  BigDecimal sumAmountByUserIdAndOccurredOnBetween(
      @Param("userId") UUID userId, @Param("from") LocalDate from, @Param("to") LocalDate to);
}
