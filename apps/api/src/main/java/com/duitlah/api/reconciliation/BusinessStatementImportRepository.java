package com.duitlah.api.reconciliation;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BusinessStatementImportRepository
    extends JpaRepository<BusinessStatementImport, UUID> {

  Optional<BusinessStatementImport> findByIdAndSpaceId(UUID id, UUID spaceId);

  List<BusinessStatementImport> findBySpaceIdOrderByCreatedAtDesc(UUID spaceId);
}
