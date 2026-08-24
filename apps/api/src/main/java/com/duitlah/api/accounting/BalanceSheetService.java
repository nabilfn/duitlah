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
 * Assets = Liabilities + Equity, as of a date. There is no formal period-close step in this phase
 * that rolls net income into Retained Earnings, so cumulative revenue-minus-expense since inception
 * is shown as its own "Current Earnings" equity line — exactly what makes the sheet balance without
 * requiring a closing entry every reporting period.
 */
@Service
public class BalanceSheetService {

  private final LedgerAccountRepository accounts;
  private final LedgerQueryService ledgerQuery;
  private final SpaceService spaceService;

  public BalanceSheetService(
      LedgerAccountRepository accounts, LedgerQueryService ledgerQuery, SpaceService spaceService) {
    this.accounts = accounts;
    this.ledgerQuery = ledgerQuery;
    this.spaceService = spaceService;
  }

  public BalanceSheetResponse generate(UUID userId, UUID spaceId, LocalDate asOf) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.VIEW_REPORTS);

    Map<UUID, LedgerAccount> accountById = new HashMap<>();
    accounts.findBySpaceIdOrderByCodeAsc(spaceId).forEach(a -> accountById.put(a.getId(), a));

    Map<UUID, BigDecimal> balanceByAccount = new HashMap<>();
    BigDecimal currentEarnings = BigDecimal.ZERO;
    for (var line : ledgerQuery.linesAsOf(spaceId, asOf)) {
      LedgerAccount account = accountById.get(line.accountId());
      if (account == null) {
        continue;
      }
      BigDecimal signed =
          NormalBalance.signedAmount(account.getType(), line.direction(), line.amount());
      if (account.getType() == AccountType.REVENUE || account.getType() == AccountType.EXPENSE) {
        currentEarnings =
            account.getType() == AccountType.REVENUE
                ? currentEarnings.add(signed)
                : currentEarnings.subtract(signed);
      } else {
        balanceByAccount.merge(line.accountId(), signed, BigDecimal::add);
      }
    }

    List<BalanceSheetLineResponse> assets = new java.util.ArrayList<>();
    List<BalanceSheetLineResponse> liabilities = new java.util.ArrayList<>();
    List<BalanceSheetLineResponse> equity = new java.util.ArrayList<>();
    BigDecimal totalAssets = BigDecimal.ZERO;
    BigDecimal totalLiabilities = BigDecimal.ZERO;
    BigDecimal totalEquity = BigDecimal.ZERO;
    for (var e : balanceByAccount.entrySet()) {
      LedgerAccount account = accountById.get(e.getKey());
      BigDecimal amount = e.getValue();
      if (amount.signum() == 0) {
        continue;
      }
      var line =
          new BalanceSheetLineResponse(
              account.getId(), account.getCode(), account.getName(), amount);
      switch (account.getType()) {
        case ASSET -> {
          assets.add(line);
          totalAssets = totalAssets.add(amount);
        }
        case LIABILITY -> {
          liabilities.add(line);
          totalLiabilities = totalLiabilities.add(amount);
        }
        case EQUITY -> {
          equity.add(line);
          totalEquity = totalEquity.add(amount);
        }
        default -> {}
      }
    }
    assets.sort(java.util.Comparator.comparing(BalanceSheetLineResponse::accountCode));
    liabilities.sort(java.util.Comparator.comparing(BalanceSheetLineResponse::accountCode));
    equity.sort(java.util.Comparator.comparing(BalanceSheetLineResponse::accountCode));

    return new BalanceSheetResponse(
        asOf,
        assets,
        totalAssets,
        liabilities,
        totalLiabilities,
        equity,
        totalEquity,
        currentEarnings,
        totalLiabilities.add(totalEquity).add(currentEarnings));
  }
}
