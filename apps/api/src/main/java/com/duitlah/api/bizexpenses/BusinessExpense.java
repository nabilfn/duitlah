package com.duitlah.api.bizexpenses;

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
@Table(name = "business_expenses")
@Getter
@Setter
@NoArgsConstructor
public class BusinessExpense extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "space_id", nullable = false)
  private UUID spaceId;

  @Column(name = "supplier_id")
  private UUID supplierId;

  private String category;

  @Column(nullable = false)
  private BigDecimal amount;

  @Column(name = "occurred_on", nullable = false)
  private LocalDate occurredOn;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private ExpenseStatus status;

  @Column(name = "receipt_id")
  private UUID receiptId;

  /**
   * Optional link into the space's Chart of Accounts (V2 Phase 6) — which expense ledger account
   * this bill posts to when paid. Null until mapped; {@code AutomaticPostingService} falls back to
   * the default "Other Operating Expenses" system account when absent.
   */
  @Column(name = "chart_of_accounts_id")
  private UUID chartOfAccountsId;

  private String notes;

  public BusinessExpense(
      UUID spaceId, UUID supplierId, String category, BigDecimal amount, LocalDate occurredOn) {
    this.spaceId = spaceId;
    this.supplierId = supplierId;
    this.category = category;
    this.amount = amount;
    this.occurredOn = occurredOn;
    this.status = ExpenseStatus.UNPAID;
  }
}
