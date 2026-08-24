package com.duitlah.api.goals;

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

/** A signed entry in a goal's ledger — positive to add, negative to correct/withdraw. */
@Entity
@Table(name = "goal_contributions")
@Getter
@Setter
@NoArgsConstructor
public class GoalContribution {

  @Id @GeneratedValue private UUID id;

  @Column(name = "goal_id", nullable = false)
  private UUID goalId;

  @Column(name = "user_id", nullable = false)
  private UUID userId;

  @Column(nullable = false)
  private BigDecimal amount;

  @Column(name = "occurred_on", nullable = false)
  private LocalDate occurredOn;

  private String note;

  @Column(name = "created_at", nullable = false)
  private Instant createdAt;

  public GoalContribution(
      UUID goalId, UUID userId, BigDecimal amount, LocalDate occurredOn, String note) {
    this.goalId = goalId;
    this.userId = userId;
    this.amount = amount;
    this.occurredOn = occurredOn;
    this.note = note;
    this.createdAt = Instant.now();
  }
}
