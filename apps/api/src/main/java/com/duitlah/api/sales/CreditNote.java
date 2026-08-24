package com.duitlah.api.sales;

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

@Entity
@Table(name = "credit_notes")
@Getter
@Setter
@NoArgsConstructor
public class CreditNote extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "space_id", nullable = false)
  private UUID spaceId;

  @Column(name = "customer_id", nullable = false)
  private UUID customerId;

  @Column(name = "invoice_id")
  private UUID invoiceId;

  @Column(name = "credit_note_number", nullable = false)
  private String creditNoteNumber;

  @Column(name = "issue_date", nullable = false)
  private LocalDate issueDate;

  @Column(nullable = false)
  private BigDecimal amount;

  private String reason;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private CreditNoteStatus status;

  public CreditNote(
      UUID spaceId,
      UUID customerId,
      UUID invoiceId,
      String creditNoteNumber,
      LocalDate issueDate,
      BigDecimal amount,
      String reason) {
    this.spaceId = spaceId;
    this.customerId = customerId;
    this.invoiceId = invoiceId;
    this.creditNoteNumber = creditNoteNumber;
    this.issueDate = issueDate;
    this.amount = amount;
    this.reason = reason;
    this.status = CreditNoteStatus.ISSUED;
  }
}
