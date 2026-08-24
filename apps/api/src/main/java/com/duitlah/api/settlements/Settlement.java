package com.duitlah.api.settlements;

import com.duitlah.api.common.jpa.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
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
 * A fixed, independent debt obligation between two real users — generated once (see {@link
 * DebtSimplifier}) and never recomputed afterward, the same "freeze it at the moment of truth"
 * philosophy as {@code bill_final_amounts}. {@code amount} never changes after creation; everything
 * about whether/how much has been paid lives in {@code settlement_payments} instead.
 */
@Entity
@Table(name = "settlements")
@Getter
@Setter
@NoArgsConstructor
public class Settlement extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "from_user_id", nullable = false)
  private UUID fromUserId;

  @Column(name = "to_user_id", nullable = false)
  private UUID toUserId;

  @Column(nullable = false)
  private BigDecimal amount;

  @Enumerated(EnumType.STRING)
  @Column(name = "source_type", nullable = false)
  private SourceType sourceType;

  @Column(name = "source_id", nullable = false)
  private UUID sourceId;

  @Column(name = "cancelled_at")
  private Instant cancelledAt;

  @Column(name = "disputed_at")
  private Instant disputedAt;

  public Settlement(
      UUID fromUserId, UUID toUserId, BigDecimal amount, SourceType sourceType, UUID sourceId) {
    this.fromUserId = fromUserId;
    this.toUserId = toUserId;
    this.amount = amount;
    this.sourceType = sourceType;
    this.sourceId = sourceId;
  }

  public boolean involves(UUID userId) {
    return fromUserId.equals(userId) || toUserId.equals(userId);
  }
}
