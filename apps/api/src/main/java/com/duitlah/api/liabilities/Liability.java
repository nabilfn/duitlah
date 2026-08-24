package com.duitlah.api.liabilities;

import com.duitlah.api.common.jpa.AuditableEntity;
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
 * {@code originalAmount} never changes after creation; outstanding principal is always {@code
 * originalAmount - SUM(LiabilityPayment.principalPortion)}, computed fresh (see {@link
 * LiabilityService#outstandingPrincipal}) — the same "computed, never stored" discipline as account
 * balance and goal progress elsewhere in this schema.
 */
@Entity
@Table(name = "liabilities")
@Getter
@Setter
@NoArgsConstructor
public class Liability extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "user_id", nullable = false)
  private UUID userId;

  @Column(name = "space_id", nullable = false)
  private UUID spaceId;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private LiabilityType type;

  @Column(nullable = false)
  private String name;

  private String lender;

  @Column(name = "original_amount", nullable = false)
  private BigDecimal originalAmount;

  @Column(name = "interest_rate_percent")
  private BigDecimal interestRatePercent;

  @Column(name = "instalment_amount")
  private BigDecimal instalmentAmount;

  @Column(name = "next_due_date")
  private LocalDate nextDueDate;

  @Column(name = "maturity_date")
  private LocalDate maturityDate;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private LiabilityStatus status;

  public Liability(
      UUID userId,
      UUID spaceId,
      LiabilityType type,
      String name,
      String lender,
      BigDecimal originalAmount,
      BigDecimal interestRatePercent,
      BigDecimal instalmentAmount,
      LocalDate nextDueDate,
      LocalDate maturityDate) {
    this.userId = userId;
    this.spaceId = spaceId;
    this.type = type;
    this.name = name;
    this.lender = lender;
    this.originalAmount = originalAmount;
    this.interestRatePercent = interestRatePercent;
    this.instalmentAmount = instalmentAmount;
    this.nextDueDate = nextDueDate;
    this.maturityDate = maturityDate;
    this.status = LiabilityStatus.ACTIVE;
  }
}
