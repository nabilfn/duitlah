package com.duitlah.api.groups;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface GroupExpenseRepository extends JpaRepository<GroupExpense, UUID> {

  List<GroupExpense> findByGroupIdOrderByOccurredOnDescCreatedAtDesc(UUID groupId);

  Optional<GroupExpense> findByIdAndGroupId(UUID id, UUID groupId);

  @Query(
      "SELECT COALESCE(SUM(e.amount), 0) FROM GroupExpense e WHERE e.groupId = :groupId AND e.paidByUserId = :userId")
  BigDecimal sumAmountByGroupIdAndPaidByUserId(
      @Param("groupId") UUID groupId, @Param("userId") UUID userId);

  @Query("SELECT COALESCE(SUM(e.amount), 0) FROM GroupExpense e WHERE e.groupId = :groupId")
  BigDecimal sumAmountByGroupId(@Param("groupId") UUID groupId);

  @Query(
      "SELECT e.category, COALESCE(SUM(e.amount), 0) FROM GroupExpense e "
          + "WHERE e.groupId = :groupId AND e.category IS NOT NULL GROUP BY e.category")
  List<Object[]> sumAmountGroupedByCategory(@Param("groupId") UUID groupId);

  @Query(
      "SELECT DISTINCT e.category FROM GroupExpense e WHERE e.groupId = :groupId "
          + "AND e.category IS NOT NULL AND e.occurredOn BETWEEN :from AND :to")
  List<GroupExpenseCategory> findDistinctCategoriesInRange(
      @Param("groupId") UUID groupId, @Param("from") LocalDate from, @Param("to") LocalDate to);
}
