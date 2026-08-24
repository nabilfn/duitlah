package com.duitlah.api.notifications;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface NotificationRecordRepository extends JpaRepository<NotificationRecord, UUID> {

  Optional<NotificationRecord> findByIdAndUserId(UUID id, UUID userId);

  List<NotificationRecord> findByUserIdOrderByCreatedAtDesc(UUID userId);

  long countByUserIdAndReadAtIsNull(UUID userId);
}
