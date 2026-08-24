package com.duitlah.api.reconciliation;

import java.util.Collection;
import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ReconciliationLineAllocationRepository
    extends JpaRepository<ReconciliationLineAllocation, UUID> {

  List<ReconciliationLineAllocation> findByBusinessStatementLineId(UUID businessStatementLineId);

  /**
   * Every ledger entry already consumed by some allocation — the matching engine excludes these
   * from its candidate pool (each entry may back at most one allocation).
   */
  @org.springframework.data.jpa.repository.Query(
      "SELECT a.businessAccountEntryId FROM ReconciliationLineAllocation a WHERE a.businessAccountEntryId IN :entryIds")
  List<UUID> findAllocatedEntryIds(
      @org.springframework.data.repository.query.Param("entryIds") Collection<UUID> entryIds);
}
