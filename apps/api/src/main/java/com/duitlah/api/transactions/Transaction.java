package com.duitlah.api.transactions;

import com.duitlah.api.common.jpa.AuditableEntity;
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
 * One row always affects exactly one account. {@code amount} is always a positive magnitude —
 * direction (in/out) carries the sign, so nothing downstream has to reason about negative amounts.
 * A transfer is two rows sharing {@code transferGroupId}; see V3__personal_finance.sql.
 */
@Entity
@Table(name = "transactions")
@Getter
@Setter
@NoArgsConstructor
public class Transaction extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "user_id", nullable = false)
  private UUID userId;

  @Column(name = "account_id", nullable = false)
  private UUID accountId;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private TransactionType type;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private TransactionDirection direction;

  @Column(name = "category_id")
  private UUID categoryId;

  @Column(name = "transfer_group_id")
  private UUID transferGroupId;

  /**
   * Non-null when this row was created by {@code RecurringTransactionService#materializeAllDue}.
   */
  @Column(name = "recurring_transaction_id")
  private UUID recurringTransactionId;

  @Column(nullable = false)
  private BigDecimal amount;

  private String merchant;

  private String description;

  private String notes;

  @Column(name = "occurred_on", nullable = false)
  private LocalDate occurredOn;

  /**
   * Multi-currency display snapshot (V2 Phase 3, spec section 22), generalized from Trip mode's
   * {@code group_expenses} columns (V11) to every personal transaction. {@code amount} above
   * remains the real base-currency figure every balance/report computation uses; these four are
   * metadata captured once at creation time and never recomputed, so a historical report never
   * silently changes when exchange rates move later.
   */
  @Column(name = "original_currency")
  private String originalCurrency;

  @Column(name = "original_amount")
  private BigDecimal originalAmount;

  @Column(name = "exchange_rate")
  private BigDecimal exchangeRate;

  @Column(name = "converted_at")
  private Instant convertedAt;

  public Transaction(
      UUID userId,
      UUID accountId,
      TransactionType type,
      TransactionDirection direction,
      UUID categoryId,
      UUID transferGroupId,
      BigDecimal amount,
      String merchant,
      String description,
      String notes,
      LocalDate occurredOn) {
    this.userId = userId;
    this.accountId = accountId;
    this.type = type;
    this.direction = direction;
    this.categoryId = categoryId;
    this.transferGroupId = transferGroupId;
    this.amount = amount;
    this.merchant = merchant;
    this.description = description;
    this.notes = notes;
    this.occurredOn = occurredOn;
  }

  /** Signed effect on the account's balance: positive for IN, negative for OUT. */
  public BigDecimal signedAmount() {
    return direction == TransactionDirection.IN ? amount : amount.negate();
  }
}
