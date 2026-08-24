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
@Table(name = "invoices")
@Getter
@Setter
@NoArgsConstructor
public class Invoice extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "space_id", nullable = false)
  private UUID spaceId;

  @Column(name = "customer_id", nullable = false)
  private UUID customerId;

  @Column(name = "invoice_number", nullable = false)
  private String invoiceNumber;

  @Column(name = "issue_date", nullable = false)
  private LocalDate issueDate;

  @Column(name = "due_date", nullable = false)
  private LocalDate dueDate;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private InvoiceStatus status;

  @Column(name = "tax_percent", nullable = false)
  private BigDecimal taxPercent;

  @Column(nullable = false)
  private BigDecimal subtotal;

  @Column(name = "tax_amount", nullable = false)
  private BigDecimal taxAmount;

  @Column(nullable = false)
  private BigDecimal total;

  @Column(name = "converted_from_quotation_id")
  private UUID convertedFromQuotationId;

  @Column(name = "source_recurring_invoice_id")
  private UUID sourceRecurringInvoiceId;

  private String notes;

  public Invoice(
      UUID spaceId,
      UUID customerId,
      String invoiceNumber,
      LocalDate issueDate,
      LocalDate dueDate,
      BigDecimal taxPercent) {
    this.spaceId = spaceId;
    this.customerId = customerId;
    this.invoiceNumber = invoiceNumber;
    this.issueDate = issueDate;
    this.dueDate = dueDate;
    this.status = InvoiceStatus.DRAFT;
    this.taxPercent = taxPercent;
    this.subtotal = BigDecimal.ZERO;
    this.taxAmount = BigDecimal.ZERO;
    this.total = BigDecimal.ZERO;
  }
}
