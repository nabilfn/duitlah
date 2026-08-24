package com.duitlah.api.personaltax;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/** Append-only, same discipline as {@code liability_payments}/{@code goal_contributions}. */
@Entity
@Table(name = "zakat_payments")
@Getter
@Setter
@NoArgsConstructor
public class ZakatPayment {

  @Id @GeneratedValue private UUID id;

  @Column(name = "user_id", nullable = false)
  private UUID userId;

  @Column(name = "year_of_assessment", nullable = false)
  private int yearOfAssessment;

  @Column(nullable = false)
  private BigDecimal amount;

  @Column(name = "paid_on", nullable = false)
  private LocalDate paidOn;

  @Column(name = "receipt_id")
  private UUID receiptId;

  private String notes;

  @Column(name = "created_at", nullable = false, updatable = false)
  private Instant createdAt;

  public ZakatPayment(
      UUID userId, int yearOfAssessment, BigDecimal amount, LocalDate paidOn, UUID receiptId) {
    this.userId = userId;
    this.yearOfAssessment = yearOfAssessment;
    this.amount = amount;
    this.paidOn = paidOn;
    this.receiptId = receiptId;
  }

  @jakarta.persistence.PrePersist
  void onCreate() {
    createdAt = Instant.now();
  }
}
