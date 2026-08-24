package com.duitlah.api.audit;

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

/**
 * Append-only by design (like {@code goal_contributions}/{@code settlement_payments}) -- an audit
 * trail that could be edited after the fact wouldn't be one. Nothing in this codebase ever updates
 * or deletes a row here.
 */
@Entity
@Table(name = "audit_logs")
@Getter
@NoArgsConstructor
public class AuditLog {

  @Id @GeneratedValue private UUID id;

  @Column(name = "actor_user_id")
  private UUID actorUserId;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private AuditAction action;

  @Column(name = "entity_type", nullable = false)
  private String entityType;

  @Column(name = "entity_id")
  private UUID entityId;

  private String metadata;

  @Column(name = "created_at", nullable = false)
  private Instant createdAt;

  public AuditLog(
      UUID actorUserId, AuditAction action, String entityType, UUID entityId, String metadata) {
    this.actorUserId = actorUserId;
    this.action = action;
    this.entityType = entityType;
    this.entityId = entityId;
    this.metadata = metadata;
    this.createdAt = Instant.now();
  }
}
