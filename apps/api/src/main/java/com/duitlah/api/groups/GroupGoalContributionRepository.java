package com.duitlah.api.groups;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface GroupGoalContributionRepository
    extends JpaRepository<GroupGoalContribution, UUID> {

  List<GroupGoalContribution> findByGroupGoalIdOrderByOccurredOnDescCreatedAtDesc(UUID groupGoalId);

  Optional<GroupGoalContribution> findByIdAndGroupGoalId(UUID id, UUID groupGoalId);

  @Query(
      "SELECT COALESCE(SUM(c.amount), 0) FROM GroupGoalContribution c WHERE c.groupGoalId = :groupGoalId")
  BigDecimal sumAmountByGroupGoalId(@Param("groupGoalId") UUID groupGoalId);

  @Query(
      "SELECT c.userId, COALESCE(SUM(c.amount), 0) FROM GroupGoalContribution c "
          + "WHERE c.groupGoalId = :groupGoalId GROUP BY c.userId")
  List<Object[]> sumAmountGroupedByUser(@Param("groupGoalId") UUID groupGoalId);
}
