package com.duitlah.api.accounting;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Append-only — the database itself enforces that every entry's lines balance (see {@code
 * check_journal_entry_balance} in V22).
 */
@Entity
@Table(name = "journal_lines")
@Getter
@Setter
@NoArgsConstructor
public class JournalLine {

  @Id @GeneratedValue private UUID id;

  @Column(name = "journal_entry_id", nullable = false)
  private UUID journalEntryId;

  @Column(name = "account_id", nullable = false)
  private UUID accountId;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private JournalDirection direction;

  @Column(nullable = false)
  private BigDecimal amount;

  private String description;

  @Column(name = "sort_order", nullable = false)
  private int sortOrder;

  public JournalLine(
      UUID journalEntryId,
      UUID accountId,
      JournalDirection direction,
      BigDecimal amount,
      String description,
      int sortOrder) {
    this.journalEntryId = journalEntryId;
    this.accountId = accountId;
    this.direction = direction;
    this.amount = amount;
    this.description = description;
    this.sortOrder = sortOrder;
  }

  public BigDecimal signedAmount() {
    return direction == JournalDirection.DEBIT ? amount : amount.negate();
  }
}
