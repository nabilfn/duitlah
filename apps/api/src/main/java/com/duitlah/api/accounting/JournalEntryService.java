package com.duitlah.api.accounting;

import com.duitlah.api.common.error.ApiException;
import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.spaces.BusinessPermission;
import com.duitlah.api.spaces.SpaceService;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * The one path anything in this codebase uses to create a {@link JournalEntry} — manual entries
 * (via {@link #postManual}, permission-gated) and automatic postings from other modules (via {@link
 * #post}, already-authorized by the caller's own action) both funnel through the same balance/
 * closed-period validation, so there is exactly one place that invariant can be gotten wrong.
 */
@Service
public class JournalEntryService {

  private final JournalEntryRepository entries;
  private final JournalLineRepository lines;
  private final ChartOfAccountsService chartOfAccounts;
  private final AccountingPeriodService periods;
  private final SpaceService spaceService;

  public JournalEntryService(
      JournalEntryRepository entries,
      JournalLineRepository lines,
      ChartOfAccountsService chartOfAccounts,
      AccountingPeriodService periods,
      SpaceService spaceService) {
    this.entries = entries;
    this.lines = lines;
    this.chartOfAccounts = chartOfAccounts;
    this.periods = periods;
    this.spaceService = spaceService;
  }

  @Transactional
  public JournalEntryResponse postManual(
      UUID userId, UUID spaceId, CreateJournalEntryRequest request) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_BOOKS);
    JournalEntry entry =
        post(
            spaceId,
            request.entryDate(),
            request.description(),
            JournalSourceType.MANUAL,
            null,
            userId,
            request.lines());
    return toResponse(entry);
  }

  /**
   * Package-private — called by {@link AutomaticPostingService}. The caller has already established
   * the acting user is authorized for the business action that triggered this (e.g. {@code
   * RECORD_PAYMENTS}); this method only enforces the accounting invariants, not a second permission
   * check.
   */
  @Transactional
  JournalEntry post(
      UUID spaceId,
      LocalDate entryDate,
      String description,
      JournalSourceType sourceType,
      UUID sourceId,
      UUID createdByUserId,
      List<JournalLineRequest> lineRequests) {
    if (periods.isDateInClosedPeriod(spaceId, entryDate)) {
      throw new ApiException(
          HttpStatus.CONFLICT,
          "ACCOUNTING_PERIOD_CLOSED",
          "This date falls inside a closed accounting period.");
    }

    BigDecimal debitTotal = BigDecimal.ZERO;
    BigDecimal creditTotal = BigDecimal.ZERO;
    for (JournalLineRequest line : lineRequests) {
      LedgerAccount account = chartOfAccounts.requireOwned(spaceId, line.accountId());
      if (account.isArchived()) {
        throw new ApiException(
            HttpStatus.CONFLICT,
            "LEDGER_ACCOUNT_ARCHIVED",
            "\"" + account.getName() + "\" is archived.");
      }
      if (line.direction() == JournalDirection.DEBIT) {
        debitTotal = debitTotal.add(line.amount());
      } else {
        creditTotal = creditTotal.add(line.amount());
      }
    }
    if (debitTotal.compareTo(creditTotal) != 0) {
      throw new ApiException(
          HttpStatus.CONFLICT,
          "JOURNAL_ENTRY_NOT_BALANCED",
          "Total debits (%s) must equal total credits (%s).".formatted(debitTotal, creditTotal));
    }

    JournalEntry entry =
        new JournalEntry(spaceId, entryDate, description, sourceType, sourceId, createdByUserId);
    entries.save(entry);

    int order = 0;
    for (JournalLineRequest line : lineRequests) {
      lines.save(
          new JournalLine(
              entry.getId(),
              line.accountId(),
              line.direction(),
              line.amount(),
              line.description(),
              order++));
    }
    return entry;
  }

  public List<JournalEntryResponse> list(UUID userId, UUID spaceId, LocalDate from, LocalDate to) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.VIEW_REPORTS);
    return entries
        .findBySpaceIdAndEntryDateBetweenOrderByEntryDateAscCreatedAtAsc(spaceId, from, to)
        .stream()
        .map(this::toResponse)
        .toList();
  }

  public JournalEntryResponse get(UUID userId, UUID spaceId, UUID entryId) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.VIEW_REPORTS);
    return toResponse(requireOwned(spaceId, entryId));
  }

  public JournalEntry requireOwned(UUID spaceId, UUID entryId) {
    return entries
        .findByIdAndSpaceId(entryId, spaceId)
        .orElseThrow(
            () -> new NotFoundException("JOURNAL_ENTRY_NOT_FOUND", "Journal entry not found."));
  }

  private JournalEntryResponse toResponse(JournalEntry entry) {
    List<JournalLineResponse> lineResponses =
        lines.findByJournalEntryIdOrderBySortOrderAsc(entry.getId()).stream()
            .map(
                line -> {
                  LedgerAccount account =
                      chartOfAccounts.requireOwned(entry.getSpaceId(), line.getAccountId());
                  return new JournalLineResponse(
                      line.getId(),
                      account.getId(),
                      account.getCode(),
                      account.getName(),
                      line.getDirection(),
                      line.getAmount(),
                      line.getDescription());
                })
            .toList();
    return new JournalEntryResponse(
        entry.getId(),
        entry.getEntryDate(),
        entry.getDescription(),
        entry.getSourceType(),
        entry.getSourceId(),
        lineResponses);
  }
}
