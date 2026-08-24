package com.duitlah.api.statements;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface StatementImportRepository extends JpaRepository<StatementImport, UUID> {

  Optional<StatementImport> findByIdAndUserId(UUID id, UUID userId);

  List<StatementImport> findByUserIdOrderByCreatedAtDesc(UUID userId);
}
