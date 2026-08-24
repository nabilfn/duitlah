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
import java.time.Instant;
import java.time.LocalDate;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "bills")
@Getter
@Setter
@NoArgsConstructor
public class Bill extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "owner_user_id", nullable = false)
  private UUID ownerUserId;

  @Column(name = "group_id")
  private UUID groupId;

  private String merchant;

  @Column(name = "receipt_date", nullable = false)
  private LocalDate receiptDate;

  @Column(nullable = false)
  private String currency;

  @Column(nullable = false)
  private BigDecimal tax;

  @Enumerated(EnumType.STRING)
  @Column(name = "tax_strategy", nullable = false)
  private AllocationStrategy taxStrategy;

  @Column(name = "service_charge", nullable = false)
  private BigDecimal serviceCharge;

  @Enumerated(EnumType.STRING)
  @Column(name = "service_strategy", nullable = false)
  private AllocationStrategy serviceStrategy;

  @Column(nullable = false)
  private BigDecimal discount;

  @Column(name = "discount_label")
  private String discountLabel;

  @Column(name = "declared_total")
  private BigDecimal declaredTotal;

  @Column private BigDecimal total;

  @Column(name = "rounding_adjustment")
  private BigDecimal roundingAdjustment;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private BillStatus status;

  @Column(name = "finalized_at")
  private Instant finalizedAt;

  @Column(name = "invite_token_hash")
  private String inviteTokenHash;

  public Bill(
      UUID ownerUserId, UUID groupId, String merchant, LocalDate receiptDate, String currency) {
    this.ownerUserId = ownerUserId;
    this.groupId = groupId;
    this.merchant = merchant;
    this.receiptDate = receiptDate;
    this.currency = currency;
    this.tax = BigDecimal.ZERO.setScale(2);
    this.taxStrategy = AllocationStrategy.PROPORTIONAL;
    this.serviceCharge = BigDecimal.ZERO.setScale(2);
    this.serviceStrategy = AllocationStrategy.PROPORTIONAL;
    this.discount = BigDecimal.ZERO.setScale(2);
    this.status = BillStatus.DRAFT;
  }

  public boolean isDraft() {
    return status == BillStatus.DRAFT;
  }
}
