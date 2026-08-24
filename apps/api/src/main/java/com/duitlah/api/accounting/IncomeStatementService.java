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

/**
 * The Profit &amp; Loss report (spec Phase 6 bullet "P&amp;L") — revenue minus expenses over a
 * period, using each account's normal-balance sign so both totals read as positive numbers.
 */
@Service
public class IncomeStatementService {

  private final LedgerAccountRepository accounts;
  private final LedgerQueryService ledgerQuery;
  private final SpaceService spaceService;

  public IncomeStatementService(
      LedgerAccountRepository accounts, LedgerQueryService ledgerQuery, SpaceService spaceService) {
    this.accounts = accounts;
    this.ledgerQuery = ledgerQuery;
    this.spaceService = spaceService;
  }

  public IncomeStatementResponse generate(UUID userId, UUID spaceId, LocalDate from, LocalDate to) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.VIEW_REPORTS);

    Map<UUID, LedgerAccount> accountById = new HashMap<>();
    accounts.findBySpaceIdOrderByCodeAsc(spaceId).forEach(a -> accountById.put(a.getId(), a));

    Map<UUID, BigDecimal> movementByAccount = new HashMap<>();
    for (var line : ledgerQuery.linesBetween(spaceId, from, to)) {
      LedgerAccount account = accountById.get(line.accountId());
      if (account == null
          || (account.getType() != AccountType.REVENUE
              && account.getType() != AccountType.EXPENSE)) {
        continue;
      }
      movementByAccount.merge(
          line.accountId(),
          NormalBalance.signedAmount(account.getType(), line.direction(), line.amount()),
          BigDecimal::add);
    }

    List<IncomeStatementLineResponse> revenueLines = new java.util.ArrayList<>();
    List<IncomeStatementLineResponse> expenseLines = new java.util.ArrayList<>();
    BigDecimal totalRevenue = BigDecimal.ZERO;
    BigDecimal totalExpenses = BigDecimal.ZERO;
    for (var e : movementByAccount.entrySet()) {
      LedgerAccount account = accountById.get(e.getKey());
      BigDecimal amount = e.getValue();
      if (amount.signum() == 0) {
        continue;
      }
      var lineResponse =
          new IncomeStatementLineResponse(
              account.getId(), account.getCode(), account.getName(), amount);
      if (account.getType() == AccountType.REVENUE) {
        revenueLines.add(lineResponse);
        totalRevenue = totalRevenue.add(amount);
      } else {
        expenseLines.add(lineResponse);
        totalExpenses = totalExpenses.add(amount);
      }
    }
    revenueLines.sort(java.util.Comparator.comparing(IncomeStatementLineResponse::accountCode));
    expenseLines.sort(java.util.Comparator.comparing(IncomeStatementLineResponse::accountCode));

    return new IncomeStatementResponse(
        from,
        to,
        revenueLines,
        totalRevenue,
        expenseLines,
        totalExpenses,
        totalRevenue.subtract(totalExpenses));
  }
}
