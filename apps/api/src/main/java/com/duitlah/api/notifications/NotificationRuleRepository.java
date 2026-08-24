package com.duitlah.api.notifications;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface NotificationRuleRepository extends JpaRepository<NotificationRule, UUID> {

  List<NotificationRule> findByUserId(UUID userId);

  Optional<NotificationRule> findByUserIdAndType(UUID userId, NotificationRuleType type);

  List<NotificationRule> findByTypeAndEnabledTrueAndThresholdAmountIsNotNull(
      NotificationRuleType type);
}
