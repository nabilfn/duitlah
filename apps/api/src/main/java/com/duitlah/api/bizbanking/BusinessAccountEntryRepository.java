package com.duitlah.api.bizbanking;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface BusinessAccountEntryRepository extends JpaRepository<BusinessAccountEntry, UUID> {

  List<BusinessAccountEntry> findByBusinessAccountIdOrderByOccurredOnDescCreatedAtDesc(
      UUID businessAccountId);

  @Query(
      """
            SELECT COALESCE(SUM(CASE WHEN e.direction = com.duitlah.api.bizbanking.EntryDirection.IN
                                      THEN e.amount ELSE -e.amount END), 0)
            FROM BusinessAccountEntry e WHERE e.businessAccountId = :businessAccountId
            """)
  BigDecimal sumSignedAmountByBusinessAccountId(@Param("businessAccountId") UUID businessAccountId);
}
