package com.duitlah.api.settlements;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Append-only: never edited or deleted after creation — a correction is a new, note-explained
 * entry, not a rewrite of what was recorded.
 */
@Entity
@Table(name = "settlement_payments")
@Getter
@Setter
@NoArgsConstructor
public class SettlementPayment {

  @Id @GeneratedValue private UUID id;

  @Column(name = "settlement_id", nullable = false)
  private UUID settlementId;

  @Column(nullable = false)
  private BigDecimal amount;

  @Column(name = "recorded_by_user_id", nullable = false)
  private UUID recordedByUserId;

  private String note;

  @Column(name = "paid_at", nullable = false)
  private Instant paidAt;

  @Column(name = "created_at", nullable = false)
  private Instant createdAt;

  public SettlementPayment(
      UUID settlementId, BigDecimal amount, UUID recordedByUserId, String note) {
    this.settlementId = settlementId;
    this.amount = amount;
    this.recordedByUserId = recordedByUserId;
    this.note = note;
    this.paidAt = Instant.now();
    this.createdAt = Instant.now();
  }
}
