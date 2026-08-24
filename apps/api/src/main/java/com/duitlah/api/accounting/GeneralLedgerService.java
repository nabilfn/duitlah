package com.duitlah.api.accounting;

import com.duitlah.api.spaces.BusinessPermission;
import com.duitlah.api.spaces.SpaceService;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;

@Service
public class GeneralLedgerService {

  private final ChartOfAccountsService chartOfAccounts;
  private final LedgerQueryService ledgerQuery;
  private final SpaceService spaceService;

  public GeneralLedgerService(
      ChartOfAccountsService chartOfAccounts,
      LedgerQueryService ledgerQuery,
      SpaceService spaceService) {
    this.chartOfAccounts = chartOfAccounts;
    this.ledgerQuery = ledgerQuery;
    this.spaceService = spaceService;
  }

  public GeneralLedgerResponse forAccount(
      UUID userId, UUID spaceId, UUID accountId, LocalDate from, LocalDate to) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.VIEW_REPORTS);
    LedgerAccount account = chartOfAccounts.requireOwned(spaceId, accountId);

    BigDecimal openingBalance =
        ledgerQuery.linesAsOf(spaceId, from.minusDays(1)).stream()
            .filter(l -> l.accountId().equals(accountId))
            .map(l -> NormalBalance.signedAmount(account.getType(), l.direction(), l.amount()))
            .reduce(BigDecimal.ZERO, BigDecimal::add);

    BigDecimal running = openingBalance;
    List<GeneralLedgerLineResponse> lines = new java.util.ArrayList<>();
    for (var line : ledgerQuery.linesBetween(spaceId, from, to)) {
      if (!line.accountId().equals(accountId)) {
        continue;
      }
      running =
          running.add(
              NormalBalance.signedAmount(account.getType(), line.direction(), line.amount()));
      lines.add(
          new GeneralLedgerLineResponse(
              line.entryDate(),
              line.journalEntryId(),
              line.lineDescription() != null ? line.lineDescription() : line.entryDescription(),
              line.direction(),
              line.amount(),
              running));
    }

    return new GeneralLedgerResponse(
        account.getId(), account.getCode(), account.getName(), openingBalance, lines, running);
  }
}
