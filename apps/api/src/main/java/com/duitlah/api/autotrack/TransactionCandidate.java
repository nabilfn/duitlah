package com.duitlah.api.autotrack;

import com.duitlah.api.common.jpa.AuditableEntity;
import com.duitlah.api.transactions.TransactionDirection;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * A suggested, not-yet-real transaction awaiting a human decision. Nothing in this entity ever
 * writes to {@code transactions} on its own — {@link TransactionCandidateService#confirm} is the
 * only path from here into the real ledger, and it always requires an explicit request, never an
 * automatic promotion no matter how high {@code confidence} is.
 */
@Entity
@Table(name = "transaction_candidates")
@Getter
@Setter
@NoArgsConstructor
public class TransactionCandidate extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "user_id", nullable = false)
  private UUID userId;

  @Column(name = "space_id", nullable = false)
  private UUID spaceId;

  @Enumerated(EnumType.STRING)
  @Column(name = "source_type", nullable = false)
  private CandidateSourceType sourceType;

  @Column(name = "receipt_id")
  private UUID receiptId;

  @Column(name = "statement_import_id")
  private UUID statementImportId;

  @Column(name = "detected_amount", nullable = false)
  private BigDecimal detectedAmount;

  @Column(name = "detected_currency", nullable = false)
  private String detectedCurrency;

  @Column(name = "detected_merchant")
  private String detectedMerchant;

  @Column(name = "detected_date", nullable = false)
  private LocalDate detectedDate;

  @Enumerated(EnumType.STRING)
  @Column(name = "detected_direction", nullable = false)
  private TransactionDirection detectedDirection;

  @Column(name = "suggested_account_id")
  private UUID suggestedAccountId;

  @Column(name = "suggested_category_id")
  private UUID suggestedCategoryId;

  @Column(nullable = false)
  private BigDecimal confidence;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private CandidateStatus status;

  @Column(name = "duplicate_of_transaction_id")
  private UUID duplicateOfTransactionId;

  @Column(name = "duplicate_confidence")
  private BigDecimal duplicateConfidence;

  @Column(name = "resulting_transaction_id")
  private UUID resultingTransactionId;

  public TransactionCandidate(
      UUID userId,
      UUID spaceId,
      CandidateSourceType sourceType,
      UUID receiptId,
      UUID statementImportId,
      BigDecimal detectedAmount,
      String detectedCurrency,
      String detectedMerchant,
      LocalDate detectedDate,
      TransactionDirection detectedDirection,
      UUID suggestedAccountId,
      UUID suggestedCategoryId,
      BigDecimal confidence) {
    this.userId = userId;
    this.spaceId = spaceId;
    this.sourceType = sourceType;
    this.receiptId = receiptId;
    this.statementImportId = statementImportId;
    this.detectedAmount = detectedAmount;
    this.detectedCurrency = detectedCurrency;
    this.detectedMerchant = detectedMerchant;
    this.detectedDate = detectedDate;
    this.detectedDirection = detectedDirection;
    this.suggestedAccountId = suggestedAccountId;
    this.suggestedCategoryId = suggestedCategoryId;
    this.confidence = confidence;
    this.status = CandidateStatus.PENDING;
  }

  public boolean isPending() {
    return status == CandidateStatus.PENDING;
  }
}
