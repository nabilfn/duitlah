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

/** The ledger of truth {@link PersonalTaxCalculationService} reads from. */
@Entity
@Table(name = "confirmed_tax_reliefs")
@Getter
@Setter
@NoArgsConstructor
public class ConfirmedTaxRelief extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "user_id", nullable = false)
  private UUID userId;

  @Column(name = "year_of_assessment", nullable = false)
  private int yearOfAssessment;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private PersonalTaxReliefCategory category;

  @Column(name = "confirmed_amount", nullable = false)
  private BigDecimal confirmedAmount;

  @Column(name = "source_candidate_id")
  private UUID sourceCandidateId;

  public ConfirmedTaxRelief(
      UUID userId,
      int yearOfAssessment,
      PersonalTaxReliefCategory category,
      BigDecimal confirmedAmount) {
    this.userId = userId;
    this.yearOfAssessment = yearOfAssessment;
    this.category = category;
    this.confirmedAmount = confirmedAmount;
  }
}
