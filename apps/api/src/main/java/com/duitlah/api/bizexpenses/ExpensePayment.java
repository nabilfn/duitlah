package com.duitlah.api.bizexpenses;

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

/** Append-only ledger of what's been paid against a {@link BusinessExpense}. */
@Entity
@Table(name = "expense_payments")
@Getter
@Setter
@NoArgsConstructor
public class ExpensePayment {

  @Id @GeneratedValue private UUID id;

  @Column(name = "business_expense_id", nullable = false)
  private UUID businessExpenseId;

  @Column(name = "business_account_id", nullable = false)
  private UUID businessAccountId;

  @Column(nullable = false)
  private BigDecimal amount;

  @Column(name = "paid_on", nullable = false)
  private LocalDate paidOn;

  private String notes;

  @Column(name = "created_at", nullable = false)
  private Instant createdAt;

  public ExpensePayment(
      UUID businessExpenseId,
      UUID businessAccountId,
      BigDecimal amount,
      LocalDate paidOn,
      String notes) {
    this.businessExpenseId = businessExpenseId;
    this.businessAccountId = businessAccountId;
    this.amount = amount;
    this.paidOn = paidOn;
    this.notes = notes;
    this.createdAt = Instant.now();
  }
}
