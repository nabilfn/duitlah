package com.duitlah.api.receipts;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface ReceiptRepository extends JpaRepository<Receipt, UUID> {

  Optional<Receipt> findByIdAndUserId(UUID id, UUID userId);

  /**
   * {@code merchantPattern} is a pre-wildcarded, already-lowercased {@code %term%} string (see
   * {@link ReceiptVaultService#search}) rather than a raw term concatenated here — binding a {@code
   * null} parameter into a JPQL {@code CONCAT}/{@code LIKE} expression makes Postgres's JDBC driver
   * unable to infer the parameter's type when that branch of the {@code OR} is never evaluated,
   * which surfaces as a real {@code function lower(bytea) does not exist} error, not a
   * silently-skipped filter.
   */
  @Query(
      """
            SELECT r FROM Receipt r
            WHERE r.userId = :userId
              AND (:folder IS NULL OR r.folder = :folder)
              AND (:merchantPattern IS NULL OR LOWER(r.merchant) LIKE :merchantPattern)
            ORDER BY r.createdAt DESC
            """)
  List<Receipt> search(
      @Param("userId") UUID userId,
      @Param("folder") String folder,
      @Param("merchantPattern") String merchantPattern);
}
