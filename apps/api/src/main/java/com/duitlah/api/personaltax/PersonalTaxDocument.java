package com.duitlah.api.personaltax;

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

/**
 * Either references an existing Receipt Vault entry ({@code receiptId} — reusing its OCR/storage
 * rather than duplicating it) or stores its own file directly ({@code storageKey}) for document
 * types that aren't naturally "receipts" (an EA form, an EPF statement PDF).
 */
@Entity
@Table(name = "personal_tax_documents")
@Getter
@Setter
@NoArgsConstructor
public class PersonalTaxDocument extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "user_id", nullable = false)
  private UUID userId;

  @Column(name = "space_id", nullable = false)
  private UUID spaceId;

  @Column(name = "year_of_assessment", nullable = false)
  private int yearOfAssessment;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private TaxDocumentType type;

  @Column(name = "receipt_id")
  private UUID receiptId;

  @Column(name = "storage_key")
  private String storageKey;

  private String notes;

  public PersonalTaxDocument(
      UUID userId,
      UUID spaceId,
      int yearOfAssessment,
      TaxDocumentType type,
      UUID receiptId,
      String storageKey) {
    this.userId = userId;
    this.spaceId = spaceId;
    this.yearOfAssessment = yearOfAssessment;
    this.type = type;
    this.receiptId = receiptId;
    this.storageKey = storageKey;
  }
}
