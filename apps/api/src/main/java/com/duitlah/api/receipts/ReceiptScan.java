package com.duitlah.api.receipts;

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
@Table(name = "receipt_scans")
@Getter
@Setter
@NoArgsConstructor
public class ReceiptScan extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "owner_user_id", nullable = false)
  private UUID ownerUserId;

  @Column(name = "bill_id")
  private UUID billId;

  @Column(name = "image_storage_key", nullable = false)
  private String imageStorageKey;

  @Column(name = "content_type", nullable = false)
  private String contentType;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private ScanStatus status;

  @Column(nullable = false)
  private String provider;

  @Column(name = "overall_confidence")
  private Double overallConfidence;

  @Column(name = "parsed_result_json", columnDefinition = "TEXT")
  private String parsedResultJson;

  @Column(name = "error_message")
  private String errorMessage;

  public ReceiptScan(
      UUID ownerUserId, String imageStorageKey, String contentType, String provider) {
    this.ownerUserId = ownerUserId;
    this.imageStorageKey = imageStorageKey;
    this.contentType = contentType;
    this.provider = provider;
  }
}
