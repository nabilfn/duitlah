package com.duitlah.api.accounting;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface JournalEntryRepository extends JpaRepository<JournalEntry, UUID> {

  Optional<JournalEntry> findByIdAndSpaceId(UUID id, UUID spaceId);

  List<JournalEntry> findBySpaceIdAndEntryDateBetweenOrderByEntryDateAscCreatedAtAsc(
      UUID spaceId, LocalDate from, LocalDate to);

  boolean existsBySpaceIdAndSourceTypeAndSourceId(
      UUID spaceId, JournalSourceType sourceType, UUID sourceId);
}
