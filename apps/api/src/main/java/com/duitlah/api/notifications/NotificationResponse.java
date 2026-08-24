package com.duitlah.api.notifications;

import java.time.Instant;
import java.util.UUID;

public record NotificationResponse(
    UUID id, String type, String title, String body, boolean read, Instant createdAt) {

  public static NotificationResponse from(NotificationRecord record) {
    return new NotificationResponse(
        record.getId(),
        record.getType(),
        record.getTitle(),
        record.getBody(),
        record.isRead(),
        record.getCreatedAt());
  }
}
