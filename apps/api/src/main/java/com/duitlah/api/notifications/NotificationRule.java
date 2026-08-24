package com.duitlah.api.notifications;

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
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * One row per (user, {@link NotificationRuleType}) the user has ever changed from its default — see
 * {@link NotificationRuleService} for what "no row" means per type. {@code lastTriggeredAt} is the
 * dedup timestamp for the two new scheduler-driven triggers ({@code BUDGET_EXCEEDED} uses its own
 * per-budget {@code Budget.budgetExceededNotifiedAt} instead, since a budget row is the more
 * natural per-entity granularity there — this field is for {@code LOW_BALANCE}, which has no
 * per-entity row of its own to hang a timestamp on).
 */
@Entity
@Table(name = "notification_rules")
@Getter
@Setter
@NoArgsConstructor
public class NotificationRule extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "user_id", nullable = false)
  private UUID userId;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private NotificationRuleType type;

  @Column(nullable = false)
  private boolean enabled;

  @Column(name = "threshold_amount")
  private BigDecimal thresholdAmount;

  @Column(name = "last_triggered_at")
  private Instant lastTriggeredAt;

  public NotificationRule(
      UUID userId, NotificationRuleType type, boolean enabled, BigDecimal thresholdAmount) {
    this.userId = userId;
    this.type = type;
    this.enabled = enabled;
    this.thresholdAmount = thresholdAmount;
  }
}
