package com.duitlah.api.bizbanking;

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

/**
 * Append-only. A manual entry (adjustment/transfer) leaves both linked_*_id columns null; a payment
 * recorded by {@code bizexpenses} or {@code sales} sets exactly one of them.
 */
@Entity
@Table(name = "business_account_entries")
@Getter
@Setter
@NoArgsConstructor
public class BusinessAccountEntry {

  @Id @GeneratedValue private UUID id;

  @Column(name = "business_account_id", nullable = false)
  private UUID businessAccountId;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private EntryDirection direction;

  @Column(nullable = false)
  private BigDecimal amount;

  @Column(name = "occurred_on", nullable = false)
  private LocalDate occurredOn;

  private String description;

  @Column(name = "linked_expense_payment_id")
  private UUID linkedExpensePaymentId;

  @Column(name = "linked_invoice_payment_id")
  private UUID linkedInvoicePaymentId;

  @Column(name = "transfer_group_id")
  private UUID transferGroupId;

  @Column(name = "created_at", nullable = false)
  private Instant createdAt;

  public BusinessAccountEntry(
      UUID businessAccountId,
      EntryDirection direction,
      BigDecimal amount,
      LocalDate occurredOn,
      String description) {
    this.businessAccountId = businessAccountId;
    this.direction = direction;
    this.amount = amount;
    this.occurredOn = occurredOn;
    this.description = description;
    this.createdAt = Instant.now();
  }

  public BigDecimal signedAmount() {
    return direction == EntryDirection.IN ? amount : amount.negate();
  }
}
