package com.duitlah.api.bagilah;

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

@Entity
@Table(name = "item_claims")
@Getter
@Setter
@NoArgsConstructor
public class ItemClaim extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "receipt_item_id", nullable = false)
  private UUID receiptItemId;

  @Column(name = "participant_id", nullable = false)
  private UUID participantId;

  @Enumerated(EnumType.STRING)
  @Column(name = "claim_type", nullable = false)
  private ClaimType claimType;

  private BigDecimal quantity;
  private BigDecimal percentage;
  private BigDecimal amount;

  public ItemClaim(UUID receiptItemId, UUID participantId, ClaimType claimType, BigDecimal value) {
    this.receiptItemId = receiptItemId;
    this.participantId = participantId;
    this.claimType = claimType;
    switch (claimType) {
      case QUANTITY -> this.quantity = value;
      case PERCENTAGE -> this.percentage = value;
      case AMOUNT -> this.amount = value;
    }
  }

  public BigDecimal getValue() {
    return switch (claimType) {
      case QUANTITY -> quantity;
      case PERCENTAGE -> percentage;
      case AMOUNT -> amount;
    };
  }
}
