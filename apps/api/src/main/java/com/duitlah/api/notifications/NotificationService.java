package com.duitlah.api.notifications;

import com.duitlah.api.common.error.NotFoundException;
import java.time.Instant;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class NotificationService {

  private final NotificationRecordRepository records;
  private final List<NotificationProvider> providers;
  private final NotificationRuleService notificationRuleService;

  public NotificationService(
      NotificationRecordRepository records,
      List<NotificationProvider> providers,
      NotificationRuleService notificationRuleService) {
    this.records = records;
    this.providers = providers;
    this.notificationRuleService = notificationRuleService;
  }

  /**
   * Fans out to every configured channel — callers never need to know which ones exist. V2 Phase
   * 13: every call is gated by {@link NotificationRuleService#isEnabledFor} first, so a user who's
   * disabled a given type sees nothing from it, without every one of this method's callers (across
   * {@code bills}, {@code inventory}, {@code budgets}, ...) needing to check a rule itself.
   */
  public void notify(UUID userId, String type, String title, String body) {
    if (!notificationRuleService.isEnabledFor(userId, type)) {
      return;
    }
    providers.forEach(provider -> provider.send(userId, type, title, body));
  }

  public List<NotificationResponse> list(UUID userId) {
    return records.findByUserIdOrderByCreatedAtDesc(userId).stream()
        .map(NotificationResponse::from)
        .toList();
  }

  public long unreadCount(UUID userId) {
    return records.countByUserIdAndReadAtIsNull(userId);
  }

  @Transactional
  public NotificationResponse markRead(UUID userId, UUID notificationId) {
    NotificationRecord record =
        records
            .findByIdAndUserId(notificationId, userId)
            .orElseThrow(
                () -> new NotFoundException("NOTIFICATION_NOT_FOUND", "Notification not found."));
    if (!record.isRead()) {
      record.setReadAt(Instant.now());
      records.save(record);
    }
    return NotificationResponse.from(record);
  }
}
