package com.duitlah.api.notifications;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.Instant;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * The in-app half of {@link NotificationService} — a persisted, readable notification a user sees
 * inside the app. Deliberately its own mapped superclass usage, not {@code AuditableEntity}: a
 * notification is never edited after creation (only marked read), so it needs {@code created_at}
 * but no {@code updated_at}.
 */
@Entity
@Table(name = "notification_records")
@Getter
@Setter
@NoArgsConstructor
public class NotificationRecord {

  @Id @GeneratedValue private UUID id;

  @Column(name = "user_id", nullable = false)
  private UUID userId;

  @Column(nullable = false)
  private String type;

  @Column(nullable = false)
  private String title;

  @Column(nullable = false)
  private String body;

  @Column(name = "read_at")
  private Instant readAt;

  @Column(name = "created_at", nullable = false, updatable = false)
  private Instant createdAt;

  public NotificationRecord(UUID userId, String type, String title, String body) {
    this.userId = userId;
    this.type = type;
    this.title = title;
    this.body = body;
  }

  @jakarta.persistence.PrePersist
  void onCreate() {
    createdAt = Instant.now();
  }

  public boolean isRead() {
    return readAt != null;
  }
}
