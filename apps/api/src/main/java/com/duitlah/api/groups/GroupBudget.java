package com.duitlah.api.groups;

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

/**
 * Trip mode's single overall budget (product spec section 32) — one flat target for the group's
 * lifetime, not the monthly-recurring-per-category model {@code budgets} uses. {@code spent} is
 * always derived from {@code group_expenses}, never stored here — see V11__special_group_modes.sql.
 */
@Entity
@Table(name = "group_budgets")
@Getter
@Setter
@NoArgsConstructor
public class GroupBudget {

  @Id @GeneratedValue private UUID id;

  @Column(name = "group_id", nullable = false, unique = true)
  private UUID groupId;

  @Column(nullable = false)
  private BigDecimal amount;

  @Column(name = "created_by_user_id", nullable = false)
  private UUID createdByUserId;

  @Column(name = "created_at", nullable = false)
  private Instant createdAt;

  @Column(name = "updated_at", nullable = false)
  private Instant updatedAt;

  public GroupBudget(UUID groupId, BigDecimal amount, UUID createdByUserId) {
    this.groupId = groupId;
    this.amount = amount;
    this.createdByUserId = createdByUserId;
    this.createdAt = Instant.now();
    this.updatedAt = this.createdAt;
  }
}
