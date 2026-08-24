package com.duitlah.api.reconciliation;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BusinessStatementLineRepository
    extends JpaRepository<BusinessStatementLine, UUID> {

  Optional<BusinessStatementLine> findByIdAndBusinessStatementImportId(
      UUID id, UUID businessStatementImportId);

  List<BusinessStatementLine> findByBusinessStatementImportIdOrderByOccurredOnAsc(
      UUID businessStatementImportId);

  List<BusinessStatementLine> findByBusinessStatementImportIdAndStatus(
      UUID businessStatementImportId, StatementLineStatus status);
}
