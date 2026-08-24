package com.duitlah.api.bills;

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
@Table(name = "personal_bills")
@Getter
@Setter
@NoArgsConstructor
public class PersonalBill extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "user_id", nullable = false)
  private UUID userId;

  @Column(name = "space_id", nullable = false)
  private UUID spaceId;

  @Column(nullable = false)
  private String name;

  private String provider;

  @Column(name = "due_date", nullable = false)
  private LocalDate dueDate;

  @Column(name = "expected_amount", nullable = false)
  private BigDecimal expectedAmount;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private BillRecurrence recurrence;

  @Column(name = "recurring_transaction_id")
  private UUID recurringTransactionId;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private BillStatus status;

  @Column(name = "linked_transaction_id")
  private UUID linkedTransactionId;

  @Column(name = "receipt_id")
  private UUID receiptId;

  private String notes;

  public PersonalBill(
      UUID userId,
      UUID spaceId,
      String name,
      String provider,
      LocalDate dueDate,
      BigDecimal expectedAmount,
      BillRecurrence recurrence,
      UUID recurringTransactionId) {
    this.userId = userId;
    this.spaceId = spaceId;
    this.name = name;
    this.provider = provider;
    this.dueDate = dueDate;
    this.expectedAmount = expectedAmount;
    this.recurrence = recurrence;
    this.recurringTransactionId = recurringTransactionId;
    this.status = BillStatus.UPCOMING;
  }

  public boolean isResolved() {
    return status == BillStatus.PAID || status == BillStatus.SKIPPED;
  }
}
