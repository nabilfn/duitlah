package com.duitlah.api.reconciliation;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Append-only. A plain Match or a Create Transaction produces exactly one row; a Split produces
 * several, one per new ledger entry the line's amount was divided into.
 */
@Entity
@Table(name = "reconciliation_line_allocations")
@Getter
@Setter
@NoArgsConstructor
public class ReconciliationLineAllocation {

  @Id @GeneratedValue private UUID id;

  @Column(name = "business_statement_line_id", nullable = false)
  private UUID businessStatementLineId;

  @Column(name = "business_account_entry_id", nullable = false)
  private UUID businessAccountEntryId;

  @Column(nullable = false)
  private BigDecimal amount;

  @Column(name = "created_at", nullable = false)
  private Instant createdAt;

  public ReconciliationLineAllocation(
      UUID businessStatementLineId, UUID businessAccountEntryId, BigDecimal amount) {
    this.businessStatementLineId = businessStatementLineId;
    this.businessAccountEntryId = businessAccountEntryId;
    this.amount = amount;
    this.createdAt = Instant.now();
  }
}
