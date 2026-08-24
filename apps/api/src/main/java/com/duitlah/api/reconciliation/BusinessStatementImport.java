package com.duitlah.api.reconciliation;

import com.duitlah.api.statements.StatementProvider;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.Instant;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/** Append-only — status is decided once at parse time and never changes afterward. */
@Entity
@Table(name = "business_statement_imports")
@Getter
@Setter
@NoArgsConstructor
public class BusinessStatementImport {

  @Id @GeneratedValue private UUID id;

  @Column(name = "space_id", nullable = false)
  private UUID spaceId;

  @Column(name = "business_account_id", nullable = false)
  private UUID businessAccountId;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private StatementProvider provider;

  @Column(name = "original_filename", nullable = false)
  private String originalFilename;

  @Column(name = "storage_key", nullable = false)
  private String storageKey;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private BusinessStatementImportStatus status;

  @Column(name = "row_count", nullable = false)
  private int rowCount;

  @Column(name = "error_message")
  private String errorMessage;

  @Column(name = "created_by_user_id", nullable = false)
  private UUID createdByUserId;

  @Column(name = "created_at", nullable = false)
  private Instant createdAt;

  public BusinessStatementImport(
      UUID spaceId,
      UUID businessAccountId,
      StatementProvider provider,
      String originalFilename,
      String storageKey,
      UUID createdByUserId) {
    this.spaceId = spaceId;
    this.businessAccountId = businessAccountId;
    this.provider = provider;
    this.originalFilename = originalFilename;
    this.storageKey = storageKey;
    this.createdByUserId = createdByUserId;
    this.createdAt = Instant.now();
  }
}
