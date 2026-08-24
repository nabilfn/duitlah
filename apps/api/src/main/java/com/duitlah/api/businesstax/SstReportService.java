package com.duitlah.api.businesstax;

import com.duitlah.api.accounting.ChartOfAccountsService;
import com.duitlah.api.accounting.GeneralLedgerLineResponse;
import com.duitlah.api.accounting.GeneralLedgerResponse;
import com.duitlah.api.accounting.GeneralLedgerService;
import com.duitlah.api.accounting.JournalDirection;
import com.duitlah.api.accounting.LedgerAccount;
import com.duitlah.api.spaces.BusinessPermission;
import com.duitlah.api.spaces.SpaceService;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;
import org.springframework.stereotype.Service;

@Service
public class SstReportService {

  private static final String SST_PAYABLE_CODE = "2020";

  private final ChartOfAccountsService chartOfAccounts;
  private final GeneralLedgerService generalLedgerService;
  private final SpaceService spaceService;

  public SstReportService(
      ChartOfAccountsService chartOfAccounts,
      GeneralLedgerService generalLedgerService,
      SpaceService spaceService) {
    this.chartOfAccounts = chartOfAccounts;
    this.generalLedgerService = generalLedgerService;
    this.spaceService = spaceService;
  }

  public SstReportResponse reportForPeriod(
      UUID userId, UUID spaceId, LocalDate from, LocalDate to) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.VIEW_REPORTS);
    return chartOfAccounts
        .findByCode(spaceId, SST_PAYABLE_CODE)
        .map(LedgerAccount::getId)
        .map(
            accountId -> {
              GeneralLedgerResponse ledger =
                  generalLedgerService.forAccount(userId, spaceId, accountId, from, to);
              BigDecimal collected =
                  ledger.lines().stream()
                      .filter(l -> l.direction() == JournalDirection.CREDIT)
                      .map(GeneralLedgerLineResponse::amount)
                      .reduce(BigDecimal.ZERO, BigDecimal::add);
              return new SstReportResponse(from, to, collected, ledger.closingBalance());
            })
        .orElseGet(() -> new SstReportResponse(from, to, BigDecimal.ZERO, BigDecimal.ZERO));
  }
}
