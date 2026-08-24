package com.duitlah.api.einvoice;

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

/**
 * Append-only — see package-info's "all provider interactions must be auditable". Independent of
 * {@link EInvoiceDocument}'s own current-state columns, so a full interaction history survives
 * across state transitions.
 */
@Entity
@Table(name = "einvoice_provider_logs")
@Getter
@Setter
@NoArgsConstructor
public class EInvoiceProviderLog {

  @Id @GeneratedValue private UUID id;

  @Column(name = "einvoice_document_id", nullable = false)
  private UUID einvoiceDocumentId;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private EInvoiceOperation operation;

  @Column(name = "provider_name", nullable = false)
  private String providerName;

  @Column(nullable = false)
  private boolean success;

  private String detail;

  @Column(name = "created_at", nullable = false)
  private Instant createdAt;

  public EInvoiceProviderLog(
      UUID einvoiceDocumentId,
      EInvoiceOperation operation,
      String providerName,
      boolean success,
      String detail) {
    this.einvoiceDocumentId = einvoiceDocumentId;
    this.operation = operation;
    this.providerName = providerName;
    this.success = success;
    this.detail = detail;
    this.createdAt = Instant.now();
  }
}
