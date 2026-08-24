package com.duitlah.api.goals;

import com.duitlah.api.common.jpa.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
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

/**
 * Like {@link com.duitlah.api.finance.Account}, the current amount saved is never stored here —
 * it's SUM({@link GoalContribution}) for this goal, computed on read. See
 * V4__budgets_and_goals.sql.
 */
@Entity
@Table(name = "goals")
@Getter
@Setter
@NoArgsConstructor
public class Goal extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "user_id", nullable = false)
  private UUID userId;

  @Column(nullable = false)
  private String name;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private GoalType type;

  @Column(name = "target_amount", nullable = false)
  private BigDecimal targetAmount;

  @Column(name = "target_date")
  private LocalDate targetDate;

  @Column(name = "archived_at")
  private Instant archivedAt;

  public Goal(
      UUID userId, String name, GoalType type, BigDecimal targetAmount, LocalDate targetDate) {
    this.userId = userId;
    this.name = name;
    this.type = type;
    this.targetAmount = targetAmount;
    this.targetDate = targetDate;
  }

  public boolean isArchived() {
    return archivedAt != null;
  }
}
