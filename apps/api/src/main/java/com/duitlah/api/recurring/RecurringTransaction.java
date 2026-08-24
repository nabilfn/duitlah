package com.duitlah.api.recurring;

import com.duitlah.api.common.jpa.AuditableEntity;
import com.duitlah.api.transactions.TransactionDirection;
import com.duitlah.api.transactions.TransactionType;
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

/**
 * A recurring schedule (rent, salary, Netflix, ...) that materializes into ordinary {@code
 * Transaction} rows over time — see {@code RecurringTransactionService#materializeAllDue}. This row
 * is the rule, not the history; each occurrence it produces is a real, independent {@code
 * Transaction} the same "computed balance" formula already relies on, so a rule never needs
 * special-casing anywhere balances are read.
 *
 * <p>{@code isSubscription} is the only thing distinguishing a "Subscription" (Netflix, Spotify)
 * from any other recurring transaction (rent, salary) — same schedule machinery either way, just a
 * different lens for display (see docs/database.md).
 */
@Entity
@Table(name = "recurring_transactions")
@Getter
@Setter
@NoArgsConstructor
public class RecurringTransaction extends AuditableEntity {

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

  @Column(nullable = false)
  private BigDecimal amount;

  private String merchant;

  private String description;

  private String notes;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private RecurrenceFrequency frequency;

  @Column(name = "interval_count", nullable = false)
  private int intervalCount;

  @Column(name = "start_date", nullable = false)
  private LocalDate startDate;

  @Column(name = "end_date")
  private LocalDate endDate;

  @Column(name = "next_occurrence_date", nullable = false)
  private LocalDate nextOccurrenceDate;

  @Column(name = "is_subscription", nullable = false)
  private boolean subscription;

  @Column(nullable = false)
  private boolean active;

  public RecurringTransaction(
      UUID userId,
      UUID accountId,
      TransactionType type,
      TransactionDirection direction,
      UUID categoryId,
      BigDecimal amount,
      String merchant,
      String description,
      String notes,
      RecurrenceFrequency frequency,
      int intervalCount,
      LocalDate startDate,
      LocalDate endDate,
      boolean subscription) {
    this.userId = userId;
    this.accountId = accountId;
    this.type = type;
    this.direction = direction;
    this.categoryId = categoryId;
    this.amount = amount;
    this.merchant = merchant;
    this.description = description;
    this.notes = notes;
    this.frequency = frequency;
    this.intervalCount = intervalCount;
    this.startDate = startDate;
    this.endDate = endDate;
    this.nextOccurrenceDate = startDate;
    this.subscription = subscription;
    this.active = true;
  }
}
