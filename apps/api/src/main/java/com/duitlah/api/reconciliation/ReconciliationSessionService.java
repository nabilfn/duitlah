package com.duitlah.api.reconciliation;

import com.duitlah.api.audit.AuditAction;
import com.duitlah.api.audit.AuditLogService;
import com.duitlah.api.bizbanking.BusinessAccount;
import com.duitlah.api.bizbanking.BusinessAccountService;
import com.duitlah.api.bizbanking.CreateEntryRequest;
import com.duitlah.api.bizbanking.EntryDirection;
import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.spaces.BusinessPermission;
import com.duitlah.api.spaces.SpaceService;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Session lifecycle and the one session-level action, "Resolve Difference" (spec section 38).
 * {@code ledgerBalance} in the summary is the business account's *current* computed balance — this
 * phase assumes a reconciliation session works through the most recent statement, the same
 * simplification {@code accounting.CashFlowService} makes for its own direct-method report, rather
 * than threading an as-of-date balance through {@code bizbanking} for a point-in-time comparison.
 */
@Service
public class ReconciliationSessionService {

  private final ReconciliationSessionRepository sessions;
  private final BusinessStatementLineRepository lines;
  private final BusinessAccountService businessAccountService;
  private final SpaceService spaceService;
  private final AuditLogService auditLogService;

  public ReconciliationSessionService(
      ReconciliationSessionRepository sessions,
      BusinessStatementLineRepository lines,
      BusinessAccountService businessAccountService,
      SpaceService spaceService,
      AuditLogService auditLogService) {
    this.sessions = sessions;
    this.lines = lines;
    this.businessAccountService = businessAccountService;
    this.spaceService = spaceService;
    this.auditLogService = auditLogService;
  }

  public List<ReconciliationSessionResponse> list(UUID userId, UUID spaceId) {
    spaceService.requireMembership(userId, spaceId);
    return sessions.findBySpaceIdOrderByStartedAtDesc(spaceId).stream()
        .map(ReconciliationSessionResponse::of)
        .toList();
  }

  public ReconciliationSessionResponse get(UUID userId, UUID spaceId, UUID sessionId) {
    spaceService.requireMembership(userId, spaceId);
    return ReconciliationSessionResponse.of(requireOwned(spaceId, sessionId));
  }

  public ReconciliationSummaryResponse summary(UUID userId, UUID spaceId, UUID sessionId) {
    spaceService.requireMembership(userId, spaceId);
    ReconciliationSession session = requireOwned(spaceId, sessionId);
    List<BusinessStatementLine> statementLines =
        lines.findByBusinessStatementImportIdOrderByOccurredOnAsc(
            session.getBusinessStatementImportId());

    BusinessAccount account =
        businessAccountService.requireOwned(spaceId, session.getBusinessAccountId());
    BigDecimal ledgerBalance = businessAccountService.balanceOf(account);
    BigDecimal difference =
        session.getStatementEndingBalance() != null
            ? session.getStatementEndingBalance().subtract(ledgerBalance)
            : null;

    return new ReconciliationSummaryResponse(
        countByStatus(statementLines, StatementLineStatus.UNMATCHED),
        countByStatus(statementLines, StatementLineStatus.MATCHED),
        countByStatus(statementLines, StatementLineStatus.CREATED),
        countByStatus(statementLines, StatementLineStatus.IGNORED),
        countByStatus(statementLines, StatementLineStatus.SPLIT),
        session.getStatementEndingBalance(),
        ledgerBalance,
        difference);
  }

  @Transactional
  public ReconciliationSessionResponse resolveDifference(
      UUID userId, UUID spaceId, UUID sessionId, ResolveDifferenceRequest request) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_BANKING);
    ReconciliationSession session = requireOwned(spaceId, sessionId);

    if (request.statementEndingBalance() != null) {
      session.setStatementEndingBalance(request.statementEndingBalance());
    }
    BusinessAccount account =
        businessAccountService.requireOwned(spaceId, session.getBusinessAccountId());
    BigDecimal ledgerBalance = businessAccountService.balanceOf(account);
    BigDecimal difference =
        session.getStatementEndingBalance() != null
            ? session.getStatementEndingBalance().subtract(ledgerBalance)
            : BigDecimal.ZERO;

    if (difference.signum() != 0) {
      String description =
          request.description() != null ? request.description() : "Reconciliation adjustment";
      businessAccountService.addEntry(
          userId,
          spaceId,
          session.getBusinessAccountId(),
          new CreateEntryRequest(
              difference.signum() > 0 ? EntryDirection.IN : EntryDirection.OUT,
              difference.abs(),
              java.time.LocalDate.now(),
              description));
    }

    session.setStatus(ReconciliationSessionStatus.COMPLETED);
    session.setCompletedAt(Instant.now());
    sessions.save(session);

    auditLogService.record(
        userId,
        AuditAction.RECONCILIATION_DIFFERENCE_RESOLVED,
        "reconciliation_session",
        sessionId,
        Map.of("difference", difference));
    return ReconciliationSessionResponse.of(session);
  }

  private static long countByStatus(List<BusinessStatementLine> lines, StatementLineStatus status) {
    return lines.stream().filter(l -> l.getStatus() == status).count();
  }

  public ReconciliationSession requireOwned(UUID spaceId, UUID sessionId) {
    return sessions
        .findByIdAndSpaceId(sessionId, spaceId)
        .orElseThrow(
            () ->
                new NotFoundException(
                    "RECONCILIATION_SESSION_NOT_FOUND", "Reconciliation session not found."));
  }
}
