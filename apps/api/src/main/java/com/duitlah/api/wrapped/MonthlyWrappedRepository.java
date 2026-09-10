package com.duitlah.api.wrapped;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MonthlyWrappedRepository extends JpaRepository<MonthlyWrapped, UUID> {

  Optional<MonthlyWrapped> findByUserIdAndYearAndMonth(UUID userId, int year, int month);

  List<MonthlyWrapped> findByUserIdOrderByYearDescMonthDesc(UUID userId);

  boolean existsByUserIdAndYearAndMonth(UUID userId, int year, int month);
}
