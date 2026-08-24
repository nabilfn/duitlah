package com.duitlah.api.subscriptions;

import com.duitlah.api.common.jpa.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.Instant;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Duitlah's own verified entitlement record (product spec section 56) — never a live mirror of
 * Apple/Google/Stripe's own subscription object. A row only exists once a user has actually
 * verified a real purchase; its absence means FREE (see {@link SubscriptionService}).
 */
@Entity
@Table(name = "user_subscriptions")
@Getter
@Setter
@NoArgsConstructor
public class UserSubscription extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "user_id", nullable = false, unique = true)
  private UUID userId;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private SubscriptionTier tier;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private SubscriptionSource source;

  @Column(name = "external_reference", nullable = false)
  private String externalReference;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private SubscriptionStatus status;

  @Column(name = "started_at", nullable = false)
  private Instant startedAt;

  @Column(name = "expires_at")
  private Instant expiresAt;

  public UserSubscription(
      UUID userId,
      SubscriptionTier tier,
      SubscriptionSource source,
      String externalReference,
      SubscriptionStatus status,
      Instant startedAt,
      Instant expiresAt) {
    this.userId = userId;
    this.tier = tier;
    this.source = source;
    this.externalReference = externalReference;
    this.status = status;
    this.startedAt = startedAt;
    this.expiresAt = expiresAt;
  }

  public boolean isCurrentlyEntitled() {
    boolean statusOk =
        status == SubscriptionStatus.ACTIVE || status == SubscriptionStatus.GRACE_PERIOD;
    boolean notExpired = expiresAt == null || expiresAt.isAfter(Instant.now());
    return statusOk && notExpired;
  }
}
