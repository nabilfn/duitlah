package com.duitlah.api.bagilah;

import com.duitlah.api.common.jpa.AuditableEntity;
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

@Entity
@Table(name = "receipt_items")
@Getter
@Setter
@NoArgsConstructor
public class ReceiptItem extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "bill_id", nullable = false)
  private UUID billId;

  @Column(nullable = false)
  private String name;

  @Column(nullable = false)
  private BigDecimal quantity;

  @Column(name = "unit_price", nullable = false)
  private BigDecimal unitPrice;

  @Column(name = "item_discount", nullable = false)
  private BigDecimal itemDiscount;

  @Column(name = "total_price", nullable = false)
  private BigDecimal totalPrice;

  public ReceiptItem(
      UUID billId,
      String name,
      BigDecimal quantity,
      BigDecimal unitPrice,
      BigDecimal itemDiscount,
      BigDecimal totalPrice) {
    this.billId = billId;
    this.name = name;
    this.quantity = quantity;
    this.unitPrice = unitPrice;
    this.itemDiscount = itemDiscount;
    this.totalPrice = totalPrice;
  }
}
