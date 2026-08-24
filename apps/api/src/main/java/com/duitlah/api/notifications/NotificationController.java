package com.duitlah.api.notifications;

import java.util.List;
import java.util.Map;
import java.util.UUID;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class NotificationController {

  private final NotificationService notifications;

  public NotificationController(NotificationService notifications) {
    this.notifications = notifications;
  }

  @GetMapping("/api/v1/notifications")
  public List<NotificationResponse> list(@AuthenticationPrincipal UUID userId) {
    return notifications.list(userId);
  }

  @GetMapping("/api/v1/notifications/unread-count")
  public Map<String, Long> unreadCount(@AuthenticationPrincipal UUID userId) {
    return Map.of("count", notifications.unreadCount(userId));
  }

  @PostMapping("/api/v1/notifications/{notificationId}/read")
  public NotificationResponse markRead(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID notificationId) {
    return notifications.markRead(userId, notificationId);
  }
}
