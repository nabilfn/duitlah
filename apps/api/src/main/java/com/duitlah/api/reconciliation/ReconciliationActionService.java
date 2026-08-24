package com.duitlah.api.reconciliation;

import com.duitlah.api.audit.AuditAction;
import com.duitlah.api.audit.AuditLogService;
import com.duitlah.api.bizbanking.BusinessAccountService;
import com.duitlah.api.bizbanking.CreateEntryRequest;
import com.duitlah.api.bizbanking.EntryDirection;
import com.duitlah.api.bizbanking.EntryResponse;
import com.duitlah.api.common.error.ApiException;
import com.duitlah.api.common.error.ConflictException;
import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.spaces.BusinessPermission;
import com.duitlah.api.spaces.SpaceService;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * The four line-level reconciliation actions (spec section 38): Match, Create Transaction, Ignore,
 * Split. "Resolve Difference" is session-level — see {@link ReconciliationSessionService}. Every
 * action here records itself through the existing generic audit trail ({@link AuditLogService}),
 * satisfying the phase's own "persist reconciliation history" requirement without a second audit
 * mechanism.
 */
@Service
public class ReconciliationActionService {

  private final BusinessStatementLineRepository lines;
  private final BusinessStatementImportService importService;
  private final ReconciliationLineAllocationRepository allocations;
  private final BusinessAccountService businessAccountService;
  private final SpaceService spaceService;
  private final AuditLogService auditLogService;
  private final MatchingService matchingService;

  public ReconciliationActionService(
      BusinessStatementLineRepository lines,
      BusinessStatementImportService importService,
      ReconciliationLineAllocationRepository allocations,
      BusinessAccountService businessAccountService,
      SpaceService spaceService,
      AuditLogService auditLogService,
      MatchingService matchingService) {
    this.lines = lines;
    this.importService = importService;
    this.allocations = allocations;
    this.businessAccountService = businessAccountService;
    this.spaceService = spaceService;
    this.auditLogService = auditLogService;
    this.matchingService = matchingService;
  }

