package com.duitlah.api.settlements;

import jakarta.persistence.LockModeType;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface SettlementRepository extends JpaRepository<Settlement, UUID> {

  @Query(
      "SELECT s FROM Settlement s WHERE s.fromUserId = :userId OR s.toUserId = :userId ORDER BY s.createdAt DESC")
  List<Settlement> findAllInvolvingUser(@Param("userId") UUID userId);

  @Query(
      "SELECT s FROM Settlement s WHERE s.id = :id AND (s.fromUserId = :userId OR s.toUserId = :userId)")
  Optional<Settlement> findByIdInvolvingUser(@Param("id") UUID id, @Param("userId") UUID userId);

  @Lock(LockModeType.PESSIMISTIC_WRITE)
  @Query(
      "SELECT s FROM Settlement s WHERE s.id = :id AND (s.fromUserId = :userId OR s.toUserId = :userId)")
  Optional<Settlement> findByIdInvolvingUserForUpdate(
      @Param("id") UUID id, @Param("userId") UUID userId);

  List<Settlement> findBySourceTypeAndSourceId(SourceType sourceType, UUID sourceId);

  /**
   * Net amount already carved out of this source's ongoing balance for {@code userId} by previously
   * generated (non-cancelled) settlements — positive means already-recorded-as-owed-to them,
   * negative means already-recorded-as-owed-by-them. Used so re-settling a group never
   * double-counts a net position that was already turned into a fixed Settlement.
   */
  @Query(
      """
      SELECT COALESCE(SUM(CASE WHEN s.toUserId = :userId THEN s.amount ELSE -s.amount END), 0)
      FROM Settlement s
      WHERE s.sourceType = :sourceType AND s.sourceId = :sourceId
        AND (s.fromUserId = :userId OR s.toUserId = :userId)
        AND s.cancelledAt IS NULL
      """)
  BigDecimal netAlreadyGeneratedForUser(
      @Param("sourceType") SourceType sourceType,
      @Param("sourceId") UUID sourceId,
      @Param("userId") UUID userId);
}
