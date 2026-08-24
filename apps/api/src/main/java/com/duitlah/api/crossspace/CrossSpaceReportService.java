package com.duitlah.api.crossspace;

import com.duitlah.api.accounting.BalanceSheetService;
import com.duitlah.api.common.error.ApiException;
import com.duitlah.api.networth.NetWorthService;
import com.duitlah.api.spaces.FinancialSpaceResponse;
import com.duitlah.api.spaces.SpaceService;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;

/** Section 61 — "Combined Personal View." See package-info. */
@Service
public class CrossSpaceReportService {

  private final NetWorthService netWorthService;
  private final BalanceSheetService balanceSheetService;
  private final SpaceService spaceService;

  public CrossSpaceReportService(
      NetWorthService netWorthService,
      BalanceSheetService balanceSheetService,
      SpaceService spaceService) {
    this.netWorthService = netWorthService;
    this.balanceSheetService = balanceSheetService;
    this.spaceService = spaceService;
  }

  public CombinedNetWorthResponse combinedNetWorth(UUID userId) {
    BigDecimal personalNetWorth = netWorthService.compute(userId).netWorth();

    List<BusinessOwnershipLine> businessOwnership = new ArrayList<>();
    for (FinancialSpaceResponse space : spaceService.listBusinessSpacesFor(userId)) {
      try {
        var balanceSheet = balanceSheetService.generate(userId, space.id(), LocalDate.now());
        // totalEquity() alone excludes currentEarnings -- Phase 6's own substitute for Retained
        // Earnings, since there's no period-close step that rolls net income into it. The
        // owner's real stake is Assets - Liabilities, i.e. totalEquity + currentEarnings.
        BigDecimal equity = balanceSheet.totalEquity().add(balanceSheet.currentEarnings());
        businessOwnership.add(new BusinessOwnershipLine(space.id(), space.name(), equity));
      } catch (ApiException e) {
        // No VIEW_REPORTS permission on this business, or its books aren't seeded yet -- skip it
        // rather than failing the whole informational view for every other space.
      }
    }
    BigDecimal totalBusinessOwnershipValue =
        businessOwnership.stream()
            .map(BusinessOwnershipLine::equityValue)
            .reduce(BigDecimal.ZERO, BigDecimal::add);

    return new CombinedNetWorthResponse(
        personalNetWorth,
        businessOwnership,
        totalBusinessOwnershipValue,
        personalNetWorth.add(totalBusinessOwnershipValue));
  }
}
