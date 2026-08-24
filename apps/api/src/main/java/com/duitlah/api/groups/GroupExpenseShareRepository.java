package com.duitlah.api.groups;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface GroupExpenseShareRepository extends JpaRepository<GroupExpenseShare, UUID> {

  List<GroupExpenseShare> findByGroupExpenseId(UUID groupExpenseId);

  @Query(
      """
            SELECT COALESCE(SUM(s.amount), 0) FROM GroupExpenseShare s
            WHERE s.userId = :userId AND s.groupExpenseId IN
              (SELECT e.id FROM GroupExpense e WHERE e.groupId = :groupId)
            """)
  BigDecimal sumAmountByUserIdAndGroupId(
      @Param("userId") UUID userId, @Param("groupId") UUID groupId);
}
