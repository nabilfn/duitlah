package com.duitlah.api.notifications;

import java.util.Arrays;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * "Notification rules" (V2 Phase 13) — before this phase, every trigger fired unconditionally (see
 * {@code NotificationService#notify}, which now consults {@link #isEnabledFor} first). A missing
 * row means the type's own default: {@code true} for every type except {@link
 * NotificationRuleType#LOW_BALANCE}, which defaults {@code false} — it needs a user-supplied
 * threshold to mean anything, so it's opt-in rather than opt-out like the other four.
 */
@Service
public class NotificationRuleService {

  private final NotificationRuleRepository rules;

  public NotificationRuleService(NotificationRuleRepository rules) {
    this.rules = rules;
  }

  /** Every type, including ones the user has never touched (default row, never persisted). */
  public List<NotificationRuleResponse> list(UUID userId) {
    List<NotificationRule> existing = rules.findByUserId(userId);
    return Arrays.stream(NotificationRuleType.values())
        .map(
            type ->
                existing.stream()
                    .filter(rule -> rule.getType() == type)
                    .findFirst()
                    .map(
                        rule ->
                            new NotificationRuleResponse(
                                type, rule.isEnabled(), rule.getThresholdAmount()))
                    .orElseGet(
                        () -> new NotificationRuleResponse(type, defaultEnabled(type), null)))
        .toList();
  }

  @Transactional
  public NotificationRuleResponse upsert(
      UUID userId, NotificationRuleType type, UpdateNotificationRuleRequest request) {
    NotificationRule rule =
        rules
            .findByUserIdAndType(userId, type)
            .orElseGet(() -> new NotificationRule(userId, type, defaultEnabled(type), null));
    rule.setEnabled(request.enabled());
    rule.setThresholdAmount(request.thresholdAmount());
    rules.save(rule);
    return new NotificationRuleResponse(type, rule.isEnabled(), rule.getThresholdAmount());
  }

  /** Consulted by {@link NotificationService#notify} before fanning out to any channel. */
  public boolean isEnabledFor(UUID userId, String typeName) {
    NotificationRuleType type = parseType(typeName);
    if (type == null) {
      return true;
    }
    return rules
        .findByUserIdAndType(userId, type)
        .map(NotificationRule::isEnabled)
        .orElseGet(() -> defaultEnabled(type));
  }

  private static NotificationRuleType parseType(String typeName) {
    try {
      return NotificationRuleType.valueOf(typeName);
    } catch (IllegalArgumentException | NullPointerException e) {
      return null;
    }
  }

  private static boolean defaultEnabled(NotificationRuleType type) {
    return type != NotificationRuleType.LOW_BALANCE;
  }

  public List<NotificationRule> findEnabledWithThreshold(NotificationRuleType type) {
    return rules.findByTypeAndEnabledTrueAndThresholdAmountIsNotNull(type);
  }

  @Transactional
  public void markTriggered(NotificationRule rule) {
    rule.setLastTriggeredAt(java.time.Instant.now());
    rules.save(rule);
  }

  @Transactional
  public void clearTriggered(NotificationRule rule) {
    rule.setLastTriggeredAt(null);
    rules.save(rule);
  }
}
