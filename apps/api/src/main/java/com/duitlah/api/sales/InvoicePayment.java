package com.duitlah.api.sales;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
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

/** Append-only ledger of what's been received against an {@link Invoice}. */
@Entity
@Table(name = "invoice_payments")
@Getter
@Setter
@NoArgsConstructor
public class InvoicePayment {

  @Id @GeneratedValue private UUID id;

  @Column(name = "invoice_id", nullable = false)
  private UUID invoiceId;

  @Column(name = "business_account_id", nullable = false)
  private UUID businessAccountId;

  @Column(nullable = false)
  private BigDecimal amount;

  @Column(name = "paid_on", nullable = false)
  private LocalDate paidOn;

  private String notes;

  @Column(name = "created_at", nullable = false)
  private Instant createdAt;

  public InvoicePayment(
      UUID invoiceId, UUID businessAccountId, BigDecimal amount, LocalDate paidOn, String notes) {
    this.invoiceId = invoiceId;
    this.businessAccountId = businessAccountId;
    this.amount = amount;
    this.paidOn = paidOn;
    this.notes = notes;
    this.createdAt = Instant.now();
  }
}
