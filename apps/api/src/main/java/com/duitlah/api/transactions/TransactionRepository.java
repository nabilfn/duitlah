package com.duitlah.api.transactions;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface TransactionRepository extends JpaRepository<Transaction, UUID> {

  Optional<Transaction> findByIdAndUserId(UUID id, UUID userId);

  List<Transaction> findByTransferGroupId(UUID transferGroupId);

  List<Transaction> findTop10ByUserIdOrderByOccurredOnDescCreatedAtDesc(UUID userId);

  /** Most recently used account — the simple heuristic behind AutoTrack's account suggestion. */
  Optional<Transaction> findFirstByUserIdOrderByOccurredOnDescCreatedAtDesc(UUID userId);

  /**
   * Most recent transaction at the same merchant with a category already set — the simple heuristic
   * behind AutoTrack's category suggestion (spec section 10: "detect merchant, suggest category").
   * Case-insensitive since OCR/statement-parsed merchant strings vary in casing from how the user
   * originally typed it.
   */
  Optional<Transaction>
      findFirstByUserIdAndMerchantIgnoreCaseAndCategoryIdIsNotNullOrderByOccurredOnDesc(
          UUID userId, String merchant);

  @Query(
      """
            SELECT t FROM Transaction t
            WHERE t.userId = :userId
              AND (:accountId IS NULL OR t.accountId = :accountId)
              AND (:type IS NULL OR t.type = :type)
              AND (:from IS NULL OR t.occurredOn >= :from)
              AND (:to IS NULL OR t.occurredOn <= :to)
            ORDER BY t.occurredOn DESC, t.createdAt DESC
            """)
  Page<Transaction> search(
      @Param("userId") UUID userId,
      @Param("accountId") UUID accountId,
      @Param("type") TransactionType type,
      @Param("from") LocalDate from,
      @Param("to") LocalDate to,
      Pageable pageable);

  @Query(
      """
            SELECT COALESCE(SUM(CASE WHEN t.direction = com.duitlah.api.transactions.TransactionDirection.IN
                                      THEN t.amount ELSE -t.amount END), 0)
            FROM Transaction t WHERE t.accountId = :accountId
            """)
  BigDecimal sumSignedAmountByAccountId(@Param("accountId") UUID accountId);

  /**
   * Same signed-sum formula as {@link #sumSignedAmountByAccountId}, but as of a specific past date
   * — used to compute a credit card's statement balance (the outstanding amount as of its last
   * statement cutoff), not just "right now".
   */
  @Query(
      """
            SELECT COALESCE(SUM(CASE WHEN t.direction = com.duitlah.api.transactions.TransactionDirection.IN
                                      THEN t.amount ELSE -t.amount END), 0)
            FROM Transaction t WHERE t.accountId = :accountId AND t.occurredOn <= :asOf
            """)
  BigDecimal sumSignedAmountByAccountIdAndOccurredOnLessThanEqual(
      @Param("accountId") UUID accountId, @Param("asOf") LocalDate asOf);

  @Query(
      """
            SELECT COALESCE(SUM(t.amount), 0) FROM Transaction t
            WHERE t.userId = :userId AND t.type = :type
              AND t.occurredOn >= :from AND t.occurredOn <= :to
            """)
  BigDecimal sumAmountByUserIdAndTypeAndOccurredOnBetween(
      @Param("userId") UUID userId,
      @Param("type") TransactionType type,
      @Param("from") LocalDate from,
      @Param("to") LocalDate to);

  /**
   * Same as above, scoped to a set of category ids — used for category budgets. A budget set on a
   * parent category (e.g. "Food") must roll up spending across its children, since transactions are
   * only ever tagged to a leaf category (Restaurants, Cafe, ...), never the parent itself — callers
   * resolve the id set (self, or self+children for a parent) via {@link
   * com.duitlah.api.finance.CategoryService} before calling this.
   */
  @Query(
      """
            SELECT COALESCE(SUM(t.amount), 0) FROM Transaction t
            WHERE t.userId = :userId AND t.type = :type
              AND t.categoryId IN :categoryIds
              AND t.occurredOn >= :from AND t.occurredOn <= :to
            """)
  BigDecimal sumAmountByUserIdAndTypeAndCategoryIdInAndOccurredOnBetween(
      @Param("userId") UUID userId,
      @Param("type") TransactionType type,
      @Param("categoryIds") List<UUID> categoryIds,
      @Param("from") LocalDate from,
      @Param("to") LocalDate to);

  /**
   * Same shape as {@link #sumAmountByUserIdAndTypeAndOccurredOnBetween}, but excluding rows created
   * by a recurring rule — used by cash-flow forecasting's "typical variable spending" average,
   * since a recurring transaction's future occurrences are already counted as "scheduled", not
   * "predicted" (see AnalyticsService#forecast); without this exclusion, rent would be averaged
   * into the variable-spending estimate *and* projected separately as scheduled, double-counting
   * it.
   */
  @Query(
      """
            SELECT COALESCE(SUM(t.amount), 0) FROM Transaction t
            WHERE t.userId = :userId AND t.type = :type AND t.recurringTransactionId IS NULL
              AND t.occurredOn >= :from AND t.occurredOn <= :to
            """)
  BigDecimal sumNonRecurringAmountByUserIdAndTypeAndOccurredOnBetween(
      @Param("userId") UUID userId,
      @Param("type") TransactionType type,
      @Param("from") LocalDate from,
      @Param("to") LocalDate to);

  /**
   * Total EXPENSE spend per merchant in a date range, highest first — each row is {@code [String
   * merchant, BigDecimal total, Long count]}. Returned as {@code Object[]} rather than a typed
   * projection so this query doesn't need a dedicated interface just for one analytics endpoint;
   * {@code AnalyticsService} maps it into {@code MerchantSpendingResponse}.
   */
  @Query(
      """
            SELECT t.merchant, SUM(t.amount), COUNT(t) FROM Transaction t
            WHERE t.userId = :userId AND t.type = com.duitlah.api.transactions.TransactionType.EXPENSE
              AND t.merchant IS NOT NULL
              AND t.occurredOn >= :from AND t.occurredOn <= :to
            GROUP BY t.merchant
            ORDER BY SUM(t.amount) DESC
            """)
  List<Object[]> sumExpenseAmountGroupedByMerchant(
      @Param("userId") UUID userId, @Param("from") LocalDate from, @Param("to") LocalDate to);

  /** Real transactions (not projected occurrences) in a date range, for the calendar view. */
  List<Transaction> findByUserIdAndOccurredOnBetween(UUID userId, LocalDate from, LocalDate to);
}
