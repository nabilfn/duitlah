package com.duitlah.api.reconciliation;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ReconciliationSessionRepository
    extends JpaRepository<ReconciliationSession, UUID> {

  Optional<ReconciliationSession> findByIdAndSpaceId(UUID id, UUID spaceId);

  Optional<ReconciliationSession> findByBusinessStatementImportId(UUID businessStatementImportId);

  List<ReconciliationSession> findBySpaceIdOrderByStartedAtDesc(UUID spaceId);
}
