package com.duitlah.api.personaltax;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/** One row per (user, YA, month) — recording the same month twice updates the existing row. */
@Entity
@Table(name = "pcb_payments")
@Getter
@Setter
@NoArgsConstructor
public class PcbPayment {

  @Id @GeneratedValue private UUID id;

  @Column(name = "user_id", nullable = false)
  private UUID userId;

  @Column(name = "year_of_assessment", nullable = false)
  private int yearOfAssessment;

  @Column(nullable = false)
  private short month;

  @Column(nullable = false)
  private BigDecimal amount;

  private String notes;

  @Column(name = "created_at", nullable = false, updatable = false)
  private Instant createdAt;

  public PcbPayment(UUID userId, int yearOfAssessment, int month, BigDecimal amount) {
    this.userId = userId;
    this.yearOfAssessment = yearOfAssessment;
    this.month = (short) month;
    this.amount = amount;
  }

  @jakarta.persistence.PrePersist
  void onCreate() {
    createdAt = Instant.now();
  }
}
