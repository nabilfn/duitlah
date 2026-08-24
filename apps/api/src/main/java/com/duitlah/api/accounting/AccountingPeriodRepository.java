package com.duitlah.api.accounting;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface AccountingPeriodRepository extends JpaRepository<AccountingPeriod, UUID> {

  Optional<AccountingPeriod> findByIdAndSpaceId(UUID id, UUID spaceId);

  List<AccountingPeriod> findBySpaceIdOrderByPeriodStartDesc(UUID spaceId);

  @Query(
      """
            SELECT p FROM AccountingPeriod p
            WHERE p.spaceId = :spaceId AND p.periodStart <= :date AND p.periodEnd >= :date
            """)
  Optional<AccountingPeriod> findCoveringDate(
      @Param("spaceId") UUID spaceId, @Param("date") LocalDate date);

  @Query(
      """
            SELECT COUNT(p) > 0 FROM AccountingPeriod p
            WHERE p.spaceId = :spaceId AND p.periodStart <= :periodEnd AND p.periodEnd >= :periodStart
            """)
  boolean existsOverlapping(
      @Param("spaceId") UUID spaceId,
      @Param("periodStart") LocalDate periodStart,
      @Param("periodEnd") LocalDate periodEnd);
}
