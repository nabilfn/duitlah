package com.duitlah.api.reconciliation;

import com.duitlah.api.bizbanking.BusinessAccountEntry;
import com.duitlah.api.bizbanking.BusinessAccountService;
import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.spaces.BusinessPermission;
import com.duitlah.api.spaces.SpaceService;
import java.math.BigDecimal;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;
import org.springframework.stereotype.Service;

/**
 * The matching engine (spec section 38) — deterministic, no fuzzy scoring. See package-info for
 * why.
 */
@Service
public class MatchingService {

  private static final int DATE_WINDOW_DAYS = 5;
  private static final BigDecimal AMOUNT_TOLERANCE = new BigDecimal("1.00");

  private final BusinessStatementLineRepository lines;
  private final BusinessStatementImportService importService;
  private final ReconciliationLineAllocationRepository allocations;
  private final BusinessAccountService businessAccountService;
  private final SpaceService spaceService;

  public MatchingService(
      BusinessStatementLineRepository lines,
      BusinessStatementImportService importService,
      ReconciliationLineAllocationRepository allocations,
      BusinessAccountService businessAccountService,
      SpaceService spaceService) {
    this.lines = lines;
    this.importService = importService;
    this.allocations = allocations;
    this.businessAccountService = businessAccountService;
    this.spaceService = spaceService;
  }

  public List<MatchSuggestionResponse> suggestMatches(
      UUID userId, UUID spaceId, UUID importId, UUID lineId) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_BANKING);
    BusinessStatementImport statementImport = importService.requireOwned(spaceId, importId);
    BusinessStatementLine line = requireLineOwned(importId, lineId);

    List<BusinessAccountEntry> candidates =
        businessAccountService.listEntryEntities(statementImport.getBusinessAccountId());
    Set<UUID> allocated =
        new HashSet<>(
            allocations.findAllocatedEntryIds(
                candidates.stream().map(BusinessAccountEntry::getId).toList()));

    List<MatchSuggestionResponse> exact = new ArrayList<>();
    List<MatchSuggestionResponse> probable = new ArrayList<>();
    for (BusinessAccountEntry entry : candidates) {
      if (allocated.contains(entry.getId())) {
        continue;
      }
      BigDecimal entrySigned = entry.signedAmount();
      boolean sameAmount = entrySigned.compareTo(line.getAmount()) == 0;
      boolean sameDate = entry.getOccurredOn().isEqual(line.getOccurredOn());
      long daysBetween =
          Math.abs(ChronoUnit.DAYS.between(entry.getOccurredOn(), line.getOccurredOn()));
      boolean amountWithinTolerance =
          entrySigned.subtract(line.getAmount()).abs().compareTo(AMOUNT_TOLERANCE) <= 0;

      if (sameAmount && sameDate) {
        exact.add(toSuggestion(entry, entrySigned, MatchConfidence.EXACT));
      } else if (sameAmount && daysBetween <= DATE_WINDOW_DAYS) {
        probable.add(toSuggestion(entry, entrySigned, MatchConfidence.PROBABLE));
      } else if (sameDate && amountWithinTolerance) {
        probable.add(toSuggestion(entry, entrySigned, MatchConfidence.PROBABLE));
      }
    }
    exact.addAll(probable);
    return exact;
  }

  private static MatchSuggestionResponse toSuggestion(
      BusinessAccountEntry entry, BigDecimal signedAmount, MatchConfidence confidence) {
    return new MatchSuggestionResponse(
        entry.getId(), entry.getOccurredOn(), entry.getDescription(), signedAmount, confidence);
  }

  BusinessStatementLine requireLineOwned(UUID importId, UUID lineId) {
    return lines
        .findByIdAndBusinessStatementImportId(lineId, importId)
        .orElseThrow(
            () -> new NotFoundException("STATEMENT_LINE_NOT_FOUND", "Statement line not found."));
  }
}
