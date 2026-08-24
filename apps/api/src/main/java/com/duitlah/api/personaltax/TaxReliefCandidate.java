package com.duitlah.api.personaltax;

import com.duitlah.api.common.jpa.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * The pipeline's own suggestion step (spec section 27) — never becomes a real relief on its own.
 */
@Entity
@Table(name = "tax_relief_candidates")
@Getter
@Setter
@NoArgsConstructor
public class TaxReliefCandidate extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "user_id", nullable = false)
  private UUID userId;

  @Column(name = "year_of_assessment", nullable = false)
  private int yearOfAssessment;

  @Enumerated(EnumType.STRING)
  private PersonalTaxReliefCategory category;

  @Column(name = "source_receipt_id")
  private UUID sourceReceiptId;

  @Column(name = "suggested_amount", nullable = false)
  private BigDecimal suggestedAmount;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private TaxReliefCandidateStatus status;

  private String notes;

  public TaxReliefCandidate(
      UUID userId,
      int yearOfAssessment,
      PersonalTaxReliefCategory category,
      UUID sourceReceiptId,
      BigDecimal suggestedAmount,
      TaxReliefCandidateStatus status) {
    this.userId = userId;
    this.yearOfAssessment = yearOfAssessment;
    this.category = category;
    this.sourceReceiptId = sourceReceiptId;
    this.suggestedAmount = suggestedAmount;
    this.status = status;
  }

  public boolean isResolved() {
    return status == TaxReliefCandidateStatus.CONFIRMED
        || status == TaxReliefCandidateStatus.REJECTED;
  }
}
