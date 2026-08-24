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

/** A line-item template — copied into a real {@link InvoiceLineItem} on each materialization. */
@Entity
@Table(name = "recurring_invoice_line_items")
@Getter
@Setter
@NoArgsConstructor
public class RecurringInvoiceLineItem {

  @Id @GeneratedValue private UUID id;

  @Column(name = "recurring_invoice_id", nullable = false)
  private UUID recurringInvoiceId;

  @Column(name = "product_id")
  private UUID productId;

  @Column(nullable = false)
  private String description;

  @Column(nullable = false)
  private BigDecimal quantity;

  @Column(name = "unit_price", nullable = false)
  private BigDecimal unitPrice;

  @Column(name = "sort_order", nullable = false)
  private int sortOrder;

  public RecurringInvoiceLineItem(
      UUID recurringInvoiceId,
      UUID productId,
      String description,
      BigDecimal quantity,
      BigDecimal unitPrice,
      int sortOrder) {
    this.recurringInvoiceId = recurringInvoiceId;
    this.productId = productId;
    this.description = description;
    this.quantity = quantity;
    this.unitPrice = unitPrice;
    this.sortOrder = sortOrder;
  }
}
