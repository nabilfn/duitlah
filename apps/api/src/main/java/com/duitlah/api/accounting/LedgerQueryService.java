package com.duitlah.api.accounting;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import org.springframework.stereotype.Service;

/**
 * Shared fetch logic every report service needs. There's no JPA association between {@link
 * JournalLine} and {@link JournalEntry} (see {@link JournalLineRepository}'s own note), so this
 * joins the two in Java rather than in a query, and hands back one flat, report-ready row per line.
 */
@Service
class LedgerQueryService {

  private final JournalEntryRepository journalEntries;
  private final JournalLineRepository journalLines;

  LedgerQueryService(JournalEntryRepository journalEntries, JournalLineRepository journalLines) {
    this.journalEntries = journalEntries;
    this.journalLines = journalLines;
  }

  record PostedLine(
      LocalDate entryDate,
      String entryDescription,
      UUID journalEntryId,
      UUID accountId,
      JournalDirection direction,
      BigDecimal amount,
      String lineDescription) {}

  /**
   * Every line posted for {@code spaceId} with an entry date in {@code [from, to]}, in entry order.
   */
  List<PostedLine> linesBetween(UUID spaceId, LocalDate from, LocalDate to) {
    List<JournalEntry> entries =
        journalEntries.findBySpaceIdAndEntryDateBetweenOrderByEntryDateAscCreatedAtAsc(
            spaceId, from, to);
    if (entries.isEmpty()) {
      return List.of();
    }
    Map<UUID, JournalEntry> entryById =
        entries.stream().collect(java.util.stream.Collectors.toMap(JournalEntry::getId, e -> e));
    return journalLines.findByJournalEntryIdIn(entryById.keySet()).stream()
        .map(
            line -> {
              JournalEntry entry = entryById.get(line.getJournalEntryId());
              return new PostedLine(
                  entry.getEntryDate(),
                  entry.getDescription(),
                  entry.getId(),
                  line.getAccountId(),
                  line.getDirection(),
                  line.getAmount(),
                  line.getDescription());
            })
        .sorted(java.util.Comparator.comparing(PostedLine::entryDate))
        .toList();
  }

  /**
   * Every line posted for {@code spaceId} on or before {@code asOf} — for cumulative "as of a date"
   * reports (Trial Balance, Balance Sheet), as opposed to a flow-over-a-period report (P&amp;L,
   * Cash Flow), which should call {@link #linesBetween} instead.
   */
  List<PostedLine> linesAsOf(UUID spaceId, LocalDate asOf) {
    return linesBetween(spaceId, LocalDate.EPOCH, asOf);
  }
}
