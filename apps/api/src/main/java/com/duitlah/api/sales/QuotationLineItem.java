package com.duitlah.api.sales;

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
@Table(name = "quotation_line_items")
@Getter
@Setter
@NoArgsConstructor
public class QuotationLineItem {

  @Id @GeneratedValue private UUID id;

  @Column(name = "quotation_id", nullable = false)
  private UUID quotationId;

  @Column(name = "product_id")
  private UUID productId;

  @Column(nullable = false)
  private String description;

  @Column(nullable = false)
  private BigDecimal quantity;

  @Column(name = "unit_price", nullable = false)
  private BigDecimal unitPrice;

  @Column(name = "line_total", nullable = false)
  private BigDecimal lineTotal;

  @Column(name = "sort_order", nullable = false)
  private int sortOrder;

  public QuotationLineItem(
      UUID quotationId,
      UUID productId,
      String description,
      BigDecimal quantity,
      BigDecimal unitPrice,
      int sortOrder) {
    this.quotationId = quotationId;
    this.productId = productId;
    this.description = description;
    this.quantity = quantity;
    this.unitPrice = unitPrice;
    this.lineTotal = quantity.multiply(unitPrice);
    this.sortOrder = sortOrder;
  }
}
