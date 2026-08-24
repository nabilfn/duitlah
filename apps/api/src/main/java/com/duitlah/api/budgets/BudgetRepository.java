package com.duitlah.api.budgets;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BudgetRepository extends JpaRepository<Budget, UUID> {

  List<Budget> findByUserIdAndPeriodYearAndPeriodMonth(
      UUID userId, short periodYear, short periodMonth);

  Optional<Budget> findByIdAndUserId(UUID id, UUID userId);

  boolean existsByUserIdAndCategoryIdIsNullAndPeriodYearAndPeriodMonth(
      UUID userId, short periodYear, short periodMonth);

  boolean existsByUserIdAndCategoryIdAndPeriodYearAndPeriodMonth(
      UUID userId, UUID categoryId, short periodYear, short periodMonth);
}