  @Transactional
  public StatementLineResponse match(
      UUID userId, UUID spaceId, UUID importId, UUID lineId, MatchLineRequest request) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_BANKING);
    importService.requireOwned(spaceId, importId);
    BusinessStatementLine line = requireUnmatched(importId, lineId);

    if (!allocations.findAllocatedEntryIds(List.of(request.businessAccountEntryId())).isEmpty()) {
      throw new ConflictException(
          "LEDGER_ENTRY_ALREADY_ALLOCATED",
          "That ledger entry is already reconciled against another line.");
    }
    allocations.save(
        new ReconciliationLineAllocation(
            lineId, request.businessAccountEntryId(), line.getAmount().abs()));
    line.setStatus(StatementLineStatus.MATCHED);
    lines.save(line);

    auditLogService.record(
        userId,
        AuditAction.RECONCILIATION_LINE_MATCHED,
        "business_statement_line",
        lineId,
        Map.of(
            "businessAccountEntryId",
            request.businessAccountEntryId().toString(),
            "amount",
            line.getAmount()));
    return StatementLineResponse.of(line);
  }

  @Transactional
  public StatementLineResponse createTransaction(
      UUID userId, UUID spaceId, UUID importId, UUID lineId) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_BANKING);
    BusinessStatementImport statementImport = importService.requireOwned(spaceId, importId);
    BusinessStatementLine line = requireUnmatched(importId, lineId);

    EntryResponse entry =
        businessAccountService.addEntry(
            userId,
            spaceId,
            statementImport.getBusinessAccountId(),
            new CreateEntryRequest(
                line.getAmount().signum() >= 0 ? EntryDirection.IN : EntryDirection.OUT,
                line.getAmount().abs(),
                line.getOccurredOn(),
                line.getDescription()));
    allocations.save(new ReconciliationLineAllocation(lineId, entry.id(), line.getAmount().abs()));
    line.setStatus(StatementLineStatus.CREATED);
    lines.save(line);

    auditLogService.record(
        userId,
        AuditAction.RECONCILIATION_TRANSACTION_CREATED,
        "business_statement_line",
        lineId,
        Map.of("businessAccountEntryId", entry.id().toString(), "amount", line.getAmount()));
    return StatementLineResponse.of(line);
  }

  @Transactional
  public StatementLineResponse ignore(UUID userId, UUID spaceId, UUID importId, UUID lineId) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_BANKING);
    importService.requireOwned(spaceId, importId);
    BusinessStatementLine line = requireUnmatched(importId, lineId);

    line.setStatus(StatementLineStatus.IGNORED);
    lines.save(line);

    auditLogService.record(
        userId,
        AuditAction.RECONCILIATION_LINE_IGNORED,
        "business_statement_line",
        lineId,
        Map.of());
    return StatementLineResponse.of(line);
  }

  @Transactional
  public StatementLineResponse split(
      UUID userId, UUID spaceId, UUID importId, UUID lineId, SplitLineRequest request) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_BANKING);
    BusinessStatementImport statementImport = importService.requireOwned(spaceId, importId);
    BusinessStatementLine line = requireUnmatched(importId, lineId);

    BigDecimal portionTotal =
        request.portions().stream()
            .map(SplitLineRequest.Portion::amount)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
    if (portionTotal.compareTo(line.getAmount().abs()) != 0) {
      throw new ApiException(
          HttpStatus.CONFLICT,
          "SPLIT_PORTIONS_DO_NOT_SUM_TO_LINE_AMOUNT",
          "Portions (%s) must sum to the line's amount (%s)."
              .formatted(portionTotal, line.getAmount().abs()));
    }

    EntryDirection direction =
        line.getAmount().signum() >= 0 ? EntryDirection.IN : EntryDirection.OUT;
    for (SplitLineRequest.Portion portion : request.portions()) {
      EntryResponse entry =
          businessAccountService.addEntry(
              userId,
              spaceId,
              statementImport.getBusinessAccountId(),
              new CreateEntryRequest(
                  direction, portion.amount(), line.getOccurredOn(), portion.description()));
      allocations.save(new ReconciliationLineAllocation(lineId, entry.id(), portion.amount()));
    }
    line.setStatus(StatementLineStatus.SPLIT);
    lines.save(line);

    auditLogService.record(
        userId,
        AuditAction.RECONCILIATION_LINE_SPLIT,
        "business_statement_line",
        lineId,
        Map.of("portionCount", request.portions().size(), "amount", line.getAmount()));
    return StatementLineResponse.of(line);
  }

  /**
   * "Intelligent reconciliation" (V2 Phase 13): a single explicit, user-triggered action that
   * auto-applies every unambiguous EXACT match (same amount, same date — see {@link
   * MatchingService#suggestMatches}) across an entire import, reusing {@link #match} for each one
   * so every auto-applied match gets the exact same audit trail ({@code
   * RECONCILIATION_LINE_MATCHED}) as a manually-matched line. Deliberately does not touch PROBABLE
   * suggestions or lines with more than one EXACT candidate — those stay genuinely ambiguous and
   * are left for a human, the same "no fuzzy scoring, no silent guessing" posture {@link
   * MatchingService}'s own package-info documents.
   */
  @Transactional
  public AutoMatchSummary autoMatchExact(UUID userId, UUID spaceId, UUID importId) {
    importService.requireOwned(spaceId, importId);
    List<BusinessStatementLine> unmatched =
        lines.findByBusinessStatementImportIdAndStatus(importId, StatementLineStatus.UNMATCHED);

    int matched = 0;
    int skipped = 0;
    for (BusinessStatementLine line : unmatched) {
      List<MatchSuggestionResponse> suggestions =
          matchingService.suggestMatches(userId, spaceId, importId, line.getId());
      List<MatchSuggestionResponse> exactOnly =
          suggestions.stream().filter(s -> s.confidence() == MatchConfidence.EXACT).toList();
      if (exactOnly.size() == 1) {
        match(
            userId,
            spaceId,
            importId,
            line.getId(),
            new MatchLineRequest(exactOnly.get(0).businessAccountEntryId()));
        matched++;
      } else {
        skipped++;
      }
    }
    return new AutoMatchSummary(matched, skipped);
  }

  private BusinessStatementLine requireUnmatched(UUID importId, UUID lineId) {
    BusinessStatementLine line =
        lines
            .findByIdAndBusinessStatementImportId(lineId, importId)
            .orElseThrow(
                () ->
                    new NotFoundException("STATEMENT_LINE_NOT_FOUND", "Statement line not found."));
    if (line.getStatus() != StatementLineStatus.UNMATCHED) {
      throw new ConflictException(
          "STATEMENT_LINE_ALREADY_RESOLVED",
          "This line has already been " + line.getStatus().name().toLowerCase() + ".");
    }
    return line;
  }
}
