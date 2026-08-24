package com.duitlah.api.receipts;

import com.duitlah.api.common.jpa.AuditableEntity;
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
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

/**
 * The Receipt Vault (spec section 15): a receipt that exists independently of any one Bagilah bill,
 * personal transaction, or business expense, and can attach to one afterward via {@link
 * #linkedTransactionId}/{@link #linkedBillId}. The binary itself lives in {@code
 * common.storage.ObjectStorage}, same as {@link ReceiptScan}'s images — this row is metadata only.
 */
@Entity
@Table(name = "receipts")
@Getter
@Setter
@NoArgsConstructor
public class Receipt extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "user_id", nullable = false)
  private UUID userId;

  @Column(name = "space_id", nullable = false)
  private UUID spaceId;

  @Column(name = "storage_key", nullable = false)
  private String storageKey;

  @Column(name = "content_type", nullable = false)
  private String contentType;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private ReceiptPurpose purpose;

  @Enumerated(EnumType.STRING)
  @Column(name = "ocr_status", nullable = false)
  private VaultOcrStatus ocrStatus;

  private String merchant;

  @Column(name = "receipt_date")
  private LocalDate receiptDate;

  @Column(name = "total_amount")
  private BigDecimal totalAmount;

  @Column(name = "overall_confidence")
  private Double overallConfidence;

  private String folder;

  @JdbcTypeCode(SqlTypes.ARRAY)
  @Column(columnDefinition = "text[]")
  private String[] tags = new String[0];

  @Column(name = "linked_transaction_id")
  private UUID linkedTransactionId;

  @Column(name = "linked_bill_id")
  private UUID linkedBillId;

  public Receipt(
      UUID userId, UUID spaceId, String storageKey, String contentType, ReceiptPurpose purpose) {
    this.userId = userId;
    this.spaceId = spaceId;
    this.storageKey = storageKey;
    this.contentType = contentType;
    this.purpose = purpose;
    this.ocrStatus = VaultOcrStatus.UNPROCESSED;
  }
}
