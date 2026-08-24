package com.duitlah.api.feedback;

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
 * Append-only, like {@link com.duitlah.api.audit.AuditLog} — nothing in this codebase ever edits or
 * deletes a submitted piece of feedback. No admin-facing edit/triage surface exists yet; this is
 * only the submission half of "feedback system" (Phase 15).
 */
@Entity
@Table(name = "feedback")
@Getter
@NoArgsConstructor
public class Feedback {

  @Id @GeneratedValue private UUID id;

  @Column(name = "user_id", nullable = false)
  private UUID userId;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private FeedbackCategory category;

  @Column(nullable = false)
  private String message;

  @Column(name = "created_at", nullable = false)
  private Instant createdAt;

  public Feedback(UUID userId, FeedbackCategory category, String message) {
    this.userId = userId;
    this.category = category;
    this.message = message;
    this.createdAt = Instant.now();
  }
}
