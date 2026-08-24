package com.duitlah.api.accounting;

import java.util.Collection;
import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface JournalLineRepository extends JpaRepository<JournalLine, UUID> {

  List<JournalLine> findByJournalEntryIdOrderBySortOrderAsc(UUID journalEntryId);

  /**
   * Bulk fetch for report aggregation (General Ledger / Trial Balance / P&amp;L / Balance Sheet /
   * Cash Flow) — there's no JPA association between {@link JournalLine} and {@link JournalEntry}
   * (this codebase deliberately links tables by plain UUID fields, never {@code @ManyToOne}), so
   * report services fetch the relevant entry ids first, then their lines, and aggregate in Java
   * rather than reaching for a native SQL join.
   */
  List<JournalLine> findByJournalEntryIdIn(Collection<UUID> journalEntryIds);
}
