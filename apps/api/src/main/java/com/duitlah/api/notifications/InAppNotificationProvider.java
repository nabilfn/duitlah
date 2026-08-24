package com.duitlah.api.notifications;

import java.util.UUID;
import org.springframework.stereotype.Component;

/** Always active — a real, persisted, in-app notification list needs no external provider. */
@Component
public class InAppNotificationProvider implements NotificationProvider {

  private final NotificationRecordRepository records;

  public InAppNotificationProvider(NotificationRecordRepository records) {
    this.records = records;
  }

  @Override
  public void send(UUID userId, String type, String title, String body) {
    records.save(new NotificationRecord(userId, type, title, body));
  }
}
