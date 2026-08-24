package com.duitlah.api.accounting;

import com.duitlah.api.spaces.BusinessPermission;
import com.duitlah.api.spaces.SpaceService;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Set;
import java.util.UUID;
import org.springframework.stereotype.Service;

@Service
public class CashFlowService {

  private final LedgerAccountRepository accounts;
  private final LedgerQueryService ledgerQuery;
  private final SpaceService spaceService;

  public CashFlowService(
      LedgerAccountRepository accounts, LedgerQueryService ledgerQuery, SpaceService spaceService) {
    this.accounts = accounts;
    this.ledgerQuery = ledgerQuery;
    this.spaceService = spaceService;
  }

  public CashFlowResponse generate(UUID userId, UUID spaceId, LocalDate from, LocalDate to) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.VIEW_REPORTS);

    Set<UUID> cashAccountIds =
        accounts.findBySpaceIdOrderByCodeAsc(spaceId).stream()
            .filter(LedgerAccount::isCashEquivalent)
            .map(LedgerAccount::getId)
            .collect(java.util.stream.Collectors.toSet());

    BigDecimal openingCash =
        ledgerQuery.linesAsOf(spaceId, from.minusDays(1)).stream()
            .filter(l -> cashAccountIds.contains(l.accountId()))
            .map(l -> l.direction() == JournalDirection.DEBIT ? l.amount() : l.amount().negate())
            .reduce(BigDecimal.ZERO, BigDecimal::add);

    List<LedgerQueryService.PostedLine> periodLines =
        ledgerQuery.linesBetween(spaceId, from, to).stream()
            .filter(l -> cashAccountIds.contains(l.accountId()))
            .toList();

    BigDecimal cashIn =
        periodLines.stream()
            .filter(l -> l.direction() == JournalDirection.DEBIT)
            .map(LedgerQueryService.PostedLine::amount)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
    BigDecimal cashOut =
        periodLines.stream()
            .filter(l -> l.direction() == JournalDirection.CREDIT)
            .map(LedgerQueryService.PostedLine::amount)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
    BigDecimal netChange = cashIn.subtract(cashOut);

    return new CashFlowResponse(
        from, to, openingCash, cashIn, cashOut, netChange, openingCash.add(netChange));
  }
}
