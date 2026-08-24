package com.duitlah.api.statements;

import com.duitlah.api.common.jpa.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "statement_imports")
@Getter
@Setter
@NoArgsConstructor
public class StatementImport extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "user_id", nullable = false)
  private UUID userId;

  @Column(name = "space_id", nullable = false)
  private UUID spaceId;

  @Column(name = "account_id", nullable = false)
  private UUID accountId;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private StatementProvider provider;

  @Column(name = "original_filename", nullable = false)
  private String originalFilename;

  @Column(name = "storage_key", nullable = false)
  private String storageKey;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private StatementImportStatus status;

  @Column(name = "row_count", nullable = false)
  private int rowCount;

  @Column(name = "error_message")
  private String errorMessage;

  public StatementImport(
      UUID userId,
      UUID spaceId,
      UUID accountId,
      StatementProvider provider,
      String originalFilename,
      String storageKey) {
    this.userId = userId;
    this.spaceId = spaceId;
    this.accountId = accountId;
    this.provider = provider;
    this.originalFilename = originalFilename;
    this.storageKey = storageKey;
    this.status = StatementImportStatus.UPLOADED;
    this.rowCount = 0;
  }
}
