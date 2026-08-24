package com.duitlah.api.reconciliation;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "reconciliation_sessions")
@Getter
@Setter
@NoArgsConstructor
public class ReconciliationSession {

  @Id @GeneratedValue private UUID id;

  @Column(name = "space_id", nullable = false)
  private UUID spaceId;

  @Column(name = "business_account_id", nullable = false)
  private UUID businessAccountId;

  @Column(name = "business_statement_import_id", nullable = false)
  private UUID businessStatementImportId;

  @Column(name = "statement_ending_balance")
  private BigDecimal statementEndingBalance;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private ReconciliationSessionStatus status;

  @Column(name = "started_at", nullable = false)
  private Instant startedAt;

  @Column(name = "completed_at")
  private Instant completedAt;

  @Column(name = "created_by_user_id", nullable = false)
  private UUID createdByUserId;

  public ReconciliationSession(
      UUID spaceId, UUID businessAccountId, UUID businessStatementImportId, UUID createdByUserId) {
    this.spaceId = spaceId;
    this.businessAccountId = businessAccountId;
    this.businessStatementImportId = businessStatementImportId;
    this.createdByUserId = createdByUserId;
    this.status = ReconciliationSessionStatus.IN_PROGRESS;
    this.startedAt = Instant.now();
  }
}
