package com.duitlah.api.accounting;

import com.duitlah.api.spaces.BusinessPermission;
import com.duitlah.api.spaces.SpaceService;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import org.springframework.stereotype.Service;

@Service
public class TrialBalanceService {

  private final LedgerAccountRepository accounts;
  private final LedgerQueryService ledgerQuery;
  private final SpaceService spaceService;

  public TrialBalanceService(
      LedgerAccountRepository accounts, LedgerQueryService ledgerQuery, SpaceService spaceService) {
    this.accounts = accounts;
    this.ledgerQuery = ledgerQuery;
    this.spaceService = spaceService;
  }

  public TrialBalanceResponse generate(UUID userId, UUID spaceId, LocalDate asOf) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.VIEW_REPORTS);

    Map<UUID, BigDecimal> debitTotals = new HashMap<>();
    Map<UUID, BigDecimal> creditTotals = new HashMap<>();
    for (var line : ledgerQuery.linesAsOf(spaceId, asOf)) {
      Map<UUID, BigDecimal> target =
          line.direction() == JournalDirection.DEBIT ? debitTotals : creditTotals;
      target.merge(line.accountId(), line.amount(), BigDecimal::add);
    }

    List<TrialBalanceLineResponse> reportLines = new java.util.ArrayList<>();
    BigDecimal totalDebit = BigDecimal.ZERO;
    BigDecimal totalCredit = BigDecimal.ZERO;
    for (LedgerAccount account : accounts.findBySpaceIdOrderByCodeAsc(spaceId)) {
      BigDecimal debit = debitTotals.getOrDefault(account.getId(), BigDecimal.ZERO);
      BigDecimal credit = creditTotals.getOrDefault(account.getId(), BigDecimal.ZERO);
      BigDecimal net = debit.subtract(credit);
      if (net.signum() == 0 && debit.signum() == 0 && credit.signum() == 0) {
        continue;
      }
      BigDecimal debitColumn = net.signum() > 0 ? net : BigDecimal.ZERO;
      BigDecimal creditColumn = net.signum() < 0 ? net.negate() : BigDecimal.ZERO;
      reportLines.add(
          new TrialBalanceLineResponse(
              account.getId(),
              account.getCode(),
              account.getName(),
              account.getType(),
              debitColumn,
              creditColumn));
      totalDebit = totalDebit.add(debitColumn);
      totalCredit = totalCredit.add(creditColumn);
    }

    return new TrialBalanceResponse(asOf, reportLines, totalDebit, totalCredit);
  }
}
