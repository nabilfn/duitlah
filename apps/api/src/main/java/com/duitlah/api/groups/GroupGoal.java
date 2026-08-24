package com.duitlah.api.groups;

import com.duitlah.api.common.jpa.AuditableEntity;
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

/**
 * The group-scoped counterpart to {@link com.duitlah.api.goals.Goal} (product spec section 27,
 * "Shared goals"). Like the personal version, the current amount saved is never stored here -- it's
 * SUM({@link GroupGoalContribution}) for this goal, computed on read.
 */
@Entity
@Table(name = "group_goals")
@Getter
@Setter
@NoArgsConstructor
public class GroupGoal extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "group_id", nullable = false)
  private UUID groupId;

  @Column(nullable = false)
  private String name;

  @Column(name = "target_amount", nullable = false)
  private BigDecimal targetAmount;

  @Column(name = "target_date")
  private LocalDate targetDate;

  @Column(name = "created_by_user_id", nullable = false)
  private UUID createdByUserId;

  @Column(name = "archived_at")
  private Instant archivedAt;

  public GroupGoal(
      UUID groupId,
      String name,
      BigDecimal targetAmount,
      LocalDate targetDate,
      UUID createdByUserId) {
    this.groupId = groupId;
    this.name = name;
    this.targetAmount = targetAmount;
    this.targetDate = targetDate;
    this.createdByUserId = createdByUserId;
  }

  public boolean isArchived() {
    return archivedAt != null;
  }
}
