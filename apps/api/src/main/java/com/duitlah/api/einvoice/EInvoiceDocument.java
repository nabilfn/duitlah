package com.duitlah.api.einvoice;

import com.duitlah.api.common.jpa.AuditableEntity;
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
 * One row per invoice that has entered the e-Invoice workflow (spec section 56). See package-info.
 */
@Entity
@Table(name = "einvoice_documents")
@Getter
@Setter
@NoArgsConstructor
public class EInvoiceDocument extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "space_id", nullable = false)
  private UUID spaceId;

  @Column(name = "invoice_id", nullable = false)
  private UUID invoiceId;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private EInvoiceStatus status;

  @Column(name = "submission_uid")
  private String submissionUid;

  @Column(name = "document_uuid")
  private String documentUuid;

  @Column(name = "long_id")
  private String longId;

  @Column(name = "validated_at")
  private Instant validatedAt;

  @Column(name = "invalid_reason")
  private String invalidReason;

  @Column(name = "cancelled_at")
  private Instant cancelledAt;

  @Column(name = "cancellation_reason")
  private String cancellationReason;

  @Column(name = "rejected_at")
  private Instant rejectedAt;

  @Column(name = "rejection_reason")
  private String rejectionReason;

  @Column(name = "created_by_user_id", nullable = false)
  private UUID createdByUserId;

  public EInvoiceDocument(UUID spaceId, UUID invoiceId, UUID createdByUserId) {
    this.spaceId = spaceId;
    this.invoiceId = invoiceId;
    this.status = EInvoiceStatus.READY;
    this.createdByUserId = createdByUserId;
  }
}
