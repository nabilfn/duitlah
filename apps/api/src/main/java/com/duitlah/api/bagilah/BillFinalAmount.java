package com.duitlah.api.bagilah;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Written once at {@code Bill.finalize()} time and never updated afterward -- see {@code
 * V6__bagilah.sql} for why this is a deliberate exception to the "computed, never stored" rule that
 * governs every other balance in this schema.
 */
@Entity
@Table(name = "bill_final_amounts")
@Getter
@Setter
@NoArgsConstructor
public class BillFinalAmount {

  @Id @GeneratedValue private UUID id;

  @Column(name = "bill_id", nullable = false)
  private UUID billId;

  @Column(name = "participant_id", nullable = false)
  private UUID participantId;

  @Column(nullable = false)
  private BigDecimal subtotal;

  @Column(name = "tax_share", nullable = false)
  private BigDecimal taxShare;

  @Column(name = "service_share", nullable = false)
  private BigDecimal serviceShare;

  @Column(name = "discount_share", nullable = false)
  private BigDecimal discountShare;

  @Column(name = "rounding_share", nullable = false)
  private BigDecimal roundingShare;

  @Column(name = "final_amount", nullable = false)
  private BigDecimal finalAmount;

  public BillFinalAmount(
      UUID billId,
      UUID participantId,
      BigDecimal subtotal,
      BigDecimal taxShare,
      BigDecimal serviceShare,
      BigDecimal discountShare,
      BigDecimal roundingShare,
      BigDecimal finalAmount) {
    this.billId = billId;
    this.participantId = participantId;
    this.subtotal = subtotal;
    this.taxShare = taxShare;
    this.serviceShare = serviceShare;
    this.discountShare = discountShare;
    this.roundingShare = roundingShare;
    this.finalAmount = finalAmount;
  }
}
