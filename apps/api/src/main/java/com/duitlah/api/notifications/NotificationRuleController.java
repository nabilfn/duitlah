package com.duitlah.api.notifications;

import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class NotificationRuleController {

  private final NotificationRuleService rules;

  public NotificationRuleController(NotificationRuleService rules) {
    this.rules = rules;
  }

  @GetMapping("/api/v1/notification-rules")
  public List<NotificationRuleResponse> list(@AuthenticationPrincipal UUID userId) {
    return rules.list(userId);
  }

  @PutMapping("/api/v1/notification-rules/{type}")
  public NotificationRuleResponse update(
      @AuthenticationPrincipal UUID userId,
      @PathVariable NotificationRuleType type,
      @Valid @RequestBody UpdateNotificationRuleRequest request) {
    return rules.upsert(userId, type, request);
  }
}
