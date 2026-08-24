package com.duitlah.api.sales;

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

@Entity
@Table(name = "quotations")
@Getter
@Setter
@NoArgsConstructor
public class Quotation extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "space_id", nullable = false)
  private UUID spaceId;

  @Column(name = "customer_id", nullable = false)
  private UUID customerId;

  @Column(name = "quote_number", nullable = false)
  private String quoteNumber;

  @Column(name = "issue_date", nullable = false)
  private LocalDate issueDate;

  @Column(name = "expiry_date")
  private LocalDate expiryDate;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private QuotationStatus status;

  @Column(name = "tax_percent", nullable = false)
  private BigDecimal taxPercent;

  @Column(nullable = false)
  private BigDecimal subtotal;

  @Column(name = "tax_amount", nullable = false)
  private BigDecimal taxAmount;

  @Column(nullable = false)
  private BigDecimal total;

  private String notes;

  public Quotation(
      UUID spaceId,
      UUID customerId,
      String quoteNumber,
      LocalDate issueDate,
      LocalDate expiryDate,
      BigDecimal taxPercent) {
    this.spaceId = spaceId;
    this.customerId = customerId;
    this.quoteNumber = quoteNumber;
    this.issueDate = issueDate;
    this.expiryDate = expiryDate;
    this.status = QuotationStatus.DRAFT;
    this.taxPercent = taxPercent;
    this.subtotal = BigDecimal.ZERO;
    this.taxAmount = BigDecimal.ZERO;
    this.total = BigDecimal.ZERO;
  }
}
