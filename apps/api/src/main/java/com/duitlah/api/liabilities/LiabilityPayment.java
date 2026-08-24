package com.duitlah.api.liabilities;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/** Append-only, same discipline as {@code goal_contributions}/{@code settlement_payments}. */
@Entity
@Table(name = "liability_payments")
@Getter
@Setter
@NoArgsConstructor
public class LiabilityPayment {

  @Id @GeneratedValue private UUID id;

  @Column(name = "liability_id", nullable = false)
  private UUID liabilityId;

  @Column(nullable = false)
  private BigDecimal amount;

  @Column(name = "principal_portion", nullable = false)
  private BigDecimal principalPortion;

  @Column(name = "interest_portion", nullable = false)
  private BigDecimal interestPortion;

  @Column(name = "paid_on", nullable = false)
  private LocalDate paidOn;

  @Column(name = "linked_transaction_id")
  private UUID linkedTransactionId;

  @Column(name = "created_at", nullable = false, updatable = false)
  private Instant createdAt;

  public LiabilityPayment(
      UUID liabilityId,
      BigDecimal amount,
      BigDecimal principalPortion,
      BigDecimal interestPortion,
      LocalDate paidOn,
      UUID linkedTransactionId) {
    this.liabilityId = liabilityId;
    this.amount = amount;
    this.principalPortion = principalPortion;
    this.interestPortion = interestPortion;
    this.paidOn = paidOn;
    this.linkedTransactionId = linkedTransactionId;
  }

  @jakarta.persistence.PrePersist
  void onCreate() {
    createdAt = Instant.now();
  }
}
